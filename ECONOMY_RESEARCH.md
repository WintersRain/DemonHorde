# Economy & Progression Research

Research into how strategy games connect their economy/progression layer to tactical combat. Organized by **mechanical problem**, not by game.

---

## 1. How Resource Decisions Between Battles Affect What You CAN Do in Combat

The critical design principle: resources should constrain **options**, not just **power**. When resources only affect stat scaling (bigger numbers), the decision is always "get more." When resources affect what compositions, abilities, and strategies are available, players face genuine trade-offs.

### Reference Games

**Darkest Dungeon** — Gold spent on provisions before an expedition directly shapes your dungeon experience. Torches affect light level (high light = you surprise enemies; low light = enemies surprise you but loot is better). Food prevents starvation stress. Shovels, antidotes, bandages each counter specific hazards. The preparation screen IS a strategic puzzle: you're spending limited gold to hedge against partially-known threats. Over-provisioning wastes gold needed for hero upgrades. Under-provisioning risks a party wipe that costs far more. Each dungeon area has different hazards, so the "correct" loadout changes every time.

**XCOM** — The strategic layer forces triage. You cannot research everything simultaneously. Choosing to research laser weapons before armor means your soldiers hit harder but die more easily. Building a Workshop before a Laboratory means cheaper production but slower unlocks. The Squad Size upgrade from the Officer Training School is cheap and more impactful than any weapon upgrade — knowing this is a knowledge-reward for experienced players. Crucially, XCOM's economy forces you to deploy squads that aren't ready. Mission timers and strategic pressure mean you sometimes send B-teams with suboptimal gear, creating tension the combat system alone never would.

**Battle Brothers** — Hiring a Hedge Knight (expensive, guaranteed decent stats) versus a Farmhand (cheap, might be incredible or terrible) is a resource-to-combat-options pipeline. Every crown spent on wages and food is a crown not spent on better armor. Equipment directly determines tactical viability: a brother without a shield plays fundamentally differently than one with a shield. The economy constrains your tactical roster in real-time.

**Monster Hunter** — No random loot. You craft gear from monster parts, meaning preparation IS the game. Fighting Rathalos to build Rathalos armor to resist fire to fight Teostra is a progression chain where each hunt is simultaneously resource gathering AND skill practice. Different weapon/armor builds create entirely different combat experiences against the same monster. The "loadout" system lets players save configurations for different threats — the game rewards players who prepare specifically rather than generically.

### Lessons for Demon Horde

- **Captives/Souls/Corruption should open strategic BRANCHES, not just upgrade paths.** A captive spent on breeding a new demon is a captive NOT sacrificed for souls. Souls spent on mutation are souls NOT spent on evolving a tier. Make these trade-offs visible and agonizing.
- **Pre-raid preparation should involve meaningful unknowns.** If the player knows exactly what they'll face, preparation is just optimization. If they know the settlement type but not the exact composition, they must hedge — bringing adaptable units or gambling on specialization.
- **Different resource states should unlock different STRATEGIES, not just better stats.** A player rich in captives but poor in souls should play differently than the reverse. Each resource should enable a qualitatively different approach.

---

## 2. Breeding/Recruitment Systems That Create Meaningful Army Composition Choices

The design problem: how do you make "pick your army" interesting rather than "pick your best units"?

### Reference Games

**Pokemon Breeding** — The deepest template/blueprint system in gaming. IVs (Individual Values, 0-31 per stat, set at birth) and EVs (Effort Values, trained through specific actions, up to 252 per stat and 510 total) create a multi-layered optimization puzzle. The Destiny Knot passes 5 of 12 parent IVs to offspring (instead of 3), making breeding a generational refinement process. The Everstone locks nature inheritance at 100%. Competitive players spend hours breeding to get perfect specimens — but the REAL depth comes from team composition. A perfect Garchomp is worthless if your team can't handle Ice types. The system rewards both individual optimization AND holistic team-building.

**Fire Emblem (Awakening/Fates)** — Parent pairing determines child unit stats, skills, and classes. Children inherit growth rates averaged from parents, plus specific skills from each parent's equipped skill list. The strategic puzzle is pairing parents to produce children with ideal class/skill combinations. The system turns roster management into a multi-generational planning exercise where current tactical decisions (who fights alongside whom) have long-term breeding implications.

**Battle Brothers** — Recruitment is gambling. Every hire has hidden stats revealed only through play. Background matters (a Monk might have great resolve but poor melee), but individuals vary wildly. This means your roster evolves organically — you build compositions around what you HAVE, not what you PLANNED. The game rewards adaptability over theory-crafting, because your "ideal" army composition may never materialize. Stars (talent indicators) give partial information, creating a scouting meta-game.

