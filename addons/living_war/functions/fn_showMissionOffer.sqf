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
