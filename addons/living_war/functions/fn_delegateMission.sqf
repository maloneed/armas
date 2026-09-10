if (!isServer) exitWith {false};
params ["_missionId", ["_targetObject", objNull], ["_requiredCapability", "DEMOLITION"]];
private _state = call LW_fnc_getState;
private _missions = _state getOrDefault ["missions", []];
private _missionIndex = _missions findIf {(_x getOrDefault ["instanceId", ""]) == _missionId || {(_x getOrDefault ["missionId", ""]) == _missionId}};
if (_missionIndex < 0) exitWith {false};
private _mission = _missions select _missionIndex;
if ((_mission getOrDefault ["status", "ACTIVE"]) != "ACTIVE") exitWith {false};
_requiredCapability = _mission getOrDefault ["requiredCapability", _requiredCapability];
private _groups = [];
{if ((_x getVariable ["LW_currentOperation", ""]) isEqualTo "" && {(alive leader _x)} && {[_x] call LW_fnc_getCapabilities find _requiredCapability >= 0}) then {_groups pushBack _x}} forEach allGroups;
if (count _groups == 0) exitWith {
    _mission set ["status", "WAITING_FOR_GROUP"];
    _mission set ["blockedReason", "Нет доступной группы с требуемой capability"];
    _missions set [_missionIndex, _mission];
    _state set ["missions", _missions];
    missionNamespace setVariable ["LW_state", _state, true];
    ["MISSION_FAILED", createHashMapFromArray [["operation", _missionId], ["reason", "Нет доступной группы"]], "OPERATIONAL"] call LW_fnc_radioPublish;
    false
};
private _group = _groups select 0;
private _targetPos = if (isNull _targetObject) then {_mission getOrDefault ["targetPosition", [0,0,0]]} else {getPosATL _targetObject};
if (isNull _targetObject) then {
    private _district = _state getOrDefault ["districts", createHashMap] getOrDefault [_mission getOrDefault ["district", ""], createHashMap];
    private _origin = _district getOrDefault ["position", _targetPos];
    private _targetTypes = _mission getOrDefault ["targetTypes", []];
    if (count _targetTypes > 0 && {_origin isEqualType []} && {count _origin >= 2}) then {
        private _near = nearestObjects [_origin, _targetTypes, 5000];
        if (count _near > 0) then {_targetObject = _near select 0; _targetPos = getPosATL _targetObject};
    };
};
if (isNull _targetObject) exitWith {
    ["MISSION_FAILED", createHashMapFromArray [["operation", _missionId], ["reason", "Цель радиовышки не найдена"]], "OPERATIONAL"] call LW_fnc_radioPublish;
    false
};
private _operation = ["DESTROY_STRUCTURE", _mission getOrDefault ["title", "Уничтожить объект"], _mission getOrDefault ["district", ""], _targetPos, _missionId] call LW_fnc_createOperation;
_state = call LW_fnc_getState;
private _ops = _state getOrDefault ["operations", []];
private _opIndex = _ops findIf {(_x getOrDefault ["id", ""]) == (_operation get "id")};
_operation set ["assignedGroup", _group];
_operation set ["assignedCallsign", _group getVariable ["LW_callsign", "ALPHA"]];
_operation set ["state", "PREPARING"];
_operation set ["currentAction", "MOVING"];
_ops set [_opIndex, _operation];
_group setVariable ["LW_currentOperation", _operation get "id", true];
_group setVariable ["LW_operationRole", _requiredCapability, true];
_group setVariable ["LW_directorOrder", createHashMapFromArray [["type", "OPERATION"], ["operation", _operation get "id"], ["position", _targetPos]], true];
missionNamespace setVariable ["LW_operationTargets", missionNamespace getVariable ["LW_operationTargets", createHashMap], true];
private _targets = missionNamespace getVariable ["LW_operationTargets", createHashMap];
_targets set [_operation get "id", _targetObject];
missionNamespace setVariable ["LW_operationTargets", _targets, true];
_mission set ["status", "DELEGATED"];
_mission set ["operationId", _operation get "id"];
_missions set [_missionIndex, _mission];
_state set ["operations", _ops];
_state set ["missions", _missions];
missionNamespace setVariable ["LW_state", _state, true];
["ORDER_ASSIGNED", createHashMapFromArray [["operation", _operation get "id"], ["callsign", _operation get "assignedCallsign"]], "OPERATIONAL"] call LW_fnc_radioPublish;
missionNamespace setVariable ["LW_dirty", true, true];
true
