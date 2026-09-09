params ["_districtId", "_eventType", ["_amount", 10]];
if (!isServer) exitWith {false};
private _delta = createHashMap;
switch (toUpper _eventType) do {
    case "CONVOY_SUCCESS": {_delta set ["supply", _amount]; _delta set ["support", 2];};
    case "CONVOY_FAILED": {_delta set ["supply", -_amount]; _delta set ["pressure", 5];};
    case "SABOTAGE": {_delta set ["supply", -_amount]; _delta set ["threat", 5];};
    default {exitWith {false};};
};
[_eventType, _districtId, createHashMapFromArray [["delta", _delta], ["amount", _amount]]] call LW_fnc_applyEvent
