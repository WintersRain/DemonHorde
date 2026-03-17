# Demon Horde — Mechanical Specification v1

This document defines RULES, not themes. Every mechanic has numbers and logic.

---

## 1. Battle Flow: Three Phases Per Round

### Command Phase (Player-Controlled, Turn-Based)
- Player sets **intent** for each squad: target position, target enemy, target building, or stance (hold/retreat)
- Player can adjust guard assignments
- Player can set squad-level behavior override: "aggressive" (loosen cohesion, prioritize damage), "cautious" (tighten cohesion, prioritize survival), "default" (personality-driven)
- No time pressure — think as long as you want
- 3-6 player squads per battle (hard cap)

### Execution Phase (Simultaneous, Real-Time ~5-10 seconds)
- All demons (player + enemy) move and act simultaneously
- Movement via boid rules + personality weights
- Combat resolves continuously: demons attack when in range of enemies
- Loot scatters when buildings break or demons die
- Personality triggers fire based on environment
- Player can **pause** to observe but NOT change orders mid-execution
- Phase ends when: all movement settles, OR a time limit (~8 seconds of game-time) elapses

### Resolution Phase (Automatic)
- Dead removed, loot tallied
- Morale checks per squad
- Cohesion recalculated
- Check win/loss conditions
- → Back to Command Phase

---

## 2. Demon Entity

Each demon is an individual with:

```
Position:       Vector2 (continuous space)
HP:             int (per individual, e.g., 8 for an imp)
Personality:    enum (Pyromaniac, Coward, Greedy, Berserker, Loyal)
Squad:          reference to parent squad
State:          enum (Following, Looting, Fleeing, Berserk, Dead)
Inventory:      Array of loot items (max capacity based on tier)
Velocity:       Vector2 (current movement vector)
Attack Cooldown: float (time until next attack)
```

### Tier Differences (per individual demon)

| Stat | Swarmling | Brute | Behemoth |
|---|---|---|---|
| HP | 5-10 | 20-40 | 80-150 |
| Attack | 3-5 | 8-15 | 25-50 |
| Defense | 1-2 | 4-8 | 10-20 |
| Speed | 80-120 px/s | 50-80 px/s | 30-50 px/s |
| Attack Range | 20px (melee) | 30px (melee) | 50px (reach) |
| Attack Cooldown | 0.8s | 1.2s | 2.0s |
| Loot Capacity | 1 | 3 | 5 |
| Visual Size | 6-8px radius | 12-16px radius | 24-32px radius |

---

## 3. Boid Movement System

Each demon's velocity is computed from weighted steering forces:

```
velocity = (
    separation * W_SEP +
    alignment  * W_ALI +
    cohesion   * W_COH +
    intent     * W_INT +
    personality_force * W_PERS +
    avoidance  * W_AVOID
) normalized * speed
```

### Base Weights (Swarmling defaults)

| Force | Weight | Description |
|---|---|---|
| Separation | 1.5 | Don't crowd neighbors (radius: 15px) |
| Alignment | 1.0 | Match squad-mates' heading |
| Cohesion | 1.2 | Steer toward squad center |
| Intent | 2.0 | Steer toward squad's commanded target |
| Personality | 0.0-3.0 | Variable, based on triggers (see below) |
| Avoidance | 3.0 | Avoid walls/buildings (radius: 20px) |

### Personality Weight Modifiers

Personality forces ACTIVATE when trigger conditions are met:

**Greedy:**
- Trigger: loot item within 100px
- Force: steer toward nearest loot (W_PERS = 2.5)
- State change: Following → Looting
- Exit: inventory full OR no loot within 150px → return to Following
- Cohesion drops to 0.3 while Looting

**Coward:**
- Trigger: squad HP below 50% OR enemy within 60px and demon HP below 50%
- Force: steer away from nearest enemy (W_PERS = 3.0)
- State change: Following → Fleeing
- Exit: no enemies within 200px → return to Following
- Speed bonus: +40% while Fleeing

