/*
    Strategic director tick. Existing AI dispatch is opt-in through LW_config.dispatchAI.
    Recent AI losses can escalate a district reaction to REGROUP or QRF_REQUEST.
*/
if (!isServer) exitWith {false};
params [["_districtIds", []]];
private _state = call LW_fnc_getState;
private _districts = _state getOrDefault ["districts", createHashMap];
private _ids = if (count _districtIds == 0) then {keys _districts} else {_districtIds};
private _config = call LW_fnc_getConfig;
private _records = _state getOrDefault ["aiGroups", []];
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

    private _losses = 0;
    {
        if ((_x getOrDefault ["district", ""]) == _id) then {
            _losses = _losses + (_x getOrDefault ["recentLosses", 0]);
        };
    } forEach _records;
    private _reaction = switch (true) do {
        case (_losses >= 4): {"QRF_REQUEST"};
        case (_losses >= 2): {"REGROUP"};
        case (_threat >= 75): {"COUNTERATTACK"};
        case (_threat >= 50): {"QRF_READY"};
        case (_threat >= 25): {"PATROL"};
        default {"OBSERVE"};
    };
    private _dispatch = [];
    private _position = _district getOrDefault ["position", []];
    if (_config getOrDefault ["dispatchAI", false] && {_position isEqualType []} && {count _position >= 2} && {_reaction != "OBSERVE"}) then {
        _dispatch = [_reaction, _id, _position, _config getOrDefault ["dispatchRadius", 2500], east] call LW_fnc_directorDispatch;
    };
    _reactions pushBack createHashMapFromArray [
        ["district", _id],
        ["reaction", _reaction],
        ["threat", _threat],
        ["recentLosses", _losses],
        ["ordersIssued", count _dispatch]
    ];
} forEach _ids;

_state set ["districts", _districts];
_state set ["director", createHashMapFromArray [["lastTick", diag_tickTime], ["reactions", _reactions]]];
missionNamespace setVariable ["LW_state", _state, true];
_reactions
