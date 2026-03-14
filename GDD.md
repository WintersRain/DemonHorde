# Demon Horde — Game Design Document

**Working Title:** Demon Horde
**Genre:** Turn-Based Squad Tactics + Horde Management
**Engine:** Godot 4.x (GDScript)
**Tone:** Playful chaos — irreverent, funny, strategically deep
**Tagline:** *"Build your horde. Raid the kingdom. Try not to set yourself on fire."*

---

## 1. Core Fantasy

You are an ancient, malevolent force — the will behind the horde. You don't have a body (yet). You are the unseen intelligence that directs demons from the depths, breeding them, shaping them, commanding them. You see through their eyes, but you never touch the battlefield yourself.

Until you do.

The Demon Lord awakening isn't summoning some other entity — it's *you* manifesting physically. A hundred corruption's worth of stolen souls and salted earth finally gives you form. When the Demon Lord steps onto the battlefield at 100% corruption, the player goes from strategic puppeteer to *active combatant*. The stakes are real: if your manifestation falls in battle, you're banished back to formlessness and must rebuild.

Your demons are unruly, your plans will go sideways, and the world fights back. But that's the fun.

---

## 2. Core Loop

```
┌─────────────────────────────────────────────────┐
│                                                 │
│   EMERGE → PREPARE → RAID → REAP → EVOLVE      │
│     ↑                                  │        │
│     └──────────────────────────────────┘        │
│                                                 │
└─────────────────────────────────────────────────┘
```

1. **Emerge** — Your horde surfaces through an entry point (volcano, hell pit, crack in the earth). The entry point changes per campaign/map, setting the tone.
2. **Prepare** — Manage your roster. Breed new demons, evolve existing ones, assign squads, pick your target on the world map.
3. **Raid** — Deploy squads against a target location. Turn-based tactical combat plays out.
4. **Reap** — Collect captives, souls, and corruption from the raid. Decide: salt the earth or leave it standing?
5. **Evolve** — Spend resources on breeding, mutations, and upgrades. Grow your horde. Return to step 2.

---

## 3. The World Map

### 3.1 Living World
The overworld is a strategic map with settlements connected by roads/paths. This is NOT a static target list — the world reacts to you.

- **Settlements** range from tiny hamlets to fortified capitals
- **Each settlement has stats:** population, militia strength, fortification level, morale, resources
- **Recovery:** Raided settlements rebuild over time. Population regrows, walls get repaired, militia re-musters. A village you hit 5 turns ago is harder than when you first found it — they're *scared now* and they *prepared*
- **Consolidation:** When you raze/salt a settlement, nearby settlements absorb its refugees. Their population grows, they gain veteran defenders, they might upgrade fortifications. You create harder fights by eliminating easy ones
- **Awareness:** Early raids are against unsuspecting targets. As your threat grows, the kingdom organizes — patrols appear, heroes are summoned, alliances form between settlements

### 3.2 Salt the Earth
After a successful raid, you can choose to:

| Choice | Effect |
|---|---|
| **Raid & Leave** | Take your loot and go. Settlement recovers over time. Can be re-raided. Lower awareness increase. |
| **Occupy** | Station a squad to hold the location. Provides passive resources but ties up units. Enemies will try to reclaim it. |
| **Salt the Earth** | Permanently destroy the settlement. Refugees flee to nearby settlements, strengthening them. Cannot be undone. Significant awareness spike. |

This creates a strategic tension: salting feels powerful but makes the remaining targets harder. A player who salts everything early will face consolidated, fortified mega-cities. A player who re-raids carefully keeps the world fragmented but has to manage more active threats.

### 3.3 Entry Points
Your horde emerges from a thematic entry point that varies per campaign:
- **Volcanic Rift** — Fire-themed, boosts fire demons
- **Abyssal Crack** — Shadow-themed, boosts stealth demons
- **Corrupted Swamp** — Poison-themed, boosts toxic demons
- **Meteor Crater** — Chaos-themed, no bonuses but higher starting resources

Entry points can be upgraded between raids (expand the pit, deepen the rift, etc.), serving as your de facto base.

---

