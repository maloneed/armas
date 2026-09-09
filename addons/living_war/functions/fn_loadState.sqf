if (!isServer) exitWith {false};
private _saved = profileNamespace getVariable ["LW_state", createHashMap];
if (count _saved == 0) exitWith {false};
missionNamespace setVariable ["LW_state", _saved, true];
true
