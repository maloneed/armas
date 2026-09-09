/*
    Living War campaign state bootstrap.
    The server owns the state; clients receive read-only snapshots through public functions.
*/
if (!isServer) exitWith {};
call LW_fnc_applyMissionParams;

private _loaded = call LW_fnc_loadState;
if (!_loaded) then {
    private _districts = createHashMap;
    _districts set ["default", createHashMapFromArray [
        ["pressure", 0],
        ["support", 50],
        ["supply", 50],
        ["threat", 0]
    ]];

    missionNamespace setVariable ["LW_state", createHashMapFromArray [
        ["version", 1],
        ["sequence", 0],
        ["districts", _districts],
        ["eventLog", []],
        ["aiGroups", []],
        ["callsignIndexes", createHashMap],
        ["logistics", createHashMap],
        ["missions", []],
        ["rewards", createHashMapFromArray [["manpower", 0], ["money", 0], ["eliteGear", 0]]],
        ["lastSavedAt", diag_tickTime]
    ], true];
};

["INIT", "default", createHashMapFromArray [["message", "Campaign state ready"]]] call LW_fnc_applyEvent;
"Living War initialized" call LW_fnc_log;
missionNamespace setVariable ["LW_serverReady", true, true];

[] spawn {
    sleep 20;
    private _restored = call LW_fnc_restoreAIState;
    [format ["Restored %1 AI group records", count _restored]] call LW_fnc_log;
    while {true} do {
        sleep 30;
        private _config = call LW_fnc_getConfig;
        if (_config getOrDefault ["enabled", true] && {_config getOrDefault ["ambientEnabled", true]}) then {call LW_fnc_ambientTick};
        if (_config getOrDefault ["enabled", true] && {_config getOrDefault ["radioEnabled", true]} && {(diag_tickTime mod 120) < 30}) then {call LW_fnc_radioTick};
        if ((diag_tickTime mod 300) < 30 && {_config getOrDefault ["enabled", true]}) then {
            call LW_fnc_persistAIState;
            call LW_fnc_replenishLogistics;
            call LW_fnc_assignAIRoles;
            call LW_fnc_directorTick;
            call LW_fnc_saveState;
        };
    };
};
