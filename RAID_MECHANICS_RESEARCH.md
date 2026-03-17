# Raid Mechanics Research — Attacking Defended Settlements

Research organized by **mechanical problem**, not by game. Every section addresses a specific design question from Demon Horde's perspective: you are the attacker, the horde, the chaos. How does raiding feel like a *puzzle* rather than a stat check?

---

## 1. The Core Problem: Assault as Puzzle, Not "Bring More Troops"

### What makes attacking a defended position tactically interesting?

The worst version of siege gameplay is "accumulate enough force, then overwhelm." The best version treats every defended position as a **spatial puzzle with multiple valid solutions**.

**Into the Breach** is the gold standard for "combat as puzzle." Every turn, enemy attacks are telegraphed — the puzzle is manipulating the board so those attacks miss, hit each other, or become irrelevant. The attacker (player) has **perfect information** about what happens next, but **limited actions** to reshape the outcome. The constraint isn't strength — it's action economy and positioning.

**Rainbow Six Siege** treats attack as a **preparation + execution** puzzle. Attackers get a drone phase (intelligence gathering) before the assault. The puzzle isn't "can I kill them?" — it's "WHERE do I breach, in what ORDER, and how do I deny the defenders their prepared advantages?" Environmental destruction means the map itself is a variable — walls can become doors, floors become kill holes, ceilings become entry points.

**Total War: Warhammer III's siege rework** added capture points, barricades, and a supply mechanic. Defenders spend supply to build barricades and towers; attackers must choose WHERE to concentrate pressure. Breaking walls in multiple distant locations forces the defender to split — the puzzle is reading the defense's shape and finding the seams. But community criticism showed this still devolved into stat-checks when the AI couldn't react intelligently.

### Design Implications for Demon Horde

The GDD already has the right ingredients: terrain from settlement type, demon abilities that interact with environment (fire demons ignite, shadow demons use darkness, brutes smash walls). The missing mechanical piece is **what constrains the attacker**. Without constraints, puzzles don't exist.

**Key insight:** The puzzle isn't in what the attacker CAN do — it's in what they CAN'T do all at once. Action economy, deployment limits, and terrain channeling create the constraint space. The defender's layout is the puzzle; the attacker's tools are the solution set.

---

## 2. Breach Points, Flanking, Infiltration: How Approach Routes Create Choices

### The problem: How do you make WHERE you attack matter as much as WHAT you attack with?

**Total War sieges** let attackers create breaches by destroying wall sections. Multiple breaches force defenders to spread thin. The best moments come from creating a diversionary breach (drawing defenders) then launching the real assault elsewhere. But this requires the defender AI to actually react to threats believably.

**Shadow of War fortress assaults** offer the richest approach-choice system studied. Before attacking a fortress, the player:
- **Gathers intelligence** on the Overlord's weaknesses (beast fodder? afraid of fire? vulnerable to stealth?)
- **Plants spy captains** inside the fortress who betray during the assault (opening gates, capturing points, assassinating warchiefs from within)
- **Chooses assault leaders and their reinforcements**: Sappers (breach gates), Mounted Cavalry (fast capture), Olog-Hai (brute force), Siege Beasts (artillery), Caragors/Graugs (beast assault), or Spider Brood (area denial)
- **Counters specific fortress upgrades**: Iron Gates need Sappers; Reinforced Walls need War Graugs; Poison Mines need ranged-heavy assault leaders; Fire Spouts need frost-resistant troops

This creates a **rock-paper-scissors layer on top of the assault**: the fortress has a defensive configuration, and the attacker's preparation choices determine how hard or easy each phase of the breach will be. The puzzle is in the PREPARATION, not just the execution.

**Rainbow Six Siege** takes this further with environmental destruction as the core mechanic. There is no pre-set "breach point" — the attacker CREATES breach points by destroying walls, floors, and ceilings. Every surface is a potential entry. The puzzle is choosing which surfaces to destroy (and in what order) to create advantageous sight lines and entry angles that the defender can't cover simultaneously.

