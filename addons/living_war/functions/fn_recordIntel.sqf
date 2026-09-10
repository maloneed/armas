if (!isServer) exitWith {false};
params ["_districtId", "_position", ["_source", "SCRIPTED"], ["_confidence", 0.5], ["_estimatedStrength", 0]];
private _state = call LW_fnc_getState;
private _intel = _state getOrDefault ["enemyIntel", []];
_intel pushBack createHashMapFromArray [
    ["district", _districtId], ["lastKnownPosition", _position], ["timestamp", diag_tickTime],
    ["confidence", _confidence max 0 min 1], ["source", _source], ["estimatedStrength", _estimatedStrength]
];
if (count _intel > 50) then {_intel deleteAt 0};
_state set ["enemyIntel", _intel];
missionNamespace setVariable ["LW_state", _state, true];
missionNamespace setVariable ["LW_dirty", true, true];
true
