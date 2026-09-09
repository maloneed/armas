if (!isServer) exitWith {};
private _config = call LW_fnc_getConfig;
if !(_config getOrDefault ["campMissionsEnabled", true]) exitWith {};
params ["_player", "_campId"];
private _result = [_player, _campId] call LW_fnc_offerMission;
[_result] remoteExecCall ["LW_fnc_showMissionOffer", owner _player];
