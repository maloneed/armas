if (!isServer) exitWith {createHashMap};
params ["_group"];
private _callsign = [_group] call LW_fnc_assignCallsign;
private _sideKey = switch (side _group) do {
    case west: {"WEST"};
    case east: {"EAST"};
    case independent: {"INDEPENDENT"};
    default {"OTHER"};
};
private _uid = format ["%1:%2", _sideKey, _callsign];
private _state = call LW_fnc_getState;
private _oldRecords = _state getOrDefault ["aiGroups", []];
private _old = _oldRecords select {(_x getOrDefault ["uid", ""]) == _uid};
private _oldStrength = if (count _old > 0) then {(_old select 0) getOrDefault ["strength", 0]} else {0};
private _units = (units _group) select {alive _x};
private _strength = count _units;
private _losses = if (count _old > 0) then {(_old select 0) getOrDefault ["losses", 0] + ((_oldStrength - _strength) max 0)} else {0};
private _unitSnapshots = [];
{
    _unitSnapshots pushBack createHashMapFromArray [
        ["position", getPosATL _x],
        ["direction", getDir _x],
        ["loadout", getUnitLoadout _x],
        ["damage", damage _x]
    ];
} forEach _units;
createHashMapFromArray [
    ["uid", _uid],
    ["callsign", _callsign],
    ["side", _sideKey],
    ["role", _group getVariable ["LW_antistasiRole", "UNASSIGNED"]],
    ["district", _group getVariable ["LW_districtId", ""]],
    ["position", getPosATL (leader _group)],
    ["direction", getDir (leader _group)],
    ["strength", _strength],
    ["losses", _losses],
    ["recentLosses", ((_oldStrength - _strength) max 0)],
    ["order", _group getVariable ["LW_directorOrder", createHashMap]],
    ["units", _unitSnapshots],
    ["savedAt", diag_tickTime]
]
