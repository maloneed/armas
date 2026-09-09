params ["_type", "_districtId", ["_payload", createHashMap]];
if (!isServer) exitWith {false};

private _state = call LW_fnc_getState;
if (count _state == 0) exitWith {false};
private _districts = _state getOrDefault ["districts", createHashMap];
private _district = _districts getOrDefault [_districtId, createHashMapFromArray [
    ["pressure", 0], ["support", 50], ["supply", 50], ["threat", 0]
]];

private _delta = _payload getOrDefault ["delta", createHashMap];
{
    private _key = _x;
    private _value = _district getOrDefault [_key, 0];
    _district set [_key, (_value + (_delta getOrDefault [_key, 0])) max 0 min 100];
} forEach ["pressure", "support", "supply", "threat"];

_districts set [_districtId, _district];
private _sequence = (_state getOrDefault ["sequence", 0]) + 1;
private _log = _state getOrDefault ["eventLog", []];
_log pushBack createHashMapFromArray [
    ["sequence", _sequence],
    ["type", _type],
    ["district", _districtId],
    ["payload", _payload],
    ["at", diag_tickTime]
];
if (count _log > 100) then {_log deleteAt 0};

_state set ["sequence", _sequence];
_state set ["districts", _districts];
_state set ["eventLog", _log];
missionNamespace setVariable ["LW_state", _state, true];
[_type, _districtId] call LW_fnc_log;
call LW_fnc_saveState;
true
