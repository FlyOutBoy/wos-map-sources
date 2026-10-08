"""Execute Crocodile's actual JASS state methods with deterministic native mocks.

This small test-only evaluator covers set/if/loop/call/return. It is deliberately
not a Warcraft engine: visual rendering, native weapon setters and collision
must still be exercised in game. Tests read the production method bodies, rather
than maintaining a second Python implementation of Crocodile's mechanics.
"""
from pathlib import Path
from types import SimpleNamespace
import copy
import json
import math
import re
import shutil
import tempfile
import unittest

import configure_crocodile_test_objects as profile
import war3_object_workspace as objects

ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / "triggers/Heroes/Crocodile.j"

# Retain concise test terminology while resolving the production WoS names.
METHOD_NAMES = {
    "RefreshBonus":"CrocodileBonus_Refresh", "SetEnhanced":"CrocodileF_SetEnhanced",
    "SandSpeed":"CrocodileG_SandSpeed", "OnGround":"CrocodileSand_IsOnGround",
    "AddSand":"CrocodileSand_Start", "FinishChannel":"CrocodileT_Finish",
    "Combo":"CrocodileW_Combo", "Loop":"Loop_Crocodile", "Register":"Register_Crocodile",
    "Cast":"Test_CrocodileCast", "Damage":"CrocodileCore_Damage", "Death":"CrocodileCore_Death",
}


class Return(Exception):
    def __init__(self, value):
        self.value = value


class Break(Exception):
    pass


