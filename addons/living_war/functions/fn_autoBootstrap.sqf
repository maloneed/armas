/*
    Non-invasive runtime discovery. Antistasi owns physical lifecycle; this only
    registers supplemental metadata and never creates, deletes or teleports AI.
*/
if (!isServer) exitWith {createHashMap};
private _state = call LW_fnc_getState;
private _districts = _state getOrDefault ["districts", createHashMap];
private _groups = [[], 1e9] call LW_fnc_getAntistasiGroups;
private _sides = [];
private _groupCount = 0;
{
    private _g = _x get "group";
    private _side = _x get "side";
    if !(_side in _sides) then {_sides pushBack _side};
    _groupCount = _groupCount + 1;
    private _districtId = _x getOrDefault ["district", ""];
    if (_districtId == "") then {
        private _pos = _x get "position";
        private _nearest = nearestLocation [_pos, "NameCityCapital"];
        _districtId = if (isNull _nearest) then {"auto_unknown"} else {format ["auto_%1", text _nearest]};
        _g setVariable ["LW_districtId", _districtId, true];
    };
    if (isNil {_districts get _districtId}) then {
        _districts set [_districtId, createHashMapFromArray [
            ["position", _x get "position"], ["pressure", 0], ["support", 50], ["supply", 50], ["threat", 0], ["autoDetected", true]
        ]];
    };
} forEach _groups;
if (count _groups == 0 && {isNil {_districts get "auto_default"}}) then {
    _districts set ["auto_default", createHashMapFromArray [["pressure", 0], ["support", 50], ["supply", 50], ["threat", 0], ["autoDetected", true]]];
};
_state set ["districts", _districts];
_state set ["discoveredSides", _sides];
_state set ["lastBootstrapAt", diag_tickTime];
missionNamespace setVariable ["LW_state", _state, true];
private _result = createHashMapFromArray [["groups", _groupCount], ["sides", _sides], ["districts", count _districts], ["at", diag_tickTime]];
missionNamespace setVariable ["LW_bootstrapReport", _result, true];
[format ["Bootstrap: sides=%1 groups=%2 districts=%3", count _sides, _groupCount, count _districts]] call LW_fnc_log;
_result
