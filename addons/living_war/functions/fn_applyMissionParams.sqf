if (!isServer) exitWith {createHashMap};
private _runtime = createHashMap;
private _read = {
    params ["_name", "_key"];
    private _value = getMissionConfigValue [_name, -1];
    if (_value isEqualType 0 && {_value >= 0}) then {_runtime set [_key, _value == 1]};
};
["LW_enabled", "enabled"] call _read;
["LW_autoAssignRoles", "autoAssignRoles"] call _read;
["LW_dispatchAI", "dispatchAI"] call _read;
["LW_ambientEnabled", "ambientEnabled"] call _read;
["LW_radioEnabled", "radioEnabled"] call _read;
["LW_campMissionsEnabled", "campMissionsEnabled"] call _read;
private _radius = getMissionConfigValue ["LW_roleAssignmentRadius", -1];
if (_radius >= 0) then {_runtime set ["roleAssignmentRadius", _radius]};
private _dispatchRadius = getMissionConfigValue ["LW_dispatchRadius", -1];
if (_dispatchRadius >= 0) then {_runtime set ["dispatchRadius", _dispatchRadius]};
missionNamespace setVariable ["LW_runtimeConfig", _runtime, true];
_runtime