### Design Implications for Demon Horde

Demon Horde's settlement types should present different **approach puzzles**:
- **Villages**: Open terrain, multiple approach vectors, but defenders can SEE you coming. The puzzle is speed and overwhelming before militia consolidates.
- **Towns**: Streets and buildings create chokepoints. The puzzle is WHICH street to push through, and whether to smash through buildings (brutes) or go around (flanking).
- **Cities**: Walls create a mandatory breach-or-bypass decision. Breach points could be: smash the gate (loud, concentrated), collapse a wall section (requires siege capability), infiltrate via sewers (stealth demons only, bypasses walls but emerges inside with no support), or fly over (if you have flying units, but towers target flyers).
- **Fortresses**: Multi-layered defenses. You must solve the outer ring before reaching the inner ring. Each layer is its own sub-puzzle.

The key design principle from Shadow of War: **make preparation (squad selection, approach choice) a first-class strategic decision that happens BEFORE the tactical battle, not during it.**

---

## 3. Settlement Types as Mechanically Different Battles

### The problem: How do you make raiding a village feel fundamentally different from raiding a city — not just "harder"?

**Total War: Warhammer III** differentiates settlement battles by map layout. Minor settlements are street fights without walls; major settlements have multi-tier defenses with walls, barricades, and capture points. The mechanical difference: minor settlements are about maneuvering through streets and chokepoints; major settlements are about breaching defenses and then fighting through streets. Different terrain, different puzzle.

**Advance Wars / Wargroove** use terrain defense values — forests give 30% damage reduction, mountains give more, roads give none. Unit positioning relative to terrain IS the game. A chokepoint defended by units in forests is fundamentally different from an open-field engagement. Defense scales with health (a damaged unit gets less terrain benefit), creating a "crack the shell" dynamic.

**Evil Genius** differentiates by making different rooms serve different functions during raids. When agents infiltrate your base, they must navigate through layers: entrance hall (distraction), trap corridors (attrition), barracks (guard response), and finally the inner sanctum. Different base layouts create different infiltration puzzles.

### Settlement Differentiation Framework

The mechanical axis should NOT be "more HP on walls" — it should be **what tactical verbs does the settlement force you to use?**

| Settlement Type | Primary Tactical Verb | Puzzle Shape | Terrain Character |
|---|---|---|---|
| **Hamlet** | Overwhelm | Speed puzzle — strike before anyone escapes to warn neighbors | Open fields, maybe a fence. One or two buildings. |
| **Village** | Surround | Positioning puzzle — militia clumps around town square, flanking dissolves them | Scattered buildings, hedgerows, a central gathering point |
| **Town** | Breach & Push | Chokepoint puzzle — walls/buildings create lanes, you choose which lanes | Streets, alleys, barricades, a gatehouse |
| **City** | Multi-stage Assault | Layered puzzle — outer walls, inner districts, keep/citadel | Walls, towers, districts with different terrain, a central fortress |
| **Fortress** | Siege | Preparation puzzle — you can't just assault, you need the right tools and plan | Thick walls, killing fields, narrow approaches, elevated defenses |

Each type should demand different **army compositions** to solve efficiently. A swarm flood that trivializes hamlets gets shredded in city chokepoints by AoE defenders. An elite strike force that cracks fortresses wastes resources on hamlets (overkill). This naturally feeds back into the breeding/evolution system — you're building your horde to solve specific tactical problems.

---

## 4. The "Living World Fights Back" Problem

### How does escalating enemy response create interesting strategic pressure without just being a difficulty slider?

**XCOM 2's Dark Events** system is the best example of "the enemy plays the game alongside you." Each month, the aliens advance 2-3 Dark Events — persistent buffs to alien forces (armored enemies, reduced intel, retaliatory strikes). The player can counter ONE of them by sending a team on a mission — but can't stop all of them. This creates a **triage decision**: which escalation is most dangerous to you RIGHT NOW?

