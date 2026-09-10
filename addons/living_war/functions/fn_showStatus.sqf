if (!hasInterface) exitWith {};
private _ready = missionNamespace getVariable ["LW_serverReady", false];
private _cfg = call LW_fnc_getConfig;
private _enabled = _cfg getOrDefault ["enabled", true];
private _sites = count (missionNamespace getVariable ["LW_ambientSites", createHashMap]);
private _status = if (!_ready) then {"Ядро сервера не подтвердило запуск"} else {
    if (_enabled) then {"Ядро запущено"} else {"Системы отключены настройками"}
};
private _color = if (_ready && {_enabled}) then {"#80d890"} else {"#ffcc66"};
private _note = if (_sites == 0) then {"Лагеря не зарегистрированы: бытовые сцены пока не активны. Требуется подключение лагерей миссии к Living War."} else {"Бытовые сцены доступны у зарегистрированных лагерей для свободных AI."};
hint parseText format ["<t size='1.3' color='%1'>◆ LIVING WAR</t><br/>%2<br/><br/>Карта: %3<br/>Лагерей: %4<br/>Анимации: %5<br/>Радио: %6<br/><br/>%7<br/><br/><t size='0.85'>Повторная проверка: меню действий → Living War — состояние.</t>", _color, _status, worldName, _sites, _cfg getOrDefault ["ambientEnabled", true], _cfg getOrDefault ["radioEnabled", true], _note];
diag_log format ["[Living War] Client status: ready=%1 enabled=%2 sites=%3 world=%4", _ready, _enabled, _sites, worldName];
