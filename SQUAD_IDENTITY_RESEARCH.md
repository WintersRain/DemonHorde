# Squad Identity & Horde Management Research

Research into how games make squads feel like *groups with identity* rather than single units with big HP bars, and how controlling multiple squads can feel like "managing chaos" rather than tedious micro.

---

## 1. How Squad SIZE Matters Mechanically (Beyond "More HP")

The GDD says a 50-imp squad should feel different from a 5-brute squad. The question is: what mechanics make count matter beyond raw stats?

### Linear Degradation (Total War)

Total War's multi-entity system is the gold standard. Each model in a unit has individual HP. When a model dies, the unit loses one attacker. A 120-model unit at 50% strength has 60 attackers — it literally hits half as hard. Crucially, **damage to surviving models doesn't reduce their output** — only model *death* reduces combat power. This creates a clean degradation curve: the unit visibly, mechanically weakens as bodies drop.

**Key insight for Demon Horde:** The GDD already describes this ("a 50-imp squad at half strength hits half as hard"), but Total War reveals a subtlety — *per-model health matters*. Low-HP swarmlings die fast (each hit kills one, steady degradation), while high-HP brutes lose power in sudden chunks (each brute death is a big drop). Same linear rule, radically different feel.

### Entity Count Changes What Attacks Are Good Against You

Total War Warhammer demonstrates that unit size shifts the entire tactical meta:
- **Single-target attacks** overkill swarm models (wasted damage) but efficiently kill elite models
- **AoE/cleave** is devastating against tightly-packed swarms but weak vs single entities
- **Charges** are physics-based: a heavy unit smashing into light infantry scatters and kills by mass, but the same charge into another heavy unit barely moves it

This means squad size isn't just a stat — it determines your *vulnerability profile*. A swarm isn't just "more HP distributed across bodies"; it's categorically resistant to single-target damage and categorically vulnerable to AoE. The GDD's damage type table (Single-Target, Cleave/AoE, Anti-Horde, Precision) already captures this, which is good design.

### Count as Currency (Company of Heroes)

In Company of Heroes, squads lose individual soldiers but can be **reinforced** near base structures. The cost to replace one soldier is always cheaper than buying a new squad, but the reinforcement takes time and requires proximity to supply. This makes attrition meaningful without making every casualty permanent.

**Relevance to Demon Horde:** The permadeath design means no mid-battle reinforcement, which makes casualty degradation even more impactful. Every imp that dies is gone. This is more like Myth: The Fallen Lords, where units cannot be replaced and preservation is the entire game.

### Count Creates Physical Presence (Charge & Mass)

Total War separates three physical mechanics:
- **Charge bonus** — flat attack/damage boost for 12-15 seconds after initial contact, fades linearly
- **Impact damage** — only applies when the charging unit is at least one size category larger; based on mass ratio and speed; ~70% armor-piercing
- **Collision** — continuous knockback/damage from mass differential during melee

A 50-imp swarm physically *cannot* generate the impact damage of a single Behemoth. But 50 imps surrounding an enemy create a tarpit — the enemy can't disengage, can't charge through, can't reach the high-value target behind them. Size manifests as *presence on the board*, not just numbers.

---

## 2. Guard/Screening Mechanics — The Tactical Puzzle

### Military Doctrine Translated to Games

Real military screening has three levels of commitment:
1. **Screen** — observe, report, delay. The lightest touch. The screening force avoids decisive engagement.
2. **Guard** — contains enough combat power to defeat or fix the enemy's lead elements before they reach the main body.
3. **Cover** — a full defensive operation. Essentially an independent battle to protect the main force.

Most games only implement #2 (guard), but the distinction matters for Demon Horde because demon personalities could create all three behaviors:
- A **Coward** squad assigned to guard might only screen (flee before real engagement)
- A **Loyal** squad guards properly (intercepts and fights)
- A **Berserker** squad goes beyond guard into aggressive cover (charges out to meet the enemy)

