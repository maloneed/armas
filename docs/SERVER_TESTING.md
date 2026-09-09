# Тестирование Living War на сервере

## Установка

Скопируйте `release/@LivingWar` в корень сервера и добавьте `-mod=@LivingWar` к параметрам запуска. Запускайте совместимую миссию Antistasi как обычно. Мод не требует собственной миссии.

## Smoke-тест ядра

В серверном debug-консоли или через серверный init-код выполните:

```sqf
call LW_fnc_runSmokeTest;
```

Результат должен быть `Living War smoke test: PASS`.

## Тест интеграции AI-групп

Сначала пометьте существующую AI-группу Antistasi, не содержащую игроков:

```sqf
private _g = /* существующая группа Antistasi */;
_g setVariable ["LW_antistasiRole", "QRF", true];
_g setVariable ["LW_districtId", "town_alpha", true];
```

Затем выдайте безопасный приказ:

```sqf
private _orders = ["QRF_READY", "town_alpha", getPosATL (leader _g), 3000, east] call LW_fnc_directorDispatch;
diag_log format ["LW orders issued: %1", count _orders];
```

Проверьте на сервере:

```sqf
_g getVariable ["LW_directorOrder", createHashMap]
```

Группа должна получить поля `reaction`, `district`, `issuedAt` и `targetPosition`. По умолчанию Living War не меняет waypoint или FSM группы.

Чтобы подключить движение к API конкретной версии Antistasi, задайте hook:

```sqf
LW_antistasiDirectorHook = {
    params ["_group", "_order"];
    // Здесь вызовите вашу версию функции постановки задачи Antistasi.
    _group setVariable ["myMissionOrder", _order, true];
};
```

После теста очистите приказы:

```sqf
call LW_fnc_clearDirectorOrders;
```

## Включение автоматической выдачи

Автоматическая выдача выключена по умолчанию. Для района нужно сохранить позицию в его состоянии, затем включить в профиле сервера:

```sqf
private _cfg = profileNamespace getVariable ["LW_config", createHashMap];
_cfg set ["dispatchAI", true];
_cfg set ["dispatchRadius", 2500];
profileNamespace setVariable ["LW_config", _cfg];
saveProfileNamespace;
```

После этого `LW_fnc_directorTick` будет выдавать приказы существующим группам восточной стороны для реакций `PATROL`, `QRF_READY` и `COUNTERATTACK`. Группы игроков исключаются, новые группы не создаются.

## Что проверять в логах

Ищите записи `[Living War]` в серверном RPT. После события должна увеличиваться последовательность состояния, а после загрузки кампании район и журнал должны восстановиться.

## Ограничения

Названия и сигнатуры внутренних функций Antistasi различаются между версиями. Поэтому адаптер использует стабильный внешний hook `LW_antistasiDirectorHook`, а конкретный вызов создания waypoint или боевой задачи должен быть добавлен в mission init после проверки вашей версии Antistasi.