class JassState:
    def __init__(self, text=None):
        self.text = text if text is not None else SOURCE.read_text(encoding="utf-8")
        if text is None:
            # Execute the actual CastCheck branch; ability-ID dispatch lives only there.
            routing = (ROOT/"triggers/Systems/CastCheck.j").read_text(encoding="utf-8")
            begin = routing.index("    if GetUnitTypeId(c) == Crocodile_ID")
            end = routing.index("    endif // shared dispatch",begin)
            end = routing.rfind("    endif\n",begin,end)
            branch = routing[begin:end]
            self.text += ("\nfunction Test_CrocodileCast takes unit c, integer id, real x, real y returns boolean\n"
                          "    local integer check = 0\n"+branch+
                          "    return check == 1\nendfunction\n")
        self.text = re.sub(r"\b(?:public|private)? ?function", "method", self.text).replace("endfunction", "endmethod")
        self.methods = dict(re.findall(r"^\s*(?:(?:public|private) )?(?:static )?method (\w+) takes [^\n]+\n(.*?)\n\s*endmethod", self.text, re.S|re.M))
        self.fields = {name: kind for kind, name in re.findall(r"^        (unit|player|integer|real|effect|group|boolean|string) (\w+)\s*$", self.text, re.M)}
        self.units = []
        self.damage = []
        self.groups = set()
        self.effects = set()
        self.stuns = []
        self.slows = []
        self.pulls = []
        self.effect_history = []
        self.timed_effects = []
        self.fade_history = []
        self.scan_calls = []
        self.vision_calls = []
        self.decor_calls = []
        self.clock_users = 0
        self.elapsed = 0.0
        self.pause_history = []
        self.spell_pause_history = []
        self.ability_history = []
        self.range_history = []
        self.g = {
            "VisionTimed": lambda *args: self.vision_calls.append(args),
            "DecorRemove": lambda *args: self.decor_calls.append(args),
            "DecorRemoveLine": lambda *args: self.decor_calls.append(args),
            "bj_PI": math.pi, "bj_RADTODEG": 180/math.pi, "bj_DEGTORAD": math.pi/180,
            "CrocodileTable": {}, "instances": [None]*8192, "last": -1,
            "CrocodileDecorHits": {},
            "LoadBoolean": lambda table,key,child: table.get((key,child),False),
            "SaveBoolean": lambda table,key,child,v: table.update({(key,child):v}),
            "RMinBJ": min, "RMaxBJ": max, "IMinBJ": min, "IMaxBJ": max,
            "RAbsBJ": abs, "RoundReal":lambda v,n:round(v,n), "SquareRoot": math.sqrt, "Cos": math.cos, "Sin": math.sin, "Atan2": math.atan2,
            "GetHandleId": id, "GetOwningPlayer": lambda u: u.owner,
            "GetUnitX": lambda u: u.x, "GetUnitY": lambda u: u.y,
            "GetEffX": lambda e: e.x, "GetEffY": lambda e: e.y,
            "SR0": lambda x,y,a,b: math.hypot(x-a,y-b),
            "SR3": lambda u,x,y: math.hypot(u.x-x,u.y-y),
            "GetHeroAgi": lambda u,b: u.agi,
            "GetHeroLevel": lambda u: u.hero_level,
            "IsUnitEnemy": lambda u,p: u.owner != p,
            "SpellBool": lambda u: u.life > 0,
            "SpellBoolCaster": lambda u: u.life > 0,
            "IsUnitType": lambda u,t: False,
            "IsUnitIllusion": lambda u: u.illusion,
            "IsUnitPaused": lambda u: u.paused,
            "BlzPauseUnitEx": self.pause,
            "StartSpellUnit2": lambda u: self.spell_pause(u,True),
            "StopSpellUnit2": lambda u: self.spell_pause(u,False),
            "StartSpellUnit": lambda u: (self.add_ability(u,'Avul'),self.spell_pause(u,True)),
            "StopSpellUnit": lambda u: (self.remove_ability(u,'Avul'),self.spell_pause(u,False)),
            "R2I": int,
            "GetRandomInt": lambda a,b:a,
            "GetRandomReal": lambda a,b:(a+b)/2,
            "SetUnitTimeScale": lambda u,s:setattr(u,"timescale",s),
            "MoveEff": lambda e,d,a:(setattr(e,"x",e.x+d*math.cos(a)),setattr(e,"y",e.y+d*math.sin(a))),
            "NextSound": lambda *a:None,
            "ScaleEffDummy": lambda *a:None,
            "GetUnitFlyHeight": lambda u: u.height,
            "SetFly": lambda u,h: setattr(u,"height",h),
            "GetUnitFacing": lambda u: u.facing,
            "GearTimer03": None, "TimerGetElapsed": lambda t: self.elapsed,
            "GetUnitTypeId": lambda u: u.type,
            "GetWidgetLife": lambda u: u.life,
            "GetUnitAbilityLevel": lambda u,a: u.abilities.get(a,{}).get("level",0),
            "BlzGetUnitAbility": lambda u,a: u.abilities.get(a),
            "UnitAddAbility": self.add_ability,
            "UnitRemoveAbility": self.remove_ability,
            "BlzGetAbilityRealLevelField": lambda a,f,i: a.get(f,0.15),
            "BlzSetAbilityRealLevelField": lambda a,f,i,v: a.update({f:v}),
            "BlzGetAbilityIntegerLevelField": lambda a,f,i: a.get(f,0),
            "BlzSetAbilityIntegerLevelField": lambda a,f,i,v: a.update({f:v}),
            "BlzGetAbilityIntegerField": lambda a,f: a.get(f,1) if a else 0,
            "BlzSetAbilityIntegerField": lambda a,f,v: a.update({f:v}),
            "IncUnitAbilityLevel": self.inc_ability,
            "DecUnitAbilityLevel": self.dec_ability,
            "BlzGetUnitWeaponBooleanField": lambda u,f,i: u.weapons[i][f],
            "BlzSetUnitWeaponBooleanField": lambda u,f,i,v: u.weapons[i].update({f:v}),
            "BlzGetUnitWeaponStringField": lambda u,f,i: u.weapons[i][f],
            "BlzSetUnitWeaponStringField": lambda u,f,i,v: u.weapons[i].update({f:v}),
            "BlzGetUnitWeaponRealField": lambda u,f,i: u.weapons[i][f],
            "SetUnitRange": self.set_unit_range,
            # Range setter at weapon index 2 is broken in real Warcraft builds.
            "BlzSetUnitWeaponRealField": lambda u,f,i,v: False,
            "UNIT_STATE_MAX_MANA": "max_mana", "UNIT_STATE_MANA": "mana",
            "GetUnitState": lambda u,s: getattr(u,s),
            "SetMpCurrent": lambda u,v: setattr(u,"mana",max(0,u.mana+v)),
            "LoadInteger": lambda table,key,child: table.get((key,child),0),
            "SaveInteger": lambda table,key,child,v: table.update({(key,child):v}),
            "LoadReal": lambda table,key,child: table.get((key,child),0.0),
            "SaveReal": lambda table,key,child,v: table.update({(key,child):v}),
            "RemoveSavedReal": lambda table,key,child: table.pop((key,child),None),
            "FlushChildHashtable": self.flush,
            "I2S": str, "BlzEndUnitAbilityCooldown": lambda u,a: setattr(u,"cooldown",0),
            "BlzGetUnitAbilityCooldownRemaining": lambda u,a: u.cooldown,
            "BlzStartUnitAbilityCooldown": lambda u,a,v: setattr(u,"cooldown",v),
            "BlzGetUnitAbilityCooldown": lambda u,a,n: u.abilities.get(a,{}).get('cooldowns',[18,16,14,12,10])[n],
            "TasAbilityChargeBox_SetValue": self.counter,
            "TasAbilityChargeBox_Clear": lambda u: None,
            "TasAbilityChargeBox_ClearValue": lambda u,a: u.counters.pop(a,None),
            "CreateGroup": self.create_group,
            "DestroyGroup": lambda g: self.groups.discard(id(g)),
            "GroupEnumUnitsInRange": self.enum,
            "GroupAddUnit": lambda g,u: g.append(u) if not any(member is u for member in g) else None,
            "GroupRemoveUnit": lambda g,u: g.__delitem__(next(i for i,member in enumerate(g) if member is u)),
            "FirstOfGroup": lambda g: g[0] if g else None,
            "BlzGroupGetSize": len, "BlzGroupUnitAt": lambda g,i: g[i],
            "IsUnitInGroup": lambda u,g: any(member is u for member in g),
            "EffectSpawn": self.effect,
            "DestroyEffect": self.destroy_effect,
            "BlzSetSpecialEffectScale": lambda e,s: setattr(e,"scale",s),
            "BlzGetSpecialEffectScale": lambda e: e.scale,
            "BlzSetSpecialEffectAlpha": lambda e,a: setattr(e,"alpha",a),
            "BlzSetSpecialEffectPosition": lambda e,x,y,z: (setattr(e,"x",x),setattr(e,"y",y)),
            "BlzSetSpecialEffectX": lambda e,x: setattr(e,"x",x),
            "BlzSetSpecialEffectY": lambda e,y: setattr(e,"y",y),
            "BlzSetSpecialEffectYaw": lambda *a: None,
            "dmgphys": lambda c,u,d: self.damage.append((c,u,d)),
            "StunUnit": lambda c,u,d: self.stuns.append((u,d)),
            "SlowUnit": lambda *a: self.slows.append(a),
            "MUE": lambda *a: self.pulls.append(a),
            "MyRemoveEff": lambda e,t: self.timed_effects.append([e,t]),
            "ColorEffDummy32": self.fade_effect,
            "ColorEffDummy3": self.fade_effect,
            "ColorEffDummy4": lambda *a: None,
            "EffectSpawnScale": self.effect,
            "ColorEffDummy3Alpha": lambda e,d,r,g,b,a,t: self.fade_effect(e,d,r,g,b,t),
            "RemoveSavedInteger": lambda table,key,child: table.pop((key,child),None),
            "AddSpecialEffectTarget": self.effect,
            "MakeSound": lambda *a: None,
            "SetUnitAnimationByIndex": lambda *a: None,
            "DebuffClear": lambda *a: None,
            "IssueImmediateOrder": lambda *a: None,
            "GearCCProtected": lambda u: u.protection > 0,
            "GearCCProtect": lambda u,b: setattr(u,"protection",u.protection+(1 if b else -1)),
            "DebuffImmune_Start": lambda u,l: l,
            "IsTerrainPathable": lambda *a: False,
            "MoveUnit3": lambda u,d,a: (setattr(u,"x",u.x+d*math.cos(a)),setattr(u,"y",u.y+d*math.sin(a))),
            "MoveUnit": lambda u,d,a: (setattr(u,"x",u.x+d*math.cos(a)),setattr(u,"y",u.y+d*math.sin(a))) if u is not None and u.protection == 0 else None,
            "BlzUnitDisableAbility": lambda u,a,b,h: u.disabled.update({a:b}),
            "SetUnitAnimation": lambda *a: None,
            "SetUnitX": lambda u,x: setattr(u,"x",x),
            "SetUnitY": lambda u,y: setattr(u,"y",y),
            "GearTimer03Acquire": lambda: setattr(self,"clock_users",self.clock_users+1),
            "GearTimer03Release": lambda: setattr(self,"clock_users",self.clock_users-1),
            "NoDecor_Cond": None,
        }
        for name in re.findall(r"\b(?:UNIT_WEAPON_\w+|ABILITY_[RI]LF_\w+|ABILITY_IF_\w+|UNIT_TYPE_\w+|PATHING_TYPE_\w+)\b",self.text):
            self.g[name] = name
        # Constants and rawcodes are read from the implementation, not copied.
        for name, value in re.findall(r"^        (?:private )?(?:constant )?(?:integer|real|string|group|unit|player|trigger) (\w+) = ([^\n]+)",self.text,re.M):
            self.g[name] = eval(value.split(" //")[0].replace("null","None"), {}, self.g)
        self.g["thistype"] = self
        self.structs = {}
        self.method_classes = {}
        for name, body in re.findall(r"private struct (\w+)[^\n]*\n(.*?)endstruct", self.text, re.S):
            ns = StructState(self, name, body)
            self.structs[name] = ns
            self.g[name] = ns
            for meth in re.findall(r"method (\w+) takes", body):
                self.method_classes[meth] = ns
        self.g.update({name: lambda *args, n=name: self.run(n,args) for name in self.methods})
        self.g["Enemy"] = lambda c,u: u.life > 0 and u.owner != c.owner
        self.g["CanPull"] = lambda u: u.life > 0 and u.protection == 0
        self.g["Pull"] = lambda u,x,y,d: (setattr(u,"x",x),setattr(u,"y",y)) if u.protection == 0 else None

    def __call__(self, value):
        return value

    def __getattr__(self, name):
        if name in self.g:
            return self.g[name]
        if name == "allocate":
            return self.allocate
        return lambda *args: self.run(name,args)

    def __setattr__(self,name,value):
        globals_ = self.__dict__.get("g",{})
        if name in globals_:
            globals_[name] = value
        else:
            object.__setattr__(self,name,value)

    def allocate(self, structure=None):
        obj = SimpleNamespace(**{k: 0 if t in ("integer","real") else False if t=="boolean" else None for k,t in (structure.fields if structure else self.fields).items()})
        for name in self.methods:
            setattr(obj,name,lambda *args,n=name,o=obj: self.run(n,args,o))
        for old,new in METHOD_NAMES.items():
            if new in self.methods:
                setattr(obj,old,lambda *args,n=new,o=obj: self.run(n,args,o))
        obj.alive = True
        obj.deallocate = lambda: setattr(obj,"alive",False)
        obj.destroy = obj.deallocate
        return obj

    def unit(self, x=0, y=0, owner=1):
        u = SimpleNamespace(x=x,y=y,owner=owner,agi=100,life=100,type="H00A",illusion=False,counters={},
            mana=100,max_mana=100,cooldown=0,charge_ui="",protection=0,disabled={},abilities={},weapons=[],paused=False,pause_count=0,height=0.0,facing=0.0,hero_level=12)
        for index,enabled in enumerate([True,False]):
            u.weapons.append({"UNIT_WEAPON_BF_ATTACKS_ENABLED":enabled,"UNIT_WEAPON_RF_ATTACK_RANGE":175 if index == 0 else 800,
                              "UNIT_WEAPON_SF_ATTACK_PROJECTILE_ART":"original"})
        self.units.append(u)
        return u

    def hero(self, unit):
        self.run("Register",(unit,))
        h = self.g["LoadInteger"](self.g["CrocodileTable"],id(unit),0)
        for a in [self.g["CrocodileF_ID"],self.g["CrocodileG_ID"]]:
            self.add_ability(unit,a)
        return h

    def destroy_effect(self,e):
        if e is not None:
            if id(e) not in self.effects:
                raise AssertionError("Effect destroyed twice")
            self.effects.remove(id(e))

    def spell_pause(self,u,enabled):
        previous = getattr(u,"hard_paused",False)
        if previous != enabled:
            u.pause_count += 1 if enabled else -1
        u.hard_paused = enabled
        u.paused = u.pause_count > 0
        self.pause_history.append((u,enabled))
        self.spell_pause_history.append((u,enabled))

    def pause(self,u,enabled):
        u.pause_count += 1 if enabled else -1
        if u.pause_count < 0:
            raise AssertionError("Unbalanced enhanced pause")
        u.paused = u.pause_count > 0
        self.pause_history.append((u,enabled))

    def add_ability(self,u,a):
        self.ability_history.append((u,a,True))
        u.abilities.setdefault(a,{"level":1})

    def remove_ability(self,u,a):
        self.ability_history.append((u,a,False))
        u.abilities.pop(a,None)

    def inc_ability(self,u,a):
        ability = u.abilities[a]
        if ability["level"] < ability.get("ABILITY_IF_LEVELS",1):
            ability["level"] += 1
            ability["refreshes"] = ability.get("refreshes",0) + 1

    def dec_ability(self,u,a):
        ability = u.abilities[a]
        ability["level"] = max(1,ability["level"]-1)

    def counter(self,u,a,v):
        u.counters[a] = v
        if a == self.g["CrocodileE_ID"]:
            u.charge_ui = v

    def create_group(self):
        g = []
        self.groups.add(id(g))
        return g

    def fade_effect(self,e,delay,red,green,blue,duration):
        self.fade_history.append((e,delay,duration))
        self.timed_effects.append([e,delay+duration])

    def effect(self,*args):
        e = SimpleNamespace(model=args[0],x=args[1] if len(args)>1 else 0,y=args[2] if len(args)>2 else 0,scale=args[5] if len(args)>5 else None)
        self.effects.add(id(e))
        self.effect_history.append(e)
        return e

    def set_unit_range(self,unit,value):
        # Mock the shared helper's contract; native index coupling is an in-game check.
        self.range_history.append((unit,value))
        unit.weapons[0]['UNIT_WEAPON_RF_ATTACK_RANGE'] = value

    def enum(self,g,x,y,r,*args):
        self.scan_calls.append((g,x,y,r))
        g[:] = [u for u in self.units if math.hypot(u.x-x,u.y-y) <= r]

    def flush(self,table,key):
        for k in list(table):
            if k[0] == key: del table[k]

    def run(self,name,args=(),obj=None):
        name = METHOD_NAMES.get(name,name)
        signature = re.search(r"method "+name+r" takes (.*?) returns",self.text)[1]
        structure = self.method_classes.get(name)
        def environment():
            result = dict(self.g)
            if structure is not None:
                result.update(structure.statics)
                result["thistype"] = structure
            return result
        if obj is not None and signature == "CrocodileInstance_Struct data" and not args:
            args = (obj,)
        local = dict(zip([] if signature=="nothing" else [p.strip().split()[-1] for p in signature.split(",")],args))
        if obj is not None: local["this"] = obj
        lines = [l.strip().split(" //")[0] for l in self.methods[name].splitlines() if l.strip() and not l.strip().startswith("//")]
        def expr(s):
            env = environment()
            current = local.get("this")
            if hasattr(current,"__dict__"): env.update(vars(current))
            env.update(local)
            s = re.sub(r"\b(true|false|null)\b",lambda m:{"true":"True","false":"False","null":"None"}[m[0]],s)
            s = re.sub(r"\b(?:function|method)\s+([\w.]+)",r"\1",s)
            return eval(s,{},env)
        def assign(target,value):
            if "." in target or "[" in target:
                env = environment()
                if local.get("this") is not None: env.update(vars(local["this"]))
                env.update(local)
                env["_value"] = value
                exec(target+" = _value",{},env)
            elif target in local: local[target] = value
            elif structure is not None and target in structure.statics: structure.statics[target] = value
            elif target in self.g: self.g[target] = value
            elif local.get("this") is not None: setattr(local["this"],target,value)
            else: raise AssertionError(target)
        def block(start,end):
            i = start
            while i < end:
                line = lines[i]
                if line.startswith("local "):
                    decl = line.split(" ",2)[2]
                    var,sep,value = decl.partition("=")
                    local[var.strip()] = expr(value.strip()) if sep else None
                elif line.startswith("set "):
                    target,value = line[4:].split(" = ",1)
                    assign(target,expr(value))
                elif line.startswith("call "): expr(line[5:])
                elif line.startswith("return"): raise Return(expr(line[7:]) if line!="return" else None)
                elif line.startswith("exitwhen "):
                    if expr(line[9:]): raise Break()
                elif line.startswith("if "):
                    branches = [(line[3:-5],i+1)]
                    depth = 1
                    j = i+1
                    while depth:
                        token = lines[j]
                        if token.startswith("if "): depth += 1
                        if token=="endif": depth -= 1
                        if depth==1 and (token.startswith("elseif ") or token=="else"):
                            branches.append((token[7:-5] if token!="else" else "True",j+1))
                        j += 1
                    for n,(condition,begin) in enumerate(branches):
                        finish = branches[n+1][1]-1 if n+1<len(branches) else j-1
                        if expr(condition):
                            block(begin,finish)
                            break
                    i = j-1
                elif line=="loop":
                    depth,j = 1,i+1
                    while depth:
                        if lines[j]=="loop": depth += 1
                        if lines[j]=="endloop": depth -= 1
                        j += 1
                    for _ in range(10000):
                        try: block(i+1,j-1)
                        except Break: break
                    else: raise AssertionError("Non-terminating JASS loop")
                    i = j-1
                else: raise AssertionError(line)
                i += 1
        try: block(0,len(lines))
        except Return as result: return result.value
        if name == "Loop_Crocodile":
            for entry in self.timed_effects[:]:
                entry[1] -= self.g["CrocodilePeriod"]
                if entry[1] <= 0:
                    self.effects.discard(id(entry[0]))
                    self.timed_effects.remove(entry)


