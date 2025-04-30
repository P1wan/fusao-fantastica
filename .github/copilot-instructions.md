# GitHub Copilot Custom Instructions for **Fusão Fantástica**

> These guidelines shape Copilot Chat answers and inline completions for this repository.

- **Language & Engine**  
    Use **GDScript 4** (typed syntax) for every code example; avoid C#, C++ or pseudo‑code.
- **Project Layout Awareness**  
    Assume the canonical structure:

```
    src/
        scenes/
        scripts/
    assets/
        sound/
            music/
            sfx/
        sprites/
            characters/
            enemies/
            effects/
            tileset/
            UI/
    docs/
        assets/
        scripts/
    config/
    .github/
    .godot/
    .vscode/

```

    Reference assets with `res://assets/…` paths, never absolute OS paths.
- **Naming & Style**  
    * Files and variables → `snake_case`  
    * Classes and singletons → `PascalCase`  
    * Indent with **tab**, keep lines ≤ 100 chars, favour explicit typing.
- **Gameplay Text & Comments**  
    All UI text **must be Portuguese (pt‑BR)** for now; keep code comments in clear English.
- **Asset Conventions**  
    Sprite suggestions = **32 × 32 px** grid.
- **Node Usage**  
    Prefer Godot built‑ins (`CharacterBody2D`, `Area2D`, signals) before writing custom physics.
- **Serialization**  
    Use `@export` for editable fields; expose only what designers need.
- **Input**  
    Reference actions from `config/input_map.cfg` instead of hard‑coding key codes.
- **Testing**  
    When asked, scaffold tests with Godot’s `UnitTest` framework in `src/tests`.
- **Performance Tips**  
    Mention `tile_set` atlasing, signal‑based decoupling, and memory‑friendly textures; avoid premature micro‑optimisation.
- **Commit Messages**  
    Follow **Conventional Commits** (e.g., `feat: add Rafa crawl animation`).
    Add any changes to docs/CHANGELOG.md when commits are made.
- **Localisation Hooks**  
    Demonstrate `tr()` and `.po` workflow under `assets/locale/`.
- **Dependency Policy**  
    Stick to **vanilla Godot**; do **not** propose external libraries unless explicitly requested.
- **Content Safety**  
    Never output proprietary or license‑restricted code/assets; cite open‑source licences where relevant.

<!-- End of custom instructions -->