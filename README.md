# ARMAS / Living War

ARMAS is the project-owned Antistasi-based codebase with the Living War strategic layer integrated into it. The repository contains a pinned Antistasi Community 3.11.1 baseline under `upstream/antistasi/`; the APL-ND garage and StreetArtist components are intentionally excluded. Living War does not run a competing campaign manager: Antistasi remains authoritative for its campaign and physical AI lifecycle while ARMAS adds operations, delegation, intelligence, radio and command presentation.

## Current playable vertical slice

A player can request a camp mission, choose the AI delegation action, and have the server select an existing group with the required capability. ARMAS creates a persistent operation, assigns the group, moves it toward the target, executes and verifies the demolition path, applies mission completion, and emits structured Russian radio events. `ARMAS Strategic Command` opens a map with dynamic friendly-group, operation and fog-of-war intel markers; it refreshes every ten seconds rather than every frame.

The operation framework is reusable. Its states include `PLANNING`, `PREPARING`, `MOVING`, `APPROACHING`, `EXECUTING`, `VERIFYING`, `COMPLETED`, `FAILED`, `ABORTED` and `RETRYING`. Capabilities are abstract (`DEMOLITION`, `ANTI_ARMOR`, `ASSAULT`, `MEDICAL`, `TRANSPORT`, `SUPPORT`) rather than tied to one classname.

## Installation

Download [LivingWar-EasyInstall.zip](release/LivingWar-EasyInstall.zip), extract it into the Arma 3 directory, and enable `@LivingWar` in the launcher. Start a compatible Antistasi Community mission with both systems loaded. The target side must be configured by the mission after its faction setup:

```sqf
if (isServer) then {
    missionNamespace setVariable ["LW_enemySide", east, true];
};
```

For a dedicated server use `-mod=@Antistasi;@LivingWar`. See [ANTISTASI_BASELINE.md](docs/ANTISTASI_BASELINE.md), [COMPATIBILITY.md](docs/COMPATIBILITY.md), and [RADIO_UI_REGRESSION.md](docs/RADIO_UI_REGRESSION.md) for the current integration and provenance contract.

## Existing systems

The project retains the startup status, Antistasi settings, logistics, ambient life, Russian radio, camp missions, AI callsigns, Director reactions and server persistence already present in the repository. The new vertical slice extends those systems rather than replacing them.

## Development and testing

Use a feature branch and small commits. Build with `./build_mod.sh dist`; create the easy-install archive with `./build_easy_install.sh`. Static delimiter checks, PBO marker checks and ZIP validation are run locally. A real dedicated-server scenario remains the next runtime verification step; the sandbox cannot execute Arma 3.

## Documentation

- [Simple installation](release/INSTALL_RU.txt)
- [Antistasi baseline and provenance](docs/ANTISTASI_BASELINE.md)
- [Compatibility contract](docs/COMPATIBILITY.md)
- [Radio/HUD regression analysis](docs/RADIO_UI_REGRESSION.md)
- [Architecture audit](docs/ARCHITECTURE_AUDIT.md)
- [Donor matrix](docs/DONOR_MATRIX.md)
- [Roadmap](docs/ROADMAP_2.md)
