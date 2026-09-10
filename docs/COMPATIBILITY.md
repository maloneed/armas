# Antistasi compatibility contract

## Current policy

Living War is an optional overlay. Antistasi remains authoritative for territory, campaign saves, garrisons, groups, headless-client locality and logistics. Living War does not recreate, transfer, teleport or delete Antistasi AI groups during restore.

The adapter detects an A3A mission config and fails closed when the opposing side is not explicitly configured. In the mission's server-side init, set the side used by the Director after Antistasi has selected its factions:

```sqf
if (isServer) then {
    missionNamespace setVariable ["LW_enemySide", east, true];
};
```

Use `west` or `independent` when that is the configured enemy side for the selected Antistasi scenario. Do not guess this value from a hard-coded faction name.

## Supported API boundary

The current adapter only treats these facts as stable:

| Contract | Current behavior |
|---|---|
| A3A mission detection | Checks `missionConfigFile >> "A3A"`. |
| Enemy side | Requires explicit `LW_enemySide`; `sideUnknown` disables dispatch. |
| Event API | Detects `A3A_Events_fnc_addEventListener`, but does not register assumed event names. |
| AI lifecycle | Antistasi remains owner; Living War stores supplemental records only. |
| Persistence | Uses a version-2 key scoped by `LW_campaignId`, or world and mission name fallback. |

The project does not claim support for every Antistasi fork. Pin and test one Antistasi release before enabling Director dispatch in production. The audit investigated official Community Edition sources and A3AExtender patterns; it did not establish a universal stable territory/convoy/camp callback.

## Campaign identity

For multiple campaigns using the same map and mission, provide a unique campaign ID before Living War initializes:

```sqf
missionNamespace setVariable ["LW_campaignId", "my_campaign_01"];
```

The supplemental state key becomes `LW_state_v2_<campaign-id>`. Invalid or unsupported saved versions are ignored rather than loaded into the running campaign.

## Graceful degradation

If A3A is absent, the adapter logs a warning. If the side is unresolved, Director continues calculating read-only reactions but issues no AI orders. Other independent systems may continue to run. This is intentional until a tested compatibility contract is supplied.
