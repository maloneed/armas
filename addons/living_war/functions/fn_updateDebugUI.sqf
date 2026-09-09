if (!hasInterface) exitWith {false};
private _display = uiNamespace getVariable ["LW_debugDisplay", displayNull];
private _body = uiNamespace getVariable ["LW_debugBody", controlNull];
if (isNull _display || {isNull _body}) exitWith {false};

private _state = call LW_fnc_getState;
private _districts = _state getOrDefault ["districts", createHashMap];
private _lines = [
    "<t color='#ffd84a' size='1.15'>СОСТОЯНИЕ КАМПАНИИ</t>",
    format ["Версия: %1 | Событие №: %2", _state getOrDefault ["version", 0], _state getOrDefault ["sequence", 0]],
    ""
];
{
    private _d = _districts get _x;
    _lines pushBack format [
        "<t color='#8fd3ff'>Район %1</t> — давление %2 | поддержка %3 | снабжение %4 | угроза %5",
        _x,
        round (_d getOrDefault ["pressure", 0]),
        round (_d getOrDefault ["support", 50]),
        round (_d getOrDefault ["supply", 50]),
        round (_d getOrDefault ["threat", 0])
    ];
} forEach keys _districts;

_lines pushBack "";
_lines pushBack "<t color='#ffd84a' size='1.15'>ПРИКАЗЫ DIRECTOR И РОЛИ AI</t>";
private _count = 0;
{
    private _role = _x getVariable ["LW_antistasiRole", "НЕ НАЗНАЧЕНА"];
    private _callsign = _x getVariable ["LW_callsign", "без позывного"];
    private _order = _x getVariable ["LW_directorOrder", createHashMap];
    if (_role != "UNASSIGNED" || {count _order > 0}) then {
        private _reaction = _order getOrDefault ["reaction", "нет приказа"];
        private _district = _x getVariable ["LW_districtId", "не определён"];
        private _strength = count (units _x select {alive _x});
        private _losses = 0;
        {
            if ((_x getOrDefault ["callsign", ""]) == _callsign) exitWith {_losses = _x getOrDefault ["losses", 0]};
        } forEach (_state getOrDefault ["aiGroups", []]);
        _lines pushBack format ["%1 — роль: %2 | район: %3 | приказ: %4 | бойцов: %5 | потери: %6", _callsign, _role, _district, _reaction, _strength, _losses];
        _count = _count + 1;
    };
} forEach allGroups;
if (_count == 0) then {_lines pushBack "Нет назначенных AI-групп или активных приказов.";};

_lines pushBack "";
_lines pushBack format ["Время сервера: %1 | Групп в отчёте: %2", round diag_tickTime, _count];
_body ctrlSetStructuredText parseText (_lines joinString "<br/>");
true
