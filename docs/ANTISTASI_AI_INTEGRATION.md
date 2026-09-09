# Интеграция директора с AI Antistasi

Адаптер Living War не создаёт и не удаляет AI-группы. Он сканирует уже существующие группы через `allGroups`, исключает группы игроков, фильтрует их по стороне и передаёт приказ как переменную `LW_directorOrder`.

## Сканирование

```sqf
private _groups = [[worldSize / 2, worldSize / 2, 0], 2000, east] call LW_fnc_getAntistasiGroups;
```

Каждая запись содержит группу, роль, район, сторону, численность, расстояние и позицию. Роль можно заранее указать из миссии Antistasi:

```sqf
_group setVariable ["LW_antistasiRole", "QRF", true];
_group setVariable ["LW_districtId", "town_alpha", true];
```

## Выдача приказа

```sqf
["COUNTERATTACK", "town_alpha", getPosATL player, 2500, east] call LW_fnc_directorDispatch;
```

Поддерживаемые реакции: `PATROL`, `QRF_READY`, `COUNTERATTACK`. По умолчанию функция только записывает приказ на группу, поэтому не конфликтует с текущим FSM Antistasi.

## Подключение поведения Antistasi

Миссия может определить безопасный hook после загрузки Antistasi:

```sqf
LW_antistasiDirectorHook = {
    params ["_group", "_order"];
    private _reaction = _order get "reaction";
    private _target = _order get "targetPosition";

    // Здесь вызывается конкретная функция вашей версии Antistasi.
    // Не используйте имена функций, которых нет в установленной версии.
    _group setVariable ["myMissionOrder", [_reaction, _target], true];
};
publicVariable "LW_antistasiDirectorHook";
```

Такой hook намеренно оставляет конкретное движение, создание waypoint и смену боевого режима стороне Antistasi. Это необходимо, потому что разные версии Antistasi используют разные имена и структуры AI-функций.

## Проверка на сервере

```sqf
private _orders = ["QRF_READY", "town_alpha", getPosATL player, 3000, east] call LW_fnc_directorDispatch;
diag_log format ["LW orders issued: %1", count _orders];
```

Проверьте в RPT и отладочной консоли группы с `LW_directorOrder`. После тестов очистите состояние:

```sqf
call LW_fnc_clearDirectorOrders;
```

Адаптер не гарантирует наличие групп подходящей роли: если групп нет, результатом будет пустой массив и штатная логика Antistasi останется без изменений.
