/*
    Reserve ammunition and reinforcement capacity for a Director order.
    Actual Antistasi logistics actions can be connected with LW_antistasiLogisticsHook.
*/
if (!isServer) exitWith {createHashMapFromArray [["approved", false]]};
params ["_districtId", "_side", ["_ammo", 0], ["_reinforcements", 0], ["_reason", "DIRECTOR_ORDER"]];
private _state = call LW_fnc_getState;
private _logistics = _state getOrDefault ["logistics", createHashMap];
private _key = format ["%1:%2", _districtId, _side];
private _pool = _logistics getOrDefault [_key, createHashMapFromArray [["ammo", 100], ["reinforcements", 8]]];
private _availableAmmo = _pool getOrDefault ["ammo", 0];
private _availableReinforcements = _pool getOrDefault ["reinforcements", 0];
private _approved = _availableAmmo >= _ammo && {_availableReinforcements >= _reinforcements};
if (_approved) then {
    _pool set ["ammo", _availableAmmo - _ammo];
    _pool set ["reinforcements", _availableReinforcements - _reinforcements];
    _logistics set [_key, _pool];
    _state set ["logistics", _logistics];
    missionNamespace setVariable ["LW_state", _state, true];
    private _hook = missionNamespace getVariable ["LW_antistasiLogisticsHook", nil];
    private _request = createHashMapFromArray [
        ["district", _districtId], ["side", _side], ["ammo", _ammo],
        ["reinforcements", _reinforcements], ["reason", _reason]
    ];
    if (!isNil "_hook" && {_hook isEqualType {}}) then {[_request] call _hook};
    _request set ["approved", true];
    _request
} else {
    createHashMapFromArray [
        ["approved", false], ["district", _districtId], ["side", _side],
        ["ammoAvailable", _availableAmmo], ["reinforcementsAvailable", _availableReinforcements]
    ]
}
