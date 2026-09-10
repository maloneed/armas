# Antistasi radio/HUD regression check

## Проверка baseline

The pinned Antistasi Community `3.11.1` source was searched for `showHUD`, `enableRadio`, `showRadio`, `cutRsc`, `RscTitles`, and display event handlers. The baseline does not contain calls that disable the engine radio or HUD. Its client init uses `cutRsc ["H8erHUD", "PLAIN", 0, false]` and starts `A3A_fnc_statistics`; this is the Antistasi information bar, not a radio suppression call.

Therefore ARMAS does not claim a false Antistasi bug fix. The actionable regression source was the extension boundary: an addon must not leave the engine flags disabled or replace the global notification path. Living War now runs `LW_fnc_restoreVanillaRadioUI` on clients after initialization. It explicitly restores `showHUD`, `enableRadio`, and `showRadio`, while keeping Living War radio output on its own whitelisted `LW_fnc_playRadioLine` path.

The function intentionally does not remove `H8erHUD`, does not overwrite Antistasi `RscTitles`, and does not call `cutRsc` for global notifications. This preserves Antistasi UI and allows other mods to use standard notification/radio elements.

## Runtime verification

A dedicated-server/client test must still verify: vanilla radio text, another mod's notification, Antistasi H8erHUD, Living War radio event output, map open/close, and reconnect. If a future ARMAS change adds `showHUD false`, `enableRadio false`, `showRadio false`, a global `cutRsc`, or a display EH that consumes notification events, that change is a regression and must be removed or scoped to its own display.
