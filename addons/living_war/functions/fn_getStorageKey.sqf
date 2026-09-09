private _campaign = missionNamespace getVariable ["LW_campaignId", ""];
if (_campaign == "") then {_campaign = format ["%1:%2", worldName, missionName]};
private _safe = toLower _campaign;
_safe = _safe regexReplace ["[^a-zA-Z0-9_:-]", "_"];
format ["LW_state_v2_%1", _safe]
