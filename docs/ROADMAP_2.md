# ARMAS / Living War Roadmap 2 — Secure Antistasi Extension

**Planning basis:** This roadmap sequences the architecture audit into decision gates and implementation work. It uses priorities rather than calendar dates because no schedule, team capacity, target game mode, or acceptance owner was supplied. Any date, staffing level, or performance budget would be an **unverified assumption**.

> **Target outcome:** A separately packaged Living War addon that augments a **pinned** Antistasi Community release through verified extension points. Antistasi remains authoritative for campaign save data, territory, groups, garrisons, logistics, and headless-client behavior. [1] [2]

## Priority summary

| Priority | Objective | Release gate | Primary dependency |
|---|---|---|---|
| **P0 — Blockers** | Establish legal authority, compatibility baseline, and server trust boundary. | No distributable integration code or production release before closure. | License decision; selected Antistasi tag; security design. |
| **P1 — Foundations** | Build a safe state/event kernel and a version-pinned Antistasi adapter. | Dedicated-server integration milestone. | P0 closure. |
| **P2 — Gameplay and command UX** | Turn the prototype mechanics into real callback-driven content and a trusted user workflow. | Feature-complete beta candidate. | P1 adapter and test harness. |
| **P3 — Operational hardening** | Make builds reproducible, observable, and releaseable. | Production release candidate. | P1/P2 acceptance evidence. |

## P0 — Blockers: decide rights, scope, and trust model

| ID | Work item | Why it is first | Deliverable / acceptance evidence |
|---|---|---|---|
| P0.1 | **Resolve Living War licensing.** Locate a license from the rightsholder or obtain written permission for the intended use; record author attribution (`maloneed`) and decision in a provenance register. | The local audit found no `LICENSE`, `COPYING`, SPDX headers, or explicit license declaration. Shipping, forking, or merging code without a rights decision is not acceptable. [3] | A committed license/permission record and a scope statement. Until then, retain current source only for internal audit/reference. |
| P0.2 | **Freeze the compatibility contract.** Select one Antistasi release/tag, record its repository commit, and define supported map/mod/load topology. Do not target the default `unstable` branch as a stable ABI. | Extension behavior, events, and internal APIs can change. The supplied audit identifies `unstable` as default and reports 3.11.1 as the then-latest release, but does not prove Living War compatibility. [1] [4] | `COMPATIBILITY.md` names exact tag/commit, tested dependencies, and allowed client/server mod arrangement. |
| P0.3 | **Choose packaging semantics.** Decide whether Living War is strictly Antistasi-required or can load independently in disabled mode. | A hard addon dependency and optional standalone behavior are different installation contracts. | Config/load test for the chosen contract; unsupported configurations fail clearly and do not mutate state. |
| P0.4 | **Create a source and asset provenance register.** Separate code, visual assets, audio, configuration examples, and documentation. | AIC’s README offers MIT terms for code, while its assets need independent review. Antistasi lists APL-ND exceptions despite its main MIT license. A3AExtender licensing was not separately verified. [5] [6] [7] | Donor register includes source URL/path, version, license, notice requirement, disposition, and reviewer decision for every incorporated item. |
| P0.5 | **Specify the RemoteExec threat model.** Replace client-trusted action semantics with server-derived identity and authoritative object resolution. | The audited camp-mission request accepts client-provided player/camp data, and completion has no demonstrated nonce, owner, expiry, or objective proof. [3] | Request/response schema covering caller identity, authorization, validation, nonce/idempotency key, lifecycle state, error codes, audit record, and replay behavior. |
| P0.6 | **Stop unsafe AI persistence behavior by policy.** Remove the plan to restore/teleport Antistasi groups from Living War snapshots unless a documented stable upstream contract is proven. | Existing restore logic heuristically matches groups and teleports units without creating missing entities. This risks incorrect or conflicting state. [3] | Written ownership policy: Antistasi owns AI lifecycle/HC; Living War stores no reconstructive AI snapshot. A regression test asserts no group transfer, spawn, delete, or teleport from restoration code. |

### P0 exit gate

P0 passes only when legal status permits the planned distribution, the Antistasi target is pinned, the addon load contract is explicit, the donor register is complete, and server authority has been designed before client UI work continues. If Living War rights remain unresolved, implement only newly authored code in a separate clean-room path and do not copy local source.

## P1 — Foundations: build the extension boundary and safe state kernel

