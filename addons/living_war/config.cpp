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
            class getConfig {};
            class getState {};
            class getDistrict {};
            class getSummary {};
            class getCommanderBrief {};
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
            class runSmokeTest {serverOnly = 1;};
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
        };
    };
};
