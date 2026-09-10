if (!isServer) exitWith {false};
params ["_eventType", ["_payload", createHashMap], ["_priority", "INFORMATION"]];
private _state = call LW_fnc_getState;
private _queue = _state getOrDefault ["radioEvents", []];
private _event = createHashMapFromArray [
    ["type", _eventType], ["payload", _payload], ["priority", _priority],
    ["at", diag_tickTime], ["key", format ["%1:%2:%3", _eventType, _payload getOrDefault ["operation", ""], floor diag_tickTime]]
];
private _duplicate = _queue findIf {(_x getOrDefault ["key", ""]) == (_event get "key")};
if (_duplicate >= 0) exitWith {false};
_queue pushBack _event;
if (count _queue > 40) then {_queue deleteAt 0};
_state set ["radioEvents", _queue];
missionNamespace setVariable ["LW_state", _state, true];
missionNamespace setVariable ["LW_dirty", true, true];
true
