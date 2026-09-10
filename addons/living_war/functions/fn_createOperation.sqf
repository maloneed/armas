if (!isServer) exitWith {createHashMap};
params ["_operationType", "_title", "_districtId", "_targetPosition", ["_targetId", ""]];
private _state = call LW_fnc_getState;
private _seq = (_state getOrDefault ["sequence", 0]) + 1;
private _id = format ["%1-%2", _operationType, _seq];
private _operation = createHashMapFromArray [
    ["id", _id], ["type", _operationType], ["title", _title], ["district", _districtId],
    ["targetPosition", _targetPosition], ["targetId", _targetId], ["state", "PLANNING"],
    ["assignedGroup", grpNull], ["assignedCallsign", ""], ["retryCount", 0],
    ["createdAt", diag_tickTime], ["lastTransition", diag_tickTime], ["blockedReason", ""],
    ["currentAction", "PLANNING"]
];
private _ops = _state getOrDefault ["operations", []];
_ops pushBack _operation;
_state set ["operations", _ops];
_state set ["sequence", _seq];
missionNamespace setVariable ["LW_state", _state, true];
[_id, createHashMapFromArray [["operation", _id], ["title", _title]]] call LW_fnc_radioPublish;
missionNamespace setVariable ["LW_dirty", true, true];
_operation