**Dungeon Keeper** — Creature acquisition depends on room construction. Build a Library, attract Warlocks. Build a Training Room, attract Dark Mistresses. The dungeon IS the recruitment system — infrastructure choices directly determine army composition. Certain creatures are natural enemies (Flies vs Spiders), so roster management involves keeping incompatible creatures apart. Creatures demand wages on payday and will desert if unpaid.

### Lessons for Demon Horde

- **Breeding should produce meaningful variation, not just stat improvements.** If breeding always produces a "better" version, there's no interesting choice. If breeding produces DIFFERENT versions with trade-offs (Fire Imp vs Shadow Imp), every breeding decision becomes a strategic commitment.
- **The fusion system (3 Swarmlings -> 1 Brute) is elegant but needs more friction.** If fusion is always optimal, players will never field Swarmlings. The cost should include losing traits/mutations that don't cleanly transfer, making fusion a genuine sacrifice of known quantity for unknown potential.
- **Template/blueprint discovery should be a reward in itself.** The process of finding a great demon configuration through experimentation should feel like Pokemon's breeding chains — each generation refining toward your vision, with surprise mutations along the way.

---

## 3. Permadeath With Investment: Creating Attachment Without Frustration

The core tension: permadeath creates stakes, but losing a heavily-invested unit can feel punishing rather than dramatic. The solution is NOT to soften permadeath, but to design the investment/attachment loop so that loss is painful but recoverable.

### Reference Games

**Darkest Dungeon** — Heroes are semi-disposable by design. The Stage Coach delivers fresh recruits weekly. Upgrading heroes (skills, equipment, stress relief) costs gold, but upgrading is relatively fast. The REAL cost of permadeath is losing a hero's quirks and trinkets, not their level. Critically, Darkest Dungeon makes permadeath survivable by ensuring no single hero is irreplaceable. The roster is deep enough that losing your best Crusader hurts but doesn't end the campaign. The game communicates this explicitly: "Remind yourself that overconfidence is a slow and insidious killer."

