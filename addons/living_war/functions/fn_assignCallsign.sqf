if (!isServer) exitWith {""};
params ["_group"];
private _existing = _group getVariable ["LW_callsign", ""];
if (_existing != "") exitWith {_existing};
private _state = call LW_fnc_getState;
private _indexes = _state getOrDefault ["callsignIndexes", createHashMap];
private _sideKey = switch (side _group) do {
    case west: {"WEST"};
    case east: {"EAST"};
    case independent: {"INDEPENDENT"};
    default {"OTHER"};
};
private _prefix = switch (_sideKey) do {
    case "WEST": {"ЗАПАД"};
    case "EAST": {"ВОСТОК"};
    case "INDEPENDENT": {"СОЮЗ"};
    default {"ГРУППА"};
};
private _number = (_indexes getOrDefault [_sideKey, 0]) + 1;
_indexes set [_sideKey, _number];
private _callsign = format ["%1-%2", _prefix, _number];
_group setVariable ["LW_callsign", _callsign, true];
_state set ["callsignIndexes", _indexes];
missionNamespace setVariable ["LW_state", _state, true];
_callsign
