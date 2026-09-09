private _defaults = createHashMapFromArray [
    ["enabled", true],
    ["autosave", true],
    ["maxEventLog", 100],
    ["debug", false]
];
private _stored = profileNamespace getVariable ["LW_config", createHashMap];
{
    _defaults set [_x, _stored getOrDefault [_x, _defaults get _x]];
} forEach keys _defaults;
_defaults