**Berserker:**
- Trigger: any enemy within 120px
- Force: steer toward nearest enemy, ignoring squad intent (W_PERS = 3.0, W_INT = 0.5)
- State change: Following → Berserk
- Exit: no enemies within 200px → return to Following
- Attack bonus: +30% damage while Berserk
- Cohesion drops to 0.2 while Berserk

**Pyromaniac:**
- Trigger: adjacent to building or flammable terrain
- Force: steer toward nearest flammable thing (W_PERS = 1.5)
- Effect: sets fires on contact (fire spreads to adjacent tiles)
- Does NOT change state — still follows orders, just... sets fires along the way

**Loyal:**
- No personality force. Cohesion increased to 2.0.
- Never changes state except via morale.

### Tier Modifiers to Boid Weights

| Tier | Cohesion | Separation | Alignment |
|---|---|---|---|
| Swarmling | 1.2 | 1.5 | 1.0 |
| Brute | 1.0 | 2.0 | 0.8 |
| Behemoth | 0.5 | 3.0 | 0.3 |

Behemoths barely flock — they're too big and independent. Swarmlings are tight clusters. Brutes are somewhere between.

---

## 4. Squad (Command Structure)

A squad is NOT a unit. It's a grouping that provides:

```
Squad:
    name:           String
    members:        Array[DemonEntity]
    intent_target:  Vector2 or Entity reference
    intent_type:    enum (Move, Attack, Breach, Hold, Retreat)
    behavior:       enum (Aggressive, Cautious, Default)
    guarding:       Squad reference (nullable)
    cohesion:       float (0.0-1.0, computed from member positions)
```

### Cohesion Calculation
```
squad_center = average position of all living members
max_spread = 150px (swarmling), 100px (brute), 80px (behemoth)
cohesion = 1.0 - (average_distance_from_center / max_spread)
clamped to 0.0-1.0
```

### Cohesion Effects
| Cohesion | Effect |
|---|---|
| 0.8-1.0 | Full squad buffs (morale bonus, guard effectiveness 100%) |
| 0.5-0.8 | Reduced guard effectiveness (50%), slight morale penalty |
| 0.2-0.5 | Squad is "scattered" — no guard benefits, morale drops fast |
| 0.0-0.2 | Squad is "broken" — members act independently, morale check vs rout |

---

## 5. Guard System (Spatial)

Guard squads project a **zone of control** around their guarded squad.

```
guard_zone_radius = 60px (swarmling), 80px (brute), 100px (behemoth)
guard_zone_center = midpoint between guard squad center and guarded squad center
```

### Guard Mechanics
- Enemies entering the guard zone are **engaged**: guard demons steer toward them (intent overridden)
- Engaged enemies have movement speed reduced by 30%
- Guard demons get +20% defense while in guard zone
- If guard squad cohesion drops below 0.5, guard zone collapses — guarded squad is exposed

### Guard as Spatial Puzzle
- Guard zone is a physical area on the battlefield, not abstract
- Player must position guard squads so the zone covers the right angles
- Multiple guard squads can overlap zones (stacking engagement)
- Flanking WORKS by attacking from outside the guard zone

---

## 6. Combat Resolution

### Attack Logic (per demon, during execution)
```
if enemy within attack_range and attack_cooldown <= 0:
    deal (attack - target.defense) damage, minimum 1
    reset attack_cooldown
    if target.HP <= 0:
        target dies
        if target had loot: scatter loot in radius
```

### Damage Types (squad-level modifier applied to all members)
- **Standard**: no modifier
- **Cleave**: hits up to 3 enemies in range simultaneously, 60% damage each
- **Anti-Horde**: +2% damage per enemy within 80px of target (rewards attacking clusters)
- **Precision**: +50% damage to targets with max HP > 50 (anti-elite)

### Death
- Demon dies → removed from squad, drops inventory as loot items at position
- Loot items scatter in 30px radius from death position
- Nearby Greedy demons within 100px get triggered

---

## 7. Loot System

