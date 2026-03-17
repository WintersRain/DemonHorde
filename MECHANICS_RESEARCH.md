# Combat Mechanics Research: What Creates Interesting Decisions

Research for Demon Horde. Organized by **mechanical problem**, not by game. Each section identifies the problem, surveys how existing games solve it, and notes what matters for a squad-based horde tactics game.

---

## 1. The "Move and Attack Every Turn" Problem

**The problem:** In shallow tactics games, optimal play on most turns is "move toward the enemy, attack." There is only one viable action, so there is no decision. The game plays itself.

**What breaks this pattern:**

### Multiple Viable Actions Per Turn
The core fix is ensuring the player has 3+ genuinely different things they could do each turn, where each choice has a real cost (opportunity cost of not doing the others).

- **XCOM's Overwatch vs. Attack:** Spending your action on Overwatch (reaction fire during the enemy turn) means forgoing an attack now. The trade-off: guaranteed damage now vs. potential damage later plus area denial. This is interesting because the right answer depends on enemy positioning, pod activation risk, and cover states.
- **Battle Brothers' Fatigue Budget:** Every action costs fatigue. Fatigue reduces initiative (turn order) and eventually locks you out of actions entirely. A unit in heavy armor that attacks aggressively will act last next round and may be unable to use skills. The decision: act now and pay later, or conserve for sustained pressure. Fatigue is probably the single most important in-combat resource in Battle Brothers.
- **Into the Breach's Displacement vs. Damage:** Most attacks both deal damage AND push/pull targets. Sometimes the optimal play is dealing 0 damage but pushing an enemy into another enemy, or into water, or out of attack range of a building. Damage is not always the goal. This is the gold standard for "actions that do different things."

### Reserve and Reaction Systems
Allowing units to hold actions for use during the opponent's turn fundamentally changes the decision space from "what do I do?" to "what do I do NOW vs. what do I save for LATER?"

- **XCOM Overwatch:** Costs your full action. Reaction shots have an aim penalty (0.7x multiplier, 0.6x vs. dashing enemies). But ambush overwatch from concealment has NO penalty, rewarding setup and patience.
- **Original X-COM Time Units:** Granular AP system where any unspent points could fuel reaction fire. More complex but more expressive: you could move a short distance and still have enough TU for a snap shot on reaction.
- **Warhammer 40k Overwatch (9th Ed):** Made into a Stratagem costing Command Points, usable once per phase. Attackers choose charge order to bait out Overwatch; defenders choose when to spend it. The scarcity creates a mind game.
- **Battle Brothers' Riposte/Spearwall:** Specific skills that trigger on enemy actions (Riposte counter-attacks when attacked in melee; Spearwall attacks anyone entering adjacent tiles). These cost fatigue to maintain, creating a tension between offensive and defensive stance.

**Key insight for Demon Horde:** The GDD's current combat is "move + attack." To create decisions, units need at least one meaningful alternative to attacking each turn. Reserve/reaction actions are a proven way to do this, but they need to cost something real (fatigue, action points, positioning advantage) or the optimal play becomes "always Overwatch."

---

## 2. Action Economy Models

**The problem:** How many things can a unit do per turn, and how do you structure those actions to create interesting choices?

### Model Comparison

| Model | Example | Pros | Cons |
|---|---|---|---|
| **2-Action (Move/Act)** | XCOM 2 | Simple, clear. Easy for players and AI. | Limited expression. Most turns are move+shoot. |
| **Action Points (6-12 AP)** | Original X-COM, Fallout | Highly granular. Many possible action combos. | Complex UI, harder to balance, slower turns. |
| **Action Points (3-4 AP)** | Divinity: Original Sin 2 | Good middle ground. Several meaningful combos. | Still more complex than 2-action. |
| **Move + Multiple Actions** | Battle Brothers (4 AP + move) | Movement is separate, actions are flexible. | Requires careful balancing of action costs. |
| **Simultaneous Resolution** | Frozen Synapse, Combat Mission WEGO | Eliminates "I go, you go" advantage. | Much harder to implement, less readable. |

