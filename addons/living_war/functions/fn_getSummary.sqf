private _state = call LW_fnc_getState;
private _districts = _state getOrDefault ["districts", createHashMap];
private _summary = [];
{
    private _district = _districts get _x;
    _summary pushBack createHashMapFromArray [
        ["district", _x],
        ["pressure", _district getOrDefault ["pressure", 0]],
        ["support", _district getOrDefault ["support", 50]],
        ["supply", _district getOrDefault ["supply", 50]],
        ["threat", _district getOrDefault ["threat", 0]]
    ];
} forEach keys _districts;
_summary
