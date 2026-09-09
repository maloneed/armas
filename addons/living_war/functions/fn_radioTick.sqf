if (!isServer) exitWith {0};
private _sites = missionNamespace getVariable ["LW_ambientSites", createHashMap];
private _state = call LW_fnc_getState;
private _districts = _state getOrDefault ["districts", createHashMap];
private _spoken = 0;
private _lines = [
    ["Командир", "Докладывайте по обстановке. Боеприпасы на контроле, патрули не расслаблять."],
    ["Радист", "Принял. На восточной дороге замечена активность, передаю координаты наблюдателям."],
    ["Солдат", "Слышал? На фронте снова сорвали вражеский конвой. Похоже, снабжение у них просело."],
    ["Командир", "Потери учтены. Усилить охрану и подготовить резерв к выдвижению."],
    ["Разведчик", "Есть свежие данные по гарнизону. Передаю в штаб, пусть Director решает."],
    ["Снабженец", "Груз пришёл в лагерь. Разложить медикаменты и не трогать резервный ящик."],
    ["Боец", "Тихо сегодня. Давайте проверим оружие и сменим часовых у КПП."],
    ["Командир", "Поддержка местных растёт. Не трогать гражданских и держать дисциплину."]
];
{
    private _site = _sites get _x;
    private _position = _site getOrDefault ["position", []];
    private _district = _site getOrDefault ["district", ""];
    if (_position isEqualType [] && {count _position >= 2} && {random 1 < 0.35}) then {
        private _line = selectRandom _lines;
        private _threat = if (_district == "") then {0} else {(_districts getOrDefault [_district, createHashMap]) getOrDefault ["threat", 0]};
        private _prefix = if (_threat >= 70) then {"ТРЕВОГА"} else {"РАДИО"};
        [_prefix, _line select 0, _line select 1, _position] remoteExecCall ["LW_fnc_playRadioLine", -2];
        _spoken = _spoken + 1;
    };
} forEach keys _sites;
_spoken