## 4. Factions

### 4.1 Modular Design Philosophy
Both the **player faction** (attackers) and **enemy faction** (defenders) are modular and swappable. The core systems (squad management, breeding, combat) work with any faction plugged in. A faction defines:

- Unit roster (types, tiers, stats, abilities)
- Visual theme / art
- Breeding/evolution rules
- Faction-specific mechanics
- Flavor text / personality

### 4.2 Player Factions (Attacker)

**Launch Faction: Demons**
- Chaotic, fire-and-brimstone aesthetic
- Breeding through dark rituals, soul infusion, corruption
- Faction mechanic: **Chaos Meter** — as combat gets more chaotic, demons get stronger (but less controllable)

**Future Factions (Post-Launch):**
- **Lizardfolk** — Cold-blooded and tactical. Breeding through eggs/clutches. Faction mechanic: ambush bonuses
- **Spore Collective** — Fungal horror. "Breeding" through infection/spreading. Faction mechanic: units leave spore clouds on death
- **Undead Legion** — Raise the fallen. "Breeding" by converting enemy dead. Faction mechanic: armies grow mid-battle

### 4.3 Enemy Factions (Defender)

**Launch Faction: Human Kingdom**
- Classic medieval fantasy humans
- Unit types: peasant militia, town guard, knights, archers, mages, heroes
- Behavior: recruit, fortify, call for aid, summon heroes at high awareness

**Future Factions:**
- **Dwarven Holds** — Extreme fortification, tunnel networks, siege-resistant
- **Elven Enclaves** — Magic barriers, nature allies, guerrilla tactics
- **Holy Order** — Paladins, clerics, demon-specific counters, exorcism mechanics

---

## 5. Demon Roster & Tiers

### 5.1 Unit Tiers

| Tier | Name | Role | Squad Size | Examples |
|---|---|---|---|---|
| **T1** | **Swarmlings** | Expendable mass, screens, distractions | 10-50 per squad | Imps, Gribbles, Mites, Skitterlings |
| **T2** | **Brutes** | Reliable mid-tier, backbone of your force | 3-12 per squad | Hellhounds, Flame Ogres, Shadow Stalkers |
| **T3** | **Behemoths** | Rare powerhouses, army centerpieces | 1-3 per squad | Pit Fiends, Balor-types, Corrupted Wyrms |

### 5.2 Army Composition Freedom
The player is NEVER forced into a "balanced" army. Every composition is valid, every composition has counters:

| Strategy | Strengths | Vulnerabilities |
|---|---|---|
| **Swarm Flood** (all T1) | Overwhelms weak defenses, cheap, expendable | AoE abilities, morale-based attacks, large-squad-targeting bonuses |
| **Elite Strike** (all T3) | Raw power, hard to kill | High single-target damage, attrition, outnumbered penalties |
| **Balanced Horde** | Flexible, adaptable | No extreme strengths, jack of all trades |
| **Screen & Strike** (T1 guards + T2/T3 core) | Best of both worlds, guard system synergy | Requires more tactical skill, vulnerable if screen collapses |

### 5.3 Demon Personalities
Every demon has a randomly assigned personality trait that affects behavior in combat:

- **Pyromaniac** — Bonus fire damage, but may set adjacent friendly units on fire
- **Coward** — Flees when squad drops below 50%, but bonus speed when retreating
- **Greedy** — Prioritizes loot objectives over combat orders, but bonus resource yield
- **Berserker** — Ignores guard orders to charge, but bonus melee damage
- **Loyal** — Always follows orders. Boring but reliable. (The rarest trait)

Personalities aren't good or bad — they're trade-offs. A squad of Pyromaniac imps screening for a fire-immune Behemoth is a *feature*, not a bug.

---

## 6. Breeding & Evolution

### 6.1 Philosophy
"Let people make what they want." The breeding system is a sandbox. Players should be able to theory-craft, experiment, and discover broken combos. If someone finds a degenerate strategy, that's a *reward* for creativity, not a problem to patch.

### 6.2 Resources

