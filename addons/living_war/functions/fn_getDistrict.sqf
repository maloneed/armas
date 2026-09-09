params ["_districtId"];
private _state = call LW_fnc_getState;
private _districts = _state getOrDefault ["districts", createHashMap];
_districts getOrDefault [_districtId, createHashMap]
