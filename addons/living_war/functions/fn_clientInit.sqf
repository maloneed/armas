// Runs on the local host too; dedicated servers have no player interface.
if (!hasInterface) exitWith {};
if (missionNamespace getVariable ["LW_clientStarted", false]) exitWith {};
missionNamespace setVariable ["LW_clientStarted", true];
[] spawn {
    waitUntil {sleep 0.25; !isNull player && {!isNull findDisplay 46}};
    private _deadline = diag_tickTime + 30;
    waitUntil {sleep 0.25; missionNamespace getVariable ["LW_serverReady", false] || {diag_tickTime >= _deadline}};
    call LW_fnc_restoreVanillaRadioUI;
    player createDiarySubject ["LivingWar", "Living War"];
    player createDiaryRecord ["LivingWar", ["Состояние мода", "Living War загружен. В меню действий бойца доступен пункт «Living War — состояние». Он показывает готовность серверного ядра, настройки и число зарегистрированных лагерей. Ноль лагерей означает, что бытовые сцены пока не подключены к этой миссии."]];
    while {true} do {
        private _unit = player;
        private _action = _unit addAction ["<t color='#80d890'>◆ Living War — состояние</t>", {call LW_fnc_showStatus}, nil, -10, false, true, "", "_target == player"];
        private _commandAction = _unit addAction ["<t color='#80bfff'>◆ ARMAS Strategic Command</t>", {call LW_fnc_openCommanderUI}, nil, -11, false, true, "", "_target == player"];
        call LW_fnc_showStatus;
        waitUntil {sleep 1; isNull _unit || {player != _unit}};
        if (!isNull _unit) then {_unit removeAction _action; _unit removeAction _commandAction};
        waitUntil {sleep 0.25; !isNull player};
    };
};