| Resource | Source | Used For |
|---|---|---|
| **Captives** | Raiding settlements | Breeding fuel. Corrupt captives into new demons or sacrifice them for souls. |
| **Souls** | Combat kills, sacrificing captives | Evolution currency. Spend souls to mutate, upgrade, or fuse demons. |
| **Corruption** | Passive gain from occupied/salted territory | Unlocking higher-tier breeding options, entry point upgrades, demon lord progression. |

### 6.3 Breeding Mechanics
- **Dark Ritual** — Combine two demons + captives to produce offspring. Offspring inherits traits from parents with random mutations.
- **Soul Infusion** — Spend souls to force a specific mutation or stat boost on an existing demon.
- **Fusion** — Sacrifice multiple demons to create a higher-tier unit. Three Swarmlings might fuse into a Brute. Three Brutes might create a Behemoth. Traits carry over unpredictably.
- **Corruption Breeding** — At high corruption levels, new breeding options unlock. Corrupted variants of existing types, hybrid forms, abominations.

### 6.4 Permadeath & Templates
Demons die permanently. When a demon falls in combat, it's gone — including all its evolution, mutations, and traits. This gives every battle real weight and makes breeding decisions matter.

**But you remember.**

You are an ancient force. When you create something noteworthy, you can save its configuration as a **Template** — a blueprint of the demon's species, evolution path, and mutation loadout.

- **Saving a Template** — Any demon can be "recorded" as a template at no cost. This captures: base type, evolution stage, mutation list, and personality type
- **Rebuilding from Template** — Costs the same resources as creating that demon from scratch (captives, souls, evolution costs). You skip the experimentation, not the investment
- **Templates don't save stats** — A rebuilt demon starts at base stats for its type/evolution. It's the same *design*, not a clone with veteran experience
- **Template Library** — Your collection of templates persists across the entire campaign. Name them, organize them, build your own bestiary of proven designs
- **Sharing potential** — Templates could be exported/imported, letting players share their best creations (future feature)

This creates a clean cycle: experiment freely → find something great → template it → lose it in battle → rebuild it (at cost) without re-discovering the recipe. The *knowledge* is permanent, the *demons* are not.

### 6.4 Evolution Paths
Demons can evolve along branching paths. Example for a basic Imp:

```
           Imp
          /   \
     Fire Imp   Shadow Imp
      /    \        \
Inferno    Bomb Imp  Assassin Imp
Imp        (explodes   (stealth,
(sustained  on death)   backstab)
 damage)
```

Players choose the path. Every path is viable. The "best" path depends on your army composition and strategy.

---

## 7. Combat System

### 7.1 Overview
Turn-based tactical combat on a grid. You deploy squads, give orders, and watch the chaos unfold. Combat is squad-vs-squad, not individual unit targeting.

### 7.2 Squad Mechanics
- A **squad** is a group of same-type demons acting as one unit
- Squad has aggregate stats: total HP (sum of members), attack power (scales with count), abilities
- As members die, the squad weakens — a 50-imp squad at half strength hits half as hard
- Squad size is a visible, meaningful number — not abstracted away

### 7.3 Damage & Targeting

| Attack Type | Behavior |
|---|---|
| **Single-Target** | Full damage to one squad. Strong vs small elite squads. Weak vs swarms (overkill waste). |
| **Cleave / AoE** | Damage split across squad members. Strong vs large squads. Weak vs single behemoths. |
| **Anti-Horde** | Bonus damage based on target squad size. The counter to swarm strategies. |
| **Precision** | Bonus damage vs squads with fewer members. The counter to elite strategies. |

### 7.4 The Guard System
Squads can be assigned to **guard** other squads. Guarding creates a tactical relationship:

- **Melee Interception** — When the guarded squad is attacked in melee, the guard squad intercepts, taking the hit instead (or splitting damage)
- **Standoff Maintenance** — Guard squads keep enemies at bay so the guarded squad can operate freely (ranged attacks, abilities, positioning)
- **Screen Collapse** — If the guard squad is destroyed or routed, the guarded squad is exposed. Smart enemies will target guard squads first

