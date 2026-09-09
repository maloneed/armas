if (!hasInterface) exitWith {};
params ["_prefix", "_speaker", "_text", "_position"];
private _distance = if (isNull player) then {0} else {player distance2D _position};
if (_distance > 1800) exitWith {};
private _volume = (1 - (_distance / 1800)) max 0.15;
private _soundHook = missionNamespace getVariable ["LW_radioSoundHook", nil];
if (!isNil "_soundHook" && {_soundHook isEqualType {}}) then {
    [_prefix, _speaker, _text, _position, _volume] call _soundHook;
} else {
    playSoundUI ["Hint", _volume, 1];
};
systemChat format ["[%1] %2: %3", _prefix, _speaker, _text];
