# ARMAS / Living War Architecture Audit

**Status:** Decision-support audit; not a production-readiness approval  
**Evidence baseline:** Living War local repository at `53cbca9` on `main`, plus the supplied source audits of Advanced AI Command (AIC) and Official Antistasi Community. The audit records observed implementation and source-backed recommendations. It does not represent a runtime test on a dedicated server.

## Executive conclusion

Living War is currently a **small, server-authoritative state overlay** with client-side UI and optional orders for already existing AI groups. Its useful core is the bounded district event model: server initialization, clamped district mutations, an event log, opt-in dispatch, and a clear attempt not to create or delete Antistasi base units. The implementation is a partial vertical slice rather than a completed Antistasi extension. It has no verified mission bootstrap, no implemented Antistasi district/camp/convoy adapter, and no dedicated-server integration evidence. [1] [2] [3]

The recommended end state is an **event-driven Antistasi extension**, not a second campaign manager. Antistasi must remain authoritative for campaign persistence, territory, groups, garrisons, headless-client routing, and logistics. Living War should subscribe to supported events, translate them through a version-pinned adapter, validate all state-changing requests on the server, and own only bounded supplemental reaction/content state. This direction matches the official extension model and avoids fragile replacement of Antistasi internals. [4] [5] [6]

> **Release decision:** Do not treat the current Living War package as production-ready for dedicated servers. Block production release until campaign-scoped persistence, the RemoteExec trust boundary, faction/side resolution, AI restoration policy, and automated dedicated-server evidence are addressed.

## Scope, evidence, and confidence

| Area | Evidence | Confidence | Boundary |
|---|---|---:|---|
| Living War runtime | `config.cpp`, all audited SQF functions, README/docs/params, build/release files, and EasyInstall archive at local commit `53cbca9` | Confirmed | Static source and package audit; no live mission execution was supplied. |
| Antistasi integration model | Official Antistasi repository, documentation, events addon, and A3AExtender examples | Confirmed for cited extension mechanisms | The exact event needed for a Living War gameplay trigger has **not** been verified as a stable public hook. |
| AIC donor evaluation | AIC README, source layout, selected implementation and commit history | Confirmed for stated map-command capabilities and README license text | No modern multiplayer, JIP, performance, or security validation was performed. |
| Target architecture | Synthesis/recommendation | Recommended, not implemented | Design decisions below must be validated against a pinned Antistasi release. |

## Observed architecture

### Runtime and state flow

| Component | Observed behavior | Current authority | Integration assessment |
|---|---|---|---|
| Addon bootstrap | `CfgFunctions` registers `LW_fnc_init` as `preInit`; `fn_init` exits on non-server, loads or creates state, then starts a server loop. `CfgPatches` presently requires only `A3_Functions_F`. [1] [2] | Server | The documented Antistasi relationship is not enforced by an addon dependency or verified runtime contract. |
| State and mutation | State contains a version, sequence, districts, event log, AI groups, logistics, missions, and rewards. `applyEvent` clamps district fields to `0..100`, caps the log at 100, publishes a `missionNamespace` snapshot, and saves after every event. [2] | Server intends to own mutation | State is local to the Living War layer and is not a demonstrated bridge to Antistasi campaign state. |
| Director and dispatch | Threat is calculated from pressure, supply, and support. The Director chooses reaction states and, when enabled, assigns orders only to existing groups. Dispatch paths use `east`; a district requires a pre-existing position. [2] | Server | The fixed side and local district model require an explicit faction/district adapter. |
| AI persistence | Only living, player-free groups are captured. Restore waits 20 seconds, finds heuristic matches, and teleports nearby surviving units; it does not recreate groups or units. [2] | Server | This can conflict with or misidentify Antistasi-managed entities. It is not reliable entity restoration. |
| Missions, ambient, radio | Each exists as a local mechanism. Camp offers use a static catalogue; ambient uses registered sites; radio remotely plays local lines. [2] | Mixed server/client | No verified Antistasi callback supplies camp, objective, convoy, or territory lifecycle data. |
| UI | Procedural `RscDisplayEmpty` debug and camp UI. Camp UI checks local site distance and sends a request to the server; debug is limited by `serverCommandAvailable '#kick'`. [2] | Client display; server should authorize actions | The UI is not a JIP-safe command protocol and does not itself prove server-side authorization. |
| Build and release | Scripts package the PBO and EasyInstall archive. CI builds and archives but does not run SQF lint, in-game PBO verification, or a dedicated-server smoke/integration test. [3] | Build system | Artifact freshness, signing/checksums, and reproducibility checks are absent. |

### Current control boundaries

The code distinguishes `serverOnly` functions in configuration and limits the listed RemoteExec surface to camp-mission request, offer display, and radio playback. That is a useful boundary declaration, but it is **not an authorization system**. In the audited flow, the client supplies `_player` and camp identity for `requestCampMission`; the reviewed API did not show independent server verification of sender ownership, distance, life, side, or an authoritative registered camp. Mission completion also lacks demonstrated nonce, owner, expiry, or objective proof. [1] [2]

