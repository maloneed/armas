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
            class registerDistrict {serverOnly = 1;};
            class applyEvent {serverOnly = 1;};
            class log {serverOnly = 1;};
            class saveState {serverOnly = 1;};
            class loadState {serverOnly = 1;};
        };
    };
};
