if (!isServer) exitWith {[]};
private _state = call LW_fnc_getState;
private _records = [];
{
    private _group = _x;
    private _alive = (units _group) select {alive _x};
    private _hasPlayer = _alive findIf {isPlayer _x} >= 0;
    if (count _alive > 0 && !_hasPlayer) then {
        _records pushBack ([_group] call LW_fnc_captureGroupState);
    };
} forEach allGroups;
_state set ["aiGroups", _records];
_state set ["groupsSavedAt", diag_tickTime];
missionNamespace setVariable ["LW_state", _state, true];
_records
