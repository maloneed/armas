/*
    Dispatches a director order to existing Antistasi AI groups.
    The default integration is non-invasive: it stores order metadata on the group.
    A mission can opt into movement/combat behavior through LW_antistasiDirectorHook.
*/
if (!isServer) exitWith {[]};
params ["_reaction", "_districtId", ["_center", []], ["_radius", 1500], ["_side", east]];
private _groups = [_center, _radius, _side] call LW_fnc_getAntistasiGroups;
private _reactionKey = toUpper _reaction;
private _eligible = switch (_reactionKey) do {
    case "COUNTERATTACK": {_groups select {(_x get "role") in ["QRF", "GARRISON", "UNASSIGNED"]}};
    case "QRF_REQUEST": {_groups select {(_x get "role") in ["QRF", "RESERVE", "UNASSIGNED"]}};
    case "QRF_READY": {_groups select {(_x get "role") in ["QRF", "RESERVE", "UNASSIGNED"]}};
    case "REGROUP": {_groups select {(_x get "role") in ["QRF", "GARRISON", "PATROL", "RESERVE"]}};
    case "PATROL": {_groups select {(_x get "role") in ["PATROL", "GARRISON", "UNASSIGNED"]}};
    default {[]};
};
private _orders = [];
private _limit = if (_reactionKey in ["COUNTERATTACK", "QRF_REQUEST"]) then {2} else {1};
{
    if (count _orders >= _limit) exitWith {};
    private _group = _x get "group";
    private _order = createHashMapFromArray [
        ["reaction", _reactionKey],
        ["district", _districtId],
        ["issuedAt", diag_tickTime],
        ["targetPosition", _center]
    ];
    _group setVariable ["LW_directorOrder", _order, true];
    _group setVariable ["LW_districtId", _districtId, true];
    _orders pushBack createHashMapFromArray [["group", _group], ["order", _order]];

    private _hook = missionNamespace getVariable ["LW_antistasiDirectorHook", nil];
    if (!isNil "_hook" && {_hook isEqualType {}}) then {
        [_group, _order] call _hook;
    };
} forEach _eligible;
_orders
