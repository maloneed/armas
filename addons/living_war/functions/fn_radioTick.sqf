if (!isServer) exitWith {0};
private _state = call LW_fnc_getState;
private _queue = _state getOrDefault ["radioEvents", []];
private _now = diag_tickTime;
private _last = _state getOrDefault ["radioLastAt", -1e9];
private _spoken = 0;
if (count _queue > 0 && {_now - _last >= 8}) then {
    private _priority = ["CRITICAL", "OPERATIONAL", "INFORMATION", "AMBIENT", "DEBUG"];
    private _best = -1;
    private _bestRank = 99;
    {
        private _rank = _priority find (_x getOrDefault ["priority", "INFORMATION"]);
        if (_rank >= 0 && {_rank < _bestRank}) then {_best = _forEachIndex; _bestRank = _rank};
    } forEach _queue;
    if (_best >= 0) then {
        private _event = _queue deleteAt _best;
        private _payload = _event getOrDefault ["payload", createHashMap];
        private _callsign = _payload getOrDefault ["callsign", "Штаб"];
        private _operation = _payload getOrDefault ["operation", ""];
        private _text = switch (_event getOrDefault ["type", "INFORMATION"]) do {
            case "GROUP_FORMED": {format ["Сформирована группа %1.", _callsign]};
            case "OBJECTIVE_REACHED": {format ["%1: вышли к цели операции %2.", _callsign, _operation]};
            case "DEMOLITION_PLANTED": {format ["%1: подрывник устанавливает заряд.", _callsign]};
            case "OBJECTIVE_DESTROYED": {format ["%1: цель %2 уничтожена. Отходим.", _callsign, _operation]};
            case "MISSION_COMPLETE": {format ["Штаб: операция %1 завершена.", _operation]};
            case "MISSION_FAILED": {format ["Штаб: операция %1 провалена.", _operation]};
            case "QRF_DISPATCHED": {format ["Штаб: QRF выдвигается к операции %1.", _operation]};
            default {format ["%1: событие %2. Операция %3.", _callsign, _event getOrDefault ["type", "INFORMATION"], _operation]};
        };
        ["РАДИО", _callsign, _text, [0,0,0]] remoteExecCall ["LW_fnc_playRadioLine", 0];
        _state set ["radioLastAt", _now];
        _state set ["radioEvents", _queue];
        _spoken = 1;
    };
};
missionNamespace setVariable ["LW_state", _state, true];
_spoken
