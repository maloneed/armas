if (!hasInterface) exitWith {};
private _markers = uiNamespace getVariable ["LW_commanderMarkers", []];
{deleteMarkerLocal _x} forEach _markers;
_markers = [];
private _state = missionNamespace getVariable ["LW_state", createHashMap];
private _ops = _state getOrDefault ["operations", []];
private _intel = _state getOrDefault ["enemyIntel", []];
{
    private _g = _x;
    if (!isNull _g && {count (units _g select {alive _x}) > 0}) then {
        private _m = createMarkerLocal [format ["LW_CMD_%1", _forEachIndex], getPosATL (leader _g)];
        _m setMarkerTypeLocal "mil_dot";
        _m setMarkerColorLocal "ColorGreen";
        _m setMarkerTextLocal format ["%1 [%2]", _g getVariable ["LW_callsign", "AI"], count (units _g select {alive _x})];
        _markers pushBack _m;
    };
} forEach allGroups;
{
    private _pos = _x getOrDefault ["targetPosition", []];
    if (_pos isEqualType [] && {count _pos >= 2}) then {
        private _m = createMarkerLocal [format ["LW_OP_%1", _forEachIndex], _pos];
        _m setMarkerTypeLocal "mil_objective";
        _m setMarkerColorLocal (if ((_x getOrDefault ["state", ""]) == "COMPLETED") then {"ColorGreen"} else {"ColorYellow"});
        _m setMarkerTextLocal format ["%1: %2", _x getOrDefault ["id", "OP"], _x getOrDefault ["state", "?"]];
        _markers pushBack _m;
    };
} forEach _ops;
{
    private _entry = _x;
    private _age = diag_tickTime - (_entry getOrDefault ["timestamp", 0]);
    private _confidence = _entry getOrDefault ["confidence", 0];
    private _label = if (_age > 900) then {"STALE"} else {if (_confidence >= 0.8) then {"CONFIRMED"} else {if (_confidence >= 0.5) then {"PROBABLE"} else {"UNCONFIRMED"}}};
    private _pos = _entry getOrDefault ["lastKnownPosition", []];
    if (_pos isEqualType [] && {count _pos >= 2}) then {
        private _m = createMarkerLocal [format ["LW_INTEL_%1", _forEachIndex], _pos];
        _m setMarkerTypeLocal "mil_warning";
        _m setMarkerColorLocal "ColorRed";
        _m setMarkerTextLocal format ["%1 (%2)", _label, _entry getOrDefault ["estimatedStrength", 0]];
        _markers pushBack _m;
    };
} forEach _intel;
uiNamespace setVariable ["LW_commanderMarkers", _markers];