The design must therefore treat every client-originated action as an untrusted request. The server must derive the player from the remote caller, resolve the camp/objective from authoritative state, check permissions and current conditions, and make completion idempotent.

## Material risks and required treatment

| Priority | Risk | Why it matters | Required architectural treatment |
|---|---|---|---|
| P0 | Global `profileNamespace` key `LW_state` is not campaign-, map-, server-, or instance-scoped. There is no demonstrated schema migration or corruption handling. [2] | Different missions or hosts can mix state; persistence can be invalid or unrecoverable. | Stop using the global key as campaign truth. Use an Antistasi-supported save extension point only after verification, or a separately namespaced, versioned supplemental store keyed by an authoritative campaign identity. Validate and migrate on load. |
| P0 | Camp and mission APIs trust client-supplied identifiers; mission completion has no demonstrated anti-replay or objective evidence. [2] | Enables spoofing, unauthorized completion, and duplicate rewards/pressure changes. | Server-derive caller; issue opaque mission instances with owner, nonce, lifecycle status, expiry, and server-side objective validation; reject duplicates. |
| P0 | AI restore matches heuristically and teleports units but does not recreate entities. [2] | Can affect the wrong group or conflict with Antistasi cleanup, ownership, map changes, and gameplay. | Do not restore Antistasi AI from Living War snapshots. Use stable upstream identifiers only if a documented, tested contract exists; otherwise retain only supplemental metadata. |
| P1 | Director hard-codes `east`. [2] | Reactions will be wrong when Antistasi faction/side configuration differs. | Resolve side/faction through the pinned Antistasi adapter and fail closed when no valid mapping exists. |
| P1 | Whole-state saving and `allGroups` capture occur after each event; there is no mutation queue/lock. [2] | High event rates can create I/O/CPU spikes and lost updates. | Serialize state mutations through a server queue; batch/debounce persistence; bound data; measure cost under dedicated-server load. |
| P1 | Scheduler uses `diag_tickTime mod` windows with a 30-second sleep. [2] | A task can run repeatedly in a window and timing varies with scheduler delay. | Store explicit last-run timestamps or next-run deadlines per task. |
| P1 | Antistasi owns campaign persistence, territory, AI, and HC lifecycle. [4] | A parallel controller creates competing sources of truth. | Restrict Living War to observer/reaction/content behavior. Never transfer group ownership or independently own campaign territory. |
| P2 | Current UI has no demonstrated versioned JIP refresh, command acknowledgements, or objective tracking. [2] | Players can act on stale state and cannot reliably understand result status. | Publish an immutable/versioned view; add request/acknowledgement/error contracts; design JIP and reconnect refresh explicitly. |
| P2 | Build pipeline lacks executable quality gates and release provenance. [3] | A valid archive may still contain regressions or stale output. | Add lint/static checks, PBO/package manifest verification, dedicated-server test scenario, artifact versioning, checksum/signing policy, and CI promotion gates. |

## Recommended target architecture

```text
Antistasi Community (authoritative campaign runtime)
  ├─ supported events / config extension points / setup Params
  └─ campaign save, territories, garrisons, groups, logistics, HC
                         │
                         ▼
Living War compatibility adapter (pinned A3A release)
  ├─ detects A3A and supported API surface
  ├─ maps A3A facts to Living War event schema
  ├─ resolves faction, district, camp, and stable identifiers
  └─ fails closed / disables feature when a contract is absent
                         │
                         ▼
Living War server service
  ├─ serialized event queue and bounded supplemental state
  ├─ server-side validation and idempotent mission instances
  ├─ reaction policy / optional AI order requests
  └─ rate-limited persistence of versioned supplemental metadata
                         │
                         ▼
Client presentation
  ├─ read-only versioned snapshots
  └─ narrowly whitelisted requests → server acknowledgement
```

The official A3AExtender pattern shows config registration and event listeners guarded by Antistasi detection. It specifically advises event listening rather than broad core replacement, while warning that overwrites are update-fragile. The official source contains an events addon and the setup UI reads `A3A/Params`, which are suitable discovery points for a compatibility design. [5] [6] [7]

The **adapter** is the critical missing layer. It should translate only verified Antistasi facts into a small Living War schema, for example a stable district key, position, faction/side, event type, timestamp, and upstream entity reference. It must not infer territory capture, camps, convoys, or group lifecycle from unverified internal variables. If the required official event is unavailable, the feature should remain disabled or use a separately approved, version-pinned compatibility module.

### Explicitly unverified assumptions