### Tarpit vs Screen (Warhammer Tabletop)

Warhammer distinguishes two expendable-unit roles:

**Screen:** A small, cheap unit placed in front of valuable units. Its job is to *absorb charges*. When enemy cavalry charges into the screen instead of the valuable unit behind it, the screen has done its job even if it dies instantly. The key mechanic: charges must resolve against the first unit contacted — you can't charge *through* a screen.

**Tarpit:** A large, durable (but weak) unit that bogs down a powerful enemy in melee. The tarpit doesn't need to kill anything — it just needs to take a long time to die, keeping the enemy pinned for multiple turns. Effectiveness comes from wound count, not damage output.

**For Demon Horde:** Imp swarms naturally fill both roles. As screens, they absorb the first hit. As tarpits, their sheer count means enemies spend multiple turns chewing through them. The guard system in the GDD (melee interception, standoff maintenance, screen collapse) maps directly to these tabletop roles. The mechanical question is: *how does guard assignment work spatially?* Does the guard squad need to be adjacent? Between the attacker and the guarded unit? This spatial requirement is what makes it a real tactical choice rather than just "assign guard and forget."

### Zone of Control as Guard Mechanic

Wargames use Zones of Control (ZOC) to create spatial denial:
- **Rigid ZOC** — enemy units must stop when entering an adjacent hex. Creates hard blocking.
- **Fluid ZOC** — movement slowed but not stopped. Creates soft screening.
- **Locking ZOC** — units cannot leave once engaged. Creates tarpits.

For Demon Horde's guard system, some form of ZOC could mechanically underpin the guard relationship. A guarding squad projects a ZOC that forces enemies to engage it before passing through to the guarded squad. This is more tactically interesting than a simple "redirect damage" toggle because it depends on *positioning*.

---

## 3. Formation Systems — Depth or Complexity?

### The Elegance Test

Game design theory frames this as a ratio: **depth / complexity = elegance**. A formation system that adds 5 options but only 1 meaningful choice is inelegant. A system that adds 2 options where both are situationally correct is elegant.

### Mount & Blade Bannerlord's Formation System

Bannerlord offers ~8 formation types (line, column, skein/wedge, square, circle, loose, etc.) selectable per group. The community verdict is mixed:
- **Wedge/Skein** is almost universally best for cavalry charges (pierces lines)
- **Loose** is good for ranged (avoids AoE) but suicidal for infantry
- **Circle** is a "last stand" novelty with no real tactical niche
- Most formations are traps that never outperform Line

**Lesson:** Formation variety =/= formation depth. Three formations where each is best in a clear situation > eight formations where one dominates.

### Myth: The Fallen Lords — Formation as Survival

Myth used formations differently: they controlled *spacing*. Tight formations concentrated firepower but made units vulnerable to explosives. Spread formations survived AoE but diluted melee effectiveness. Combined with a realistic physics/terrain system (archers on hills outrange archers below, explosions scatter debris that kills), formation was about *risk management in a hostile environment.*

The critical Myth insight: **no unit replacement.** Since you cannot produce new units, every formation choice is about preserving irreplaceable soldiers. This maps directly to Demon Horde's permadeath system.

### Recommendation for Demon Horde

Skip traditional named formations. Instead, make formation an *emergent property* of the guard system and positioning:
- Squads guarding something cluster around it (natural screen formation)
- Squads without guard orders operate independently
- Personality traits affect how tightly demons cluster (Berserkers spread forward, Cowards cluster behind)

This creates "formations" that emerge from the guard graph and personality traits rather than from a dropdown menu. Fewer inputs, more emergent complexity.

---

## 4. Swarm vs Elite — Making the Choice Interesting

### The Fundamental Asymmetry

From Infinity tabletop (Tohaa), the swarm/elite tradeoff has a core asymmetry:

