class CfgPatches
{
    class living_war
    {
        name = "Living War";
        author = "maloneed";
        requiredVersion = 2.10;
        requiredAddons[] = {"A3_Functions_F"};
        units[] = {};
        weapons[] = {};
    };
};

class CfgFunctions
{
    class LW
    {
        tag = "LW";

        class Core
        {
            file = "living_war\functions";
            class init {preInit = 1;};
            class antistasiAdapter {serverOnly = 1;};
            class applyMissionParams {serverOnly = 1;};
            class getStorageKey {serverOnly = 1;};
            class getConfig {};
            class getState {};
            class getDistrict {};
            class getSummary {};
            class getCommanderBrief {};
            class getMissionCatalog {};
            class registerDistrict {serverOnly = 1;};
            class applyEvent {serverOnly = 1;};
            class applyLogisticsEvent {serverOnly = 1;};
            class requestLogistics {serverOnly = 1;};
            class replenishLogistics {serverOnly = 1;};
            class applyCivilianEvent {serverOnly = 1;};
            class getAntistasiGroups {serverOnly = 1;};
            class assignCallsign {serverOnly = 1;};
            class assignAIRoles {serverOnly = 1;};
            class captureGroupState {serverOnly = 1;};
            class persistAIState {serverOnly = 1;};
            class restoreAIState {serverOnly = 1;};
            class directorDispatch {serverOnly = 1;};
            class clearDirectorOrders {serverOnly = 1;};
            class directorTick {serverOnly = 1;};
            class registerAmbientSite {serverOnly = 1;};
            class ambientTick {serverOnly = 1;};
            class radioTick {serverOnly = 1;};
            class offerMission {serverOnly = 1;};
            class requestCampMission {serverOnly = 1;};
            class completeMission {serverOnly = 1;};
            class log {serverOnly = 1;};
            class saveState {serverOnly = 1;};
            class loadState {serverOnly = 1;};
        };

        class UI
        {
            file = "living_war\functions";
            class openDebugUI {};
            class updateDebugUI {};
            class closeDebugUI {};
            class openCampUI {};
            class showMissionOffer {};
            class playRadioLine {};
        };
    };
};

class CfgRemoteExec
{
    class Functions
    {
        mode = 2;
        jip = 0;
        class LW_fnc_requestCampMission {allowedTargets = 2;};
        class LW_fnc_showMissionOffer {allowedTargets = 1;};
        class LW_fnc_playRadioLine {allowedTargets = -2;};
    };
};
