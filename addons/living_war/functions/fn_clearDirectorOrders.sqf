if (!isServer) exitWith {0};
private _cleared = 0;
{
    if (!isNull _x && {!isPlayer (leader _x)} && {!isNil {_x getVariable "LW_directorOrder"}}) then {
        _x setVariable ["LW_directorOrder", nil, true];
        _cleared = _cleared + 1;
    };
} forEach allGroups;
_cleared