| Assumption that must not be treated as fact | Validation required before implementation |
|---|---|
| A single high-level, stable Antistasi event exists for each desired territory, loss, camp, convoy, and logistics trigger. | Inventory `A3A >> Events` and the selected release source; record exact event name, argument contract, locality, and compatibility test. The supplied audit found no guaranteed `onTerritoryCaptured`-style hook. [5] [6] |
| Antistasi exposes a documented save hook and stable campaign identifier suitable for Living War data. | Confirm against the pinned release and an actual dedicated-server save/load cycle. Do not assume a private variable or `profileNamespace` key is safe. |
| Antistasi 3.11.1 is the selected compatibility baseline. | Product owner must choose and pin a release/tag. The supplied audit reports 3.11.1 as the then-latest release and identifies `unstable` as the default branch; neither proves production compatibility. [4] |
| Living War should load without Antistasi as a standalone disabled overlay. | Choose one packaging contract: an Antistasi-required extension or a standalone addon that detects and disables integration. Do not simultaneously claim a hard required addon and optional standalone behavior without a tested load plan. |
| Existing AI groups may safely receive Living War orders. | Validate authority, group ownership, HC interaction, faction rules, and a rollback/cleanup contract in the pinned release. |
| The author has granted reuse/distribution rights for the current Living War source. | Obtain a license file or written authorization from the rightsholder before distribution, forking, or incorporating the code. [8] |

## Donor and licensing posture

AIC is an appropriate **UX reference**, not an implementation donor: reuse the concept of direct map manipulation, scoped commander/group control, and separate tactical-map/remote-view modes; independently build code, networking, assets, and camera lifecycle. The AIC README contains MIT terms, but its image and game-related assets require separate provenance review. [9] [10]

Antistasi provides the extension model and, where applicable, MIT-licensed source. Its license also lists components under Arma Public License No Derivatives (APL-ND), so those components must not be copied or modified as though they were MIT. A3AExtender had no separately verified license in the supplied audit; treat its examples as reference until upstream notices are verified. [5] [8]

The local Living War repository showed no `LICENSE`, `COPYING`, SPDX header, or explicit license field. Its legal status is **unverified**. Preserve attribution to `maloneed`, but do not publicly fork, redistribute, or merge its code until permission or a license is established. [1] [3]

## Architecture acceptance criteria

The architecture is ready to move from prototype to integration only when all of the following are demonstrated on a pinned Antistasi release:

1. The addon detects the supported Antistasi API, registers no listeners when unsupported, and leaves no competing campaign state behind.
2. Every state-changing network request is server-authorized, replay-resistant, idempotent, and acknowledged with a versioned result.
3. Living War no longer restores or teleports Antistasi groups from its own snapshots, and no hard-coded `east` dispatch remains.
4. Supplemental persistence is campaign-scoped, schema-versioned, migration-tested, bounded, and resilient to invalid data.
5. A dedicated-server scenario proves bootstrap, JIP, reconnect, save/load, event handling, cleanup, and disabled-mode behavior; CI gates packaging on those checks.
6. The release carries verified license notices, donor attributions, a source/provenance record, and reproducible artifact metadata.

## References

[1]: file:///home/ubuntu/gh-armas/addons/living_war/config.cpp "Living War addon configuration at audited local commit 53cbca9"
[2]: file:///home/ubuntu/gh-armas/addons/living_war/functions/ "Living War SQF function set audited at local commit 53cbca9"
[3]: file:///home/ubuntu/gh-armas/README.md "Living War README, documentation, parameters, build scripts, CI, and release archive audited at local commit 53cbca9"
[4]: https://github.com/official-antistasi-community/A3-Antistasi/releases/tag/3.11.1 "Official Antistasi Community A3-Antistasi release 3.11.1"
[5]: https://github.com/official-antistasi-community/A3AExtender "Official A3AExtender repository and extension guidance"
[6]: https://raw.githubusercontent.com/official-antistasi-community/A3AExtender/master/A3AE/addons/functions/Events/fn_addExampleEventListener.sqf "A3AExtender example event listener"
[7]: https://github.com/official-antistasi-community/A3-Antistasi/tree/unstable/A3A/addons/events "A3-Antistasi events addon"
[8]: https://raw.githubusercontent.com/official-antistasi-community/A3-Antistasi/unstable/LICENSE "A3-Antistasi license and listed APL-ND exceptions"
[9]: https://raw.githubusercontent.com/sethduda/AIC/master/README.md "Advanced AI Command README and MIT license text"
[10]: https://github.com/sethduda/AIC "Advanced AI Command source repository"
[11]: https://github.com/official-antistasi-community/A3-Antistasi "Official Antistasi Community A3-Antistasi repository README"
[12]: file:///home/ubuntu/gh-armas/.github/workflows/build.yml "Living War CI workflow at audited local commit 53cbca9"

<!-- Source traceability: local audit also reviewed params.hpp, docs/*.md, build_mod.sh, build_easy_install.sh, tools/build_pbo.py, addons/living_war/README.md, release/INSTALL_RU.txt, and release/LivingWar-EasyInstall.zip. -->