**Battle Brothers** — Permadeath hits harder here because brothers accumulate veteran levels, perks, and equipment. Losing a level 11 veteran with perfect perks and named equipment is devastating. The game mitigates this through: (1) battles rarely kill your BEST brothers (they're strong enough to survive), (2) retreating is always an option, (3) equipment can be recovered from the dead. The injury system also creates graduated failure — a brother might survive with a permanent injury that reduces stats, creating a "walking wounded" narrative.

**XCOM** — The gold standard for "permadeath that creates stories." XCOM soldiers gain names, nicknames, customizable appearances, and class specializations over time. Losing Colonel "Deadshot" Rodriguez who carried your team through 30 missions is genuinely emotional — but XCOM ensures this loss is the player's fault (bad positioning, greedy plays) rather than random. The key insight: **permadeath must feel like consequence, not punishment.** When a death is clearly caused by a player decision, it teaches. When it's random, it frustrates.

**Rogue/Roguelike Design Philosophy** — Glenn Wichman (Rogue co-creator) argues permadeath was "never supposed to be about pain." The purpose is making decisions matter by removing the ability to undo them. The three-legged stool of roguelike design — randomization, emergent gameplay, permanent death — each depends on the others. Permadeath without randomization is just memorization. Permadeath without emergence is just frustration.

### Lessons for Demon Horde

- **The Template system is the perfect mitigation.** You lose the demon, you keep the recipe. This is exactly the right design — the KNOWLEDGE persists, the INVESTMENT must be re-made. But templates should NOT make rebuilding trivial. Rebuilding from template should cost the same resources as the original creation, making it a genuine economic decision: "Do I rebuild my proven Inferno Imp design, or try something new with these resources?"
- **Make sure the player caused the death.** Demon Horde already has personality traits that inject chaos (Pyromaniac, Coward, Berserker). These are potential death-causes the player CHOSE by fielding that demon. "My Berserker charged and died" feels fair because the player knew the risk. "Random crit killed my Behemoth" does not. Minimize pure randomness in lethality.
- **Graduated failure before death.** Injuries, morale breaks, routing — these give the player a chance to pull back before a unit dies. A wounded Behemoth that survives is a resource management problem (heal or replace?), which is more interesting than a dead Behemoth that's just gone.
- **Investment should be spread across the horde, not concentrated.** If one Behemoth has 90% of your souls invested, losing it feels campaign-ending. If your investment is distributed across a roster of 20 demons, no single loss is catastrophic. The economy should encourage breadth.

---

## 4. Template/Blueprint Systems: Preserving Knowledge While Losing Investment

How games let players retain design knowledge while still making loss meaningful.

### Reference Games

**Pokemon Breeding** — The ultimate template system. A competitive player might breed 200 Magikarp to get one perfect Gyarados. The "template" is the player's knowledge of which IVs to breed for, which nature to lock with an Everstone, which EVs to train. The knowledge is permanent, the Pokemon are expendable. This creates a satisfying loop: discover optimal build -> template it in your mind -> rebuild quickly when needed -> iterate and improve.

**Monster Hunter** — Gear loadouts serve as templates. Once you've crafted a build, you can save it and swap instantly. The COST was in the initial crafting (farming monster parts), but once paid, the template is permanent. This removes friction from the "try different approaches" loop — you can experiment freely once you've invested in the options.

**Fire Emblem Inheritance** — The breeding system IS a template system. Parent pairings are "recipes" that produce children with predictable (but not identical) outcomes. Experienced players know "Pair Unit A with Unit B to get Child C with optimal skills." The template is the pairing knowledge; the investment is in getting both parents to the right level/class.

### Lessons for Demon Horde

- **Templates should capture the DESIGN DECISIONS, not the outcome.** A template should record: base species, evolution path taken, mutations selected, personality type. It should NOT record: current stats, combat experience, veterancy bonuses. Rebuilding from template gives you the blueprint at base stats — the veterancy must be re-earned through combat.
- **Template discovery should feel like research.** When a player finds that "Fire Imp + Pyromaniac personality + Explosive mutation = devastating screen unit," saving that as a template should feel like a scientific breakthrough, not just a UI convenience.
- **Templates could have a cost to SAVE, not just to rebuild.** If saving a template is free, players will template everything. If it costs a small resource (a soul?), they must choose which designs are worth preserving. This prevents template hoarding and makes the library feel curated.

---

## 5. Pre-Raid Preparation as Strategic Puzzle

The design goal: make "get ready for the next fight" feel as engaging as the fight itself.

### Reference Games

**Darkest Dungeon** — The provision purchase screen is a puzzle with incomplete information. You know the dungeon type (Ruins, Weald, Warrens, Cove) and length (short/medium/long), which tells you the CATEGORY of threats. Ruins have undead and curios that need holy water. Warrens have disease and curios that need herbs. But you don't know the specific room layout, enemy composition, or curio placement. This creates a "hedge your bets" puzzle: bring general-purpose supplies and hope, or specialize and risk being caught unprepared. The team composition decision (which 4 heroes from your roster) is equally important — each hero's abilities map to specific challenges, and no team is good at everything.

**XCOM** — Pre-mission loadout is constrained by: what you've researched, what you've built, who's available (not wounded/fatigued), and what you know about the mission. Sending a sniper-heavy team to a close-quarters mission is a mistake, but you might not KNOW it's close-quarters until you're in it. The "fog of war" extends to strategic preparation. XCOM 2's concealment mechanic adds another layer: your initial positioning and approach matter, turning the first few turns into a setup puzzle.

**Monster Hunter** — Preparation is central. Eating a meal for buffs, selecting the right weapon type (cutting vs blunt vs ranged), bringing the right items (traps, bombs, antidotes for poison monsters), choosing the right palico loadout — each decision is a discrete, meaningful choice. The game rewards knowledge: a player who KNOWS Diablos is weak to ice and strong against fire will prepare fundamentally differently from a novice. Preparation IS the skill expression for experienced players.

### Lessons for Demon Horde

- **Settlement type should telegraph threat CATEGORY, not specifics.** A village on plains implies open terrain and militia. A mountain fortress implies chokepoints and fortifications. But the exact composition (how many archers? any heroes?) should be uncertain. This makes preparation a probability assessment.
- **Squad selection should involve genuine trade-offs.** Bringing your full-strength horde should never be optimal. Constraints could include: entry point capacity (only X squads can deploy), terrain suitability (flying demons excel in mountains, swarm demons struggle in narrow streets), resource cost of deploying (larger deployments cost more upkeep/supplies).
- **Between-raid preparation should offer transformative choices, not just incremental ones.** Choosing between "breed a new Brute" and "evolve an existing Imp to Inferno Imp" and "save resources for a potential Behemoth" should each lead to qualitatively different raid experiences, not just +5% effectiveness.

---

## 6. Campaign Layer Pressure: Making Individual Battles Matter

The design problem: in a game with many battles, how do you prevent each one from feeling like filler?

### Reference Games

**XCOM 2 — Avatar Project** — A doom counter that fills over time, pressuring the player to act. When full, a countdown begins — you have ~3 weeks to reduce it or lose. Story missions and facility raids reduce the counter. This creates urgency: you can't just grind safely forever. However, players discovered the timer was "toothless" — easy to manage once understood. The PSYCHOLOGICAL pressure was effective even when the mechanical pressure wasn't. Lesson: perceived urgency matters as much as actual urgency.

**Battle Brothers — Economic Pressure** — The campaign creates pressure through ongoing costs. Every day, your company burns gold on wages, food, and tool/medical supply consumption. Standing still is losing. This creates a "shark must swim" dynamic — you MUST take contracts and fight battles to stay solvent. The late-game scaling of wages (higher-level brothers cost more) means a veteran company is MORE expensive to maintain, preventing "farm easy fights forever" strategies. Economic pressure forces engagement with the difficulty curve.

**Rimworld — Wealth Scaling** — Raid difficulty scales with colony wealth. Every improvement you make (better weapons, nicer rooms, more food stores) increases the threat level. This creates an elegant tension: getting stronger also makes the world more dangerous. Players who hoard wealth without building defenses get crushed. The system turns resource management into a balancing act — you want enough to fight but not so much that you attract overwhelming raids.

**Darkest Dungeon — Multiple Simultaneous Pressures** — The Hamlet needs gold for building upgrades. Heroes need gold for stress relief and equipment. Expeditions need gold for provisions. You can't fund everything simultaneously. This multi-front economic pressure means every expedition must be WORTH IT — you can't afford to come home empty-handed. Failed expeditions set you back on multiple fronts, creating a compound failure state that's recoverable but painful.

### Lessons for Demon Horde

- **The world reacting to raids IS the pressure mechanism.** The GDD already describes settlements rebuilding, refugees strengthening neighbors, and awareness escalation. This is excellent — make sure these create FELT pressure. The player should notice that the village they raided 5 turns ago is now harder. They should feel the awareness meter ticking up with each attack.
- **Corruption as a race condition.** The Demon Lord manifestation at 100% corruption versus the kingdom reaching "Desperate" awareness creates a natural race. The player is trying to grow faster than the world's response. This is an inherently interesting strategic tension. Consider making corruption decay slowly when not actively raiding — creating the "shark must swim" pressure from Battle Brothers.
- **Upkeep costs for your horde.** The GDD doesn't mention ongoing upkeep for demons. Consider it: a horde of 50 demons should be more expensive to maintain than a horde of 20. This prevents "stockpile forever, deploy maximum force every time." It forces roster management decisions: keep that wounded Brute or dismiss it to save upkeep?
- **Occupation has ongoing cost.** Holding territory should require stationed squads AND resources. This creates a "spread thin" tension — occupy too many settlements and your raiding force is weakened. Occupy too few and you miss passive income.

---

## 7. Recovery/Attrition Between Fights: Creating Pacing Tension

The design problem: how do you prevent players from always entering combat at full strength (trivializing difficulty) without making them wait boringly between fights?

### Reference Games

**Battle Brothers — Injuries and Healing** — After combat, brothers may have temporary injuries (broken ribs, pierced lung, etc.) that reduce stats for several days. Medical supplies are consumed during healing. This creates a pacing rhythm: fight -> some brothers injured -> wait 2-3 days for healing -> fight again. But the economy forces you to take contracts during recovery, meaning you might fight with wounded brothers. The tension between "heal up" and "we need the money" is the game's central pacing mechanism.

**Darkest Dungeon — Stress and Quirks** — Heroes return from dungeons with accumulated stress, diseases, and negative quirks. Stress relief costs gold and takes a week (the hero is unavailable). Disease treatment costs gold. Quirk removal costs gold. This creates a ROSTER ROTATION need — you can't run the same 4 heroes every week because they need recovery time. The Abbey and Tavern buildings provide stress relief but lock heroes out for one expedition. This forces the player to maintain a deep roster rather than over-investing in 4 heroes.

**XCOM — Wound Recovery** — Wounded soldiers are unavailable for a time period proportional to damage taken. This forces roster depth — you need a bench of trained soldiers, not just one A-team. Fatigue systems (in Long War mod and XCOM 2: War of the Chosen) further enforce rotation by making even uninjured soldiers less effective after repeated deployments.

### Lessons for Demon Horde

- **Demon recovery should enforce roster rotation.** After a raid, some demons should be wounded/exhausted/corrupted. If they need time to recover, the player must maintain a deep horde rather than a small elite force. This also gives meaning to the Swarmling/Brute/Behemoth tier system: Swarmlings are expendable and quickly replaced, Behemoths take longer to heal and are more painful to lose.
- **Recovery time creates a natural pacing rhythm.** Raid -> recover -> prepare -> raid. If recovery takes 2-3 turns, the player has time for breeding/evolution between raids. This makes the management layer feel like "productive downtime" rather than waiting.
- **Attrition should be graduated, not binary.** A squad that took heavy casualties should be depleted (fewer members = less combat power) but still functional. This creates "do I raid with a depleted squad or wait?" decisions. Replenishing squad members should cost resources, tying recovery directly back to the economy.
- **Different demon tiers should recover at different rates.** Swarmlings breed fast and recover fast — they're the workhorse. Behemoths take significant resources and time to heal or replace. This naturally creates the cadence described in the GDD where Swarmlings screen for elites.

---

## 8. Army Variety and Strategic Depth

The design problem: how do you make many unit types viable without falling into rigid rock-paper-scissors?

### Reference Games

**Total War Series** — Uses layered counter systems. Infantry beats cavalry on the charge, cavalry beats archers, archers beat infantry. But within each category, heavy infantry beats light infantry head-on while light infantry outmaneuvers heavy. Terrain modifies all of this. The result is a system where the "best" army depends entirely on the battlefield and opponent. No single composition dominates across all situations.

**Overlord** — Four minion types (Brown/Red/Green/Blue) with rigid roles: Browns are melee fighters, Reds throw fireballs but die instantly in melee, Greens are invisible assassins, Blues resurrect fallen minions. The game's puzzles come from figuring out which combination of minions solves each encounter. Critically, minions can be sacrificed in the Forge to imbue the Overlord's equipment with type-specific bonuses (Browns = damage, Reds = mana, etc.), creating a resource tension between fielding minions and upgrading gear.

**Dungeon Keeper** — Army composition is determined by infrastructure. You can't recruit specific units — you build rooms that attract them. A Library attracts Warlocks (ranged magic). A Training Room attracts Dark Mistresses (melee). A Graveyard raises Vampires (elite undead). Your dungeon design IS your recruitment strategy. Some creatures are natural enemies and will fight each other if placed in the same lair, adding a management layer to composition.

### Lessons for Demon Horde

- **The GDD's composition freedom (all-swarm, all-elite, balanced) is correct, but each needs clear strategic identity.** All-swarm should feel like a locust strategy: overwhelming weak targets, struggling against prepared defenses. All-elite should feel like a scalpel: devastating against any single threat but vulnerable to attrition and multi-front battles. Balanced should feel versatile but unremarkable.
- **Counters should come from settlement design, not just unit types.** Fortified walls counter swarms (chokepoints negate numbers). Open fields counter elites (they get swarmed by militia). AoE-heavy defenders counter massed formations. This ties army composition to TARGET SELECTION — you choose your army based on where you're raiding, not just what units you have.
- **The guard system creates natural composition pressure.** If guarding is powerful (and the GDD suggests it is), then mixed compositions that can form guard chains are naturally incentivized without rigid requirements. A player who runs all-Behemoth has no screens. A player who runs all-Swarmling has nothing worth screening. The system teaches composition through play rather than rules.

---

## Summary: Key Design Principles for Demon Horde's Economy

1. **Resources should constrain OPTIONS, not just POWER.** Captives, souls, and corruption should each unlock qualitatively different strategies, not just bigger numbers.

2. **Preparation should be a puzzle with incomplete information.** Settlement types telegraph threat categories, but specific compositions remain uncertain until combat begins.

3. **Permadeath works because of the Template system.** Knowledge persists, investment does not. Rebuilding costs full price — you skip experimentation, not investment.

4. **Economic pressure should create a "shark must swim" dynamic.** Horde upkeep, corruption decay, and awareness escalation should prevent turtling. Standing still should be losing.

5. **Recovery/attrition should enforce roster depth.** Wounded demons need healing time, depleted squads need replenishment, and different tiers recover at different rates. This prevents fielding the same optimal force every raid.

6. **Army composition should be driven by target selection.** Different settlements reward different compositions, making the world map a menu of strategic puzzles rather than a difficulty ladder.

7. **The breeding system should produce VARIETY, not just QUALITY.** Evolution branches, mutation trade-offs, and personality traits should make every demon meaningfully different. "Better" should always mean "better at THIS," not universally superior.

8. **Investment should be distributed, not concentrated.** The economy should discourage putting all souls into one Behemoth. Broad investment across a diverse horde is more interesting (and more resilient to permadeath) than narrow investment in a single unit.
