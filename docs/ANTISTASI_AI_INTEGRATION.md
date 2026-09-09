# Интеграция директора с AI Antistasi

Адаптер Living War не создаёт и не удаляет AI-группы. Он сканирует уже существующие группы через `allGroups`, исключает группы игроков и работает с переменными, не конфликтуя со штатным FSM Antistasi.

## Автоматическое назначение ролей

Каждые пять минут сервер вызывает `LW_fnc_assignAIRoles`. Для каждой свободной группы определяется ближайший район по текущей позиции лидера. Группа получает роль только один раз, если у неё нет игрока, приказа или существующей роли:

| Условия ближайшего района | Назначение |
|---|---|
| Угроза `>= 70` | `QRF` |
| Снабжение `<= 35` или угроза `>= 40` | `GARRISON` |
| Иначе | `PATROL` |

Район должен иметь координату `position` в состоянии. Радиус поиска настраивается в профиле сервера:

```sqf
private _cfg = profileNamespace getVariable ["LW_config", createHashMap];
_cfg set ["autoAssignRoles", true];
_cfg set ["roleAssignmentRadius", 3500];
profileNamespace setVariable ["LW_config", _cfg];
saveProfileNamespace;
```

Принудительный запуск:

```sqf
private _assignments = call LW_fnc_assignAIRoles;
```

## Приказы существующим группам

```sqf
["COUNTERATTACK", "town_alpha", getPosATL player, 2500, east] call LW_fnc_directorDispatch;
```

Функция записывает приказ в `LW_directorOrder`. По умолчанию она не меняет waypoint или FSM группы.

## Подключение движения к Antistasi

```sqf
LW_antistasiDirectorHook = {
    params ["_group", "_order"];
    private _reaction = _order get "reaction";
    private _target = _order get "targetPosition";

    // Здесь вызывается конкретная функция постановки задачи вашей версии Antistasi.
    _group setVariable ["myMissionOrder", [_reaction, _target], true];
};
```

## Русская панель отладки администратора

Откройте на клиенте администратора:

```sqf
call LW_fnc_openDebugUI;
```

Панель обновляется раз в секунду и показывает районы, давление, поддержку, снабжение, угрозу, роль группы и текущий приказ Director. Весь видимый текст интерфейса находится на русском языке. Закрытие:

```sqf
call LW_fnc_closeDebugUI;
```

Панель проверяет `serverCommandAvailable "#kick"` и не открывается у обычного игрока.

Названия и сигнатуры внутренних функций Antistasi различаются между версиями, поэтому конкретный вызов создания waypoint или боевой задачи должен быть добавлен в mission-side hook после проверки вашей версии.
