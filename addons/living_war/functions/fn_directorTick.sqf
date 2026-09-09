/*
    Lightweight strategic director tick.
    This function only changes campaign state; spawning AI remains an integration concern.
*/
if (!isServer) exitWith {false};
params [["_districtIds", []]];
private _state = call LW_fnc_getState;
private _districts = _state getOrDefault ["districts", createHashMap];
private _ids = if (count _districtIds == 0) then {keys _districts} else {_districtIds};
private _reactions = [];

{
    private _id = _x;
    private _district = _districts getOrDefault [_id, createHashMap];
    private _pressure = _district getOrDefault ["pressure", 0];
    private _supply = _district getOrDefault ["supply", 50];
    private _support = _district getOrDefault ["support", 50];
    private _threat = ((_pressure * 0.6) + ((100 - _supply) * 0.25) + ((100 - _support) * 0.15)) min 100 max 0;
    _district set ["threat", _threat];
    _districts set [_id, _district];

    private _reaction = switch (true) do {
        case (_threat >= 75): {"COUNTERATTACK"};
        case (_threat >= 50): {"QRF_READY"};
        case (_threat >= 25): {"PATROL"};
        default {"OBSERVE"};
    };
    _reactions pushBack createHashMapFromArray [["district", _id], ["reaction", _reaction], ["threat", _threat]];
} forEach _ids;

_state set ["districts", _districts];
_state set ["director", createHashMapFromArray [["lastTick", diag_tickTime], ["reactions", _reactions]]];
missionNamespace setVariable ["LW_state", _state, true];
_reactions
