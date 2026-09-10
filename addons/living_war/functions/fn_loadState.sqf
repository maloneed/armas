if (!isServer) exitWith {false};
private _key = call LW_fnc_getStorageKey;
private _saved = profileNamespace getVariable [_key, createHashMap];
if !(_saved isEqualType createHashMap) exitWith {
    diag_log format ["[Living War] Invalid saved state at %1; ignoring.", _key];
    false
};
if (count _saved == 0) exitWith {false};
private _version = _saved getOrDefault ["version", -1];
if !(_version isEqualTo 2) exitWith {
    diag_log format ["[Living War] Unsupported state version %1 at %2; ignoring.", _version, _key];
    false
};
missionNamespace setVariable ["LW_state", _saved, true];
true