**Swarms:**
- More actions per turn (more bodies = more things happen)
- Resilient to bad luck (one bad roll doesn't end your game)
- Vulnerable to attrition over time (losing one body = losing one action)
- Overwhelm through parallel threats

**Elites:**
- Fewer actions but each action is higher impact
- Vulnerable to bad luck (one bad roll on your 3-model squad is catastrophic)
- Resilient to light chip damage (high per-model HP absorbs glancing blows)
- Overwhelm through concentrated force

**Key insight:** The tradeoff isn't just "stats vs numbers." It's **risk profile**. Swarms are the conservative investment portfolio (diversified, steady returns). Elites are the concentrated bet (massive upside, massive downside).

### Matchup Web, Not Linear Power Scale

For this choice to stay interesting, each composition needs clear strengths AND weaknesses:

| Composition | Beats | Loses To |
|---|---|---|
| Swarm (all T1) | Spread-out enemies, objective-based missions, attrition fights | AoE, morale attacks, anti-horde damage |
| Elite (all T3) | Single-target fights, breakthrough assaults, high-fortification targets | Being surrounded, tarpit + flanker combos, attrition |
| Screen & Strike (T1 + T3) | Most situations if played well | Requires tactical skill; collapses if screen is destroyed before strike connects |
| Balanced (T1 + T2 + T3) | Flexible, no auto-loss matchups | No auto-win matchups either; jack of all trades |

The GDD already has this table. The mechanical key is making sure AoE, morale attacks, and anti-horde damage are *available to enemies in predictable ways* so the player can scout and counter-compose.

### Swarm Intelligence vs Individual Autonomy

Game AI research identifies a fundamental tension: giving swarm members more individual decision-making creates more realistic behavior but risks incoherent group action. For Demon Horde, this tension IS the game — demon personalities are the individual autonomy, and the player's commands are the group cohesion. The Chaos Meter is literally measuring this tension.

---

## 5. Morale as a Squad Mechanic

### The Cascade Problem (XCOM)

XCOM's panic system demonstrates morale's most dramatic mechanic: the **chain rout**. When one soldier dies, nearby soldiers test morale. If they panic, they act randomly (shoot at allies, freeze, flee). If their panic kills or injures another soldier, *that* triggers more morale tests. A single death can cascade into a squad wipe.

Key design elements:
- **Visibility matters** — panic only chains if panicking soldiers are in line-of-sight of other soldiers. Spreading out limits cascade risk.
- **Rank matters** — losing a high-rank soldier causes more morale damage than losing a rookie. This creates a dilemma: your best soldiers are the most dangerous to lose.
- **Will stat** — individual resistance to panic, trainable over time. Veterans are calmer.

### Thresholds, Not Gradients (Warhammer 40k 10th Edition)

40k's Battle-shock system uses a clean threshold: units below half strength take a morale test. If they fail:
1. Objective Control drops to 0 (can't hold points)
2. Can't use Stratagems (limited special actions)
3. Must test to Fall Back (might get stuck)

This is *not* a rout — the unit doesn't flee. It becomes *less useful*. This is elegant because:
- The threshold is clear and predictable (below half = test)
- Consequences are tactical (lose objective control) not narrative (run away)
- It's recoverable (resets each Command phase)

### Total War Morale — Multi-Factor Calculation

Total War calculates morale from many inputs:
- **Base leadership** (unit quality)
- **Casualties taken** (within this unit and across the army)
- **Flanking/encirclement** (attacked from multiple sides)
- **Proximity to leaders** (generals/heroes boost morale)
- **Nearby routs** (allies fleeing causes morale damage — cascade!)
- **Charge received** (getting hit by a charge shocks morale)

The result is a morale system where *tactical situation matters more than raw stats*. A low-leadership unit behind a wall with a general nearby might hold longer than an elite unit flanked and watching allies run.

**Routing states:** Wavering → Routing → Broken → Shattered. Wavering units can recover automatically. Routing units can rally if the pressure eases. Broken units need heroic intervention. Shattered units are permanently gone.

### Recommendation for Demon Horde

Demon morale should be *asymmetric* — your demons and enemy humans should have completely different morale profiles:

**Demons (player):** Low morale baseline, but the Chaos Meter feeds into it. At low chaos, demons are skittish and undisciplined (flee easily). At high chaos, demons are frenzied and fearless (never route but also never follow orders). The player manages morale indirectly through the chaos meter.

**Humans (enemy):** High baseline morale that cracks under specific conditions — watching allies die, facing fire/horror, being flanked. When human morale breaks, it cascades because humans are organized — one unit routing shakes the whole line. This makes human morale the player's primary target: break one unit, and the line might fold.

---

## 6. Casualty Tracking — Degradation Curves

### Linear Degradation (Model-by-Model)

Total War and Company of Heroes use this: each model death reduces the unit's output proportionally. A 100-model unit at 70 models has 70% of its original damage output.

**Pros:** Intuitive, every casualty matters, creates gradual weakening.
**Cons:** The "last 10%" is irrelevant (unit is so weak it can't do anything meaningful but technically exists).

### Threshold Degradation (Step Functions)

Warhammer 40k's Battle-shock is a threshold: above 50% = full power, below 50% = debuffed. Some tabletop systems use multiple thresholds (100%, 75%, 50%, 25%) with increasing penalties at each.

**Pros:** Clean, memorable breakpoints. Creates dramatic moments ("they're below half!"). Easier to track.
**Cons:** Casualties between thresholds feel meaningless. Less granular.

### Hybrid: Linear Damage + Threshold Morale

The most interesting approach combines both:
- **Combat power** degrades linearly with model count (every imp death = less damage)
- **Morale thresholds** trigger at specific breakpoints (below 75% = wavering, below 50% = morale test, below 25% = routing)

This gives casualties constant tactical weight (linear degradation) while creating dramatic turning points (threshold morale). The player always cares about keeping models alive (linear) but especially cares about hitting key breakpoints (threshold).

### Myth's Veterancy Layer

Myth added a critical twist: surviving units gain experience, making them more accurate and faster. This means early-game units that survive become mid-game veterans worth far more than replacements. Combined with no-replacement permadeath, this creates the strongest possible incentive for unit preservation.

**For Demon Horde:** Templates partially solve the "lost recipe" problem, but they don't preserve veterancy. Consider a lightweight veterancy system: squads that survive multiple raids gain a small stat bonus (faster, harder-hitting). This makes experienced squads feel irreplaceable even when you have their template, because you can rebuild the *design* but not the *experience*.

---

## 7. Controlling Multiple Squads — Chaos Management, Not Click Management

### Pikmin: Localized Agency + Time Pressure

Pikmin's genius is that the player's *body* is the control interface. You physically walk to where you want things to happen, whistle Pikmin to you, and throw them at targets. This means:
- You can only effectively control things *near your avatar*
- Multitasking requires *physically splitting attention* by running between groups
- Pikmin left unattended do nothing (or wander into danger)

The result: controlling multiple groups is about **triage and prioritization**, not simultaneous micro. The player constantly asks "what's the most important thing I should be near right now?" rather than "let me issue 6 orders in sequence."

**For Demon Horde (turn-based):** The turn-based format eliminates real-time triage, but the principle applies. Give each squad ONE action per turn (move OR attack OR ability), and the interesting decision is *which squad to activate and what to do with it.* This is closer to Into the Breach (3 units, 1 action each, every action matters enormously) than Total War (20 units, constant real-time micro).

### Overlord: Typed Squads with Behavioral Defaults

Overlord's four minion types each have a *default behavior when placed on a guard marker*:
- Browns: stand and fight (melee guard)
- Reds: enter fireball attack mode (ranged overwatch)
- Greens: go invisible (ambush)
- Blues: auto-resurrect fallen minions (support)

This is brilliant because the player doesn't need to micromanage each group. Place reds on a high point and they automatically provide covering fire. Place greens near a chokepoint and they automatically ambush. The *placement* is the decision; the *behavior* is automatic.

**For Demon Horde:** Squad type should determine default behavior when guarding or when unordered. Imp swarms might default to swarming the nearest enemy. Brutes might hold position. Behemoths might advance slowly toward the largest threat. Personality traits override these defaults (a Berserker brute charges instead of holding). The player manages by *positioning and assigning guard relationships*, not by micromanaging each squad's action.

### Into the Breach: Radical Constraint = Depth

Into the Breach proves that fewer units = more interesting decisions. With only 3 mechs and 1 action each per turn, every action is agonizing because you can see all consequences. The game achieves this by:
- Showing enemy intent (you know exactly what each enemy will do)
- Making every action interact with multiple problems (pushing one enemy saves a building but blocks your other mech)
- Having no "right answer" — every turn involves sacrifice

**For Demon Horde:** The GDD says players deploy "squads" plural, but the sweet spot is probably 3-6 squads per battle, not 20. With 3-6 squads, each getting 1 action per turn, the player has enough to create interesting guard chains and combos without drowning in micro. The chaos comes from demon personalities disrupting plans, not from having too many things to click.

### The "Managing Chaos" Feel

The goal isn't smooth control — it's *just enough* control over unruly forces. Key design levers:

1. **Orders, not direct control** — the player issues orders; demons interpret them through their personality. A "move here" order to a Greedy squad might result in them detouring past a loot pile.

2. **Guard relationships as the primary control** — instead of issuing individual move/attack orders, the player defines relationships (squad A guards squad B, squad C is independent). The game resolves these relationships against the battlefield state.

3. **Chaos as feedback** — when things go wrong (a Berserker breaks formation, a Coward flees), the player's response IS the gameplay. Do you send another squad to cover the gap? Do you adjust guard assignments? Do you lean into the chaos?

4. **Turn-based breathing room** — unlike real-time games where chaos is overwhelming, turn-based chaos gives the player time to observe, react, and plan. Each turn starts with "okay, what went wrong, and what's my best play now?"

---

## 8. Unruly Units — Making Chaos Fun, Not Frustrating

### Darkest Dungeon: Stress as Escalating Loss of Control

Darkest Dungeon's Affliction system is the masterclass in making unruly characters fun:

- **Stress accumulates** from events (darkness, enemy abilities, critical hits)
- At **100 stress**, the hero tests for an Affliction (75% chance) or Virtue (25% chance)
- Afflicted heroes **act on their own** — moving out of position, refusing orders, using random abilities, or passing turns
- Afflictions **spread stress** to nearby party members, creating a cascade
- Each hero has an **Affliction History** — they tend to develop the same affliction repeatedly, creating personality consistency

**Why it works:** The player can *see it coming*. Stress builds gradually, giving time to mitigate (stress-healing abilities, retreating, camping). When an affliction hits, it's dramatic but not random — you knew that hero was close to breaking. And because afflictions have consistent patterns per hero, you learn to plan around them ("my Crusader always becomes Abusive, so I keep the healer far from him").

### Dwarf Fortress: Personality as Simulation

Dwarf Fortress models over 50 personality facets per dwarf (creativity, anxiety, friendliness, etc.), each on a spectrum. These affect behavior: a dwarf high in anxiety and low in bravery will refuse dangerous tasks. A dwarf high in creativity and low in conscientiousness will abandon assigned work to make art.

**The problem:** Without a clear UI to expose these traits, most players experience personality as random misbehavior. The traits are mechanically deep but informationally opaque.

**Rimworld's fix:** Rimworld took the same concept but made traits **visible and binary** — a pawn either has "Pyromaniac" or doesn't. The trait directly tells you the behavior (will randomly set fires). This sacrifices Dwarf Fortress's simulation depth for clarity.

### The Fun/Frustration Line

The research consistently shows that unruly units are fun when:

1. **Predictable unpredictability** — the player knows a Pyromaniac *might* set fires, but not *when*. The personality is known; the specific disruption is not. This lets the player plan around risk without eliminating surprise.

2. **Tradeoffs, not pure negatives** — every disruptive trait should come with an upside. Berserkers deal bonus damage. Cowards get bonus retreat speed. Pyromanics have bonus fire damage. The player *chose* to include this unit knowing the risk. If a trait is pure downside, it's not a personality — it's a penalty.

3. **Agency in composition** — the player chose which demons to bring. If your squad is full of Berserkers and they break formation, that's your composition decision coming home to roost, not the game being unfair.

4. **Visible state** — the player can see when a unit is close to acting out. A stress meter, an agitation indicator, a "this unit is about to do something stupid" warning. The chaos should be *anticipated* chaos, not blindside chaos.

5. **Cascade potential but cascade limits** — one unit acting out should create problems for nearby units (a fleeing Coward shakes nearby squads' morale) but shouldn't instantly cascade into a total army collapse. There should be ways to contain the chaos (rally abilities, leader proximity, guard assignments that keep volatile units away from each other).

### Recommendation for Demon Horde

The GDD's personality traits (Pyromaniac, Coward, Greedy, Berserker, Loyal) are well-designed because they're all tradeoffs. Refinements:

- **Give each trait a visible trigger condition.** Pyromaniac: triggers when the squad deals fire damage (the fire excites them). Berserker: triggers when an enemy is within charge range. Coward: triggers when squad drops below a threshold. Greedy: triggers when a loot objective is visible. The player can predict *when* the trait will activate based on battlefield state.

- **Make Loyal the default, not the rare exception.** The GDD says Loyal is the rarest trait. This might create frustration if most squads are unreliable. Consider making Loyal the most common baseline with disruptive traits as the memorable exceptions. The ratio matters: if 80% of your squads are reliable and 20% are wild cards, the wild cards are exciting. If 80% are wild cards, it's exhausting.

  *Counter-argument:* The GDD's tone is "playful chaos." If the game is explicitly about managing an unruly horde, then Loyal being rare reinforces the fantasy. This is a tone dial the designer needs to set: "strategy game with chaotic flavor" (Loyal common) vs "chaos management game" (Loyal rare). Both can work; they're different games.

- **Let the player influence (not control) personality through breeding.** If two Loyal parents breed, higher chance of Loyal offspring. If two Berserkers breed, higher chance of Berserker (with potential for Pyromaniac mutation). This gives the player long-term agency over the chaos level of their army.

---

## Summary: Core Mechanical Principles for Demon Horde's Squad System

1. **Model count IS the stat.** Every body in a squad is a discrete attacker that can die. Linear degradation of combat power as count decreases. Different count-per-squad by tier creates fundamentally different vulnerability profiles.

2. **Guard is spatial, not abstract.** Guard relationships depend on positioning. A guard squad must be *between* the threat and the guarded squad. Zone of control mechanics make guarding a physical presence on the board.

3. **Skip named formations.** Let squad behavior emerge from guard assignments, personality traits, and type defaults. Three implicit formations > eight explicit ones.

4. **Swarm vs elite is a risk profile choice, not a power level choice.** Both compositions should be viable. The matchup web (what counters what) is what makes composition interesting.

5. **Morale has thresholds that interact with personality.** Casualty degradation is linear; morale breakpoints are thresholds. Demon and human morale work differently (chaos-driven vs discipline-driven).

6. **3-6 squads is the sweet spot.** Enough for guard chains and combos, few enough that each squad's action matters. The chaos comes from personality, not from information overload.

7. **Unruly is fun when it's predictable unpredictability.** Known personality + visible trigger conditions + tradeoff design = the player managing risk, not suffering randomness.

8. **Orders, not control.** The player issues intent; demons interpret through personality. The gap between intent and execution IS the game.
