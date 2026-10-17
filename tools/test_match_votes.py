"""Execute production voting decisions with explicit membership/native boundaries."""
from collections import defaultdict
from pathlib import Path
import unittest
import test_wos_ui as ui
from test_crocodile import JassState

ROOT = Path(__file__).resolve().parents[1]

class MatchVotes(unittest.TestCase):
    def setUp(self):
        self.vm = ui.load_source('MatchVotes.j')
        self.players = {0, 1, 5, 6}
        self.messages, self.kicked, self.forfeits = [], [], []
        self.local = 0
        g = self.vm.g
        self.heroes = {pid:self.vm.unit(owner=pid) for pid in self.players}
        def leave(p):
            g['Leave'][p] = 1
        g.update(MV_Ready=True, END1=0, CondArena=1, CurrentRound=1, TestMode=False,
                 WOS_ForfeitTeam=0, Leave=defaultdict(int), Hero=defaultdict(lambda:None,self.heroes),
                 Player=lambda p:p, GetPlayerId=lambda p:p, GetLocalPlayer=lambda:self.local,
                 IsInTeam1=lambda p:p<5, GetPlayerName=lambda p:f'Player {p}',
                 PLAYER_SLOT_STATE_PLAYING='playing', MAP_CONTROL_USER='user',
                 GetPlayerSlotState=lambda p:'playing' if p in self.players else 'empty',
                 GetPlayerController=lambda p:'user', I2S=str, S2I=int,
                 MV_Notify=lambda *a:self.messages.append(a),
                 WOS_HandlePlayerLeave=leave, CustomDefeatBJ=lambda p,msg:self.kicked.append(p),
                 WOS_ApplyForfeit=lambda team:self.forfeits.append(team) or True,
                 MV_Render=lambda:None,WUI_ResetClickedButtonFocus=lambda:None)

    def begin(self, pid=0, slot=0, target=1):
        self.vm.run('MV_Begin',(pid,slot,target))
        return self.vm.g['MV_Serial'][slot]

    def answer(self,pid,slot=0,yes=1,serial=None):
        self.vm.run('MV_Answer',(pid,slot,self.vm.g['MV_Serial'][slot] if serial is None else serial,yes))

    def test_surrender_can_be_proposed_on_base_in_normal_and_test_mode(self):
        for testing in [False,True]:
            f=MatchVotes();f.setUp();f.vm.g.update(TestMode=testing,CondArena=0)
            serial=f.begin(slot=1);self.assertTrue(f.vm.g['MV_Active'][1])
            f.answer(1,slot=1,serial=serial)
            self.assertEqual([1],f.forfeits)

    def test_kick_requires_all_other_players_including_the_other_team(self):
        self.begin()
        self.answer(1)  # target has no ballot
        self.answer(5)
        self.assertEqual([],self.kicked)
        self.answer(6)
        self.assertEqual([1],self.kicked)
        self.assertEqual(1,self.vm.g['Leave'][1])
        self.assertFalse(self.vm.g['MV_Active'][0])
        self.assertEqual([],self.forfeits)

    def test_any_no_rejects_and_cannot_be_overwritten(self):
        self.begin()
        self.answer(5,yes=2)
        self.answer(5)
        self.answer(6)
        self.assertFalse(self.vm.g['MV_Active'][0])
        self.assertEqual([],self.kicked)

    def test_two_player_lobby_opens_for_testing_but_one_yes_cannot_kick(self):
        self.players={0,1}
        self.begin()
        self.assertTrue(self.vm.g['MV_Active'][0])
        self.answer(1)
        self.assertTrue(self.vm.g['MV_Active'][0])
        self.assertEqual([],self.kicked)
        self.vm.g['MV_Left'][0]=0.01
        for _ in range(8):self.vm.run('MV_Tick')
        self.assertFalse(self.vm.g['MV_Active'][0])
        self.assertEqual([],self.kicked)

    def test_three_players_need_exactly_both_other_players(self):
        self.players={0,1,5}
        self.begin()
        self.assertEqual([],self.kicked)
        self.answer(5)
        self.assertEqual([1],self.kicked)

    def test_duplicate_yes_does_not_count_twice_and_old_serial_is_rejected(self):
        first=self.begin()
        self.answer(5);self.answer(5)
        self.assertTrue(self.vm.g['MV_Active'][0])
        self.answer(6,yes=2)
        self.vm.g['MV_RetryLeft'][0]=0.0
        second=self.begin()
        self.assertGreater(second,first)
        self.answer(5,serial=first);self.answer(6,serial=first)
        self.assertEqual(0,self.vm.g['MV_Choice'][5])
        self.assertEqual([],self.kicked)

    def test_thirty_second_retry_cooldown_is_shared_and_independent_for_kick_and_teams(self):
        self.begin();self.answer(5,yes=2)
        self.assertEqual(30.,self.vm.g['MV_RetryLeft'][0])
        serial=self.vm.g['MV_Serial'][0]
        self.begin(pid=5,target=1)
        self.assertEqual(serial,self.vm.g['MV_Serial'][0])
        self.begin(slot=1);self.assertTrue(self.vm.g['MV_Active'][1])
        self.answer(1,slot=1,yes=2)
        self.begin(slot=1);self.assertFalse(self.vm.g['MV_Active'][1])
        self.begin(pid=5,slot=2);self.assertTrue(self.vm.g['MV_Active'][2])
        ticks=0
        while self.vm.g['MV_RetryLeft'][0]>0 and ticks<1100:
            self.vm.run('MV_Tick');ticks+=1
        self.assertGreater(ticks*.03,29.9);self.assertLess(ticks*.03,30.6)
        self.begin();self.assertEqual(serial+1,self.vm.g['MV_Serial'][0])
        self.assertTrue(self.vm.g['MV_Active'][0])

    def test_disabled_ff_rejects_proposal_and_cancels_existing_vote_but_keeps_kick(self):
        self.begin(slot=1);self.vm.g['WOS_FF_ENABLED']=False
        self.answer(1,slot=1);self.assertEqual([],self.forfeits)
        for _ in range(9):self.vm.run('MV_Tick')
        self.assertFalse(self.vm.g['MV_Active'][1])
        self.begin(pid=5,slot=2);self.assertFalse(self.vm.g['MV_Active'][2])
        self.begin();self.assertTrue(self.vm.g['MV_Active'][0])
        self.answer(5);self.answer(6);self.assertEqual([1],self.kicked)

    def test_ff_only_requires_and_accepts_actual_teammates(self):
        self.begin(slot=1,target=-1)
        self.answer(5,slot=1)
        self.assertTrue(self.vm.g['MV_Active'][1])
        self.answer(1,slot=1)
        self.assertEqual([1],self.forfeits)
        self.assertEqual([],self.kicked)

    def test_two_teams_have_independent_ff_ballots(self):
        self.begin(slot=1,target=-1)
        self.begin(pid=5,slot=2,target=-1)
        self.answer(1,slot=1,yes=2)
        self.assertTrue(self.vm.g['MV_Active'][2])
        self.answer(6,slot=2)
        self.assertEqual([2],self.forfeits)

    def test_timeout_marks_every_unanswered_player_no_and_never_applies(self):
        self.begin()
        ticks=0
        while self.vm.g['MV_Active'][0] and ticks<1100:
            self.vm.run('MV_Tick');ticks+=1
        self.assertFalse(self.vm.g['MV_Active'][0])
        self.assertGreater(ticks*.03,29.)
        self.assertLess(ticks*.03,31.)
        for pid in [5,6]:
            self.assertEqual(2,self.vm.g['MV_Choice'][pid])
        self.assertEqual(2,sum('timeout' in text for _,text in self.messages))
        self.assertEqual([],self.kicked)

    def test_departure_cannot_lower_a_snapshot_quorum(self):
        self.begin();self.players.remove(6)
        self.answer(5)
        self.assertFalse(self.vm.g['MV_Active'][0])
        self.assertEqual([],self.kicked)

    def test_target_departure_cancels_without_defeating_someone_else(self):
        self.begin();self.players.remove(1)
        self.vm.run('MV_Evaluate',(0,))
        self.assertEqual([],self.kicked)
        self.assertFalse(self.vm.g['MV_Active'][0])

    def test_round_transition_cancels_ff_before_it_can_affect_next_round(self):
        self.begin(slot=1,target=-1)
        self.vm.g['CurrentRound']=2
        for _ in range(9):self.vm.run('MV_Tick')
        self.assertFalse(self.vm.g['MV_Active'][1])
        self.assertEqual([],self.forfeits)

    def test_invalid_actors_targets_are_rejected_and_ff_base_is_allowed(self):
        for pid,slot,target in [(0,0,0),(0,0,9),(9,0,1),(0,2,-1)]:
            self.begin(pid,slot,target)
        self.assertFalse(any(self.vm.g['MV_Active'].values()))
        self.vm.g['CondArena']=0
        self.begin(slot=1,target=-1)
        self.assertTrue(self.vm.g['MV_Active'][1])

    def test_click_only_sends_a_packet_shared_state_changes_in_sync_handler(self):
        self.begin(pid=5,target=1)
        g=self.vm.g;packets=[]
        g.update(MV_View=0, MV_Yes='yes', MV_No='no', MV_Start='start', MV_Close='close',
                 MV_Panel='panel', MV_Button={0:'kick',1:'ff'}, GetTriggerPlayer=lambda:0,
                 BlzGetTriggerFrame=lambda:'yes', BlzSendSyncData=lambda *a:packets.append(a),
                 BlzFrameSetVisible=lambda *_:None, WUI_ReleaseClickFocus=lambda:None)
        self.vm.run('MV_Click')
        self.assertEqual(0,g['MV_Choice'][0])
        self.assertEqual('WOSVOTE',packets[0][0])
        g['BlzGetTriggerSyncData']=lambda:packets[0][1]
        self.vm.run('MV_OnSync')
        self.assertEqual(1,g['MV_Choice'][0])

    def test_real_forfeit_bridge_only_queues_once_during_combat(self):
        text=(ROOT/'triggers/WOS_Start/MatchVotes.j').read_text(encoding='utf-8-sig')
        vm=JassState(text)
        vm.g.update(WOS_ForfeitTeam=0, WOS_FF_ENABLED=True, TestMode=False, CondArena=1, END1=0)
        self.assertTrue(vm.run('WOS_ApplyForfeit',(1,)))
        self.assertEqual(1,vm.g['WOS_ForfeitTeam'])
        self.assertFalse(vm.run('WOS_ApplyForfeit',(2,)))
        vm.g.update(WOS_ForfeitTeam=0,CondArena=0)
        self.assertTrue(vm.run('WOS_ApplyForfeit',(1,)))
        self.assertEqual(1,vm.g['WOS_ForfeitTeam'])

    def test_kick_leave_cleanup_reads_target_gold_and_runs_only_once(self):
        text=(ROOT/'triggers/WOS_Start/Leave.j').read_text(encoding='utf-8-sig')
        vm=JassState(text);reads=[];marked=[]
        vm.g.update(GetPlayerId=lambda p:p,GetGold=lambda p:reads.append(p) or 100,
                    GetTriggerPlayer=lambda:0,Hero=defaultdict(lambda:None),Leave=defaultdict(int),
                    FramePlayerFirstNameBase=defaultdict(lambda:'Target'),PlayerVision=defaultdict(lambda:None),
                    SaveSystem_MarkMatchPlayerLeft=lambda p:marked.append(p),MarkStatusPlayerLeft=lambda *_:None,
                    PlayersMsg=lambda *_:None,GetPlayerVisualColorString=lambda p:'',Player=lambda p:p,
                    SetPlayerName=lambda *_:None)
        vm.run('WOS_HandlePlayerLeave',(5,));vm.run('WOS_HandlePlayerLeave',(5,))
        self.assertEqual([5,5],reads)
        self.assertEqual([5],marked)
        self.assertEqual(1,vm.g['Leave'][5])

    def test_base_surrender_is_queued_for_the_existing_round_owner(self):
        f=MatchVotes();f.setUp();g=f.vm.g
        g.update(CondArena=0,TestMode=False,WOS_ForfeitTeam=0)
        g['WOS_ApplyForfeit']=lambda team:f.vm.run('WOS_ApplyForfeit',(team,))
        f.begin(slot=1);f.answer(1,slot=1)
        self.assertEqual(1,g['WOS_ForfeitTeam'])
        text=(ROOT/'triggers/WOS_Start/WoS_Pick_Init.j').read_text(encoding='utf-8-sig')
        body=text.split('function PrepareStart takes',1)[1].split('endfunction',1)[0]
        self.assertIn('if CondArena == 0 and WOS_ForfeitTeam == 0 then',body)

    def test_round_scoring_awards_exactly_ten_once_and_marks_only_enemy_winners(self):
        text=(ROOT/'triggers/WOS_Start/WoS_Pick_Init.j').read_text(encoding='utf-8-sig')
        a=text.index('            if WOS_ForfeitTeam != 0 then')
        b=text.index('            else\n            if TestMode == true then',a)
        vm=JassState('function RoundStep takes nothing returns nothing\n'+text[a:b]+'\nendif\nendfunction')
        results=[]
        vm.g.update(WOS_ForfeitTeam=1,Team1Round=3,Team2Round=4,k=0,k3=0,
                    Player=lambda p:p,IsInTeam1=lambda p:p<5,
                    SaveSystem_OnRoundEnd=lambda *a:results.append(a))
        vm.run('RoundStep');vm.run('RoundStep')
        self.assertEqual((3,14,1),(vm.g['Team1Round'],vm.g['Team2Round'],vm.g['k']))
        self.assertEqual([(p,p>=5) for p in range(10)],results)

if __name__=='__main__':unittest.main()
