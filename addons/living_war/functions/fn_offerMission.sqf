if (!isServer) exitWith {createHashMapFromArray [["accepted", false]]};
params ["_player", "_campId"];
private _sites = missionNamespace getVariable ["LW_ambientSites", createHashMap];
private _site = _sites getOrDefault [_campId, createHashMap];
private _position = _site getOrDefault ["position", []];
if (_position isEqualTo [] || {_player distance2D _position > 80} || {!alive _player}) exitWith {createHashMapFromArray [["accepted", false], ["reason", "Вы не можете получить задачу в этом месте"]]};
private _catalog = call LW_fnc_getMissionCatalog;
private _state = call LW_fnc_getState;
private _active = _state getOrDefault ["missions", []];
private _available = _catalog select {private _id = _x get "id"; !(_active findIf {(_x getOrDefault ["missionId", ""]) == _id && {(_x getOrDefault ["status", "ACTIVE"]) == "ACTIVE"}} >= 0)};
if (count _available == 0) exitWith {createHashMapFromArray [["accepted", false], ["reason", "Все задачи уже активны"]]};
private _mission = selectRandom _available;
private _instance = format ["%1:%2:%3", floor diag_tickTime, owner _player, floor random 1000000];
private _record = createHashMapFromArray [
    ["instanceId", _instance], ["missionId", _mission get "id"], ["camp", _campId],
    ["district", _site getOrDefault ["district", ""]], ["title", _mission get "title"],
    ["description", _mission get "description"], ["category", _mission get "category"],
    ["requiredCapability", _mission getOrDefault ["requiredCapability", ""]],
    ["targetTypes", _mission getOrDefault ["targetTypes", []]],
    ["status", "ACTIVE"], ["assignedTo", owner _player], ["assignedAt", diag_tickTime],
    ["expiresAt", diag_tickTime + 3600], ["progress", 0], ["reward", _mission]
];
_active pushBack _record;
_state set ["missions", _active];
missionNamespace setVariable ["LW_state", _state, true];
missionNamespace setVariable ["LW_dirty", true, true];
_record set ["accepted", true];
_record
