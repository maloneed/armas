if (!hasInterface) exitWith {};
params ["_ok", "_missionId"];
if (_ok) then {hint format ["Операция создана для задачи %1. Откройте ARMAS Strategic Command для наблюдения.", _missionId]} else {hint "Не удалось делегировать задачу: нет подходящей доступной группы или задача недоступна."};
