if (!isServer) exitWith {false};
params ["_missionId", ["_districtId", ""], ["_ownerId", -1]];
private _state = call LW_fnc_getState;
private _missions = _state getOrDefault ["missions", []];
private _index = _missions findIf {
    private _instance = _x getOrDefault ["instanceId", ""];
    private _legacyMatch = _instance == "" && {(_x getOrDefault ["missionId", ""]) == _missionId};
    (_instance == _missionId || {_legacyMatch}) && {(_x getOrDefault ["status", "ACTIVE"]) == "ACTIVE"}
};
if (_index < 0) exitWith {false};
private _record = _missions select _index;
if (_ownerId >= 0 && {_record getOrDefault ["assignedTo", -2] != _ownerId}) exitWith {false};
if (diag_tickTime > (_record getOrDefault ["expiresAt", diag_tickTime])) exitWith {false};
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
missionNamespace setVariable ["LW_dirty", true, true];
true
