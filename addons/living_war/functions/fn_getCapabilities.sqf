if (!isServer) exitWith {createHashMap};
params ["_group"];
private _units = (units _group) select {alive _x};
private _caps = [];
if (_units findIf {private _mags = magazines _x; (_mags findIf {toLower _x find "satchel" >= 0 || {toLower _x find "demo" >= 0 || {toLower _x find "charge" >= 0}}} >= 0) || {_x getVariable ["LW_demolition", false]}} >= 0) then {_caps pushBack "DEMOLITION"};
if (_units findIf {secondaryWeapon _x != ""} >= 0) then {_caps pushBack "ANTI_ARMOR"};
if (_units findIf {primaryWeapon _x != ""} >= 0) then {_caps pushBack "ASSAULT"};
if (_units findIf {"Medikit" in items _x || {"FirstAidKit" in items _x}} >= 0) then {_caps pushBack "MEDICAL"};
if (count (assignedVehicleRole (leader _group)) > 0 || {vehicle (leader _group) != (leader _group)}) then {_caps pushBack "TRANSPORT"};
if (count _caps == 0) then {_caps pushBack "SUPPORT"};
_caps arrayIntersect _caps
