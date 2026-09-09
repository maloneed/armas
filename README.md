# Living War

Модульная надстройка над совместимой миссией Antistasi для Arma 3. Проект хранит состояние кампании на сервере, реагирует на игровые события, использует существующие AI-группы и не заменяет базовую миссию.

## Установка

Скопируйте `release/@LivingWar` в папку сервера Arma 3 и запустите сервер с параметром:

```text
-mod=@LivingWar
```

## Настройки в меню Antistasi

Готовый файл [`params.hpp`](params.hpp) содержит русские параметры Living War для стандартного setup UI Antistasi. Подключите его **внутри существующего класса `Params`** миссии:

```cpp
#include "params_living_war.hpp"
```

Подробная инструкция и пример `server.cfg`: [docs/ANTISTASI_SETTINGS.md](docs/ANTISTASI_SETTINGS.md).

## Текущие системы

- серверное состояние кампании и сохранение;
- сохранение AI-групп, ролей, позывных, loadout и позиции;
- Director с реакциями на угрозу и боевые потери;
- интеграция приказов с резервом боеприпасов и подкреплений;
- hooks для конкретной версии Antistasi;
- автоматическое назначение `QRF`, `GARRISON`, `PATROL`;
- русская админская debug-панель;
- ambient-анимации существующих солдат в лагерях, КПП и базах;
- русские радиопереговоры и звуковые hooks;
- 20 случайных мини-миссий лагерей с наградами и экономическим ущербом.

## Документация

- [Настройки Antistasi](docs/ANTISTASI_SETTINGS.md)
- [Интеграция AI Antistasi](docs/ANTISTASI_AI_INTEGRATION.md)
- [Сохранение AI-состояния](docs/AI_STATE_PERSISTENCE.md)
- [Логистика и ambient](docs/LOGISTICS_AND_AMBIENT.md)
- [Радио и мини-миссии](docs/MISSIONS_AND_RADIO.md)
- [Серверное тестирование](docs/SERVER_TESTING.md)
