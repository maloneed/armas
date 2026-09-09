/*
    Returns existing groups that can be used by the director.
    No groups are created or deleted here.

    Params:
      0: center position (ASL/ATL-compatible position array)
      1: scan radius
      2: side to include (sideUnknown includes all non-player AI groups)
*/
params ["_center", ["_radius", 1500], ["_side", sideUnknown]];
private _result = [];
{
    private _group = _x;
    private _units = units _group;
    private _alive = _units select {alive _x};
    private _hasPlayer = _units findIf {isPlayer _x} >= 0;
    private _groupSide = side _group;
    if (count _alive > 0 && !_hasPlayer && (_side == sideUnknown || {_groupSide == _side})) then {
        private _leader = leader _group;
        private _distance = if (_center isEqualTo []) then {0} else {_leader distance2D _center};
        if (_distance <= _radius) then {
            private _role = _group getVariable ["LW_antistasiRole", "UNASSIGNED"];
            private _district = _group getVariable ["LW_districtId", ""];
            _result pushBack createHashMapFromArray [
                ["group", _group],
                ["role", _role],
                ["district", _district],
                ["side", _groupSide],
                ["strength", count _alive],
                ["distance", _distance],
                ["position", getPosATL _leader]
            ];
        };
    };
} forEach allGroups;
_result