### What Makes Action Economy Interesting
- **Actions that compete for the same resource.** If moving and attacking use the same pool (AP), then moving farther means attacking less. This is inherently a trade-off.
- **Free actions and bonus actions.** Breaking the standard economy with special abilities feels powerful and creates build diversity. XCOM's "Run and Gun" lets Rangers move twice AND attack, but it's a cooldown ability, not the default.
- **Fatigue as a secondary cost.** Battle Brothers layers fatigue on top of AP. You might have the AP to attack three times, but the fatigue cost would leave you acting last next round and unable to use skills. This creates a pacing decision within each turn.
- **Scaling efficiency.** In many games, the first action is "free" (you always get a move) but additional actions have increasing costs, creating diminishing returns that prevent one unit from dominating.

**Key insight for Demon Horde:** For squad-based combat (where each "unit" is a squad, not an individual), simpler action economies work better because the player manages multiple squads per turn. XCOM's 2-action model works because you have 4-6 soldiers. Battle Brothers' AP model works for 12 mercs. With potentially 5-8+ squads, Demon Horde should lean toward a simpler per-squad economy (2-3 actions) but add depth through squad-level decisions like guard assignments, ability timing, and formation.

---

## 3. Positioning Depth Beyond Adjacency

**The problem:** Many tactics games reduce positioning to "get in range, attack." True positioning depth means WHERE you stand matters as much as WHETHER you can reach the enemy.

### Flanking and Facing
- **Total War:** Flank attacks reduce melee defense by 40%. Rear attacks reduce it by 60%. Rear charges cause massive morale shock. This makes positioning the primary tactical lever, not raw stats.
- **Battle Brothers:** Surrounded enemies (2+ attackers from different sides) get flanking penalties to defense. Backstab perk gives bonus damage from behind. Zone of control prevents free movement through threatened hexes.
- **Warhammer 40k:** Engagement range locks units. Falling back from engagement forfeits your shooting. This creates sticky melee that rewards positioning before engagement, because once locked in, you're committed.

### Zone of Control (ZoC)
The area adjacent to a unit that restricts enemy movement.

- **Rigid ZoC:** Enemy must stop when entering the zone. Creates walls and chokepoints. (Classic wargames)
- **Fluid ZoC:** Enemy can move through but at increased cost. More dynamic but less dramatic. (Some modern tactics games)
- **Opportunity Attack ZoC:** Moving out of the zone triggers a free attack. Creates a "cost to disengage." (D&D, Battle Brothers, many tactics games)
- **No ZoC:** Units move freely. Positioning matters only for range/cover. (Simpler games)

### Displacement and Terrain Interaction
- **Into the Breach:** Almost every attack pushes, pulls, or displaces targets. Maps are designed so that every tile matters (water kills, buildings must be protected, enemies can be pushed into each other). The POSITION of the attack matters more than the DAMAGE of the attack. A 1-damage push can be better than a 3-damage direct hit.
- **Darkest Dungeon:** Linear rank system (positions 1-4) where abilities are restricted by your current rank AND can only target specific enemy ranks. Displacement abilities (pull, push, shuffle) are devastating because they put enemies in positions where their best attacks don't work. The Occultist pulling a back-rank healer to rank 1 is more valuable than any amount of damage.

### Elevation and Cover
- **XCOM:** Half cover and full cover provide defense bonuses. Flanking (attacking from a side with no cover) eliminates the bonus entirely. Elevation grants an aim bonus. Destruction of cover through explosions changes the battlefield dynamically.
- **Battle Brothers:** High ground gives attack/defense bonuses. Trees provide ranged defense. Swamps slow movement. The hex grid means positioning for high ground advantage is always a consideration.

