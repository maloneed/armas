# ARMAS / Living War Donor Matrix

**Purpose:** This matrix converts the three supplied audits into an implementation and provenance decision aid. A designation of **REUSE** means reuse of an idea, model, or documented extension point unless the row expressly says that source code may be copied. It never overrides license, attribution, or game-asset rights.

> **Default rule:** When legal provenance, API stability, or server authority is not proven, treat the material as a reference and implement an independent equivalent.

## Table-ready donor decision matrix

| Donor / source | Verified contribution | Recommended disposition | Permitted incorporation now | Prohibited or deferred incorporation | License / provenance posture | Non-negotiable conditions |
|---|---|---|---|---|---|---|
| **Current Living War** local source | Server-held district state; clamped `applyEvent`; bounded event log; opt-in orders to existing groups; procedural debug/camp UI; build/release skeleton. [1] [2] | **ADAPT concepts; REWRITE critical runtime** | Use only as an internal behavioral reference for an event overlay, bounded log, and opt-in reaction policy. Preserve `maloneed` attribution in internal records. | Do not redistribute, fork, merge, or copy as product code until rights are resolved. Do not retain global `LW_state` persistence, trust client mission inputs, hard-code `east`, or use heuristic AI teleport restore. | **Unverified.** The audited repository had no `LICENSE`, `COPYING`, SPDX headers, or explicit license declaration. [1] [2] | Obtain author permission or a license. Define a campaign-scoped state contract, server authorization, a faction adapter, and dedicated-server tests before implementation use. |
| **AIC / Advanced AI Command** | Strategic map as a command surface; group/vehicle/waypoint/commander information model; draggable waypoint feedback; scoped commander control; tactical map versus remote-view concept. [3] [4] | **REUSE product concepts; ADAPT UX patterns; REWRITE implementation** | Independently design map selection, waypoint manipulation, command feedback, vehicle assignment, and remote-view user journeys. Retain MIT notice if copying any verified code is later approved. | Do not copy SQF runtime, RemoteExec/network model, display/control IDs, PNG/JPG/PSD/PAA/logo assets, or literal UX bindings. Do not rely on its old MP behavior as a production specification. | README presents **MIT**, Copyright (c) 2016 Seth Duda, for repository code; no separate LICENSE file was observed in the audit. Asset rights are **not established** by that code license. [3] | Preserve exact MIT copyright/license text for any code copied. Complete a per-asset provenance review or replace assets. Independently implement authorization, JIP/reconnect, command queue, undo/redo, accessibility, and telemetry. |
| **Official Antistasi Community — A3-Antistasi** | Extension context; event subsystem; setup parameter schema; campaign/runtime ownership; logistics and template extension surfaces. [5] [6] [7] | **REUSE documented extension points; ADAPT through a pinned compatibility layer** | Add independent Living War functions/configuration; subscribe to verified official events; register compatible Params/templates/logistics metadata where required; defer to Antistasi as campaign authority. | Do not replace the mission/core PBO, introduce a parallel territory/AI/HC/campaign-save manager, use undocumented internal functions as a stable API, or copy APL-ND components. | Main repository license is **MIT** with specific listed **APL-ND exceptions**. [8] | Pin a release rather than `unstable`; inventory exact event signatures and locality; guard detection/API availability; preserve relevant MIT notices; exclude APL-ND files from copying/modification. |
| **A3AExtender** | Official example of config packaging, event listener registration, templates, and guarded Antistasi detection. [9] [10] | **ADAPT pattern; REWRITE addon code unless license is verified** | Model the integration shape: own namespace, precondition checks, event listener IDs, config-driven extension, and compatibility guards. | Do not assume the repository’s examples are MIT or copy them into a distributable addon without a separate rights determination. Do not adopt its permissive RemoteExec sample as policy. | **Unverified in supplied audit.** No separate license file was found. [9] | Retain attribution in the design record; verify upstream notices before copying. Whitelist only required RemoteExec functions and validate all server mutations. |
| **Antistasi documentation and setup UX** | The setup UI reads `A3A/Params`; dedicated-server setup is administrated through the Antistasi workflow; clients/server must use compatible mod loading. [7] [11] | **ADAPT configuration contract** | Add uniquely named Living War parameters only through a compatibility-tested Antistasi Params configuration. Document client/server installation requirements when client code is used. | Do not replace the Antistasi setup UI or infer compatibility with older Barbolani/Plus variants. | Documentation is evidence of behavior, not a license grant for copying visual/UI assets. | Test parameter migration, saved values, defaults, dedicated-server administration, and client/server version parity. |

## Feature-level extraction matrix

