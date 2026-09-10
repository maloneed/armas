if (!isServer) exitWith {false};
call LW_fnc_persistAIState;
private _state = call LW_fnc_getState;
_state set ["version", 2];
_state set ["lastSavedAt", diag_tickTime];
private _key = call LW_fnc_getStorageKey;
profileNamespace setVariable [_key, _state];
saveProfileNamespace;
missionNamespace setVariable ["LW_dirty", false, true];
true