| ID | Work item | Implementation direction | Acceptance test |
|---|---|---|---|
| P1.1 | **Build the compatibility adapter.** | Use a Living War namespace and guarded Antistasi detection. Subscribe through verified events/config extension points rather than overwriting core functions. Record exact event names, argument types, locality, and release applicability. [2] [8] | On the pinned release, startup confirms all required contracts. On absence or mismatch, the feature disables cleanly and produces no campaign mutations. |
| P1.2 | **Define the adapter event schema.** | Translate only verified facts into a small immutable event shape: schema version, event ID, upstream timestamp, district key, position, faction/side, event kind, and upstream entity reference. | Unit/static tests reject missing/unknown district, invalid side, duplicate ID, and unsupported schema. No feature assumes an undocumented `onTerritoryCaptured`-style hook. |
| P1.3 | **Replace global persistence.** | Treat Living War data as bounded supplemental metadata, not campaign truth. Use a documented Antistasi save hook only after validation; otherwise use a separately namespaced, campaign-scoped, schema-versioned store with validation, migration, and recovery behavior. | Save/load across restart proves no cross-campaign/map leakage, invalid data is quarantined or reset safely, and old schema handling is deterministic. |
| P1.4 | **Serialize mutations and bound I/O.** | Route every state mutation through one server queue. Make event IDs idempotent. Cap event data and batch/debounce persistence; avoid `allGroups` scans after each ordinary event. | Concurrent request test shows no lost update; load test reports queue depth, processing time, and persistence frequency within the team-approved budget. |
| P1.5 | **Replace mod-window scheduling.** | Maintain a `lastRun` or `nextRun` timestamp per Director, logistics, ambient, and radio task. | A controlled clock test proves each periodic task runs once per intended interval, including after delayed frames. |
| P1.6 | **Introduce faction and district resolution.** | Have the adapter supply faction/side and authoritative district/camp mappings. Remove fixed `east` dispatch and do nothing when mapping is absent. | Same scenario is tested with the configured enemy side and with no mapping; the latter fails closed without orders. |
| P1.7 | **Register compatible parameters.** | Use unique Living War names and the version-tested Antistasi Params schema. Preserve saved-value/default migration behavior. Do not replace Antistasi setup UI. [2] [9] | New campaign, existing campaign, invalid legacy value, and dedicated-admin setup flows load the intended values. |

### P1 exit gate

A clean dedicated-server scenario must demonstrate: pinned-version detection; listener registration; one real event translated through the adapter; serialized reaction state; save/load behavior; failure-closed missing API behavior; and zero Living War ownership of Antistasi campaign/AI/HC lifecycle.

## P2 — Gameplay and command UX: implement only after authority exists

| ID | Work item | Implementation direction | Acceptance test |
|---|---|---|---|
| P2.1 | **Make camp and mission lifecycle authoritative.** | Replace static offer completion with opaque server-issued mission instances. Bind an instance to authorized player/scope, nonce, state, expiry, and verified objective callback. Completion must be idempotent. | Spoofed player/camp ID, expired instance, repeated completion, foreign player, and missing objective proof are rejected; valid completion updates once. |
| P2.2 | **Connect ambient, radio, convoy, and reward reactions to real upstream callbacks.** | Keep content policy local but receive facts through P1 adapter. Rate-limit output and preserve a server event journal. | A verified upstream event causes one expected reaction; unsupported events cause no fictional world-state update. |
| P2.3 | **Rebuild Director execution as requests, not ownership.** | Permit only policy-approved, existing groups with validated side, locality, availability, and scope. Provide expiry/cleanup for orders. Never create, delete, transfer, or restore Antistasi groups. | Director does not issue a command to invalid/foreign/obsolete group; cleanup clears expired order metadata; HC/group ownership test remains unchanged. |
| P2.4 | **Deliver a versioned client snapshot protocol.** | Publish read-only, bounded state views with version/sequence and explicit refresh on JIP/reconnect. Client sends narrow requests and displays server acknowledgements/errors. | Join-in-progress and reconnect show the current state; stale request returns a deterministic resolution; client cannot mutate authoritative data locally. |
| P2.5 | **Prototype map command UX independently.** | Take only AIC’s high-level pattern: map-based groups/vehicles/waypoints, scoped commanders, visible command feedback, and distinct remote-view mode. Rewrite network, camera, interaction, and assets. [5] [10] | Usability scenario covers selection, command preview, confirm, acknowledgement, failure, cancel/undo policy, keyboard conflict avoidance, and reconnect/camera exit. |
| P2.6 | **Define content and UI provenance.** | Use original icons, audio, and visual styling unless individual donor asset rights are established. | Release inventory has no unreviewed AIC or APL-ND asset. |

### P2 exit gate

The beta candidate must prove that every player-visible mission/reaction is driven by a verified authoritative event or server validation path. It must provide JIP/reconnect correctness, safe denial behavior, and a command interaction that does not depend on copied AIC runtime or assets.

## P3 — Operational hardening and release control

