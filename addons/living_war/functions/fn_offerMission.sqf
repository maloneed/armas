if (!isServer) exitWith {createHashMapFromArray [["accepted", false]]};
params ["_player", "_campId"];
private _sites = missionNamespace getVariable ["LW_ambientSites", createHashMap];
private _site = _sites getOrDefault [_campId, createHashMap];
private _position = _site getOrDefault ["position", []];
if (_position isEqualTo [] || {_player distance2D _position > 80}) exitWith {createHashMapFromArray [["accepted", false], ["reason", "Игрок слишком далеко от лагеря"]]};
private _catalog = call LW_fnc_getMissionCatalog;
private _state = call LW_fnc_getState;
private _active = _state getOrDefault ["missions", []];
private _available = _catalog select {private _id = _x get "id"; !(_active findIf {(_x getOrDefault ["missionId", ""]) == _id && {(_x getOrDefault ["status", "ACTIVE"]) == "ACTIVE"}} >= 0)};
if (count _available == 0) exitWith {createHashMapFromArray [["accepted", false], ["reason", "Все задачи уже активны"]]};
private _mission = selectRandom _available;
private _record = createHashMapFromArray [
    ["missionId", _mission get "id"], ["camp", _campId], ["district", _site getOrDefault ["district", ""]],
    ["title", _mission get "title"], ["description", _mission get "description"], ["category", _mission get "category"],
    ["status", "ACTIVE"], ["assignedTo", owner _player], ["assignedAt", diag_tickTime], ["progress", 0],
    ["reward", _mission]
];
_active pushBack _record;
_state set ["missions", _active];
missionNamespace setVariable ["LW_state", _state, true];
call LW_fnc_saveState;
_record set ["accepted", true];
_record
