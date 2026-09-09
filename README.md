# Living War

Модульная надстройка над совместимой миссией Antistasi для Arma 3. Проект хранит состояние кампании на сервере, реагирует на игровые события, использует существующие AI-группы и не заменяет базовую миссию.

## Установка

Скопируйте `release/@LivingWar` в папку сервера Arma 3 и запустите сервер с параметром:

```text
-mod=@LivingWar
```

## Текущие системы

- серверное состояние кампании и сохранение;
- сохранение AI-групп, ролей, позывных, loadout и позиции;
- Director с реакциями на угрозу и боевые потери;
- интеграция приказов с резервом боеприпасов и подкреплений;
- hooks для конкретной версии Antistasi;
- автоматическое назначение `QRF`, `GARRISON`, `PATROL`;
- русская админская debug-панель;
- ambient-анимации существующих солдат в лагерях, КПП и базах.

## Примеры

```sqf
["checkpoint_alpha", "CHECKPOINT", getPosATL _checkpoint, 35, "town_alpha"] call LW_fnc_registerAmbientSite;
["camp_alpha", "CAMP", getPosATL _camp, 45, "town_alpha"] call LW_fnc_registerAmbientSite;
```

```sqf
LW_antistasiLogisticsHook = {
    params ["_request"];
    // Подключение конкретного API снабжения Antistasi.
};
```

```sqf
call LW_fnc_openDebugUI;
```

## Документация

- [Интеграция AI Antistasi](docs/ANTISTASI_AI_INTEGRATION.md)
- [Сохранение AI-состояния](docs/AI_STATE_PERSISTENCE.md)
- [Логистика и ambient](docs/LOGISTICS_AND_AMBIENT.md)
- [Серверное тестирование](docs/SERVER_TESTING.md)