class StructState:
    def __setattr__(self,name,value):
        statics = self.__dict__.get('statics',{})
        if name in statics:
            statics[name] = value
        else:
            object.__setattr__(self,name,value)

    def __init__(self, vm, name, text):
        self.vm, self.name = vm, name
        self.statics = {"MUI":-1,"m":[None]*8192}
        declarations = text.split("method ",1)[0]
        self.fields = {n:t for t,n in re.findall(r"^        (unit|integer|real|effect|group|boolean|string) (\w+)\s*$",declarations,re.M)}
    def __call__(self,value): return value
    def allocate(self): return self.vm.allocate(self)
    def create(self): return self.allocate()
    def __getattr__(self,name):
        if name in self.statics: return self.statics[name]
        return lambda *args: self.vm.run(name,args)


class CrocodileStateTests(unittest.TestCase):
    def setUp(self):
        self.vm = JassState()
        self.vm.g["CrocodileQ_Aoe"] = 155.0
        self.c = self.vm.unit()
        self.hero = self.vm.hero(self.c)
        self.e = self.state(1)
        self.f = self.state(2)
        self.g = self.state(3)

    def state(self,key):
        return self.vm.g["LoadInteger"](self.vm.g["CrocodileTable"],id(self.c),key)

    def step(self,ticks=1):
        for _ in range(ticks): self.vm.run("Loop")

    def cast(self,code,x=300,y=0):
        self.vm.g.update({"GetSpellAbilityUnit":lambda:self.c,
            "GetSpellAbilityId":lambda:self.vm.g[code],
            "GetSpellTargetX":lambda:x,"GetSpellTargetY":lambda:y,"GearSpellHandled":False})
        self.vm.add_ability(self.c,self.vm.g[code])
        return self.vm.run("Cast",(self.c,self.vm.g[code],x,y))

    def damage_event(self,target,phase,kind=2,amount=100):
        self.vm.g.update(GearDamageSource=self.c,GearDamageTarget=target,GearDamagePhase=phase,GearDamageType=kind,GearDamageAmount=amount)
        return self.vm.run("Damage",(self.c,target,amount,kind,phase))

    def test_one_level_bonus_refresh_restores_level_count(self):
        self.vm.add_ability(self.c,"AIsx")
        ability = self.c.abilities["AIsx"]
        self.vm.run("RefreshBonus",(self.c,"AIsx"))
        self.assertEqual((ability["refreshes"],ability["level"],ability["ABILITY_IF_LEVELS"]),(1,1,1))
        ability.update(level=2,ABILITY_IF_LEVELS=4)
        self.vm.run("RefreshBonus",(self.c,"AIsx"))
        self.assertEqual((ability["refreshes"],ability["level"],ability["ABILITY_IF_LEVELS"]),(2,2,4))

    def test_g_preview_is_pure_and_caps_all_damage(self):
        target = self.vm.unit(owner=2)
        target.mana = 0
        for kind in [0,1,2]: self.assertAlmostEqual(self.damage_event(target,1,kind),115)
        self.assertEqual(target.mana,0)
        target.mana = 80
        self.assertAlmostEqual(self.damage_event(target,1),107)
        self.assertEqual(target.mana,80)
        target.max_mana = 0
        self.assertEqual(self.damage_event(target,1),100)

    def test_g_drain_only_positive_spell_events(self):
        target = self.vm.unit(owner=2)
        self.damage_event(target,3,kind=0)
        self.damage_event(target,3,kind=2,amount=0)
        self.assertEqual(target.mana,100)
        self.damage_event(target,3,kind=2)
        self.damage_event(target,3,kind=1)
        self.assertEqual(target.mana,98)
        self.assertEqual(len(self.vm.damage),0)

    def test_independent_charge_deadlines_and_ui(self):
        self.e.charge1,self.e.charge2,self.e.charge3 = 1,2,3
        self.step(34)
        self.assertEqual(self.c.charge_ui,"1")
        self.assertAlmostEqual(self.e.charge2,0.98)
        self.assertAlmostEqual(self.e.charge3,1.98)
        self.step(36)
        self.assertEqual(self.c.charge_ui,"2")
        self.step(35)
        self.assertEqual(self.c.charge_ui,"3")

    def test_f_consumes_projectiles_and_restores_owned_bonuses(self):
        target = self.vm.unit(owner=2)
        self.f.stacks = 3
        self.f.SetEnhanced(True)
        self.assertEqual(self.c.weapons[1]["UNIT_WEAPON_RF_ATTACK_RANGE"],800)
        for remaining in [2,1,0]:
            self.assertEqual(self.vm.run("CrocodileF_Attack",(self.c,target,100)),0)
            self.assertIn("Abun",self.c.abilities)
            self.step(1)
            self.assertEqual(self.f.stacks,remaining)
            self.assertEqual(self.c.counters[self.vm.g["CrocodileF_ID"]],str(remaining))
            self.assertNotIn("Abun",self.c.abilities)
            self.step(8)
        self.assertNotIn("AIsx",self.c.abilities)
        self.assertEqual(self.c.weapons[1]["UNIT_WEAPON_RF_ATTACK_RANGE"],800)
        self.assertTrue(self.c.weapons[0]["UNIT_WEAPON_BF_ATTACKS_ENABLED"])
        self.assertFalse(self.c.weapons[1]["UNIT_WEAPON_BF_ATTACKS_ENABLED"])

    def test_f_preserves_unrelated_bonus_and_range_changes(self):
        key = "ABILITY_RLF_ATTACK_SPEED_INCREASE_ISX1"
        self.c.abilities["AIsx"] = {"level":1,key:0.5}
        self.f.SetEnhanced(True)
        self.c.abilities["AIsx"][key] += 0.2
        self.c.weapons[1]["UNIT_WEAPON_RF_ATTACK_RANGE"] += 50
        self.f.SetEnhanced(False)
        self.assertAlmostEqual(self.c.abilities["AIsx"][key],0.7)
        self.assertEqual(self.c.weapons[1]["UNIT_WEAPON_RF_ATTACK_RANGE"],850)

    def test_f_cooldown_accounts_for_fraction_of_shared_tick(self):
        target = self.vm.unit(x=100,owner=2)
        self.f.stacks = 3
        self.f.SetEnhanced(True)
        self.vm.elapsed = 0.015
        self.assertEqual(self.vm.run("CrocodileF_Attack",(self.c,target,100)),0)
        self.assertAlmostEqual(self.f.cooldown,0.265)
        self.assertEqual(self.vm.run("CrocodileF_Attack",(self.c,target,100)),100)
        self.assertEqual(self.f.stacks,3)
        self.vm.elapsed = 0.0
        self.step(8)
        self.assertEqual(self.f.stacks,2)
        self.vm.elapsed = 0.024
        self.assertEqual(self.vm.run("CrocodileF_Attack",(self.c,target,100)),100)
        self.vm.elapsed = 0.0251
        self.assertEqual(self.vm.run("CrocodileF_Attack",(self.c,target,100)),0)
        self.assertIn("Abun",self.c.abilities)
        self.step(1)
        self.assertEqual(self.f.stacks,1)
        self.assertNotIn("Abun",self.c.abilities)

    def test_f_attack_block_sequence_and_projectile_hits_only_once(self):
        target = self.vm.unit(x=100,owner=2)
        outside = self.vm.unit(x=100,y=300,owner=2)
        self.f.stacks = 1
        self.f.SetEnhanced(True)
        start = len(self.vm.ability_history)
        launch = self.vm.structs["CrocodileF_Projectile"].CrocodileF_Projectile_Start
        def checked_launch(c,u):
            self.assertIn("Abun",c.abilities)
            self.assertGreater(self.f.cooldown,0)
            launch(c,u)
        self.vm.structs["CrocodileF_Projectile"].CrocodileF_Projectile_Start = checked_launch
        self.assertEqual(self.vm.run("CrocodileF_Attack",(self.c,target,100)),0)
        self.assertEqual([row[2] for row in self.vm.ability_history[start:] if row[1] == "Abun"],[True])
        self.assertEqual(len(self.vm.damage),0)
        self.step(1)
        self.assertEqual([row[2] for row in self.vm.ability_history[start:] if row[1] == "Abun"],[True,False])
        self.step(15)
        self.assertEqual([(u,amount) for _,u,amount in self.vm.damage],[(target,300)])
        self.assertFalse(any(u is outside for _,u,_ in self.vm.damage))
        self.assertEqual(len(self.vm.groups),0)
        self.assertEqual(len(self.vm.effects),0)

    def test_f_does_not_proc_from_spell_damage_illusion_or_external_attack_block(self):
        target = self.vm.unit(x=100,owner=2)
        self.f.stacks = 2
        self.damage_event(target,0,kind=0)
        self.assertEqual(self.f.stacks,2)
        self.vm.add_ability(self.c,"Abun")
        self.assertEqual(self.vm.run("CrocodileF_Attack",(self.c,target,100)),100)
        self.assertIn("Abun",self.c.abilities)
        self.c.abilities.pop("Abun")
        self.c.illusion = True
        self.assertEqual(self.vm.run("CrocodileF_Attack",(self.c,target,100)),100)
        self.assertEqual(self.f.stacks,2)

    def test_f_range_uses_object_data_even_with_broken_native_setter(self):
        units = json.loads((ROOT/"test_map/object-data/units.json").read_text(encoding="utf-8-sig"))
        self.assertEqual(units["H00A"]["attack_2_range"],800)
        self.assertEqual(units["H00A"]["attack_1_range"],175)
        self.assertNotIn("BlzSetUnitWeaponRealField",SOURCE.read_text(encoding="utf-8"))
        for distance in [400,750]:
            target = self.vm.unit(x=distance,owner=2)
            self.f.stacks = 1
            self.f.SetEnhanced(True)
            self.assertEqual(self.c.weapons[1]["UNIT_WEAPON_RF_ATTACK_RANGE"],800)
            self.assertEqual(self.vm.run("CrocodileF_Attack",(self.c,target,100)),0)
            self.assertIn("Abun",self.c.abilities)
            self.step(16)
            self.assertTrue(any(u is target for _,u,_ in self.vm.damage))
            self.assertNotIn("Abun",self.c.abilities)
            self.assertTrue(self.c.weapons[0]["UNIT_WEAPON_BF_ATTACKS_ENABLED"])

    def test_f_pending_projectile_death_releases_attack_block(self):
        target = self.vm.unit(x=600,owner=2)
        self.f.stacks = 1
        self.f.SetEnhanced(True)
        self.vm.run("CrocodileF_Attack",(self.c,target,100))
        self.assertIn("Abun",self.c.abilities)
        self.c.life = 0
        self.vm.Death(self.c)
        self.assertNotIn("Abun",self.c.abilities)
        self.assertIsNone(self.f.pendingTarget)
        self.step(1)
        self.assertEqual(self.vm.structs["CrocodileF_Projectile"].MUI,-1)

    def test_q_miss_never_creates_ground_sand(self):
        self.vm.unit(x=200,y=400,owner=2)
        self.cast("CrocodileQ_ID")
        self.step(105)
        self.assertEqual(self.vm.structs["CrocodileSand_Struct"].MUI,-1)
        self.assertFalse(any(e.model == "war3mapImported\\wos_az_f076.mdl" for e in self.vm.effect_history))
        self.assertEqual(len(self.vm.groups),0)
        self.assertEqual(len(self.vm.effects),0)

    def test_q_hit_creates_one_patch_and_no_duplicate_until_debuff_expires(self):
        target = self.vm.unit(x=100,owner=2)
        self.cast("CrocodileQ_ID")
        self.step(17)
        debuffs = self.vm.structs["CrocodileSand_Debuff"]
        sand = self.vm.structs["CrocodileSand_Struct"]
        self.assertEqual(debuffs.MUI,0)
        self.assertEqual(sand.MUI,0)
        fx = debuffs.m[0].e
        self.assertIs(fx.x,target)
        self.assertEqual((sand.m[0].x,sand.m[0].y),(target.x,target.y))
        self.step(22)
        target.x = 900  # A second hit must not plant sand at the new location.
        self.cast("CrocodileQ_ID")
        self.step(40)
        self.assertEqual(debuffs.MUI,0)
        self.assertEqual(sand.MUI,1) # Movement planted one spaced trail patch.
        self.assertIs(debuffs.m[0].e,fx)
        self.assertEqual(sum(u is target for _,u,_ in self.vm.damage),2)
        self.step(650)
        self.assertEqual(debuffs.MUI,-1)
        self.assertNotIn(id(fx),self.vm.effects)
        self.assertEqual(self.vm.g["LoadInteger"](self.vm.g["CrocodileTable"],id(target),7),0)
        self.cast("CrocodileQ_ID")
        self.step(40)
        self.assertEqual(debuffs.MUI,0)
        self.assertIsNot(debuffs.m[0].e,fx)

    def test_sand_debuff_rejects_allies_dead_structures_and_dummies(self):
        self.cast("CrocodileQ_ID")
        q = self.vm.structs["CrocodileQ_Struct"].m[0]
        ally = self.vm.unit(owner=self.c.owner)
        dead = self.vm.unit(owner=2)
        dead.life = 0
        structure = self.vm.unit(owner=2)
        dummy = self.vm.unit(owner=2)
        self.vm.add_ability(dummy,"Aloc")
        self.vm.g["IsUnitType"] = lambda u,t: u is structure
        for target in [ally,dead,structure,dummy]:
            self.vm.run("CrocodileQ_HitSand",(target,),q)
        self.assertEqual(self.vm.structs["CrocodileSand_Debuff"].MUI,-1)
        self.assertEqual(self.vm.structs["CrocodileSand_Struct"].MUI,-1)

    def test_sand_debuff_is_shared_between_casters_and_cleans_on_death(self):
        target = self.vm.unit(owner=2)
        other = self.vm.unit(owner=3)
        self.vm.hero(other)
        self.assertTrue(self.vm.run("Apply",(self.c,target)))
        self.assertFalse(self.vm.run("Apply",(other,target)))
        fx = self.vm.structs["CrocodileSand_Debuff"].m[0].e
        target.life = 0
        self.step()
        self.assertNotIn(id(fx),self.vm.effects)
        target.life = 100
        self.assertTrue(self.vm.run("Apply",(other,target)))

    def test_q_sand_trail_samples_movement_and_deduplicates_existing_ground(self):
        target = self.vm.unit(x=100,owner=2)
        self.cast("CrocodileQ_ID")
        self.step(17)
        sand = self.vm.structs["CrocodileSand_Struct"]
        self.assertEqual(sand.MUI,0)
        self.step(40)
        self.assertEqual(sand.MUI,0)
        target.x = 349
        self.step(5)
        self.assertEqual(sand.MUI,0)
        target.x = 350
        self.step(5)
        self.assertEqual(sand.MUI,1)
        target.x = 100
        self.step(5)
        self.assertEqual(sand.MUI,1)
        patches = [sand.m[i] for i in range(sand.MUI+1)]
        self.assertTrue(all(p.e.model == "war3mapImported\\wos_ysjsm45.mdl" and p.e.alpha == 128 for p in patches))
        self.assertEqual(len(self.vm.groups),1) # Shared slow scan group for all patches.

    def test_color_eff_dummy_three_alpha_preserves_standard_helper_contract(self):
        source = (ROOT/"triggers/Systems/Systems2.j").read_text(encoding="utf-8")
        begin = source.index("    function ColorEffDummy3Alpha takes")
        end = source.index("    function ColorEffDummy32 takes",begin)
        vm = JassState(SOURCE.read_text(encoding="utf-8")+source[begin:end])
        calls = []
        vm.g["KS_EffectColor"] = SimpleNamespace(ColorEffDummy_Start=lambda *args:calls.append(args))
        fx = vm.effect("sand",0,0)
        vm.run("ColorEffDummy3Alpha",(fx,0,255,255,255,128,0.8))
        self.assertEqual(calls[0],(fx,0,255,255,255,128,0.8,True,True))
        vm.run("ColorEffDummy3",(fx,0,255,255,255,0.8))
        self.assertEqual(calls[1],(fx,0,255,255,255,255,0.8,True,True))
        vm.run("ColorEffDummy3Alpha",(None,0,255,255,255,128,0.8))
        self.assertEqual(len(calls),2)

    def test_ground_sand_fades_after_eight_seconds_with_matching_alpha(self):
        self.vm.AddSand(self.c,0,0,210,False)
        sand = self.vm.structs["CrocodileSand_Struct"]
        fx = sand.m[0].e
        self.step(266)
        self.assertEqual(sand.MUI,0)
        self.assertFalse(self.vm.fade_history)
        self.step()
        self.assertEqual(sand.MUI,-1)
        self.assertIn((fx,0.0,0.8),self.vm.fade_history)
        self.assertIn(id(fx),self.vm.effects)
        self.step(28)
        self.assertNotIn(id(fx),self.vm.effects)

    def test_t_spreads_patches_to_1800_in_two_seconds_without_repeated_spawns(self):
        self.cast("CrocodileT_ID")
        channel = self.state(4)
        self.step(66)
        self.assertLess(channel.radius,1800)
        self.step()
        self.assertEqual(channel.radius,1800)
        sand = self.vm.structs["CrocodileSand_Struct"]
        count = sand.MUI+1
        self.assertGreater(count,80)
        self.assertLessEqual(count,100)
        for i in range(count):
            patch = sand.m[i]
            self.assertLessEqual(math.hypot(patch.x,patch.y)+patch.radius,1800.001)
            self.assertEqual(patch.e.model,"war3mapImported\\wos_ysjsm45.mdl")
        self.assertEqual(len(self.vm.groups),1) # Channel group only; ground allocates no groups.
        self.step(30)
        self.assertEqual(sand.MUI+1,count)

    def test_t2_damages_only_owned_sand_patches_and_deduplicates_overlap(self):
        on_patch = self.vm.unit(x=600,owner=2)
        off_patch = self.vm.unit(x=900,owner=2)
        distant = self.vm.unit(x=2500,owner=2)
        self.vm.AddSand(self.c,2500,0,210,True)
        self.cast("CrocodileT_ID")
        self.step(34)
        self.assertGreater(self.state(4).radius,900)
        self.cast("CrocodileT2_ID")
        self.assertEqual(sum(u is on_patch for _,u,_ in self.vm.damage),1)
        self.assertEqual(sum(u is distant for _,u,_ in self.vm.damage),1)
        self.assertEqual(sum(u is off_patch for _,u,_ in self.vm.damage),0)

    def test_r_orbit_height_forward_travel_and_natural_cleanup(self):
        target = self.vm.unit(x=50,owner=2)
        target.height = 120
        self.cast("CrocodileR_ID",x=30)
        tornado = self.vm.structs["CrocodileR_Struct"].m[0]
        self.step(1)
        self.assertTrue(target.paused)
        first = (target.x,target.y,target.height)
        self.step(15)
        self.assertGreater(tornado.x,30)
        self.assertNotEqual((target.x,target.y,target.height),first)
        self.assertAlmostEqual(math.hypot(target.x-tornado.x,target.y-tornado.y),tornado.radius*0.8)
        self.assertGreater(target.height,120)
        self.step(156)
        self.assertFalse(target.paused)
        self.assertEqual(target.height,120)
        self.assertEqual(target.pause_count,0)
        self.assertFalse(any(key[0] == id(target) for key in self.vm.g["CrocodileTable"]))

    def test_r_target_death_escape_and_immunity_release(self):
        for reason in ["death","escape","immunity","removal"]:
            with self.subTest(reason=reason):
                target = self.vm.unit(x=50,owner=2)
                target.height = 80
                self.cast("CrocodileR_ID")
                self.step()
                self.assertTrue(target.paused)
                if reason == "death":
                    target.life = 0
                    self.vm.Death(target)
                elif reason == "escape":
                    target.x = 5000
                elif reason == "immunity":
                    target.protection = 1
                else:
                    target.type = 0
                self.step()
                self.assertFalse(target.paused)
                self.assertEqual(target.height,80)
                self.c.life = 0
                self.vm.Death(self.c)
                self.step()
                self.c.life = 100

    def test_r_two_tornadoes_do_not_double_pause_and_caster_death_frees_all(self):
        target = self.vm.unit(x=50,owner=2)
        self.cast("CrocodileR_ID")
        self.cast("CrocodileR_ID")
        self.step()
        self.assertEqual(target.pause_count,1)
        self.c.life = 0
        self.vm.Death(self.c)
        self.assertEqual(target.pause_count,0)
        self.step()
        self.assertEqual(len(self.vm.groups),0)
        self.assertEqual(len(self.vm.effects),0)

    def test_removal_cleans_r_without_native_group_membership(self):
        target = self.vm.unit(x=50,owner=2)
        self.cast("CrocodileR_ID")
        self.step()
        target.type = 0
        # Native removal may drop a unit from enumerations; saved capture retains it.
        self.vm.units.remove(target)
        self.step()
        self.assertFalse(target.paused)
        self.assertEqual(target.height,0)
        self.assertEqual(self.vm.g["LoadInteger"](self.vm.g["CrocodileTable"],id(target),5),0)

    def test_crocodile_revive_has_no_stale_f_t_or_r_state(self):
        target = self.vm.unit(x=50,owner=2)
        self.cast("CrocodileR_ID")
        self.step()
        self.cast("CrocodileT_ID")
        self.c.life = 0
        self.vm.Death(self.c)
        self.step()
        self.c.life = 100
        self.step()
        self.assertEqual(self.c.pause_count,0)
        self.assertEqual(target.pause_count,0)
        self.assertEqual(self.state(4),0)
        self.assertEqual(self.f.stacks,0)
        self.assertNotIn("Abun",self.c.abilities)
        self.assertTrue(self.cast("CrocodileQ_ID"))
        self.assertEqual(self.f.stacks,1)

    def test_t_pause_pair_on_timeout_death_removal_and_t2(self):
        for reason in ["timeout","death","removal","t2"]:
            with self.subTest(reason=reason):
                self.setUp()
                self.cast("CrocodileT_ID")
                self.assertEqual(self.c.pause_count,1)
                self.step(38)
                if reason == "timeout": self.step(135)
                elif reason == "death":
                    self.c.life = 0
                    self.vm.Death(self.c)
                elif reason == "removal":
                    self.c.type = 0
                    self.step()
                else: self.cast("CrocodileT2_ID")
                self.vm.FinishChannel(self.c)
                self.assertEqual(self.c.pause_count,0)
                self.assertEqual([b for u,b in self.vm.pause_history if u is self.c],[True,False])

    def test_shared_routes_and_no_local_cast_attack_death_or_order_listener(self):
        hero = SOURCE.read_text(encoding="utf-8")
        self.assertNotIn("GearSpellListeners",hero)
        self.assertNotIn("GearDamageListeners",hero)
        for event in ["EVENT_PLAYER_UNIT_DEATH","ISSUED_ORDER","ISSUED_POINT_ORDER","ISSUED_TARGET_ORDER"]:
            self.assertNotIn(event,hero)
        routing = (ROOT/"triggers/Systems/CastCheck.j").read_text(encoding="utf-8")
        self.assertNotIn("Crocodile_Cast",hero)
        self.assertNotIn("CrocodileCore_Cast",hero)
        for name in ["Q","W","E","R","T","T2"]:
            self.assertIn("id == Crocodile"+name+"_ID then",routing)
            self.assertIn("call Crocodile"+name+"_Start(c",routing)
        damage = (ROOT/"triggers/Systems/DmgSys.j").read_text(encoding="utf-8")
        self.assertRegex(damage,r"if BlzGetEventIsAttack\(\) then\s+static if LIBRARY_CrocodileSpells then\s+set dmg = Crocodile_Attack")
        for file in ["triggers/Systems/Death.j","test_map/base/Systems/Death.j"]:
            self.assertIn("call Crocodile_Death(td)",(ROOT/file).read_text(encoding="utf-8"))

    def test_sand_merge_owner_and_expiration(self):
        self.vm.AddSand(self.c,0,0,210,True)
        self.vm.AddSand(self.c,100,0,210,False)
        self.assertEqual(self.vm.structs["CrocodileSand_Struct"].MUI,0)
        other = self.vm.unit(owner=2)
        self.vm.AddSand(other,0,0,210,False)
        self.assertEqual(self.vm.structs["CrocodileSand_Struct"].MUI,0)
        self.assertTrue(self.vm.OnGround(self.c,self.c))
        self.step(670)
        self.assertFalse(self.vm.OnGround(self.c,self.c))
        self.assertEqual(len(self.vm.groups),0)
        self.assertEqual(len(self.vm.effects),0)

    def test_e_windup_delays_movement_damage_and_keeps_pause_until_dash_end(self):
        target = self.vm.unit(x=100,owner=2)
        self.assertTrue(self.vm.run("CrocodileE_Start",(self.c,600,0)))
        self.assertAlmostEqual(self.c.timescale,0.4*1.15)
        self.assertAlmostEqual(self.e.e2.scale,0.35*1.15)
        self.step(5)
        self.assertEqual(self.c.x,0)
        self.assertFalse(self.vm.damage)
        self.assertTrue(self.c.paused)
        self.step()
        self.assertEqual(self.c.x,75)
        self.assertEqual(sum(u is target for _,u,_ in self.vm.damage),1)
        self.step(7)
        self.assertEqual(self.c.x,600)
        self.assertFalse(self.e.active)
        self.assertFalse(self.c.paused)
        self.assertEqual(sum(u is target for _,u,_ in self.vm.damage),1)

    def test_f_cooldown_removes_bonuses_and_restores_them_only_when_ready(self):
        target = self.vm.unit(x=300,owner=2)
        self.f.stacks = 3
        self.f.SetEnhanced(True)
        self.assertTrue(self.f.enhanced)
        self.assertIn("AIsx",self.c.abilities)
        self.vm.run("CrocodileF_Attack",(self.c,target,100))
        self.assertFalse(self.f.enhanced)
        self.assertNotIn("AIsx",self.c.abilities)
        self.assertTrue(self.c.weapons[0]["UNIT_WEAPON_BF_ATTACKS_ENABLED"])
        self.assertFalse(self.c.weapons[1]["UNIT_WEAPON_BF_ATTACKS_ENABLED"])
        self.step()
        self.assertEqual(self.f.stacks,2)
        self.vm.run("CrocodileF_AddStack",(self.c,))
        self.assertEqual(self.f.stacks,3)
        self.assertFalse(self.f.enhanced)
        self.assertNotIn("AIsx",self.c.abilities)
        self.step(65)
        self.assertFalse(self.f.enhanced)
        self.assertFalse(self.c.weapons[1]["UNIT_WEAPON_BF_ATTACKS_ENABLED"])
        self.step()
        self.assertTrue(self.f.enhanced)
        self.assertIn("AIsx",self.c.abilities)
        self.assertFalse(self.c.weapons[0]["UNIT_WEAPON_BF_ATTACKS_ENABLED"])
        self.assertTrue(self.c.weapons[1]["UNIT_WEAPON_BF_ATTACKS_ENABLED"])
        self.vm.run("CrocodileF_Attack",(self.c,target,100))
        self.assertFalse(self.f.enhanced)

    def test_f_ready_without_stacks_does_not_restore_bonuses(self):
        target = self.vm.unit(x=300,owner=2)
        self.f.stacks = 1
        self.f.SetEnhanced(True)
        self.vm.run("CrocodileF_Attack",(self.c,target,100))
        self.step(68)
        self.assertEqual(self.f.stacks,0)
        self.assertFalse(self.f.enhanced)
        self.assertNotIn("AIsx",self.c.abilities)
        self.assertTrue(self.c.weapons[0]["UNIT_WEAPON_BF_ATTACKS_ENABLED"])
        self.assertFalse(self.c.weapons[1]["UNIT_WEAPON_BF_ATTACKS_ENABLED"])

    def test_f_cooldown_preserves_external_attack_speed_bonus(self):
        field = "ABILITY_RLF_ATTACK_SPEED_INCREASE_ISX1"
        self.c.abilities["AIsx"] = {"level":1,field:0.5}
        target = self.vm.unit(x=300,owner=2)
        self.f.stacks = 2
        self.f.SetEnhanced(True)
        self.assertAlmostEqual(self.c.abilities["AIsx"][field],3.5)
        self.vm.run("CrocodileF_Attack",(self.c,target,100))
        self.assertAlmostEqual(self.c.abilities["AIsx"][field],0.5)
        self.c.abilities["AIsx"][field] += 0.25
        self.step(67)
        self.assertAlmostEqual(self.c.abilities["AIsx"][field],3.75)
        self.vm.run("CrocodileF_Attack",(self.c,target,100))
        self.assertAlmostEqual(self.c.abilities["AIsx"][field],0.75)

    def test_f_internal_cooldown_is_runtime_configurable(self):
        self.assertEqual(self.vm.g["CrocodileF_InternalCD"],2.0)
        self.vm.g["CrocodileF_InternalCD"] = 0.5
        target = self.vm.unit(x=300,owner=2)
        self.f.stacks = 3
        self.f.SetEnhanced(True)
        self.vm.run("CrocodileF_Attack",(self.c,target,100))
        self.assertAlmostEqual(self.f.cooldown,0.5)

    def test_e_one_second_interval_survives_remaining_charges_and_dash_end(self):
        self.assertTrue(self.vm.run("CrocodileE_Start",(self.c,600,0)))
        self.step(14)
        self.assertFalse(self.e.active)
        self.assertFalse(self.c.paused)
        self.assertGreater(self.e.useCooldown,0)
        self.assertGreater(self.c.cooldown,0)
        self.assertFalse(self.vm.run("CrocodileE_Start",(self.c,1200,0)))
        self.step(19)
        self.assertFalse(self.vm.run("CrocodileE_Start",(self.c,1200,0)))
        self.step()
        self.assertEqual(self.e.useCooldown,0)
        self.assertTrue(self.vm.run("CrocodileE_Start",(self.c,1200,0)))
        self.assertTrue(self.c.paused)
        self.assertAlmostEqual(self.e.useCooldown,1)

    def test_r_distance_trail_spacing_speed_and_animation(self):
        self.assertEqual(self.vm.g["CrocodileR_Animation"],6)
        self.cast("CrocodileR_ID",x=2000)
        tornado = self.vm.structs["CrocodileR_Struct"].m[0]
        self.step(11)
        sand = self.vm.structs["CrocodileSand_Struct"]
        self.assertEqual(sand.MUI,-1)
        self.step()
        self.assertAlmostEqual(sand.m[0].x,180)
        self.step(72)
        self.assertEqual(self.vm.structs["CrocodileR_Struct"].MUI,-1)
        self.assertEqual(sand.MUI+1,7)
        self.assertAlmostEqual(tornado.x,400*1.35*84*0.03)
        for i in range(sand.MUI+1):
            patch = sand.m[i]
            self.assertAlmostEqual(patch.x,(i+1)*180)
            self.assertEqual(patch.radius,self.vm.g["CrocodileSand_Radius"])

    def test_r_trail_skips_existing_sand_without_refreshing_it(self):
        self.vm.AddSand(self.c,180,0,210,False)
        sand = self.vm.structs["CrocodileSand_Struct"]
        existing = sand.m[0]
        fx = existing.e
        self.cast("CrocodileR_ID",x=2000)
        self.step(12)
        self.assertEqual(sand.MUI,0)
        self.assertIs(existing.e,fx)
        self.assertAlmostEqual(existing.r,0.36)
        self.assertEqual(existing.slowLife,0)
        self.step(72)
        self.assertEqual(sand.MUI+1,7)
        self.assertIs(existing.e,fx)
        self.assertAlmostEqual(existing.r,2.52)
        self.assertEqual(existing.radius,210)

    def test_r_trail_spacing_is_configurable_and_large_steps_keep_all_points(self):
        self.vm.g["CrocodileR_SandSpacing"] = 300
        self.vm.g["CrocodileR_Speed"] = 15000
        self.cast("CrocodileR_ID",x=2000)
        self.step(2)
        sand = self.vm.structs["CrocodileSand_Struct"]
        self.assertEqual(sand.MUI+1,3)
        self.assertEqual([sand.m[i].x for i in range(3)],[300,600,900])

    def test_r_short_duration_speed_and_independent_scale_settings(self):
        self.vm.g["CrocodileR_StartScale"] = 0.4
        self.vm.g["CrocodileR_EndScale"] = 0.8
        self.cast("CrocodileR_ID",x=1500)
        tornado = self.vm.structs["CrocodileR_Struct"].m[0]
        fx = tornado.e
        self.assertAlmostEqual(fx.scale,0.4)
        self.assertEqual(tornado.rmax,2.5)
        self.step(42)
        self.assertAlmostEqual(tornado.x,540*1.26)
        self.assertAlmostEqual(fx.scale,0.4+0.4*1.26/2.5)
        self.assertFalse(self.c.paused)
        self.step(42)
        self.assertEqual(self.vm.structs["CrocodileR_Struct"].MUI,-1)
        self.assertAlmostEqual(fx.scale,0.8)
        self.assertNotIn(id(fx),self.vm.effects)

    def test_f_waits_two_seconds_between_projectile_releases(self):
        target = self.vm.unit(x=300,owner=2)
        self.f.stacks = 3
        self.f.SetEnhanced(True)
        self.vm.run("CrocodileF_Attack",(self.c,target,100))
        self.step()
        self.assertEqual(self.f.stacks,2)
        self.step(65)
        self.vm.run("CrocodileF_Attack",(self.c,target,100))
        self.assertIsNone(self.f.pendingTarget)
        self.assertEqual(self.f.stacks,2)
        self.step()
        self.vm.run("CrocodileF_Attack",(self.c,target,100))
        self.assertIs(self.f.pendingTarget,target)
        self.step()
        self.assertEqual(self.f.stacks,1)

    def test_t_cancels_dash_without_dash_cleanup_releasing_t_pause(self):
        self.assertTrue(self.vm.run("CrocodileE_Start",(self.c,600,0)))
        self.assertTrue(self.vm.run("CrocodileT_Start",(self.c,)))
        self.step()
        self.assertFalse(self.e.active)
        self.assertTrue(self.c.paused)
        self.vm.FinishChannel(self.c)
        self.assertFalse(self.c.paused)

    def test_source_has_direct_spell_pause_calls_and_no_ability_disable(self):
        text = SOURCE.read_text(encoding="utf-8")
        self.assertNotIn("BlzUnitDisableAbility",text)
        self.assertNotIn("CrocodileCast",text)
        for ability in ["Q","W","E","R","T"]:
            self.assertIn("StartSpellUnit2(c)",self.vm.methods["Crocodile"+ability+"_Begin"])

    def test_w_keeps_cast_visual_and_large_sand_uses_model_46(self):
        self.cast("CrocodileW_ID",x=0)
        pit = self.vm.structs["CrocodileW_Struct"].m[0]
        self.assertEqual(pit.e.model,"war3mapImported\\wos_file00000862.mdl")
        self.assertAlmostEqual(pit.e.scale,0.01) # EffectSpawnScale begins small, then grows.
        self.vm.AddSand(self.c,0,0,210,False)
        sand = self.vm.structs["CrocodileSand_Struct"]
        small = sand.m[0]
        self.assertEqual(small.e.model,"war3mapImported\\wos_ysjsm45.mdl")
        old = small.e
        self.vm.AddSand(self.c,0,0,400,False)
        self.assertEqual(sand.MUI,0)
        self.assertEqual(small.e.model,"war3mapImported\\wos_ysjsm46.mdl")
        self.assertIsNot(small.e,old)
        self.assertIn([old,0.42],self.vm.timed_effects)
        upgraded = small.e
        self.vm.AddSand(self.c,0,0,600,False)
        self.assertIs(small.e,upgraded)
        self.assertEqual(upgraded.scale,600/150)
        self.vm.AddSand(self.c,1000,0,420,False)
        self.assertEqual(sand.m[1].e.model,"war3mapImported\\wos_ysjsm46.mdl")

    def test_w_existing_sand_never_triggers_combo_but_live_q_crossing_does(self):
        target = self.vm.unit(x=30,owner=2)
        self.vm.AddSand(self.c,0,0,210,True)
        self.cast("CrocodileW_ID",x=0)
        pit = self.vm.structs["CrocodileW_Struct"].m[0]
        self.assertFalse(pit.combo)
        self.assertFalse(self.vm.stuns)
        self.step(22)
        self.assertFalse(pit.combo)
        self.assertFalse(self.vm.stuns)
        self.cast("CrocodileQ_ID",x=1500)
        self.step(40)
        self.assertTrue(pit.combo)
        self.assertEqual(sum(u is target for u,_ in self.vm.stuns),1)
        self.step(10)
        self.assertEqual(sum(u is target for u,_ in self.vm.stuns),1)

    def test_w_leaves_model_46_sand_only_when_finished(self):
        self.cast("CrocodileW_ID",x=0)
        pit = self.vm.structs["CrocodileW_Struct"].m[0]
        fx = pit.e
        self.assertEqual(fx.model,"war3mapImported\\wos_file00000862.mdl")
        self.step(116)
        self.assertEqual(self.vm.structs["CrocodileSand_Struct"].MUI,-1)
        self.step()
        sand = self.vm.structs["CrocodileSand_Struct"].m[0]
        self.assertEqual(sand.e.model,"war3mapImported\\wos_ysjsm46.mdl")
        self.assertNotIn(id(fx),self.vm.effects)

    def test_w_quicksand_pull_strength_increases_toward_center(self):
        near = self.vm.unit(x=100,owner=2)
        middle = self.vm.unit(x=300,owner=2)
        edge = self.vm.unit(x=600,owner=2)
        self.cast("CrocodileW_ID",x=0)
        pit = self.vm.structs["CrocodileW_Struct"].m[0]
        pit.r = 0.60
        pit.scanTime = 0.15
        self.vm.run("Loop_CrocodileW")
        moves = {id(u):d for u,d,_,_ in self.vm.pulls}
        self.assertAlmostEqual(moves[id(near)],17.0)
        self.assertAlmostEqual(moves[id(middle)],9.0)
        self.assertAlmostEqual(moves[id(edge)],4.5)
        self.assertGreater(moves[id(near)],moves[id(middle)])
        self.assertGreater(moves[id(middle)],moves[id(edge)])
        self.assertTrue(all(duration == 0.15 for _,_,duration,_ in self.vm.pulls))

    def test_w_quicksand_clamps_at_center_and_excludes_allies_and_outside(self):
        center = self.vm.unit(x=0,owner=2)
        almost_center = self.vm.unit(x=1,owner=2)
        ally = self.vm.unit(x=100,owner=self.c.owner)
        outside = self.vm.unit(x=601,owner=2)
        self.cast("CrocodileW_ID",x=0)
        pit = self.vm.structs["CrocodileW_Struct"].m[0]
        pit.r = 0.60
        pit.scanTime = 0.15
        self.vm.run("Loop_CrocodileW")
        self.assertEqual(len(self.vm.pulls),1)
        u,duration_distance,duration,angle = self.vm.pulls[0]
        self.assertIs(u,almost_center)
        self.assertEqual(duration_distance,1)
        self.assertAlmostEqual(abs(angle),math.pi)

    def test_w_six_hits_at_half_second_intervals_and_no_damage_after_expiry(self):
        target = self.vm.unit(x=1000,owner=2)
        self.cast("CrocodileW_ID",x=1000)
        self.assertTrue(self.c.paused)
        self.step(15)
        self.assertFalse(self.c.paused)
        for ticks,expected in [(1,0),(1,1),(16,1),(1,2),(16,3),(17,4),(17,5),(16,6)]:
            self.step(ticks)
            self.assertEqual(sum(u is target for _,u,_ in self.vm.damage),expected)
        self.step(20)
        self.assertEqual(sum(u is target for _,u,_ in self.vm.damage),6)
        self.assertEqual(self.vm.structs["CrocodileW_Struct"].MUI,-1)

    def test_e_reaches_six_hundred_and_releases_casting_pause(self):
        self.cast("CrocodileE_ID",x=900)
        self.assertTrue(self.c.paused)
        self.step(8)
        self.assertAlmostEqual(self.c.x,600)
        self.assertFalse(self.c.paused)
        self.assertFalse(self.e.active)

    def test_r_speed_three_sixty_duration_five_and_short_casting_pause(self):
        self.cast("CrocodileR_ID",x=900)
        tornado = self.vm.structs["CrocodileR_Struct"].m[0]
        self.step(15)
        self.assertFalse(self.c.paused)
        self.assertAlmostEqual(tornado.x,360*0.45)
        self.step(150)
        self.assertTrue(tornado.alive)
        self.step(2)
        self.assertFalse(tornado.alive)

    def test_all_owned_casts_release_helpers_on_death(self):
        for ability in ["Q","W","E","R","T"]:
            with self.subTest(ability=ability):
                self.setUp()
                self.cast("Crocodile"+ability+"_ID",x=900)
                self.assertTrue(self.c.paused)
                self.c.life = 0
                self.vm.Death(self.c)
                self.step()
                self.assertFalse(self.c.paused)
                self.assertEqual(self.vm.g["LoadInteger"](self.vm.g["CrocodileTable"],id(self.c),6),0)
                self.assertEqual([b for u,b in self.vm.spell_pause_history if u is self.c],[True,False])

    def test_q_all_tails_destroy_at_explosion_without_waiting_for_next_tick(self):
        self.cast("CrocodileQ_ID",x=2000)
        q = self.vm.structs["CrocodileQ_Struct"].m[0]
        self.step(35)
        self.assertNotEqual(q.trails,0)
        self.step()
        slash_effects = [e for e in self.vm.effect_history if e.model=="war3mapImported\\wos_File00001240.mdl"]
        self.assertEqual(len(slash_effects),3)
        self.assertTrue(all(id(e) not in self.vm.effects for e in slash_effects))
        self.assertEqual(q.trails,0)
        self.assertIsNone(q.e)
        self.assertTrue(q.alive)

    def test_w_combo_is_one_shot(self):
        target = self.vm.unit(x=30,owner=2)
        self.cast("CrocodileW_ID",x=0)
        pit = self.vm.structs["CrocodileW_Struct"].m[0]
        pit.Combo()
        pit.Combo()
        self.assertEqual(len(self.vm.damage),1)
        self.assertEqual(len(self.vm.stuns),1)
        self.assertEqual(self.vm.pulls[0][0],target)
        self.assertAlmostEqual(self.vm.pulls[0][1],30)

    def test_t2_overlap_single_hit_cleanup_and_cc_owner_count(self):
        target = self.vm.unit(x=50,owner=2)
        self.cast("CrocodileT_ID")
        self.c.protection += 1
        self.step(38)
        self.vm.AddSand(self.c,0,0,210,False)
        self.vm.AddSand(self.c,300,0,400,False)
        self.cast("CrocodileT2_ID")
        self.assertEqual(len(self.vm.damage),1)
        self.assertIs(self.vm.damage[0][1],target)
        self.assertEqual(self.state(4),0)
        self.assertEqual(self.c.protection,1)
        self.assertFalse(self.vm.OnGround(target,self.c))
        self.step()
        self.assertEqual(len(self.vm.groups),0)
        self.step(35)
        self.assertEqual(len(self.vm.effects),0)

    def test_t_reduction_all_damage_types(self):
        self.cast("CrocodileT_ID")
        for kind in [0,1,2]: self.assertEqual(self.damage_event(self.c,2,kind),80)

    def test_spell_stacks_cap_and_two_independent_counters(self):
        for _ in range(4): self.cast("CrocodileQ_ID")
        self.assertEqual(self.f.stacks,3)
        self.assertEqual(self.c.counters[self.vm.g["CrocodileF_ID"]],"3")
        self.assertEqual(self.c.counters[self.vm.g["CrocodileE_ID"]],"3")
        self.cast("CrocodileF_ID")
        self.assertEqual(self.f.stacks,3)

    def test_actual_t_unlock_and_early_t2_rejection(self):
        self.cast("CrocodileT_ID")
        self.assertEqual(self.c.protection,1)
        self.cast("CrocodileT2_ID")
        self.assertNotEqual(self.state(4),0)
        self.c.abilities.pop(self.vm.g["CrocodileT2_ID"],None)
        self.step(38)
        self.assertIn(self.vm.g["CrocodileT2_ID"],self.c.abilities)
        self.cast("CrocodileT2_ID")
        self.assertEqual(self.state(4),0)
        self.assertEqual(self.c.protection,0)
        self.assertNotIn(self.vm.g["CrocodileT2_ID"],self.c.abilities)

    def test_death_during_e_does_not_leave_disabled_button(self):
        self.cast("CrocodileE_ID")
        self.assertTrue(self.c.disabled[self.vm.g["CrocodileE_ID"]])
        self.c.life = 0
        self.vm.g["GetTriggerUnit"] = lambda:self.c
        self.vm.Death(self.c)
        self.step()
        self.assertFalse(self.e.active)
        self.assertFalse(self.c.disabled[self.vm.g["CrocodileE_ID"]])
        self.assertEqual(self.f.stacks,0)
        self.assertEqual(self.c.counters[self.vm.g["CrocodileF_ID"]],"0")
        self.assertEqual(len(self.vm.groups),0)

    def test_q_stops_visual_but_logical_point_finishes_with_four_explosions(self):
        target = self.vm.unit(x=100,y=50,owner=2)
        outside = self.vm.unit(x=100,y=170,owner=2)
        self.cast("CrocodileQ_ID")
        q = self.vm.structs["CrocodileQ_Struct"].m[0]
        self.step(14)
        self.assertEqual(q.distance,75)
        self.assertIsNotNone(q.e)
        slash = q.e
        self.assertAlmostEqual(slash.scale,0.45*0.85)
        self.step(2)
        self.assertEqual(q.distance,225)
        self.assertEqual(len(self.vm.damage),0)
        self.assertEqual(len(self.vm.slows),1)
        self.assertEqual(len(self.vm.pulls),1)
        self.step(15)
        self.assertEqual(q.distance,1350)
        self.assertEqual(slash.x,1655-550*0.85)
        self.step(6)
        self.assertEqual(q.distance,1655)
        self.assertEqual(q.x,1655)
        self.assertEqual(slash.x,1655-550*0.85)
        self.assertEqual(sum(u is target for _,u,_ in self.vm.damage),1)
        self.assertEqual(sum(u is outside for _,u,_ in self.vm.damage),0)
        self.assertEqual(sum(a[1] is target and a[3] == 2 for a in self.vm.slows),1)
        explosions = [e for e in self.vm.effect_history if e.model=="war3mapImported\\wos_sandSlashUp.mdl"]
        self.assertEqual([e.x for e in explosions],[250,600,950,1300,1650])
        self.assertTrue(all(e.scale == 0.85 for e in explosions))
        self.assertTrue(all(id(e) not in self.vm.effects for e in explosions))
        self.assertEqual([e.x for e in self.vm.effect_history if e.model==slash.model and e is not slash],[0,600])
        self.assertFalse(any(id(e) in self.vm.effects for e in self.vm.effect_history if e.model==slash.model))
        self.assertIsNone(q.e)
        self.step()
        self.assertIsNone(q.g)
        self.assertIsNone(q.g2)
        self.assertIsNone(q.g3)

    def test_q_launch_and_pause_follow_supplied_timings(self):
        self.cast("CrocodileQ_ID")
        q = self.vm.structs["CrocodileQ_Struct"].m[0]
        self.assertEqual(self.c.pause_count,1)
        self.step(13)
        self.assertIsNone(q.e)
        self.step()
        self.assertEqual(q.distance,75)
        self.assertIsNotNone(q.e)
        self.step(3)
        self.assertEqual(self.c.pause_count,1)
        self.step()
        self.assertEqual(self.c.pause_count,0)
        self.assertEqual([b for u,b in self.vm.pause_history if u is self.c],[True,False])
        self.step(24)
        self.assertEqual(self.c.pause_count,0)

    def test_q_death_before_launch_releases_only_its_pause(self):
        self.vm.pause(self.c,True)
        self.cast("CrocodileQ_ID")
        self.assertEqual(self.c.pause_count,2)
        self.c.life = 0
        self.vm.Death(self.c)
        self.step()
        self.assertEqual(self.c.pause_count,1)
        self.assertEqual(self.vm.structs["CrocodileQ_Struct"].MUI,-1)

    def test_q_aoe_scan_spacing_limits_calls_and_covers_edges_and_last_section(self):
        self.vm.g["CrocodileQ_Aoe"] = 300.0
        targets = [self.vm.unit(x=x,y=299,owner=2) for x in [1,295,590,885,1180,1650]]
        self.cast("CrocodileQ_ID")
        q = self.vm.structs["CrocodileQ_Struct"].m[0]
        self.assertEqual(q.scanStep,295)
        scan_group = q.g
        self.step(37)
        q_scans = [call for call in self.vm.scan_calls if call[0] is scan_group]
        self.assertEqual(len(q_scans),12) # 6 first-pass + 6 damage, not per 75 move.
        for target in targets:
            self.assertEqual(sum(u is target for _,u,_ in self.vm.damage),1)
            self.assertEqual(sum(a[1] is target and a[3] == 2 for a in self.vm.slows),1)
        self.assertEqual(len(self.vm.groups),int(self.vm.g["CrocodileSand_ScanGroup"] is not None))

    def test_q_debug_deadline_cleans_a_stalled_projectile_without_damage(self):
        self.cast("CrocodileQ_ID")
        q = self.vm.structs["CrocodileQ_Struct"].m[0]
        q.move = 0.0 # Simulate a later mechanic accidentally stopping movement.
        self.step(101)
        self.assertFalse(q.alive)
        self.assertEqual(len(self.vm.damage),0)
        self.assertIsNone(q.g)
        self.assertIsNone(q.e)
        self.assertEqual(self.vm.structs["CrocodileQ_Struct"].MUI,-1)

    def test_q_w_combo_can_trigger_on_the_terminal_segment_after_reordering(self):
        self.vm.g["CrocodileW_Aoe"] = 10.0
        self.cast("CrocodileW_ID",x=1817)
        pit = self.vm.structs["CrocodileW_Struct"].m[0]
        self.cast("CrocodileQ_ID")
        self.step(35)
        self.assertFalse(pit.combo)
        self.step()
        self.assertTrue(pit.combo)

    def test_q_target_entering_later_section_is_hit_at_detonation(self):
        target = self.vm.unit(x=900,owner=2)
        self.cast("CrocodileQ_ID")
        self.step(38)
        self.assertEqual(sum(u is target for _,u,_ in self.vm.damage),1)
        self.assertEqual(sum(a[1] is target and a[3] == 2 for a in self.vm.slows),1)

    def test_q_hits_multiple_enemies_and_two_casters_independently(self):
        first = self.vm.unit(x=300,y=50,owner=2)
        second = self.vm.unit(x=350,y=-50,owner=2)
        other = self.vm.unit(x=0,y=1000,owner=3)
        self.vm.hero(other)
        self.cast("CrocodileQ_ID")
        self.vm.run("CrocodileQ_Start",(other,300,1000))
        self.step(38)
        self.assertEqual(sum(c is self.c and u is first for c,u,_ in self.vm.damage),1)
        self.assertEqual(sum(c is self.c and u is second for c,u,_ in self.vm.damage),1)
        self.assertEqual(sum(c is other for c,_,_ in self.vm.damage),0)
        self.assertEqual(self.vm.structs["CrocodileQ_Struct"].MUI,-1)

    def test_q_w_crossing_with_existing_sand_does_not_combo_early(self):
        target = self.vm.unit(x=300,owner=2)
        self.vm.AddSand(self.c,300,0,210,True)
        self.cast("CrocodileW_ID")
        self.assertEqual(len(self.vm.stuns),0)
        self.cast("CrocodileQ_ID")
        self.step(38)
        self.assertEqual(sum(u is target and amount==200 for _,u,amount in self.vm.damage),1)
        self.assertEqual(len(self.vm.stuns),1)

    def test_natural_t_completion_releases_protection_and_keeps_sand(self):
        self.cast("CrocodileT_ID")
        self.step(168)
        self.assertEqual(self.state(4),0)
        self.assertEqual(self.c.protection,0)
        self.assertTrue(self.vm.OnGround(self.c,self.c))

    def test_transform_during_multiple_spells_cleans_all_ability_state(self):
        for code in ["CrocodileQ_ID","CrocodileW_ID","CrocodileE_ID","CrocodileR_ID"]:
            self.cast(code)
        self.cast("CrocodileT_ID")
        self.c.type = "other"
        self.step(40)
        self.assertEqual(self.state(0),0)
        self.assertEqual(self.c.protection,0)
        self.assertEqual(self.vm.clock_users,0)
        self.assertEqual(len(self.vm.groups),0)
        self.assertEqual(len(self.vm.effects),0)


