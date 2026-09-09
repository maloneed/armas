if (!isServer) exitWith {false};
private _id = "lw_smoke_test";
[_id, createHashMapFromArray [["support", 60], ["supply", 70]]] call LW_fnc_registerDistrict;
[_id, "CONVOY_FAILED", 20] call LW_fnc_applyLogisticsEvent;
[_id, "INTEL_RECEIVED"] call LW_fnc_applyCivilianEvent;
private _reactions = [[_id]] call LW_fnc_directorTick;
private _district = [_id] call LW_fnc_getDistrict;
private _ok = (_district getOrDefault ["supply", 0]) == 50 && (_district getOrDefault ["threat", 0]) >= 0 && count _reactions == 1;
["SMOKE_TEST", _id, createHashMapFromArray [["delta", createHashMapFromArray []], ["passed", _ok]]] call LW_fnc_applyEvent;
format ["Living War smoke test: %1", if (_ok) then {"PASS"} else {"FAIL"}]
