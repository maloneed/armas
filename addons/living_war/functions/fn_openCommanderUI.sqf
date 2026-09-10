if (!hasInterface) exitWith {false};
openMap true;
private _old = uiNamespace getVariable ["LW_commanderLoop", scriptNull];
if (!isNull _old) then {terminate _old};
private _loop = [] spawn {
    hint "ARMAS Strategic Command\nКарта показывает дружественные группы, операции и их состояние.\nИнформация о противнике ограничена разведданными.";
    while {visibleMap} do {
        call LW_fnc_updateCommanderMap;
        sleep 10;
    };
    private _markers = uiNamespace getVariable ["LW_commanderMarkers", []];
    {deleteMarkerLocal _x} forEach _markers;
    uiNamespace setVariable ["LW_commanderMarkers", []];
};
uiNamespace setVariable ["LW_commanderLoop", _loop];
true