The Avatar Project adds a doom clock — a visible progress bar toward alien victory. The player must periodically knock it back by attacking specific facilities. This creates strategic oscillation: you can't just optimize your own growth, you must periodically react to the enemy's progress.

**Shadow of War's Nemesis system** makes escalation PERSONAL. Orcs that kill you get promoted, gain new abilities, and remember you. A fortress you failed to take has defenders who are now STRONGER because of your failure, AND they taunt you about it. The world doesn't just get generically harder — it gets harder in ways that reflect YOUR specific failures.

**They Are Billions** escalates through timed waves of increasing size and composition. Each wave approaches from a different direction, and a single zombie breaching your walls can cascade into a chain infection that destroys your entire base from within. The escalation isn't just "more enemies" — it's "the consequences of a single failure are catastrophic."

### Design Implications for Demon Horde

The GDD's awareness system (Unaware -> Rumors -> Alert -> War Footing -> Desperate) is a good skeleton, but needs MECHANICAL teeth. Each level shouldn't just add "more stats" — it should change WHAT the defenders do:

| Awareness Level | Mechanical Change (not just stat boost) |
|---|---|
| **Unaware** | Defenders are scattered, no formation, gates open, no patrols. You fight individuals. |
| **Rumors** | Defenders clump at chokepoints. Patrols appear on roads between settlements. Militia drills (slightly better formation). |
| **Alert** | Settlements share resources — raiding one might trigger reinforcements from neighbors mid-battle. Heroes begin appearing as mini-boss defenders. Fortification construction accelerates. |
| **War Footing** | Counter-raids on your occupied territory. Crusade armies form (mobile enemy forces that hunt you on the world map). Settlements start building ANTI-DEMON fortifications (fire-resistant walls vs fire horde, blessed ground vs shadow demons). |
| **Desperate** | United front. Settlements contribute forces to a single massive army. Last-stand bonuses (defenders fight to the death, no routing). The kingdom may make devil's bargains (summoning their own dark forces, hiring mercenaries, scorched earth of their own territory to deny you resources). |

The key from XCOM 2: **let the player partially counter the escalation.** If you can raid supply lines, you can delay fortification construction. If you can assassinate a hero before they reach a settlement, you remove that threat. The world escalates, but you have TOOLS to shape how it escalates. The strategic layer becomes a puzzle about managing the kingdom's response, not just reacting to it.

---

## 5. Consolidation: When Destruction Makes Things Harder

### How do refugees strengthening neighbors create interesting strategic pressure?

This is one of Demon Horde's most distinctive design ideas, and it has few direct parallels in existing games. The closest analogues:

**Civilization's razing mechanic** permanently removes a city from the game. In Civ VII, each razed settlement generates permanent war support against you with every opponent. The diplomatic cost is permanent and cumulative. But Civ doesn't have refugees mechanically flowing to neighboring cities — the consequences are abstract (penalties), not spatial (stronger neighbors).

**They Are Billions** (inverted perspective): when a section of your colony falls to zombies, the infected buildings spawn MORE zombies who cascade into neighboring sections. Destruction breeds MORE threat in adjacent areas. This is mechanically similar to consolidation — losing one area makes defending adjacent areas harder.

**Historical strategy** (Crusader Kings, Europa Universalis): refugees and displaced populations sometimes boost development in neighboring provinces, but this is usually a minor modifier, not a core strategic tension.

### What makes consolidation mechanically interesting (not just punishing)?

Consolidation creates a **strategic optimization puzzle**: the order in which you destroy settlements matters as much as whether you destroy them.

Consider a map with settlements A, B, C, D in a cluster:
- Salt A first: B, C, D all get refugees. Now you face three slightly harder fights.
- Salt A and B: C and D absorb TWO waves of refugees. They're significantly harder.
- Salt A, B, and C: D absorbs everything. It's now a fortress.
- OR: Don't salt any of them. Re-raid repeatedly, keeping them fragmented and weak but alive.

