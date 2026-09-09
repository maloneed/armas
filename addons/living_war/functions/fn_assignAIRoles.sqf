/*
    Assign QRF, GARRISON or PATROL to free existing AI groups.
    Assignment is based on the group's current position and the nearest district.
    No group is spawned, deleted or given a movement order here.
*/
if (!isServer) exitWith {[]};
params [["_districtIds", []]];
private _state = call LW_fnc_getState;
private _districts = _state getOrDefault ["districts", createHashMap];
private _config = call LW_fnc_getConfig;
if !(_config getOrDefault ["autoAssignRoles", true]) exitWith {[]};
private _ids = if (count _districtIds == 0) then {keys _districts} else {_districtIds};
private _maxDistance = _config getOrDefault ["roleAssignmentRadius", 3500];
private _assignments = [];

{
    private _group = _x;
    private _units = units _group;
    private _alive = _units select {alive _x};
    private _hasPlayer = _units findIf {isPlayer _x} >= 0;
    private _currentRole = _group getVariable ["LW_antistasiRole", "UNASSIGNED"];
    private _hasOrder = !isNil {_group getVariable "LW_directorOrder"};
    if (count _alive > 0 && !_hasPlayer && !_hasOrder && {_currentRole in ["", "UNASSIGNED"]}) then {
        private _leader = leader _group;
        private _groupPos = getPosATL _leader;
        private _nearest = "";
        private _nearestDistance = 1e12;
        {
            private _district = _districts getOrDefault [_x, createHashMap];
            private _position = _district getOrDefault ["position", []];
            if (_position isEqualType [] && {count _position >= 2}) then {
                private _distance = _groupPos distance2D _position;
                if (_distance < _nearestDistance) then {
                    _nearest = _x;
                    _nearestDistance = _distance;
                };
            };
        } forEach _ids;

        if (_nearest != "" && {_nearestDistance <= _maxDistance}) then {
            private _district = _districts get _nearest;
            private _threat = _district getOrDefault ["threat", 0];
            private _supply = _district getOrDefault ["supply", 50];
            private _role = switch (true) do {
                case (_threat >= 70): {"QRF"};
                case (_supply <= 35 || {_threat >= 40}): {"GARRISON"};
                default {"PATROL"};
            };
            _group setVariable ["LW_antistasiRole", _role, true];
            _group setVariable ["LW_districtId", _nearest, true];
            _group setVariable ["LW_roleAssignedAt", diag_tickTime, true];
            _assignments pushBack createHashMapFromArray [
                ["group", _group],
                ["role", _role],
                ["district", _nearest],
                ["distance", _nearestDistance]
            ];
        };
    };
} forEach allGroups;

if (count _assignments > 0) then {
    [format ["Assigned roles to %1 existing AI groups", count _assignments]] call LW_fnc_log;
};
_assignments
