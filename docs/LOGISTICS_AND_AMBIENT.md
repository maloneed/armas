# Логистика приказов и ambient-жизнь районов

## Логистика приказов

Перед выдачей приказа Director функция `LW_fnc_directorDispatch` резервирует боеприпасы и подкрепления через `LW_fnc_requestLogistics`. Если резерва недостаточно, приказ не выдаётся и записывается отказ в RPT.

Ориентировочная стоимость приказов:

| Приказ | Боеприпасы на группу | Подкрепление |
|---|---:|---:|
| `PATROL` | 3 | 0 |
| `REGROUP` | 5 | 0 |
| `QRF_READY` | 10 | 0 |
| `QRF_REQUEST` | 20 | 1 |
| `COUNTERATTACK` | 30 | 1 |

Ключ ресурса имеет вид `район:сторона`, например `town_alpha:EAST`. Раз в пять минут ресурс пополняется в зависимости от снабжения района.

Для интеграции с конкретной версией Antistasi задайте hook:

```sqf
LW_antistasiLogisticsHook = {
    params ["_request"];
    // Здесь вызовите конкретную функцию Antistasi для боеприпасов
    // или спавна/доставки подкрепления.
};
```

## Ambient-система

Миссия регистрирует места, где уже находятся лагеря, КПП или базы:

```sqf
["checkpoint_alpha", "CHECKPOINT", getPosATL _checkpoint, 35, "town_alpha"] call LW_fnc_registerAmbientSite;
["camp_alpha", "CAMP", getPosATL _camp, 45, "town_alpha"] call LW_fnc_registerAmbientSite;
["base_alpha", "BASE", getPosATL _base, 60, "town_alpha"] call LW_fnc_registerAmbientSite;
```

Каждые 30 секунд существующий небоевой AI рядом с зарегистрированной точкой может выполнить короткую бытовую анимацию. Группы игроков, группы в бою, группы с приказом Director и бойцы в технике пропускаются. Новые юниты и объекты не создаются.

Отключение:

```sqf
private _cfg = profileNamespace getVariable ["LW_config", createHashMap];
_cfg set ["ambientEnabled", false];
profileNamespace setVariable ["LW_config", _cfg];
saveProfileNamespace;
```

Список анимаций проверяется через `CfgMovesMaleSdr`; если конкретная анимация отсутствует в версии игры, она пропускается. Для полноценной работы конкретной версии Antistasi можно заменить набор в `fn_ambientTick.sqf`.