The interesting decision emerges when consolidation effects are VISIBLE AND PREDICTABLE. The player should be able to see: "If I salt this village, these neighbors will absorb X population and gain Y militia." Then the decision becomes a genuine strategic calculation, not a surprise punishment.

**Additional consolidation mechanics to consider:**
- **Refugee skills transfer**: A town that absorbs refugees from a military fortress gains veteran defenders. A town that absorbs farming village refugees gains food production (faster recovery). The TYPE of settlement destroyed affects HOW its neighbors strengthen.
- **Overcrowding negatives**: A settlement that absorbs too many refugees might suffer morale penalties, food shortages, or internal unrest — creating a WINDOW of opportunity for the attacker.
- **Refugee caravans as targets**: Refugees don't teleport — they travel along roads. Intercepting refugee columns is a morally interesting (and strategically valuable) choice. Do you let them reach the next town (which strengthens it) or do you hit the column (which is easy but provides less loot and spikes awareness)?

---

## 6. Multi-Battle Campaign: World State Between Raids Creates Emergent Strategy

### How does the state of the world between battles create a campaign-level puzzle?

**FTL: Faster Than Light** creates campaign-level strategy through resource scarcity and meaningful event choices. Between fights, every decision (which system to upgrade, which crew to recruit, which beacon to visit) has long-term consequences. The fleet pursuing you creates time pressure — you can't grind every sector clean. You must make trade-offs and commit to a build path.

**Slay the Spire** creates emergent strategy through MAP PATHING. The player sees the full map of a floor and chooses a path through it: fight elites (harder but better rewards), visit merchants (spend resources), rest (heal but miss opportunities), or take normal fights (moderate risk/reward). The path IS the strategy — choosing which order to face challenges based on your current state.

**Darkest Dungeon** creates campaign strategy through its town/roster management layer. Heroes accumulate stress and afflictions; the town needs upgrades; resources are scarce. The player must balance SHORT-TERM (which dungeon to run this week) against LONG-TERM (which town buildings to upgrade, which heroes to invest in). The base is the persistent strategic asset; heroes are expendable resources.

### Design Implications for Demon Horde

The GDD's core loop (Emerge -> Prepare -> Raid -> Reap -> Evolve) already has the right structure. The campaign-level puzzle should emerge from:

1. **Target selection as strategic choice**: The world map should present multiple valid raid targets each turn, each offering different risk/reward profiles. "Do I hit the weak hamlet for easy captives, or assault the town that's been building fortifications before it finishes?" Target selection IS the strategic game.

2. **Horde state persistence**: Squads that fought in the last raid are damaged, depleted, possibly with dead members. Do you send your veterans (experienced but wounded) or your fresh reserves (full strength but untested)? Permadeath means every battle has long-term consequences for your roster.

3. **World state evolution**: Between your raids, settlements recover, fortify, and coordinate. The map CHANGES whether you act on it or not. Waiting has a cost (settlements rebuild), but rushing has a cost (your horde is depleted). This temporal pressure is critical.

4. **Information as resource**: You shouldn't have perfect information about all settlements. Scouting (sending imps to observe) should reveal settlement defenses, garrison composition, and fortification status. Acting without intelligence is riskier. This makes "where to raid" a decision under uncertainty, which is more interesting than a decision with perfect information.

---

## 7. Permanent Consequence Decisions: Salt the Earth and Beyond

### How do irreversible choices create strategic depth?

**Civilization's raze/keep decision** has clear permanent consequences: razed cities are gone forever along with their wonders and improvements. But the decision is usually obvious (raze poorly-placed cities, keep good ones). The interesting version of this decision requires TENSION — both options must be appealing AND costly.

**Darkest Dungeon's permadeath** creates permanent consequences at the unit level. Every hero you lose is gone with their skills, equipment, and investment. But the ROSTER replenishes — new heroes arrive at the stagecoach. The loss is real but not campaign-ending. This creates a healthy relationship with loss: it hurts, but you can recover.

