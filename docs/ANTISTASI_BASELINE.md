# ARMAS Antistasi baseline

ARMAS использует официальный Antistasi Community release как внутреннюю исходную базу, а не как runtime-внешнюю зависимость.

| Поле | Значение |
|---|---|
| Upstream | https://github.com/official-antistasi-community/A3-Antistasi |
| Release tag | `3.11.1` |
| Commit | `6e4226d3863ca8673535386c2fff8b6e08a806c4` |
| Upstream license | MIT для основного кода |
| Attribution | Copyright (c) 2019 Barbolani & The Official Antistasi Community |
| Import path | `upstream/antistasi/` |

Импорт выполнен скриптом `tools/import_antistasi_baseline.sh`. В репозиторий не включены компоненты, которые upstream LICENSE выделяет под APL-ND: `A3A/addons/garage/` и `Tools/StreetArtist/`. Их нельзя модифицировать и распространять как часть ARMAS. В baseline также сохранён оригинальный `upstream/antistasi/LICENSE`.

С этого этапа Antistasi является частью ARMAS source baseline, который можно постепенно расширять. Living War не создаёт второго владельца campaign/territory/HC lifecycle: изменения должны использовать или осознанно расширять внутренние Antistasi systems.

## Donor provenance

AIC: `https://github.com/sethduda/AIC`, commit `HEAD` на момент аудита, MIT, Copyright (c) 2016 Seth Duda. В ARMAS переносятся только выбранные SQF-паттерны map interaction и command UI; AIC assets не импортируются.

Для каждого перенесённого donor-файла сохраняются источник, лицензия и адаптация в `docs/DONOR_MATRIX.md`. Внешние assets без отдельной provenance-проверки запрещены.
