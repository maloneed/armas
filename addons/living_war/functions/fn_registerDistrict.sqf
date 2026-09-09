params ["_districtId", ["_initial", createHashMap]];
if (!isServer) exitWith {false};
private _state = call LW_fnc_getState;
private _districts = _state getOrDefault ["districts", createHashMap];
private _district = createHashMapFromArray [["pressure", 0], ["support", 50], ["supply", 50], ["threat", 0]];
{
    _district set [_x, _initial get _x];
} forEach keys _initial;
_districts set [_districtId, _district];
_state set ["districts", _districts];
missionNamespace setVariable ["LW_state", _state, true];
true
