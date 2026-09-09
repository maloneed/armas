if (!isServer) exitWith {false};
params ["_missionId", ["_districtId", ""]];
private _state = call LW_fnc_getState;
private _missions = _state getOrDefault ["missions", []];
private _index = _missions findIf {(_x getOrDefault ["missionId", ""]) == _missionId && {(_x getOrDefault ["status", "ACTIVE"]) == "ACTIVE"}};
if (_index < 0) exitWith {false};
private _record = _missions select _index;
private _reward = _record getOrDefault ["reward", createHashMap];
private _rewards = _state getOrDefault ["rewards", createHashMapFromArray [["manpower", 0], ["money", 0], ["eliteGear", 0]]];
{_rewards set [_x, (_rewards getOrDefault [_x, 0]) + (_reward getOrDefault [_x, 0])]} forEach ["manpower", "money", "eliteGear"];
_record set ["status", "COMPLETED"];
_record set ["completedAt", diag_tickTime];
_missions set [_index, _record];
_state set ["missions", _missions];
_state set ["rewards", _rewards];
missionNamespace setVariable ["LW_state", _state, true];
if (_districtId != "") then {
    [_record getOrDefault ["missionId", "MISSION"], _districtId, createHashMapFromArray [["delta", createHashMapFromArray [["pressure", -(_reward getOrDefault ["economyDamage", 0])], ["support", 2]]]]] call LW_fnc_applyEvent;
};
call LW_fnc_saveState;
true
