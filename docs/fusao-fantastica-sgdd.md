 # Fusão Fantástica – Structured Game Design Document (SGDD)

## 1. Purpose
Educational 2‑D pixel‑art platformer that nurtures empathy for different body types among children aged 9 – 10.

## 2. Target Audience
- **Primary:** Brazilian children (9 – 10 years) – Portuguese localisation first.
- **Secondary:** Educators & parents – English localisation planned post‑launch.

## 3. High‑Level Concept
During recess, three friends—**Rafa**, **Bia** and **Tonico**—accidentally fall through a portal into the **Realm of Elron**. Their essences fuse into a single body hosting all three minds. Guided by the wizard **Mestre Elron**, they must cooperate—literally—by swapping control among their forms, solving challenges that celebrate each child’s strengths, to recover shards of a *Crystalline Mirror* and return home.

## 4. Core Design Pillars
1. **Empathy Through Mechanics** – Progress requires recognising and leveraging each body‑type’s advantages.
2. **Short, Rewarding Challenges** – Bite‑sized puzzles fit classroom or home play sessions.
3. **Colourful, Inclusive Aesthetic** – Friendly pixel‑art, readable silhouettes, colour‑blind‑safe palette.

## 5. Playable Characters
| Kid | Visual Key | Strengths | Trade‑offs |
|-----|-----------|-----------|-------------|
| **Rafa** | Short; yellow shirt & backwards cap | Fastest, smallest hitbox, bounces on enemies without damage, crawls 1‑tile gaps | Weakest attack
| **Bia** | Tall; blue overalls, curly hair, glasses | Highest jump, ledge grab + climb, stomp briefly stuns foes | Average speed
| **Tonico** | Broad; red shirt, large arms | Blocks single hit, pushes heavy objects & enemies | Slowest, low jump

## 6. Core Mechanics
- **Character Swap:** Press dedicated buttons to cycle instantly between Rafa, Bia and Tonico.
- **Contextual Empathy Bubbles:** Colour‑coded speech balloons trigger near challenges, voicing admiration among the kids.
- **Adaptive Hint System:** Lingering too long near a puzzle spawns a gentle hint (text + simple icon).
- **Shared Health:** Single heart pool encourages mindful swaps rather than sacrificing “weaker” forms.

## 7. Level Progression & Scope
| Phase | Biome / Level | Learning Goal | Due Date |
|-------|---------------|---------------|----------|
| **Phase 1** | **Forest Tutorial** (4 sections) | Introduce individual abilities & swaps | **15 May 2025** |
| | Forest Level 1 | Combine abilities in short sequence | **20 May 2025** |
| **Phase 2** | Caverns Level 2 | Verticality, lighting hazards, advanced combos | **27 May 2025** |
| | Tower Level 3 | Non‑linear labyrinth, timed swaps, boss puzzle | **30 May 2025** |
| | Polish + QA | Optimisation, localisation stub, educator checklist | **02 Jun 2025** |

## 8. Art & Audio Direction
*Baseline data only, project may differ
- **Native Resolution:** 320 × 180; 32 × 32 tiles (characters up to 64 × 64).
- **Palette:** limited color master palette (see `/docs/assets/palette.png`).
- **Animation:** 8 fps idle loops; 12 fps movement.
- **Music:** CC0 Music
- **SFX:** Distinct swap “whoosh”, ability cues, ambient layers per biome.

## 9. User Interface & Accessibility
- Minimal HUD: Shared hearts, colour circles representing selected child.
- Colour‑blind‑safe palette alternatives (palette swap shader).
- Font scaling + narrated hints toggle.

## 10. Educational Goals & Classroom Assessment
| Design Element | Intended Outcome |
|----------------|-----------------|
| Swap Puzzles | Reinforce respect for differing abilities. |
| Empathy Bubbles | Model positive peer feedback. |
| Hint System | Encourage reflection, reduce frustration. |
Teachers can discuss puzzle solutions, asking students which child best solved each obstacle and why.

## 11. Tech & Tooling
- **Engine:** Godot 4.3 (GDScript).
- **IDE:** VS Code + GitHub Copilot.
- **Art:** Aseprite & Krita with AI mock‑ups (Stable Diffusion or ChatGPT) as under‑paint.
- **Version Control:** Git (GitHub Classroom); optional GitHub Actions for CI builds & web export.
- **Target Platforms:** Windows & WebGL (school laptops / browser play).

## 12. Timeline (Milestones)
| Date | Milestone |
|------|-----------|
| 30 Apr 2025 | Development kick‑off, repo initialised |
| 07 May 2025 | Character‑swap prototype complete |
| 15 May 2025 | **Phase 1 delivery** (Tutorial build) |
| 20 May 2025 | Forest Level content lock |
| 27 May 2025 | Caverns Level complete |
| 30 May 2025 | Tower Level complete & feature freeze |
| 02 Jun 2025 | **Final submission** to course |

## 13. Risks & Mitigation
| Risk | Mitigation |
|------|-----------|
| Scope creep beyond 3 levels | Strict level cap; reusable mechanics. |
| AI art inconsistency | Manual pixel pass over every mock‑up. |
| Performance (WebGL) | Optimise tilemaps; enable Godot static batching.
| Tight timeline | Weekly sprint reviews; cut non‑essential polish if needed. |

## 14. Repository Structure

```
fusao-fantastica/
├── src/
│   ├── scenes/
│   └── scripts/
├── assets/
│   ├── sound/
│   │   ├── music/
│   │   └── sfx/
│   └── sprites/
│       ├── characters/
│       ├── enemies/
│       ├── effects/
│       ├── tileset/
│       └── UI/
├── docs/
│   ├── scenes/
│   ├── scripts/
│   └── assets/
└── config/
```

## 15. Immediate Next Steps
1. Initialise Git repository & push baseline Godot project.
2. Commit limited color palette & starter tileset.
3. Implement input map & swap logic prototype.
4. Grey‑box Forest tutorial; gather playtest feedback.
5. Produce storyboard thumbnails for intro cut‑scene.
---

*Keep this SGDD updated as development progresses – all subsequent design changes must be mirrored here and in task tracking.*

