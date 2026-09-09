if (!hasInterface) exitWith {false};
private _display = uiNamespace getVariable ["LW_debugDisplay", displayNull];
if (!isNull _display) then {_display closeDisplay 2;};
uiNamespace setVariable ["LW_debugDisplay", displayNull];
uiNamespace setVariable ["LW_debugBody", controlNull];
true
