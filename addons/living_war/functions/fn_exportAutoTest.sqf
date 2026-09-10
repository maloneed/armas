if (!isServer) exitWith {false};
private _report = missionNamespace getVariable ["LW_lastAutoTest", profileNamespace getVariable ["LW_lastAutoTest", createHashMap]];
private _path = format ["LivingWar_AutoTest_%1_%2.log", worldName, floor diag_tickTime];
private _lines = [format ["Living War AutoTest | status=%1 | world=%2 | mission=%3", _report getOrDefault ["status", "UNKNOWN"], _report getOrDefault ["world", ""], _report getOrDefault ["mission", ""]]];
_lines pushBack format ["started=%1 finished=%2 duration=%3 errors=%4 warnings=%5", _report getOrDefault ["startedAt", 0], _report getOrDefault ["finishedAt", 0], _report getOrDefault ["duration", 0], _report getOrDefault ["errors", 0], _report getOrDefault ["warnings", 0]];
{_lines pushBack format ["[%1] %2: %3", _x getOrDefault ["status", ""], _x getOrDefault ["name", ""], _x getOrDefault ["detail", ""]]} forEach (_report getOrDefault ["checks", []]);
private _text = _lines joinString "\n";
if (hasInterface) then {copyToClipboard _text};
{diag_log format ["[Living War][AUTOTEST][EXPORT] %1", _x]} forEach _lines;
[format ["AutoTest report exported to RPT (%1)%2", _path, if (hasInterface) then {" and clipboard"} else {""}]] call LW_fnc_log;
_lines