**FTL's event choices** often present permanent consequences: "save the civilian ship (get a crew member but take damage) or let it burn (stay safe but lose the opportunity)." These work because they're FAST — you make the decision, see the consequence, and move on. The weight accumulates over dozens of small choices, not one big one.

**XCOM 2's Retaliation Missions** threaten permanent loss of a region if you fail or skip them. Losing a region means losing its monthly income and soldier bonuses PERMANENTLY. The decision "can I afford to skip this retaliation mission?" has real long-term weight.

### Design Implications for Demon Horde

The Salt/Occupy/Leave decision is the GDD's marquee permanent choice. For it to create real strategic tension:

**Salt the Earth must be TEMPTING:**
- Massive one-time resource payout (captives, souls, corruption spike)
- Permanently removes a recovery threat (you never have to re-raid this target)
- Territorial denial — the kingdom can't use this location either
- Emotional satisfaction (you're the horde; destruction is your thing)

**Salt the Earth must be COSTLY:**
- Consolidation (refugees strengthen neighbors — visible, predictable, significant)
- Awareness spike (the kingdom's response escalates faster)
- Resource loss (a salted settlement can never be raided again — you lose a renewable resource)
- Potential story consequences (salting a temple triggers a holy crusade; salting a marketplace denies you future trading opportunities)

**Occupy must offer a DIFFERENT trade-off:**
- Passive resource income (captives per turn, corruption generation)
- Forward operating base (deploy squads closer to targets)
- BUT: ties up a squad as garrison; enemies will attack to reclaim it; you must defend what you hold
- Creates a "supply line" vulnerability — occupied settlements far from your entry point are harder to reinforce

**Leave must be VIABLE:**
- Lets you re-raid for renewable resources
- Keeps the world fragmented (many weak targets vs. few strong ones)
- Lower awareness increase
- BUT: settlements recover and learn, making re-raids progressively harder (veteran defenders, rebuilt fortifications)

The best permanent decisions have **no correct answer** — only trade-offs relative to your current situation and strategy.

---

## 8. Siege Equipment, Preparation, and the Intelligence Game

### How does pre-battle preparation create meaningful choices?

**Shadow of War** has the richest pre-battle preparation system studied. Before assaulting a fortress:
1. **Intel phase**: Interrogate worms/captains to reveal the Overlord's weaknesses, warchief abilities, and fortress upgrades
2. **Subversion phase**: Turn enemy captains into spies who will betray during the assault
3. **Force composition**: Choose assault leaders and their specific reinforcement types to counter the fortress's defenses
4. **Upgrade selection**: Pick siege upgrades (Sappers vs. Cavalry vs. Beasts vs. Siege Towers) based on fortress configuration

This turns the fortress assault into a **two-phase puzzle**: first solve the preparation puzzle (what do I need to bring?), then solve the execution puzzle (how do I deploy what I brought?). Preparation that's done well makes execution dramatically easier — but preparation costs time and resources.

**XCOM 2** applies this at a smaller scale: choosing your squad loadout (which soldiers, which equipment, which abilities) based on the mission type and expected enemy composition. Bringing a sniper to a close-quarters mission is a preparation mistake that makes the tactical puzzle much harder.

### Design Implications for Demon Horde

**Pre-raid intelligence:**
- Send scout imps to observe a settlement before raiding. They can reveal: garrison composition, fortification type, terrain layout, notable defenders (heroes), and traps/hazards.
- Scouting costs a turn and risks detection (awareness increase if scouts are caught). Raiding blind is always an option — but you might walk into a prepared defense.
- Partial intelligence is more interesting than full intelligence. You might learn "the town has walls and archers" but not know about the hero hiding in the keep.

**Squad selection as preparation puzzle:**
- The player chooses which squads to deploy AFTER seeing available intelligence. "They have walls? Bring brutes to smash them. They have archers? Bring fire imps for smoke cover. They have a hero? Bring your best behemoth."
- Limited deployment slots force trade-offs. You can't bring everything. What do you leave behind?
- Pre-raid abilities: certain demons might have abilities usable BEFORE combat begins (sappers who pre-damage walls, infiltrators who open gates from inside, scouts who reveal traps).

**Approach selection:**
- Choose your approach vector on a zoomed-in pre-battle map. Attack from the north (open field, fast approach, no cover) or the east (forest, slow approach, concealed until close)?
- Different approach vectors change the starting positions and available terrain, making the same settlement a different tactical puzzle depending on how you approach it.

---

## 9. Chaos as Mechanical Feature: Uncontrollability as Design Space

### How do games make unpredictability a feature rather than frustration?

**Shadow of War's Nemesis system** embraces chaos through emergent betrayals, rivalries, and ambushes. Your carefully planned fortress assault might be disrupted by an orc captain who's secretly terrified of spiders — he flees when your Spider Brood siege upgrade deploys, collapsing a section of the defense you didn't plan for. Chaos creates STORIES.

**Darkest Dungeon** makes the party itself unreliable. Stressed heroes develop afflictions that override player commands — an Abusive hero insults allies (debuffing them), a Masochistic hero hurts themselves, a Fearful hero refuses to act. The player must manage the team's mental state alongside the tactical situation.

**The GDD's personality system** (Pyromaniac, Coward, Greedy, Berserker, Loyal) is already designed for this. The design challenge is making chaos MANAGEABLE — not controllable, but influenceable.

### Design Implications for Demon Horde

Chaos should create **opportunities and setbacks** — never just setbacks.

- A **Pyromaniac** squad setting a building on fire is bad if your troops are inside, but great if it's a building full of enemy archers.
- A **Greedy** squad breaking formation to loot a supply cache is bad mid-battle, but the loot might contain something valuable enough to justify the risk.
- A **Berserker** squad charging when you wanted them to hold is bad for your plan, but their charge bonus damage might crack a chokepoint you were struggling with.

The player's skill is in POSITIONING chaos — putting units where their uncontrollable tendencies will likely produce good outcomes. A Pyromaniac squad is a liability in a wooden village you want to loot intact, but an asset against a stone fortress where fire can't spread to things you care about.

---

## 10. Summary: The Five Pillars of Interesting Raid Design

Based on all research, the mechanical pillars that make raiding interesting for the ATTACKER are:

### Pillar 1: The Approach Puzzle
Every raid should begin with a choice of HOW to approach. Direction, deployment, timing. This choice should be informed by (possibly incomplete) intelligence and should meaningfully change the tactical situation.

### Pillar 2: The Constraint Space
The player must have MORE capabilities than they can deploy simultaneously. Limited deployment slots, action economy, and terrain channeling create the puzzle. "I could smash through the gate OR sneak through the sewers OR fly over the walls — but I can't do all three at once, and each has trade-offs."

### Pillar 3: The Preparation-Execution Loop
The strategic decisions made BEFORE combat (squad composition, approach vector, intelligence gathering) should have visible, consequential effects DURING combat. Good preparation should make the puzzle easier — but never trivial.

### Pillar 4: The Permanent Consequence
Every raid should force at least one irreversible decision. Salt/Occupy/Leave is the big one, but smaller permanent consequences (demons died, settlement learned your tactics, awareness increased) create campaign-level weight.

### Pillar 5: The World Reacts
The kingdom is not a passive target list. It responds, adapts, and escalates — but in ways the player can partially predict, partially counter, and must factor into their strategic planning. The best raids are ones where the player is solving not just "how do I take this settlement?" but "how does taking this settlement affect every future raid?"

---

*Research compiled for Demon Horde GDD mechanical design. Sources include analysis of: Total War: Warhammer III siege system, Shadow of Mordor/War Nemesis and Fortress systems, Into the Breach puzzle combat, Rainbow Six Siege environmental destruction, XCOM 2 strategic layer, FTL campaign structure, Slay the Spire map pathing, Darkest Dungeon permadeath/town management, They Are Billions cascade mechanics, Evil Genius base infiltration, Advance Wars/Wargroove terrain defense, and Civilization razing consequences.*
