/*
    Low-cost ambient life for existing AI near registered sites.
    Never runs for player groups, combat groups or groups with a Director order.
*/
if (!isServer) exitWith {0};
private _sites = missionNamespace getVariable ["LW_ambientSites", createHashMap];
private _played = 0;
private _animations = [
    "Acts_AidlPercMstpSlowWrflDnon_pst"
];
{
    private _siteId = _x;
    private _site = _sites get _x;
    private _position = _site getOrDefault ["position", []];
    private _radius = _site getOrDefault ["radius", 35];
    private _type = _site getOrDefault ["type", "CAMP"];
    if (_position isEqualType [] && {count _position >= 2}) then {
        private _nearGroups = [_position, _radius, sideUnknown] call LW_fnc_getAntistasiGroups;
        {
            private _group = _x get "group";
            private _leader = leader _group;
            private _busyUntil = _group getVariable ["LW_ambientBusyUntil", 0];
            private _inCombat = behaviour _leader == "COMBAT" || {_leader getVariable ["LW_inCombat", false]};
            private _hasOrder = !isNil {_group getVariable "LW_directorOrder"};
            if (diag_tickTime >= _busyUntil && {!_inCombat} && {!_hasOrder} && {vehicle _leader == _leader} && {random 1 < 0.35}) then {
                private _animation = selectRandom _animations;
                private _stateConfig = configFile >> "CfgMovesMaleSdr" >> "States" >> _animation;
                if (isClass _stateConfig) then {
                    private _actors = (units _group) select {
                        alive _x && {local _x} && {!isPlayer _x} && {vehicle _x == _x}
                        && {lifeState _x == "HEALTHY"} && {abs speed _x < 0.5}
                        && {behaviour _x in ["SAFE", "AWARE"]}
                        && {_x distance2D _position <= _radius}
                        && {isNull (_x findNearestEnemy _x)}
                        && {!( _x getVariable ["LW_ambientActive", false])}
                    };
                    if (count _actors > 0) then {
                        private _actor = selectRandom _actors;
                        _actor playMoveNow _animation;
                        _actor setVariable ["LW_ambientActive", true];
                        [_actor, _group, _animation] spawn {
                            params ["_actor", "_group", "_animation"];
                            private _end = diag_tickTime + 12 + random 8;
                            waitUntil {
                                sleep 0.5;
                                isNull _actor || {!alive _actor} || {!local _actor}
                                || {diag_tickTime >= _end} || {behaviour _actor == "COMBAT"}
                                || {lifeState _actor != "HEALTHY"} || {vehicle _actor != _actor}
                                || {!isNull (_actor findNearestEnemy _actor)}
                                || {!isNil {_group getVariable "LW_directorOrder"}}
                                || {!((call LW_fnc_getConfig) getOrDefault ["ambientEnabled", true])}
                            };
                            if (!isNull _actor) then {
                                if (local _actor && {alive _actor} && {lifeState _actor == "HEALTHY"}
                                    && {toLower animationState _actor == toLower _animation}) then {
                                    _actor switchMove "";
                                };
                                _actor setVariable ["LW_ambientActive", false];
                            };
                        };
                        _group setVariable ["LW_ambientSite", _siteId, true];
                        _group setVariable ["LW_ambientActivity", _type, true];
                        _group setVariable ["LW_ambientBusyUntil", diag_tickTime + 25 + random 35, true];
                        _played = _played + 1;
                    };
                };
            };
        } forEach _nearGroups;
    };
} forEach keys _sites;
_played