**Key insight for Demon Horde:** The GDD mentions flanking bonuses, high ground, and chokepoints. For a horde game, the most impactful positioning mechanic is probably **zone of control with engagement**, because it makes guard squads (the game's signature mechanic) into physical obstacles, not just abstract damage redirectors. A guard squad on a chokepoint that exerts ZoC creates a wall the enemy must deal with before reaching the guarded unit. This turns positioning into the core decision rather than a modifier.

---

## 4. Morale and Psychology Systems

**The problem:** In most tactics games, units fight at full effectiveness until they hit 0 HP and disappear. This is unrealistic and creates binary outcomes (alive = full power, dead = gone).

### Morale as a Combat Resource

**Battle Brothers:**
- Morale states: Confident > Steady > Wavering > Breaking > Fleeing
- Morale checks triggered by: ally death, ally fleeing, being wounded, being outnumbered, being surrounded
- **Contagious panic:** When one unit flees, nearby allies must check morale. If they fail, they flee too. This cascade effect means that a single devastating hit can unravel an entire line.
- Morale recovery: units can rally if conditions improve (ally kills an enemy, leader uses Rally skill)

**Total War:**
- Morale and Discipline are separate. Morale = confidence in winning. Discipline = ability to maintain formation.
- Rear charges cause immediate morale shock, often routing units regardless of HP
- Routing units can rally if they escape danger, but re-routed units shatter permanently
- **Mass rout cascade:** When enough units in an army rout, the entire army can collapse. This is the primary way battles end, not killing every entity.

**Darkest Dungeon:**
- Stress accumulates from combat events, traps, darkness, critical hits received
- At 100 stress: Affliction check. ~75% chance of Affliction (Selfish, Paranoid, Masochistic, etc.), ~25% chance of Virtue (Courageous, Vigorous, Powerful, etc.)
- Afflicted heroes act against orders: skip turns, attack allies, refuse healing, stress out party members
- Virtuous heroes get buffs and can de-stress the party
- **Key design insight:** The affliction system makes stress NARRATIVELY interesting. A Paranoid hero who refuses healing creates stories. Pure morale (fight/flee) is less interesting than personality-flavored breakdown.

### Why Psychology Matters Mechanically
- **Battles end before total annihilation.** In realistic morale systems, most combat ends when one side breaks and runs, not when every entity is dead. This matches real warfare and creates a different optimization target: break enemy morale before they break yours.
- **Morale flanking.** Attacking morale (through fear, intimidation, demoralizing actions) becomes a viable alternative to attacking HP. This doubles the decision space.
- **Risk of investment.** High-morale elite units are worth more but losing one is more devastating because their rout affects everyone. Expendable units that don't trigger morale cascades have strategic value beyond their combat stats.

**Key insight for Demon Horde:** The GDD already has demon personalities (Pyromaniac, Coward, Berserker, etc.) that inject chaos. A morale/psychology system would amplify this: demon squads don't just lose HP, they lose cohesion. A Coward squad that breaks early could trigger a cascade. A Berserker squad that ignores guard orders to charge could either win the fight or expose your line. The human defenders should also have morale, since demons are terrifying, so terror tactics (fear abilities, overwhelming displays, killing leaders) should be a viable win condition. You don't need to kill every guard if you can rout them.

---

## 5. Squad-Based vs. Individual Unit Combat

**The problem:** Demon Horde uses squads (groups of same-type units acting as one), not individual units. This fundamentally changes the decision space.

### How Squad Abstraction Changes Combat

**What squads gain:**
- **Degrading power curve.** A squad of 50 imps at 25 members hits at half power. There's no sudden cliff from "alive" to "dead." Every casualty matters incrementally.
- **Mass and presence.** A squad occupies space on the battlefield in a way a single unit doesn't. Formation, width, and depth become relevant.
- **Attrition mathematics.** AoE vs. single-target damage types create meaningful matchup decisions based on squad size.

**What squads lose vs. individuals:**
- **Per-unit decision granularity.** You can't position each imp individually. The squad moves as one. This means the game needs OTHER sources of tactical depth.
- **Equipment/build diversity within combat.** In XCOM, each soldier has different gear and skills. In a squad game, the squad IS the unit of diversity.

### How Existing Games Handle Squads

**Total War:**
- Each "unit" is a regiment of 40-160 entities. The player commands the regiment as one.
- Individual entities fight autonomously within the regiment. What the player controls is regiment positioning, facing, formation (loose/tight/wedge), charge timing, and target selection.
- Depth comes from: formation choices (tight = more damage but vulnerable to AoE; loose = resilient but weaker attacks), charge timing (charge bonus fades after impact), and multi-regiment coordination.

**Warhammer Tabletop (40k 10th Ed):**
- Squads of models move, shoot, and fight as a unit but allocate wounds to individual models.
- Unit coherency rules (must stay within 2" of another model) prevent spreading too thin.
- The squad leader model often has better stats, and losing it degrades the unit.

**Dawn of War (RTS, but relevant):**
- Squads can be reinforced mid-battle (spend resources to add models back).
- Squad leaders/heroes can be attached, providing buffs.
- Cover applies to the whole squad based on position.

### The Composition Problem
Squad games excel when army COMPOSITION is the strategic layer, not individual unit micro.

- **Battle Brothers:** 12 mercs, each individually built. Composition = class diversity + positioning.
- **Total War:** 20 regiments. Composition = infantry/cavalry/ranged/artillery balance.
- **Demon Horde GDD:** T1/T2/T3 tiers with different squad sizes. Composition = swarm vs. elite vs. mixed.

The interesting decisions should be: "Which squads do I bring?" (strategic) and "How do I use the squads I brought?" (tactical). Not "how do I individually micro 50 imps."

**Key insight for Demon Horde:** The guard system is the game's answer to the granularity problem. Instead of micro-positioning individual units, the player makes tactical decisions at the RELATIONSHIP level: which squad guards which? When to commit the guard vs. hold back? When to sacrifice the screen to save the core? These are interesting decisions that work naturally at squad scale.

---

## 6. What Creates Genuine Trade-Offs

**The problem:** A "decision" where one option is always better is not a real decision. True trade-offs require that every option has both upside and downside.

### Types of Trade-Offs That Work

**Offensive vs. Defensive:**
- Attack now vs. set up Overwatch (XCOM)
- Charge forward vs. hold position with Spearwall (Battle Brothers)
- Push enemy into water vs. push enemy away from building (Into the Breach)
- In all cases: the aggressive option gains ground/damage but accepts risk; the defensive option maintains safety but forfeits tempo.

**Short-term vs. Long-term:**
- Spend all AP/fatigue this turn vs. conserve for next turn (Battle Brothers)
- Dash to better position (uses both actions, can't attack) vs. stay and shoot from worse cover (XCOM)
- Use ability on cooldown vs. save it for a bigger threat
- Push to rout one enemy unit vs. maintain formation against multiple threats (Total War)

**Risk vs. Reward:**
- Low-hit-chance, high-damage shot vs. guaranteed-hit, low-damage shot
- Commit all reserves vs. hold reserves for contingency
- Push deeper into dungeon while stressed vs. retreat to safety (Darkest Dungeon)

**Resource vs. Outcome:**
- Spend grenades (limited supply) to destroy cover vs. try to outmaneuver (XCOM)
- Sacrifice a cheap unit to activate an ability vs. keep it alive for its own combat value
- Use healing now vs. save it for when things get worse

**Concentration vs. Distribution:**
- Focus fire one target to kill it vs. spread damage to weaken several (relevant in any tactics game)
- Deploy squads in one sector for overwhelming force vs. spread to cover objectives (Total War, XCOM)

### The Fire Emblem Weapon Triangle Model
A simple rock-paper-scissors relationship (swords > axes > lances > swords) creates constant low-level decisions about which unit engages which enemy. Fire Emblem Engage added "Break": winning the triangle matchup causes the loser to drop their weapon, unable to counterattack. This turns matchup awareness from a minor modifier into a major tactical consideration.

**Key insight for Demon Horde:** The GDD's attack type system (Single-Target vs. AoE vs. Anti-Horde vs. Precision) is already a matchup system. A swarm of 50 imps is devastated by AoE but barely tickled by Precision. An elite Behemoth shrugs off AoE but melts to Precision. If this matchup system has enough impact (not just +10% damage but "this attack type is twice as effective"), it creates a natural trade-off web where no army composition is safe against everything, and every tactical engagement asks "am I sending the right squad against this threat?"

---

## 7. Information and Uncertainty

**The problem:** Perfect information (chess, Into the Breach) creates puzzle-like play. Hidden information (fog of war, RNG) creates risk management and adaptation. Both are valid but serve different design goals.

### The Spectrum

| Game | Information Level | Uncertainty Source | Player Experience |
|---|---|---|---|
| Into the Breach | Perfect | None (enemy moves shown) | Pure puzzle solving |
| Fire Emblem | Near-perfect | Some RNG (hit %, crits) | Calculated risk |
| XCOM | Moderate | RNG + fog of war + pod activation | Risk management, plan B thinking |
| Darkest Dungeon | Low | RNG + stress + traps + surprise shuffles | Adaptation under pressure |
| Battle Brothers | Moderate | RNG + terrain visibility + enemy composition unknown | Preparation + adaptation |

### What Works for Squad Games
- **Fog of war** matters more in squad games because scouting becomes a role. Expendable scouts (cheap T1 squads) gain tactical value.
- **Known enemy behavior with unknown execution** (like Into the Breach showing attack directions but not exact damage) gives the player enough information to plan but not enough to optimize perfectly.
- **Partial army visibility** (see enemy force composition before deployment but not exact positioning) creates pre-battle strategic decisions.

**Key insight for Demon Horde:** The GDD mentions settlement stats being visible on the world map. This is good -- the player should know roughly what they're getting into (militia strength, fortification level) but not exact positioning or defender abilities. The chaos factor from demon personalities already injects uncertainty on the player's OWN side, which is a rare and interesting design choice. Most games only have uncertainty about the enemy. Having uncertainty about your own units (will the Coward squad hold? will the Pyromaniac set everything on fire?) creates a unique tension.

---

## 8. The Gap Between "Interesting" and "Tedious"

**The problem:** More options per turn can mean more interesting decisions OR more tedious micromanagement. The line between depth and complexity must be managed.

### What Crosses Into Tedium
- **Too many units with identical choices.** If you have 10 squads and each one just moves and attacks, that's 10 identical decisions. Boring.
- **Granular AP systems with large squads.** If each of 8 squads has 10 AP to spend, that's 80 micro-decisions per turn. Exhausting.
- **Excessive stat checking.** If optimal play requires calculating hit% for every possible target, the game becomes a spreadsheet.

### What Keeps Depth Without Tedium
- **Distinct squad roles.** Each squad type should have a DIFFERENT optimal action pattern. Swarmlings screen. Brutes hold. Behemoths strike. If their options are distinct, each squad's turn is a different decision.
- **Standing orders.** Guard assignments persist between turns. You set up your formation once and only adjust when things change. This reduces per-turn decisions while maintaining strategic depth.
- **Escalation pacing.** Early turns are simpler (move into position). Middle turns are complex (multiple engagements, guard chain decisions). Late turns simplify again (mop up or desperation). The cognitive load varies naturally.
- **Meaningful AI behavior.** Smart enemies that create problems (flanking, targeting guard squads, using terrain) force reactive decisions without adding player-side complexity.

**Key insight for Demon Horde:** The guard system is elegant because it's a PERSISTENT decision, not a per-turn one. "Squad A guards Squad B" stays in effect until changed. The per-turn decisions become: Do I maintain formation or break it? Do I advance the guard screen or hold position? Do I sacrifice the screen to get the Behemoth into striking range? This is the right level of abstraction for a horde game.

---

## Summary: What Demon Horde Should Take From This

### The Mechanical Foundations That Matter Most

1. **Action economy needs to force choices.** Not "move and attack" every turn. Each squad should have at least one meaningful alternative to attacking (guard, reserve, ability, reposition).

2. **Fatigue or equivalent in-combat resource.** Something that accumulates during combat and constrains future actions. Prevents "always attack" strategies and creates pacing decisions.

3. **Zone of control makes guard squads physical.** Guard assignments should translate to physical battlefield presence: the guard squad blocks a zone, and enemies must deal with it (fight through, go around, break it) to reach the guarded unit.

4. **Morale as a win condition.** Battles should end when one side breaks, not when every entity is dead. This creates a second axis of attack (HP damage vs. morale damage) and makes fear/terror a viable demon strategy.

5. **Matchup depth from attack types.** The existing Single-Target / AoE / Anti-Horde / Precision system has real potential IF the multipliers are significant enough to force composition awareness.

6. **Displacement and terrain interaction.** Demons that can shove, pull, rearrange, or alter the battlefield create decisions beyond damage optimization.

7. **Chaos as controlled uncertainty.** Demon personalities that inject YOUR OWN uncertainty are unique to this game. Lean into it. The player isn't playing chess -- they're directing a horde. The interesting decision is: "How do I set up a situation where even if things go sideways, I'm still in a good position?"

8. **Standing orders over per-turn micro.** Guard assignments, formation presets, and behavioral stances (aggressive/defensive/hold) reduce micromanagement while preserving strategic depth. The player makes formation decisions; the demons execute them (imperfectly).

---

*Research compiled from analysis of: Battle Brothers, XCOM / XCOM 2, Into the Breach, Darkest Dungeon, Total War (series), Warhammer 40k (tabletop), Fire Emblem (series), and general game design theory.*
