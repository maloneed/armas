/* Открыть русскоязычную панель отладки Director для администратора. */
if (!hasInterface) exitWith {false};
if !(serverCommandAvailable "#kick") exitWith {
    hint "Living War: доступ только для администратора сервера.";
    false
};
if (!isNull (uiNamespace getVariable ["LW_debugDisplay", displayNull])) exitWith {true};

private _display = (findDisplay 46) createDisplay "RscDisplayEmpty";
uiNamespace setVariable ["LW_debugDisplay", _display];
private _background = _display ctrlCreate ["RscText", 5100];
_background ctrlSetPosition [0.08, 0.08, 0.84, 0.84];
_background ctrlSetBackgroundColor [0.02, 0.02, 0.02, 0.92];
_background ctrlCommit 0;

private _title = _display ctrlCreate ["RscText", 5101];
_title ctrlSetPosition [0.10, 0.10, 0.78, 0.05];
_title ctrlSetText "LIVING WAR — ОТЛАДКА ДИРЕКТОРА";
_title ctrlSetTextColor [1, 0.8, 0.25, 1];
_title ctrlCommit 0;

private _body = _display ctrlCreate ["RscStructuredText", 5102];
_body ctrlSetPosition [0.10, 0.17, 0.78, 0.65];
_body ctrlSetBackgroundColor [0, 0, 0, 0.15];
_body ctrlCommit 0;
uiNamespace setVariable ["LW_debugBody", _body];

private _hint = _display ctrlCreate ["RscText", 5103];
_hint ctrlSetPosition [0.10, 0.84, 0.78, 0.04];
_hint ctrlSetText "Обновление: 1 сек. Закрыть: клавиша Ш или кнопка ESC.";
_hint ctrlSetTextColor [0.7, 0.7, 0.7, 1];
_hint ctrlCommit 0;

[] spawn {
    while {!isNull (uiNamespace getVariable ["LW_debugDisplay", displayNull])} do {
        call LW_fnc_updateDebugUI;
        sleep 1;
    };
};
call LW_fnc_updateDebugUI;
true
