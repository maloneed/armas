/*
    Antistasi owns AI entity lifecycle and HC locality.
    Living War deliberately does not recreate, transfer or teleport groups/units.
    Saved records remain supplemental history until a stable upstream identity contract exists.
*/
if (!isServer) exitWith {[]};
private _state = call LW_fnc_getState;
private _records = _state getOrDefault ["aiGroups", []];
if (count _records > 0) then {
    diag_log format ["[Living War] Retained %1 AI metadata records; entity restoration is disabled by policy.", count _records];
};
[]