**Design intent:** This system naturally encourages mixed armies. Surround your elite Behemoth with trash mob guards so it can strike without getting mobbed. Use Brute guards to screen your fragile ranged Swarmlings. The player discovers optimal guard chains through experimentation.

### 7.5 Terrain & Positioning
- Grid-based battlefield with terrain features (walls, rubble, fire, water, chokepoints)
- Terrain comes from the settlement type — raiding a village has open fields, a city has streets and walls
- Demons can interact with terrain — fire demons ignite things, shadow demons use darkness, brutes smash walls
- Positioning matters: flanking bonuses, high ground, chokepoint control

### 7.6 The Chaos Factor
Combat isn't perfectly orderly. Demon personalities inject unpredictability:
- A Pyromaniac squad might set a building on fire, creating a terrain hazard for BOTH sides
- A Coward squad might flee before you wanted them to
- A Greedy squad might break formation to loot a supply cache
- This is a *feature* — the player is managing chaos, not executing a chess game

---

## 8. Enemy AI & Defender Behavior

### 8.1 Settlement Defense
Each settlement has a standing defense that scales with its stats:
- **Militia** — Weak but numerous. The first thing you fight
- **Guards** — Professional soldiers. Better equipped, hold formation
- **Fortifications** — Walls, towers, gates. Must be breached or bypassed
- **Heroes** — Named characters with unique abilities. Appear at high awareness levels. These are mini-bosses

### 8.2 Kingdom Response
As awareness of your horde grows, the kingdom reacts:

| Awareness Level | Kingdom Response |
|---|---|
| **Unaware** | No coordination. Settlements defend alone. Easy pickings. |
| **Rumors** | Nearby settlements increase patrols. Slightly harder raids. |
| **Alert** | Settlements share resources and reinforcements. Heroes begin appearing. |
| **War Footing** | Organized military response. Counter-raids on your occupied territory. Crusade armies form. |
| **Desperate** | All-out defense. United front. Last stands. The kingdom throws everything at you. |

### 8.3 Recovery Mechanics
Settlements that survive a raid (or are left standing) recover over time:
- **Population regrows** (slowly)
- **Militia re-musters** (moderate speed)
- **Fortifications rebuild** (slowly, but stronger than before — they learn)
- **Morale recovers** (quickly if you leave them alone, slowly if you keep harassing)
- **Veteran bonus** — Survivors of previous raids fight harder. A town you've hit three times has battle-hardened defenders

---

## 9. Progression & Win Condition

### 9.1 Campaign Arc
The game follows a natural escalation:

1. **Early Game** — Emerge with a small horde. Raid hamlets and villages. Build up resources. Learn the systems.
2. **Mid Game** — Your horde grows. Target towns and small cities. The kingdom starts organizing. Strategic choices (salt vs occupy) matter more.
3. **Late Game** — Major cities and fortresses. Heroes and crusade armies. Your breeding/evolution pays off. Strategic map is heavily contested.
4. **Endgame** — Assault the capital OR awaken the Demon Lord.

### 9.2 Win Conditions

**Standard Victory: Conquest**
Destroy or subjugate every settlement on the map. The hard way. Requires careful strategic planning, managing consolidation, and building a horde strong enough to crack the capital.

**Accelerated Victory: Manifestation**
You are a formless will directing the horde from beyond. But as corruption accumulates, you grow closer to *having a body*. This is your awakening — not summoning something else, but *becoming physical*.

| Stage | Corruption Required | Effect |
|---|---|---|
| **Stirring** | 25% | Passive buffs to all demons. You feel the world more clearly. Minor earthquake flavor events. |
| **Rumbling** | 50% | New T3 breeding options unlock. Your presence bleeds into the physical world — terrain near your entry point corrupts. Kingdom gets a massive awareness spike. |
| **Rising** | 75% | You can project power onto the battlefield — targeted abilities (corruption blasts, fear waves) usable once per combat. Kingdom enters Desperate mode. |
| **Manifested** | 100% | You take physical form. A controllable mega-unit enters the field. The capital battle becomes dramatically easier — but if your manifestation is destroyed, you are banished back to formlessness. Corruption resets to 50%. You must rebuild. |

