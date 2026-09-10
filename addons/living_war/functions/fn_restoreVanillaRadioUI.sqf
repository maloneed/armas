if (!hasInterface) exitWith {false};
/*
    Antistasi 3.11.1 baseline does not call showHUD false, enableRadio false,
    showRadio false, or suppress display notifications. It installs H8erHUD via
    cutRsc and updates it in statistics. Keep Living War from suppressing the
    engine radio/HUD and restore the vanilla flags after mission UI init.
*/
showHUD true;
enableRadio true;
showRadio true;
missionNamespace setVariable ["LW_vanillaRadioUIRestored", true];
true
