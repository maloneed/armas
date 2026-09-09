if (!isServer) exitWith {false};
private _state = call LW_fnc_getState;
private _districts = _state getOrDefault ["districts", createHashMap];
private _logistics = _state getOrDefault ["logistics", createHashMap];
{
    private _districtId = _x;
    private _supply = (_districts get _districtId) getOrDefault ["supply", 50];
    {
        private _key = format ["%1:%2", _districtId, _x];
        private _pool = _logistics getOrDefault [_key, createHashMapFromArray [["ammo", 100], ["reinforcements", 8]]];
        private _ammo = (_pool getOrDefault ["ammo", 0]) + (floor (_supply / 20));
        private _reinforcements = (_pool getOrDefault ["reinforcements", 0]) + (if (_supply >= 70) then {1} else {0});
        _pool set ["ammo", _ammo min 100];
        _pool set ["reinforcements", _reinforcements min 8];
        _logistics set [_key, _pool];
    } forEach ["EAST", "WEST", "INDEPENDENT"];
} forEach keys _districts;
_state set ["logistics", _logistics];
missionNamespace setVariable ["LW_state", _state, true];
true