| Candidate capability | Best source of insight | Product decision | Architecture required before use | Evidence limitation |
|---|---|---|---|---|
| District pressure/support/supply reaction model | Living War | **ADAPT** | Antistasi event adapter; stable district mapping; serialized server mutation; bounded, versioned supplemental state. | Current district positions and upstream territory mapping are not implemented. [1] |
| Map-driven group command | AIC | **REUSE concept / ADAPT UX** | Server-authorized command request, group scope/ownership checks, acknowledgement, JIP snapshot, rollback/undo policy. | AIC is an old Arma 3 implementation; supplied audit did not establish modern security or performance. [3] [4] |
| Waypoint drag-and-drop | AIC | **ADAPT** | Explicit selection state, command confirmation, cancel/undo, keyboard and accessibility behavior, server validation. | Direct-manipulation behavior is evidenced; a modern interaction specification is not. [4] |
| Vehicle assignment, landing, fly height | AIC | **ADAPT** | Capability/availability checks, ownership rules, request validation, refusal feedback, and recovery behavior. | Detailed compatibility and failure rules are not documented in the supplied evidence. [3] |
| Command radio feedback | AIC + Living War | **REUSE concept / REWRITE system** | Event journal, acknowledgement priorities, filtering, rate limiting, locale/audio provenance, and server-authoritative triggers. | AIC evidence supports a command-radio concept, not a complete radio specification. [3] |
| Camps, ambient sites, missions | Living War | **REWRITE lifecycle; ADAPT content ideas** | Authoritative camp/objective adapter; opaque mission instances; nonce/owner/expiry; proof-of-completion; real marker/objective lifecycle. | Current static catalogue/offers do not prove actual Antistasi mission integration. [1] |
| Factions, templates, and logistics data | Antistasi/A3AExtender | **ADAPT documented extension points** | Pin release; use configuration extension paths; validate cargo/template behavior in-game. | Template/logistics interfaces vary; an extension point is not proof of all scenarios working. [6] [9] |
| Campaign persistence and AI/HC lifecycle | Antistasi | **DEFER TO ANTISTASI** | Living War must store only independently scoped supplemental metadata, if a verified save contract permits it. | No stable public save hook or stable entity-ID contract was verified in the supplied results. [5] [6] |
| Remote control / camera | AIC | **REUSE concept only** | New state machine for enter/exit/reconnect, authorization, camera return, safe bindings, and client/server ownership. | AIC’s remote view/control is not current production evidence. [3] |

## Legal and attribution register

| Material | Required notice/action | Status before shipping |
|---|---|---|
| Living War source | Secure an explicit license or written permission; retain author attribution. | **Blocking: unverified.** [1] [2] |
| AIC code, if any is copied after review | Include exact MIT license and copyright notice for Seth Duda (2016). | Conditional; code copying is not recommended. [3] |
| AIC visual/audio/game assets | Establish provenance and license per item, or replace with original assets. | **Blocking for asset reuse.** [3] [4] |
| A3-Antistasi MIT files, if copied | Preserve copyright/license notices and identify source/version. | Conditional; copy only minimum necessary. [8] |
| A3-Antistasi APL-ND exceptions | Do not copy, modify, or redistribute derivatives without separate permission/terms analysis. | **Reject for ordinary reuse.** [8] |
| A3AExtender examples | Find and record an applicable upstream license before copying. | **Blocking: unverified.** [9] |

## Explicitly unverified assumptions

| Assumption | Required disposition |
|---|---|
| AIC code or assets can be imported solely because the README includes MIT text. | False for assets; source-code copying still requires preservation of the exact notice and a scope check. [3] |
| A3AExtender is MIT-licensed because it is maintained alongside Antistasi tooling. | **Unverified.** Do not copy until upstream licensing is checked. [9] |
| Every desired Living War trigger has a stable, public Antistasi event. | **Unverified.** Verify the selected tag’s event names and argument contracts before committing a feature. [5] [10] |
| A `profileNamespace` key can safely function as an Antistasi campaign save. | **Unverified and rejected as a default.** The audited key is global and not campaign-scoped. [1] |
| Current Antistasi default branch is safe to target as an ABI. | **Unverified and not recommended.** The supplied audit identifies `unstable` as default; pin a release and test it. [5] |

## Adoption rule

A donor item may move from **reference** to **incorporated material** only after its row has: (1) a source/version record, (2) a license/provenance decision, (3) an authority and threat-boundary design, and (4) an automated regression test. The roadmap in `ROADMAP_2.md` operationalizes those gates.

## References

[1]: file:///home/ubuntu/gh-armas/addons/living_war/functions/ "Living War SQF function set audited at local commit 53cbca9"
[2]: file:///home/ubuntu/gh-armas/README.md "Living War README, documentation, parameters, build and release materials audited at local commit 53cbca9"
[3]: https://raw.githubusercontent.com/sethduda/AIC/master/README.md "Advanced AI Command README and MIT license text"
[4]: https://github.com/sethduda/AIC "Advanced AI Command repository"
[5]: https://github.com/official-antistasi-community/A3-Antistasi "Official Antistasi Community A3-Antistasi repository"
[6]: https://github.com/official-antistasi-community/A3AExtender "Official A3AExtender repository and extension guidance"
[7]: https://raw.githubusercontent.com/official-antistasi-community/A3-Antistasi/unstable/A3A/addons/gui/functions/SetupGUI/fn_setupParamsTab.sqf "A3-Antistasi setup parameters tab"
[8]: https://raw.githubusercontent.com/official-antistasi-community/A3-Antistasi/unstable/LICENSE "A3-Antistasi license and APL-ND exceptions"
[9]: https://raw.githubusercontent.com/official-antistasi-community/A3AExtender/master/readme.md "A3AExtender README"
[10]: https://raw.githubusercontent.com/official-antistasi-community/A3AExtender/master/A3AE/addons/functions/Events/fn_addExampleEventListener.sqf "A3AExtender example event listener"
[11]: https://official-antistasi-community.github.io/A3-Antistasi-Docs/beginners_guide/raw_beginners_guide.html "Antistasi Community beginners guide"
