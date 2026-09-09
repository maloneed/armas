if (!isServer) exitWith {false};
private _state = call LW_fnc_getState;
_state set ["lastSavedAt", diag_tickTime];
profileNamespace setVariable ["LW_state", _state];
saveProfileNamespace;
true
