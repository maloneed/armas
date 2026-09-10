if (!hasInterface) exitWith {};
params ["_result"];
if !(_result getOrDefault ["accepted", false]) exitWith {hint (_result getOrDefault ["reason", "Новая задача недоступна."])};
private _reward = _result getOrDefault ["reward", createHashMap];
hint parseText format [
    "<t size='1.2' color='#ffd84a'>НОВАЯ ЗАДАЧА</t><br/><br/><t color='#8fd3ff'>%1</t><br/>%2<br/><br/>Награда: люди %3 | деньги %4 | элитное снаряжение %5<br/>Урон экономике противника: %6",
    _result getOrDefault ["title", "Без названия"],
    _result getOrDefault ["description", ""],
    _reward getOrDefault ["manpower", 0],
    _reward getOrDefault ["money", 0],
    _reward getOrDefault ["eliteGear", 0],
    _reward getOrDefault ["economyDamage", 0]
];
private _old = uiNamespace getVariable ["LW_delegateAction", -1];
if (_old >= 0) then {player removeAction _old};
private _missionId = _result getOrDefault ["instanceId", _result getOrDefault ["missionId", ""]];
private _action = player addAction ["<t color='#ffd84a'>◆ Делегировать задачу AI</t>", {
    params ["_target", "_caller", "_id"];
    [_id, "DEMOLITION"] remoteExecCall ["LW_fnc_requestDelegateMission", 2];
}, _missionId, -9, false, true, "", "_this == player"];
uiNamespace setVariable ["LW_delegateAction", _action];