### Loot Items
```
LootItem:
    position:   Vector2
    value:      int (1-10)
    type:       enum (Coin, Gem, Supply, Captive)
    picked_up:  bool
```

### Loot Sources
- Buildings contain loot (generated per building type)
- Dead enemies drop loot
- Dead demons drop their carried loot

### Loot Collection
- Demon walks over loot item → auto-collect if inventory not full
- Greedy demons detour to collect loot (personality force)
- Non-Greedy demons only collect if loot is directly on their path (within 10px)

### Post-Battle
- Total loot = sum of all loot carried by surviving demons
- Loot on the ground at battle end = lost (incentivizes keeping demons alive)
- Dead demon's loot is recoverable IF another demon picked it up

---

## 8. Morale System

Each squad has morale (0-100, starts at base value).

### Morale Modifiers Per Resolution Phase
| Event | Morale Change |
|---|---|
| Squad member killed | -3 per death |
| Enemy squad routed | +10 |
| Squad cohesion < 0.5 | -5 per round |
| Guard squad destroyed | -15 to guarded squad |
| Behemoth present in army | +5 to all friendly squads |
| Behemoth killed | -10 to all friendly squads |
| Surrounded (enemies on 3+ sides) | -10 |
| Building on fire nearby (ally) | -5 (humans), +5 (demon Pyromaniacs) |

### Morale Thresholds
| Morale | Effect |
|---|---|
| 70-100 | Normal |
| 40-70 | Shaken: -10% attack, +10% chance per demon to hesitate (skip attack) |
| 20-40 | Wavering: -25% attack, Cowards flee, cohesion penalty |
| 0-20 | Routing: Squad breaks. All demons flee toward map edge. Can be rallied if morale recovers above 30. |

### Asymmetric Morale
- **Demons** start at 60 morale, GAIN morale from chaos (fires, kills, loot)
- **Humans** start at 80 morale, LOSE morale from chaos, GAIN from formation/heroes
- This means terror tactics are viable: burn buildings, kill visibly, break formations → enemies rout without you killing them all

---

## 9. Terrain & Buildings

### Arena Space
- Continuous 2D space, ~1200x800 pixels (scalable)
- Buildings placed on a coarse grid (64px cells) but demons move freely
- Walls are line segments that block movement and LOS

### Building Types
| Building | Contents | Tactical Role |
|---|---|---|
| House | 1-3 loot | Filler, cover |
| Market | 5-8 loot | Loot magnet (Greedy trap) |
| Barracks | 0 loot, spawns defenders | Must neutralize early |
| Granary | 3-5 supply loot | Food = captive conversion |
| Temple | 0 loot | Morale aura for defenders (+10 in radius) |
| Wall Segment | - | Blocks movement, must breach |
| Gate | - | Choke point, can be opened or destroyed |

### Destructible Buildings
- Buildings have HP (100-300 based on type)
- Behemoths can smash buildings in melee
- Fire damage over time (Pyromaniacs!)
- Destroyed building scatters its loot onto surrounding tiles

---

## 10. Settlement Generation

### Layout Templates (per size)

**Hamlet (1 approach vector):**
- 4-6 buildings, no walls
- Open field with scattered structures
- Player squads: 1-3

**Village (1-2 approach vectors):**
- 8-15 buildings, palisade wall with 1-2 gates
- Central square, buildings clustered
- Player squads: 2-4

**Town (2-3 approach vectors):**
- 20-30 buildings, stone walls, 2-3 gates
- Districts: residential, market, military
- Player squads: 3-5

**City (3 approach vectors):**
- 40+ buildings, layered walls, inner keep
- Multiple districts, multi-stage assault
- Player squads: 4-6

### Generation Rules
1. Place walls/gates from template
2. Place key buildings (barracks, temple, keep) at template-defined positions
3. Fill remaining slots with houses/markets/granaries using weighted random
4. Place roads connecting gates to key buildings
5. Scatter loot inside buildings based on type

---

*Spec Version: 1.0*
