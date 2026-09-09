params ["_districtId", "_eventType"];
if (!isServer) exitWith {false};
private _delta = createHashMap;
switch (toUpper _eventType) do {
    case "AID_DELIVERED": {_delta set ["support", 8]; _delta set ["threat", -3];};
    case "CIVILIAN_HARM": {_delta set ["support", -15]; _delta set ["pressure", 8];};
    case "INTEL_RECEIVED": {_delta set ["threat", -10];};
    default {exitWith {false};};
};
[_eventType, _districtId, createHashMapFromArray [["delta", _delta]]] call LW_fnc_applyEvent