| ID | Work item | Implementation direction | Acceptance test |
|---|---|---|---|
| P3.1 | **Add build quality gates.** | Run SQF lint/static validation, package manifest checks, and archive/PBO verification in CI before publication. The current workflow only builds/archives. [11] | CI fails on lint failure, missing required file, unexpected archive member, or package-version mismatch. |
| P3.2 | **Create a dedicated-server integration harness.** | Build a repeatable mission/test scenario that performs boot, event, authorization, JIP, reconnect, save/load, disabled mode, and cleanup tests. | CI or a documented controlled runner produces a retained pass/fail report for the pinned release. |
| P3.3 | **Measure operational behavior.** | Add structured server logging/metrics for adapter status, rejected requests, queue depth, mutation latency, save duration, and task cadence. | A load/reliability report includes inputs, observed results, known limits, and remediation thresholds approved by the team. |
| P3.4 | **Make releases traceable.** | Version PBO/archive from source metadata; create checksum/signing policy; record source revision and compatibility tag; verify release contents are built from current HEAD. | Published archive contains manifest, version, checksum, notices, install instructions, and reproducible source revision. |
| P3.5 | **Maintain upgrade discipline.** | For each Antistasi update, diff the adapter-facing APIs, rerun compatibility tests, review licenses/notices, and publish supported/unsupported status. | No upstream tag is declared supported until the full P1–P3 regression suite passes. |

## Cross-cutting test matrix

| Scenario | Minimum assertion | Phase that introduces it |
|---|---|---|
| Unsupported Antistasi / no Antistasi | Living War disables or follows the selected package contract without mutating campaign state. | P0–P1 |
| Supported startup | Required extension points resolve and listeners register once. | P1 |
| Concurrent events | No lost update; duplicate event produces no duplicate effect. | P1 |
| Save/load and corrupted data | Supplemental data remains scoped, migrated or rejected safely, and never recreates/teleports Antistasi AI. | P1 |
| Client spoof/replay | Server rejects invalid caller/object/nonce/expiry/objective state. | P0–P2 |
| Faction/map variation | No hard-coded `east`; unmapped district/side fails closed. | P1 |
| JIP/reconnect | Snapshot is current and client pending commands are reconciled. | P2 |
| Headless-client/group lifecycle | Living War does not alter ownership or rely on stale group references. | P0–P2 |
| Packaging | PBO/archive is generated from current revision with expected files and notices. | P3 |

## Explicitly unverified assumptions and decisions needed

| Item | Status and required decision |
|---|---|
| Target Antistasi release, maps, factions, and supported mod stack | **Unverified.** Select and pin before P1. Release 3.11.1 is an audit observation, not a project commitment. [1] |
| Exact official events for territory, camp, convoy, loss, and logistics callbacks | **Unverified.** Discover and contract-test them; do not build features around assumed event names. [2] [8] |
| Availability of a public campaign save hook/stable entity ID | **Unverified.** Validate before any Living War persistence or entity metadata design. |
| Desired standalone versus Antistasi-required installation model | **Unverified.** Decide in P0.3 and test it. |
| Timeline, staffing, performance targets, accessibility target, and telemetry retention | **Not supplied.** Establish explicit product/operations requirements before declaring P2/P3 complete. |
| Rights to redistribute current Living War source and A3AExtender examples | **Unverified.** P0 legal closure is mandatory; no copying based on inference. [3] [6] |

## References

[1]: https://github.com/official-antistasi-community/A3-Antistasi/releases/tag/3.11.1 "Official Antistasi Community A3-Antistasi release 3.11.1"
[2]: https://github.com/official-antistasi-community/A3AExtender "Official A3AExtender repository and extension guidance"
[3]: file:///home/ubuntu/gh-armas/addons/living_war/functions/ "Living War SQF function set audited at local commit 53cbca9"
[4]: https://github.com/official-antistasi-community/A3-Antistasi "Official Antistasi Community A3-Antistasi repository"
[5]: https://raw.githubusercontent.com/sethduda/AIC/master/README.md "Advanced AI Command README and MIT license text"
[6]: https://github.com/sethduda/AIC "Advanced AI Command repository"
[7]: https://raw.githubusercontent.com/official-antistasi-community/A3-Antistasi/unstable/LICENSE "A3-Antistasi license and APL-ND exceptions"
[8]: https://raw.githubusercontent.com/official-antistasi-community/A3AExtender/master/A3AE/addons/functions/Events/fn_addExampleEventListener.sqf "A3AExtender example event listener"
[9]: https://raw.githubusercontent.com/official-antistasi-community/A3-Antistasi/unstable/A3A/addons/gui/functions/SetupGUI/fn_setupParamsTab.sqf "A3-Antistasi setup parameters tab"
[10]: https://github.com/sethduda/AIC/blob/master/AICommand/functions/mapElements/interactiveIcon/fn_interactiveIconEventHandler.sqf "Advanced AI Command interactive map icon event handler"
[11]: file:///home/ubuntu/gh-armas/.github/workflows/build.yml "Living War CI workflow at audited local commit 53cbca9"
