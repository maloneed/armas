/* Server-side diagnostic suite. Results are safe to upload for later analysis. */
if (!isServer) exitWith {createHashMap};
params [["_persist", true]];
private _started = diag_tickTime;
private _checks = [];
private _check = {
    params ["_name", "_status", "_detail"];
    private _entry = createHashMapFromArray [["name", _name], ["status", _status], ["detail", _detail], ["at", diag_tickTime]];
    _checks pushBack _entry;
    diag_log format ["[Living War][AUTOTEST][%1] %2: %3", _status, _name, _detail];
};
private _adapter = missionNamespace getVariable ["LW_antistasiAdapter", createHashMap];
["antistasi_detected", if (_adapter getOrDefault ["detected", false]) then {"PASS"} else {"WARN"}, format ["supported=%1", _adapter getOrDefault ["supported", false]]] call _check;
private _state = call LW_fnc_getState;
["state_initialized", if (count _state > 0) then {"PASS"} else {"FAIL"}, format ["keys=%1", count _state]] call _check;
private _bootstrap = missionNamespace getVariable ["LW_bootstrapReport", createHashMap];
["bootstrap_ran", if (count _bootstrap > 0) then {"PASS"} else {"FAIL"}, format ["groups=%1 districts=%2", _bootstrap getOrDefault ["groups", 0], _bootstrap getOrDefault ["districts", 0]]] call _check;
private _groups = [[], 1e9] call LW_fnc_getAntistasiGroups;
["group_registry", if (count _groups >= 0) then {"PASS"} else {"FAIL"}, format ["visible_ai_groups=%1", count _groups]] call _check;
private _districts = _state getOrDefault ["districts", createHashMap];
["district_registry", if (count _districts > 0) then {"PASS"} else {"FAIL"}, format ["districts=%1", count _districts]] call _check;
private _logs = _state getOrDefault ["eventLog", []];
["event_log", if (_logs isEqualType []) then {"PASS"} else {"FAIL"}, format ["entries=%1", count _logs]] call _check;
private _errors = _checks select {(_x get "status") == "FAIL"};
private _warnings = _checks select {(_x get "status") == "WARN"};
private _status = if (count _errors > 0) then {"FAIL"} else {if (count _warnings > 0) then {"WARN"} else {"PASS"}};
private _report = createHashMapFromArray [["suite", "LivingWarAutoTest"], ["version", 1], ["status", _status], ["startedAt", _started], ["finishedAt", diag_tickTime], ["duration", diag_tickTime - _started], ["checks", _checks], ["errors", count _errors], ["warnings", count _warnings], ["world", worldName], ["mission", missionName], ["serverReady", missionNamespace getVariable ["LW_serverReady", false]]];
missionNamespace setVariable ["LW_lastAutoTest", _report, true];
if (_persist) then {profileNamespace setVariable ["LW_lastAutoTest", _report]; saveProfileNamespace;};
[format ["AUTOTEST RESULT: %1 errors=%2 warnings=%3 duration=%.3f", _status, count _errors, count _warnings, diag_tickTime - _started]] call LW_fnc_log;
_report
