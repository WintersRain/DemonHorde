# Demon Horde — Project Instructions

## Design Philosophy

**Mechanics before content. Always.** This genre (turn-based squad tactics) is boring if the underlying decision space isn't interesting. Never implement content (unit types, abilities, stat blocks, flavor text) until the mechanical system that content plugs into is designed, tested, and proven fun.

### Priority Order
1. **Core mechanics** — What decisions does the player make each turn? What makes those decisions interesting? What are the trade-offs?
2. **Systems design** — How do mechanics interact? Where does emergent complexity come from?
3. **Prototype & test** — Build the minimum to validate the mechanic feels good
4. **Content** — Only after the system works, fill it with unit types, abilities, etc.

### Anti-Patterns to Avoid
- Pumping out unit types, abilities, or stat blocks before the combat system is mechanically deep
- Adding surface-level polish (animations, art, UI) to distract from shallow gameplay
- Treating the GDD themes as design — "guard system" is a theme, not a mechanic until the actual rules are specified
- Narrowly focusing on one system when the problem space is wide (combat, economy, world map strategy, breeding — all interconnected)

## Current State
- **Engine:** Godot 4.6 (GDScript)
- **Prototype:** Basic combat grid with move + attack. Functional but mechanically shallow.
- **GDD:** `GDD.md` — covers vision/themes but needs mechanical depth

## Key Design Questions (Unresolved)
- What makes turn-to-turn decisions interesting?
- How do squad composition choices create meaningful trade-offs in combat?
- How does the guard system actually work mechanically (not just "intercepts attacks")?
- What is the action economy? (actions per turn, action types, costs)
- How do abilities interact with positioning, squad size, and guard relationships?
- What makes the AI challenging without being unfair?
- How does the breeding/evolution system feed back into combat in a way that matters?
- What makes raiding different settlements feel mechanically different (not just stat scaling)?
