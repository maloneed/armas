/*
    Living War campaign state bootstrap.
    Antistasi remains authoritative for campaign, territory, AI and HC lifecycle.
*/
if (!isServer) exitWith {};
private _adapter = call LW_fnc_antistasiAdapter;
missionNamespace setVariable ["LW_antistasiAdapter", _adapter, true];
call LW_fnc_applyMissionParams;

private _loaded = call LW_fnc_loadState;
if (!_loaded) then {
    private _districts = createHashMap;
    _districts set ["default", createHashMapFromArray [
        ["pressure", 0], ["support", 50], ["supply", 50], ["threat", 0]
    ]];
    missionNamespace setVariable ["LW_state", createHashMapFromArray [
        ["version", 2], ["sequence", 0], ["districts", _districts], ["eventLog", []],
        ["aiGroups", []], ["callsignIndexes", createHashMap], ["logistics", createHashMap],
        ["missions", []], ["rewards", createHashMapFromArray [["manpower", 0], ["money", 0], ["eliteGear", 0]]],
        ["lastSavedAt", diag_tickTime]
    ], true];
};

["INIT", "default", createHashMapFromArray [["message", "Campaign state ready"]]] call LW_fnc_applyEvent;
"Living War initialized" call LW_fnc_log;

[] spawn {
    sleep 20;
    private _restored = call LW_fnc_restoreAIState;
    [format ["Restored %1 AI metadata records; Antistasi owns entity lifecycle", count _restored]] call LW_fnc_log;
    private _nextAmbient = diag_tickTime;
    private _nextRadio = diag_tickTime;
    private _nextDirector = diag_tickTime + 300;
    private _nextSave = diag_tickTime + 300;
    while {true} do {
        sleep 5;
        private _now = diag_tickTime;
        private _config = call LW_fnc_getConfig;
        if (_config getOrDefault ["enabled", true] && {_config getOrDefault ["ambientEnabled", true]} && {_now >= _nextAmbient}) then {
            call LW_fnc_ambientTick;
            _nextAmbient = _now + 30;
        };
        if (_config getOrDefault ["enabled", true] && {_config getOrDefault ["radioEnabled", true]} && {_now >= _nextRadio}) then {
            call LW_fnc_radioTick;
            _nextRadio = _now + 120;
        };
        if (_config getOrDefault ["enabled", true] && {_now >= _nextDirector}) then {
            call LW_fnc_replenishLogistics;
            call LW_fnc_assignAIRoles;
            call LW_fnc_directorTick;
            _nextDirector = _now + 300;
        };
        if (_now >= _nextSave && {missionNamespace getVariable ["LW_dirty", true]}) then {
            call LW_fnc_saveState;
            _nextSave = _now + 300;
        };
    };
};
