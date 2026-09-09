if (!isServer) exitWith {[]};
private _state = call LW_fnc_getState;
private _records = _state getOrDefault ["aiGroups", []];
private _restored = [];
{
    private _record = _x;
    private _uid = _record getOrDefault ["uid", ""];
    private _callsign = _record getOrDefault ["callsign", ""];
    private _sideKey = _record getOrDefault ["side", "OTHER"];
    private _targetSide = switch (_sideKey) do {
        case "WEST": {west};
        case "EAST": {east};
        case "INDEPENDENT": {independent};
        default {sideUnknown};
    };
    private _targetPos = _record getOrDefault ["position", [0, 0, 0]];
    private _role = _record getOrDefault ["role", "UNASSIGNED"];
    private _candidates = allGroups select {
        private _g = _x;
        private _alive = (units _g) select {alive _x};
        count _alive > 0 && {_alive findIf {isPlayer _x} < 0} && {side _g == _targetSide}
    };
    private _scored = _candidates apply {
        private _g = _x;
        private _exact = (_g getVariable ["LW_callsign", ""]) == _callsign;
        private _roleMatch = (_g getVariable ["LW_antistasiRole", "UNASSIGNED"]) == _role;
        private _distance = (leader _g) distance2D _targetPos;
        [_g, _exact, _roleMatch, _distance]
    };
    _scored sort false;
    private _match = objNull;
    {
        if ((_x select 1) || {(_x select 2) && {(_x select 3) <= 3500}}) exitWith {_match = _x select 0};
    } forEach _scored;
    if (isNull _match && {count _scored > 0}) then {
        private _nearest = (_scored select 0);
        if ((_nearest select 3) <= 3500) then {_match = _nearest select 0};
    };
    if (!isNull _match) then {
        _match setVariable ["LW_callsign", _callsign, true];
        _match setVariable ["LW_antistasiRole", _role, true];
        _match setVariable ["LW_districtId", _record getOrDefault ["district", ""], true];
        private _order = _record getOrDefault ["order", createHashMap];
        if (count _order > 0) then {_match setVariable ["LW_directorOrder", _order, true]};
        private _savedUnits = _record getOrDefault ["units", []];
        private _liveUnits = (units _match) select {alive _x};
        {
            if (count _liveUnits > 0) then {
                private _saved = _x;
                private _nearest = _liveUnits select 0;
                private _nearestDistance = 1e12;
                {
                    private _distance = (_x distance2D (_saved get "position"));
                    if (_distance < _nearestDistance) then {_nearest = _x; _nearestDistance = _distance};
                } forEach _liveUnits;
                _nearest setUnitLoadout (_saved get "loadout");
                _nearest setPosATL (_saved get "position");
                _nearest setDir (_saved get "direction");
                _nearest setDamage (_saved getOrDefault ["damage", 0]);
                _liveUnits = _liveUnits - [_nearest];
            };
        } forEach _savedUnits;
        _restored pushBack createHashMapFromArray [["uid", _uid], ["group", _match], ["callsign", _callsign]];
    };
} forEach _records;
_restored