The manifestation path is faster but triggers the kingdom's strongest response. It's a gamble — rush corruption and face a united, desperate kingdom with your own godlike body on the line, or grind them down slowly with conventional forces. And if you manifest and *lose*, you're set back hard — not game over, but a devastating setback that changes the campaign.

---

## 10. Technical Architecture (Godot 4.x)

### 10.1 Scene Tree Philosophy
Godot's scene tree maps directly to the game's modular design:

```
Game
├── WorldMap (strategic layer)
│   ├── Settlement (instanced per location)
│   ├── Path (connections between settlements)
│   └── EntryPoint (player's base)
├── Combat (tactical layer)
│   ├── BattleGrid
│   ├── PlayerSquads[]
│   │   └── Squad (contains unit data, guard assignments)
│   └── EnemySquads[]
├── HordeManager (management layer)
│   ├── Roster
│   ├── BreedingLab
│   └── EvolutionTree
└── UI
    ├── WorldMapUI
    ├── CombatUI
    ├── RosterUI
    └── BreedingUI
```

### 10.2 Modular Faction System
Factions are defined as **Resources** (Godot Resource files):
- `FactionData` — defines unit roster, breeding rules, visual theme
- `UnitData` — defines stats, abilities, evolution paths, personality pool
- `SettlementData` — defines defender composition, recovery rates, fortification types

Swapping factions = swapping resource files. The core systems don't change.

### 10.3 Key Systems

| System | Responsibility |
|---|---|
| **WorldMapManager** | Settlement states, awareness tracking, recovery ticks, strategic AI |
| **CombatManager** | Turn order, damage resolution, guard system, terrain effects |
| **HordeManager** | Roster tracking, breeding/evolution, squad assignment |
| **FactionLoader** | Loads faction resources, validates unit data, handles modding |
| **SaveSystem** | Campaign state serialization. World state + horde state + progression |

### 10.4 Data-Driven Design
Stats, abilities, evolution trees, and settlement data should be defined in **resource files or JSON**, not hardcoded. This supports:
- Easy balancing (tweak numbers without touching code)
- Modular factions (add new factions by adding data files)
- Future modding support

---

## 11. Development Phases

### Phase 1: Core Skeleton
- Godot project setup
- Basic squad data structures (unit, squad, roster)
- Simple grid-based combat prototype (two squads fight)
- Damage types working (single-target vs AoE)
- Turn system

### Phase 2: Squad Depth
- Guard system implementation
- Squad size affecting stats
- Personality traits (at least 3)
- Basic AI for enemy squads

### Phase 3: World Map
- Strategic map with settlements
- Settlement stats and recovery
- Raid → combat → results flow
- Salt/occupy/leave decision

### Phase 4: Breeding & Evolution
- Resource system (captives, souls, corruption)
- Basic breeding (combine two demons)
- Evolution paths (at least one full tree)
- Soul infusion upgrades

### Phase 5: Campaign Flow
- Awareness system
- Kingdom response escalation
- Hero system (named mini-bosses)
- Win conditions (conquest + demon lord)

### Phase 6: Polish & Content
- Full demon roster
- Human faction complete
- Entry point theming
- UI polish
- Balance pass

---

## 12. Open Questions

These need answers during development, not now:

1. ~~**Permadeath?**~~ — **ANSWERED: Yes.** Permadeath with a Template system to preserve demon blueprints. The demon dies, the recipe lives.
2. **Campaign length** — How many raids to win? 20? 50? Adjustable difficulty?
3. **Multiple entry points?** — Can you open a second hell rift to attack from two fronts?
4. ~~**Demon Lord as faction leader?**~~ — **ANSWERED: You ARE the force.** Formless will that manifests physically at 100% corruption. Destruction = banishment + corruption reset to 50%.
5. **Sound/Music direction** — Metal? Orchestral? Chiptune? Something weird?
6. **Multiplayer potential** — PvP horde-vs-horde? Co-op raids? Or strictly single-player?
7. **Modding support** — How deep? Just data files, or full mod API?

---

*Document Version: 0.1 — Initial Draft*
*Last Updated: 2026-03-13*
