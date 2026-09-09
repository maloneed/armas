if (!isServer) exitWith {false};
params ["_siteId", "_siteType", "_position", ["_radius", 35], ["_districtId", ""]];
private _sites = missionNamespace getVariable ["LW_ambientSites", createHashMap];
_sites set [_siteId, createHashMapFromArray [
    ["type", toUpper _siteType],
    ["position", _position],
    ["radius", _radius],
    ["district", _districtId]
]];
missionNamespace setVariable ["LW_ambientSites", _sites, true];
true
