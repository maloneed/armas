/*
    Include these classes into the Antistasi mission Params class.
    They then appear in the normal Antistasi setup UI and can be set in server.cfg.
*/
class LW_enabled
{
    title = "Living War: включить модуль";
    texts[] = {"Отключено", "Включено"};
    values[] = {0, 1};
    default = 1;
};
class LW_autoAssignRoles
{
    title = "Living War: автоматически назначать роли AI";
    texts[] = {"Нет", "Да"};
    values[] = {0, 1};
    default = 1;
};
class LW_dispatchAI
{
    title = "Living War: выдавать приказы существующим AI";
    texts[] = {"Только журнал", "Выдавать приказы"};
    values[] = {0, 1};
    default = 0;
};
class LW_ambientEnabled
{
    title = "Living War: бытовая жизнь лагерей и КПП";
    texts[] = {"Отключено", "Включено"};
    values[] = {0, 1};
    default = 1;
};
class LW_radioEnabled
{
    title = "Living War: радио и переговоры";
    texts[] = {"Отключено", "Включено"};
    values[] = {0, 1};
    default = 1;
};
class LW_campMissionsEnabled
{
    title = "Living War: задачи в лагерях";
    texts[] = {"Отключено", "Включено"};
    values[] = {0, 1};
    default = 1;
};
class LW_roleAssignmentRadius
{
    title = "Living War: радиус назначения ролей (м)";
    texts[] = {"1500", "2500", "3500", "5000"};
    values[] = {1500, 2500, 3500, 5000};
    default = 3500;
};
class LW_dispatchRadius
{
    title = "Living War: радиус поиска групп (м)";
    texts[] = {"1500", "2500", "3500", "5000"};
    values[] = {1500, 2500, 3500, 5000};
    default = 2500;
};
