/*
    Compatibility boundary. Never assumes private Antistasi variables exist.
    A mission may explicitly provide LW_enemySide after validating its faction setup.
*/
if (!isServer) exitWith {createHashMapFromArray [["supported", false], ["side", sideUnknown]]};
private _detected = isClass (missionConfigFile >> "A3A");
private _eventApi = !isNil {missionNamespace getVariable "A3A_Events_fnc_addEventListener"};
private _side = missionNamespace getVariable ["LW_enemySide", sideUnknown];
private _supported = _detected && {_side isEqualType east} && {_side != sideUnknown};
if (!_detected) then {diag_log "[Living War] Antistasi A3A mission config not detected; integration disabled."};
if (_detected && {!_supported}) then {diag_log "[Living War] Enemy side is not configured; Director dispatch disabled."};
createHashMapFromArray [
    ["detected", _detected],
    ["eventApi", _eventApi],
    ["supported", _supported],
    ["side", _side],
    ["checkedAt", diag_tickTime]
]
