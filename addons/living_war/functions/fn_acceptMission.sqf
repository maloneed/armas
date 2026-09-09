if (!isServer) exitWith {false};
params ["_player", "_campId", "_missionId"];
private _result = [_player, _campId] call LW_fnc_offerMission;
if !(_result getOrDefault ["accepted", false]) exitWith {false};
if ((_result getOrDefault ["missionId", ""]) != _missionId) exitWith {false};
[_player, format ["Задача принята: %1", _result get "title"]] remoteExecCall ["hint", owner _player];
true
