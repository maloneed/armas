if (!isServer) exitWith {0};
private _state = call LW_fnc_getState;
private _ops = _state getOrDefault ["operations", []];
private _targets = missionNamespace getVariable ["LW_operationTargets", createHashMap];
private _changed = 0;
{
    private _op = _x;
    private _status = _op getOrDefault ["state", "PLANNING"];
    if (_status in ["COMPLETED", "FAILED", "ABORTED"]) then {continue};
    private _group = _op getOrDefault ["assignedGroup", grpNull];
    if (isNull _group || {({alive _x} count units _group) == 0}) then {
        private _retries = _op getOrDefault ["retryCount", 0];
        if (_retries < 2) then {
            _op set ["state", "RETRYING"];
            _op set ["retryCount", _retries + 1];
            _op set ["blockedReason", "Группа потеряна; требуется переназначение"];
        } else {
            _op set ["state", "FAILED"];
            _op set ["blockedReason", "Группа потеряна после повторных попыток"];
            [_op get "id", createHashMapFromArray [["operation", _op get "id"]], "CRITICAL"] call LW_fnc_radioPublish;
        };
        _changed = _changed + 1;
        continue
    };
    private _target = _targets getOrDefault [_op get "id", objNull];
    private _targetPos = _op getOrDefault ["targetPosition", []];
    private _distance = if (isNull _target) then {leader _group distance2D _targetPos} else {leader _group distance2D _target};
    if (_status in ["PREPARING", "MOVING"] && {_distance > 100}) then {
        _op set ["state", "MOVING"];
        (leader _group) doMove _targetPos;
        _op set ["currentAction", "MOVING"];
    } else {
        if (_distance <= 100 && {_status in ["PREPARING", "MOVING", "APPROACHING"]}) then {
            _op set ["state", "EXECUTING"];
            _op set ["currentAction", "DEMOLITION"];
            [_op get "id", createHashMapFromArray [["operation", _op get "id"], ["callsign", _op getOrDefault ["assignedCallsign", "ALPHA"]]], "OPERATIONAL"] call LW_fnc_radioPublish;
        };
        if ((_op getOrDefault ["state", ""]) == "EXECUTING") then {
            if (isNull _target || {!alive _target} || {_target getVariable ["LW_destroyed", false]}) then {
                _op set ["state", "COMPLETED"];
                _op set ["currentAction", "CONFIRMED"];
                _op set ["lastTransition", diag_tickTime];
                _group setVariable ["LW_currentOperation", "", true];
                [_op getOrDefault ["targetId", ""], _op getOrDefault ["district", ""]] call LW_fnc_completeMission;
                [_op get "id", createHashMapFromArray [["operation", _op get "id"], ["callsign", _op getOrDefault ["assignedCallsign", "ALPHA"]]], "CRITICAL"] call LW_fnc_radioPublish;
            } else {
                _target setDamage 1;
                _target setVariable ["LW_destroyed", true, true];
                _op set ["state", "VERIFYING"];
            };
        };
        if ((_op getOrDefault ["state", ""]) == "VERIFYING" && {isNull _target || {!alive _target} || {_target getVariable ["LW_destroyed", false]}}) then {
            _op set ["state", "COMPLETED"];
            _op set ["currentAction", "CONFIRMED"];
            _group setVariable ["LW_currentOperation", "", true];
            [_op getOrDefault ["targetId", ""], _op getOrDefault ["district", ""]] call LW_fnc_completeMission;
            [_op get "id", createHashMapFromArray [["operation", _op get "id"]], "CRITICAL"] call LW_fnc_radioPublish;
        };
    };
    _op set ["lastTransition", diag_tickTime];
    _ops set [_forEachIndex, _op];
    _changed = _changed + 1;
} forEach _ops;
if (_changed > 0) then {
    _state set ["operations", _ops];
    missionNamespace setVariable ["LW_state", _state, true];
    missionNamespace setVariable ["LW_dirty", true, true];
};
_changed
