# Настройки Living War в меню Antistasi

Официальный Antistasi Community показывает параметры в setup UI из `MissionDescription/params.hpp`. Для серверного запуска те же значения задаются в `server.cfg` внутри `class Missions > class Mission1 > class Params`.

## Подключение к миссии

1. Скопируйте `params.hpp` из корня репозитория в каталог исходников миссии Antistasi или добавьте его содержимое в существующий `MissionDescription/params.hpp`.
2. Внутри существующего класса `Params` добавьте:

```cpp
#include "params_living_war.hpp"
```

3. Переименуйте файл репозитория в `params_living_war.hpp` и положите рядом с `params.hpp`, либо используйте корректный путь include для вашей сборки.
4. Соберите/упакуйте миссию Antistasi и запустите её с `@LivingWar`.

Не создавайте второй `class Params`: include должен находиться **внутри уже существующего** класса параметров.

## Параметры setup UI

В интерфейсе Antistasi появятся русские пункты:

- включить модуль;
- автоматически назначать роли AI;
- выдавать приказы существующим AI;
- бытовая жизнь лагерей и КПП;
- радио и переговоры;
- задачи в лагерях;
- радиус назначения ролей;
- радиус поиска групп.

После выбора Antistasi передаст значения Living War через `getMissionConfigValue`. На сервере они применяются при старте до запуска Director, ambient-системы, радио и задач.

## Настройка через server.cfg

Пример:

```cpp
class Missions {
    class Mission1 {
        template = "Antistasi_Altis.Altis";
        difficulty = "Custom";
        class Params {
            LW_enabled = 1;
            LW_autoAssignRoles = 1;
            LW_dispatchAI = 0;
            LW_ambientEnabled = 1;
            LW_radioEnabled = 1;
            LW_campMissionsEnabled = 1;
            LW_roleAssignmentRadius = 3500;
            LW_dispatchRadius = 2500;
        };
    };
};
```

Точные имена миссии и остальные параметры должны соответствовать вашей установленной версии Antistasi. Данные значения применяются при старте новой/загруженной миссии; постоянный `profileNamespace` используется как запасной источник для параметров, которых нет в mission config.

## Ограничение совместимости

Аддон не пытается встраивать классы в чужой PBO автоматически: это невозможно надёжно сделать из обычного модульного PBO. Поэтому файл `params.hpp` является готовым include-мостом для миссии Antistasi. Сама система Living War при этом остаётся совместимой и продолжает работать с настройками по умолчанию, если include не подключён.
