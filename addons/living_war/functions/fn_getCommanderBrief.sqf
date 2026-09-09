private _state = call LW_fnc_getState;
private _districts = _state getOrDefault ["districts", createHashMap];
private _brief = [];
{
    private _district = _districts get _x;
    private _threat = _district getOrDefault ["threat", 0];
    private _recommendation = switch (true) do {
        case (_threat >= 75): {"Request reinforcements and prepare for a counterattack."};
        case (_threat >= 50): {"Keep a reserve ready and protect supply routes."};
        case ((_district getOrDefault ["support", 50]) < 30): {"Prioritize civilian aid and avoid collateral damage."};
        case ((_district getOrDefault ["supply", 50]) < 30): {"Restore the supply route or escort a convoy."};
        default {"Maintain pressure and gather intelligence."};
    };
    _brief pushBack createHashMapFromArray [["district", _x], ["recommendation", _recommendation], ["threat", _threat]];
} forEach keys _districts;
_brief
