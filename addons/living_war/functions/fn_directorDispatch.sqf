/*
    Dispatches a director order to existing Antistasi AI groups.
    Orders require a logistics reservation before they are issued.
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
private _limit = if (_reactionKey in ["COUNTERATTACK", "QRF_REQUEST"]) then {2} else {1};
private _orderCount = (count _eligible) min _limit;
if (_orderCount == 0) exitWith {[]};
private _ammoCost = switch (_reactionKey) do {
    case "COUNTERATTACK": {30};
    case "QRF_REQUEST": {20};
    case "QRF_READY": {10};
    case "REGROUP": {5};
    default {3};
};
private _reinforcementCost = if (_reactionKey in ["COUNTERATTACK", "QRF_REQUEST"]) then {_orderCount} else {0};
private _reservation = [_districtId, str _side, _ammoCost * _orderCount, _reinforcementCost, _reactionKey] call LW_fnc_requestLogistics;
if !(_reservation getOrDefault ["approved", false]) exitWith {
    [format ["Director order %1 denied: insufficient logistics in %2", _reactionKey, _districtId]] call LW_fnc_log;
    []
};
private _orders = [];
{
    if (count _orders >= _limit) exitWith {};
    private _group = _x get "group";
    private _order = createHashMapFromArray [
        ["reaction", _reactionKey],
        ["district", _districtId],
        ["issuedAt", diag_tickTime],
        ["targetPosition", _center],
        ["ammoReserved", _ammoCost],
        ["reinforcementsReserved", if (_reinforcementCost > 0) {1} else {0}]
    ];
    _group setVariable ["LW_directorOrder", _order, true];
    _group setVariable ["LW_districtId", _districtId, true];
    _orders pushBack createHashMapFromArray [["group", _group], ["order", _order]];

    private _hook = missionNamespace getVariable ["LW_antistasiDirectorHook", nil];
    if (!isNil "_hook" && {_hook isEqualType {}}) then {[_group, _order] call _hook};
} forEach _eligible;
_orders
