### Overview

Fusão Fantástica is a **2‑D pixel‑art platformer** created with **Godot 4.3** that helps **Brazilian children aged 9 ‑ 10** build empathy for people with different body types. Players control **Rafa, Bia and Tonico**, three classmates whose essences have merged into a single heroic form. By swapping between their original bodies—and the distinct abilities each body provides—kids learn that every physique has strengths and limits.

### Key Features

- **Swap‑on‑the‑fly** between three characters, each with unique movement & interaction skills.
- **Contextual empathy bubbles**: colour‑coded speech balloons highlight the value of each body type when challenges arise.
- **Progressive learning curve** across forest, cavern and tower biomes.
- **Short development phases** to keep scope realistic for an academic schedule.

### Folder Structure

```
FusaoFantastica/
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

### Prerequisites

| Tool             | Version            | Notes                                     |
| ---------------- | ------------------ | ----------------------------------------- |
| **Godot Engine** | 4.3 alpha or newer | Cross‑platform editor & runtime           |
| **VS Code**      | Latest             | Optional, for script editing with Copilot |
| **Git**          | 2.40+              | Clone & contribute                        |

> 💡 *Tip:* Enable the **Godot Tools** VS Code extension for auto‑completion and scene file preview.

### Installation (Local Development)

```bash
# 1 – Clone the repository
$ git clone https://github.com/your‑org/FusaoFantastica.git
$ cd FusaoFantastica

# 2 – Initialise Godot (first run generates .godot/)
$ godot4 -e  # opens the editor so you can set export templates later

# 3 – Run the game
$ godot4
```

If you prefer the GUI, simply **double‑click **`` after cloning.

> ❗ Remember to install Godot **export templates** via the editor’s *Project > Install Export Templates* menu before creating distributables.

### Roadmap

Phase 1 (tutorial) ▶ Phase 2 (levels 1‑3) ▶ Polish & localisation (PT‑BR ➜ EN).

### License

`MIT` by default—update once final asset credits are confirmed.