class TasChargeBoxTests(unittest.TestCase):
    def setUp(self):
        text = (ROOT/"triggers/Systems/TasBox.j").read_text(encoding="utf-8")
        text = re.sub(r"\b(?:public|private) function", "method", text).replace("endfunction","endmethod")
        self.vm = JassState(text)
        self.unit = self.vm.unit()
        self.hash = {}
        self.visible = {}
        self.labels = {}
        self.positions = {"E":(2,2),"F":(1,1)}
        self.vm.g.update({
            "Hash":self.hash,"Unit":[self.unit],"FrameBox":list(range(12)),"FrameText":list(range(12)),
            "GetLocalPlayer":lambda:0,"GetPlayerId":lambda p:p,
            "SaveStr":lambda table,key,child,v:table.update({(key,child,"s"):v}),
            "LoadStr":lambda table,key,child:table.get((key,child,"s"),""),
            "RemoveSavedInteger":lambda table,key,child:table.pop((key,child),None),
            "RemoveSavedString":lambda table,key,child:table.pop((key,child,"s"),None),
            "BlzGetAbilityPosX":lambda code:self.positions[code][0],
            "BlzGetAbilityPosY":lambda code:self.positions[code][1],
            "BlzFrameSetVisible":lambda frame,show:self.visible.update({frame:show}),
            "BlzFrameSetText":lambda frame,value:self.labels.update({frame:value}),
        })

    def test_clear_one_counter_preserves_other_and_readding_does_not_duplicate(self):
        self.vm.SetValue(self.unit,"E","3")
        self.vm.SetValue(self.unit,"F","2")
        self.vm.ClearValue(self.unit,"F")
        self.assertEqual(self.vm.GetValue(self.unit,"E"),"3")
        self.assertEqual(self.vm.GetValue(self.unit,"F"),"")
        self.vm.SetValue(self.unit,"F","1")
        self.vm.SetValue(self.unit,"F","0")
        self.assertEqual(self.hash[(id(self.unit),0)],2)
        self.vm.ClearValue(self.unit,"E")
        self.assertEqual(self.vm.GetValue(self.unit,"F"),"0")
        self.assertEqual(self.hash[(id(self.unit),0)],1)

    def test_render_two_slots_and_ignore_invalid_or_missing_ability(self):
        for code,value in [("E","3"),("F","2")]:
            self.vm.add_ability(self.unit,code)
            self.vm.SetValue(self.unit,code,value)
        self.vm.Update()
        self.assertEqual({i for i,show in self.visible.items() if show},{5,10})
        self.assertEqual((self.labels[10],self.labels[5]),("3","2"))
        self.positions["F"] = (-1,-1)
        self.unit.abilities.pop("E")
        self.vm.Update()
        self.assertFalse(any(self.visible.values()))
        self.positions["F"] = (0,3)
        self.vm.Update()
        self.assertNotIn(12,self.visible)


class CrocodileObjectProfileTests(unittest.TestCase):
    def test_existing_objects_only_and_idempotent(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            for folder in ["object-data",".object-data-raw"]:
                shutil.copytree(ROOT/"test_map"/folder,root/"test_map"/folder)
            before = json.loads((root/"test_map/object-data/abilities.json").read_text(encoding="utf-8-sig"))
            profile.configure(root)
            first,_ = objects.prepare_documents(root/"test_map/object-data",root/"test_map/.object-data-raw")
            profile.configure(root)
            second,_ = objects.prepare_documents(root/"test_map/object-data",root/"test_map/.object-data-raw")
            self.assertEqual(first,second)
            after = json.loads((root/"test_map/object-data/abilities.json").read_text())
            self.assertEqual(set(before),set(after))
            for key in set(before)-{"A000","A001","A002","A003","A004","A015","A01U","A01V"}:
                self.assertEqual(before[key],after[key])


if __name__ == "__main__":
    unittest.main()
