if (!isServer) exitWith {};
private _sender = remoteExecutedOwner;
private _players = allPlayers select {owner _x == _sender && {alive _x}};
if (count _players != 1) exitWith {};
params [["_missionId", ""], ["_capability", "DEMOLITION"]];
private _ok = [_missionId, objNull, _capability] call LW_fnc_delegateMission;
[_ok, _missionId] remoteExecCall ["LW_fnc_showDelegationResult", _sender];
