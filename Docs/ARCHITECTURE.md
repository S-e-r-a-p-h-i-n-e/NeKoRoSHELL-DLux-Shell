# Architecture

This document describes the current architecture of the Quickshell configuration.

The shell is **layout-driven and data-configured** — bar structure is defined by JSON, appearance is controlled by JSON, and QML files are responsible only for behaviour and rendering, not for hardcoded values.

---

## Structure

```
quickshell/
 ├ shell.qml          ← entry point
 ├ config.json        ← behaviour config
 ├ style.json         ← appearance config
 ├ globals/           ← singletons available everywhere
 ├ engine/            ← bar construction machinery
 ├ layouts/           ← JSON layout definitions
 ├ modules/           ← individual bar widgets
 ├ components/        ← reusable visual primitives
 └ panels/            ← overlay surfaces (dashboard, settings, tray)
```

---

## Layers

```
shell.qml
 └ globals/          (Config, Style, Colors — read by everything)
 └ engine/           (reads layouts/, instantiates modules/)
     └ modules/      (widgets — backend + optional *View.qml)
         └ components/  (drawing primitives used by panels and custom views)
 └ panels/           (overlay surfaces, use Panel.qml + components/)
```

---

## Configuration Files

There are two user-facing JSON files at the repo root. Both are live-reloading via `FileView` — changes take effect immediately without restarting.

### `config.json` — behaviour

Controls how the bar acts.

```json
{
  "navbarLocation": "top",
  "enableBorders": true,
  "activeLayout": "default"
}
```

| Key              | Description                                      |
| ---------------- | ------------------------------------------------ |
| `navbarLocation` | Where the bar sits: `top`, `bottom`, `left`, `right` |
| `enableBorders`  | Whether screen border decorations are shown      |
| `activeLayout`   | Which file in `layouts/` to load                 |

Parsed by `globals/Config.qml`.

### `style.json` — appearance

Controls how the bar looks.

```json
{
  "barSize": 50,
  "moduleSize": 28,
  "barFont": "JetBrainsMono Nerd Font",
  "barPadding": 12,
  "slotSpacing": 8,
  "pillPadding": 16,
  "pillSpacing": 6,
  "pillOpacity": 0.6,
  "chipSpacing": 6,
  "chipInnerSpacing": 5,
  "borderWidth": 10,
  "cornerRadius": 20
}
```

| Key               | Description                                        |
| ----------------- | -------------------------------------------------- |
| `barSize`         | Full bar thickness in px                           |
| `moduleSize`      | Thickness of individual modules/chips              |
| `barFont`         | Font family used across all bar text               |
| `barPadding`      | Margin between the bar edge and the first module   |
| `slotSpacing`     | Gap between modules within a slot                  |
| `pillPadding`     | Horizontal/vertical padding inside a pill group    |
| `pillSpacing`     | Gap between modules inside a pill group            |
| `pillOpacity`     | Background opacity of pill groups                  |
| `chipSpacing`     | Gap between chip items in DynamicChip              |
| `chipInnerSpacing`| Gap between icon and label inside a chip           |
| `borderWidth`     | Thickness of screen border edges                   |
| `cornerRadius`    | Radius of screen border corners                    |

Parsed by `globals/Style.qml`.

---

## `/globals`

Singletons registered in `globals/qmldir` and available to every QML file in the project without a local import path.

| Singleton    | Responsibility                                                  |
| ------------ | --------------------------------------------------------------- |
| `Config`     | Behaviour values from `config.json` + `isHorizontal` derived property |
| `Style`      | Appearance values from `style.json` with hardcoded defaults     |
| `Colors`     | Theme colors from wallust (`~/.cache/wallust/colors.json`)      |
| `Animations` | Shared animation durations and easing curves                    |
| `Time`       | Reactive time/date strings                                      |
| `EventBus`   | Cross-module signal bus (panel open/close events etc.)          |

`Config` and `Style` are the distinction between *how the bar behaves* and *how it looks*. Neither should contain logic belonging to the other.

---

## `/engine`

The machinery that reads a layout file and constructs the bar. You don't touch engine files to add features — only if the bar's structural behaviour needs to change.

### Files

| File                | Responsibility                                                       |
| ------------------- | -------------------------------------------------------------------- |
| `LayoutLoader.qml`  | Reads the active layout JSON, creates a `PanelWindow` per screen, positions three `BarSlot` instances (left/center/right) for each orientation |
| `SlotLayout.qml`    | Receives a module list, renders them as a `Row` or `Column`, resolves each entry as either a `PillGroup` (array) or a bare module (string) |
| `PillGroup.qml`     | Wraps a group of modules in a pill-shaped background, injects `inPill: true` into chip-based modules |
| `ModuleRegistry.qml`| Maps module name strings to their `Component`. Acts as a lookup table — add new modules here |

### Flow

```
config.json (activeLayout)
    ↓
LayoutLoader — reads layouts/<name>.json
    ↓
SlotLayout (left / center / right)
    ↓
  string entry → ModuleRegistry.resolve() → Loader → module
  array entry  → PillGroup → ModuleRegistry.resolve() → Loader → module
```

### Prop injection

The engine injects three props into every loaded module via `Binding`:

| Prop           | Value                  |
| -------------- | ---------------------- |
| `isHorizontal` | `Config.isHorizontal`  |
| `barThickness` | `Style.moduleSize`     |
| `inPill`       | `true` (pill only, guarded with `hasOwnProperty`) |

Modules must declare these props to receive them. Custom views that don't use chip components don't need `inPill`.

---

## `/layouts`

Pure JSON data. No logic, no QML. Each file describes what goes in the left, center, and right slots of the bar.

```json
{
  "left": ["workspaces"],
  "center": ["clock"],
  "right": ["tray", "notifications", "settings", "power"]
}
```

A module name string resolves directly to a module. An array of strings creates a pill group:

```json
{
  "left": ["workspaces"],
  "center": [["clock", "cava"]],
  "right": ["tray", ["audio", "network", "status"]]
}
```

Switch layouts by changing `activeLayout` in `config.json`. Multiple layout files can coexist.

---

## `/modules`

Each subfolder is a self-contained widget. Most modules follow one of two patterns:

### Pattern A — backend only (most modules)

```
module-name/
 ├ ModuleName.qml   ← singleton: data, state, IPC
 └ qmldir
```

The module exposes data as reactive properties. The engine renders it using `DynamicChip` or `StaticChip` via `ModuleRegistry` — no frontend QML needed. Examples: `audio`, `network`, `power`, `updates`, `tray`, `notifications`.

### Pattern B — backend + custom view

```
module-name/
 ├ ModuleName.qml      ← singleton: data, state
 ├ ModuleNameView.qml  ← custom visual logic
 └ qmldir
```

Used when the module's bar appearance is too complex for a chip pattern — custom layout, animation, interaction, or per-orientation rendering that can't be expressed through item descriptors. Examples: `clock`, `media`, `workspaces`, `cava`.

Custom views own their visual logic entirely. They don't import `qs.components` and don't depend on `Chip` or `IconButton` — they inline whatever primitives they need. This keeps the component layer out of module internals.

---

## `/components`

Reusable visual primitives. These know how to draw things but nothing about what they're displaying.

| Component          | Used by             | Description                                              |
| ------------------ | ------------------- | -------------------------------------------------------- |
| `DynamicChip`      | Engine (most modules) | Renders a list of `{ icon, label, bgColor, onClicked }` item descriptors as chips. Handles horizontal/vertical layout and `inPill` transparency |
| `StaticChip`       | Engine (icon-only modules) | Single circular icon button driven by one item descriptor. Handles active state |
| `Chip`             | Panels, custom views  | Icon + label pill. The base read-only display primitive  |
| `IconButton`       | Panels              | Circular icon button with active state and signals       |
| `Button`           | Panels              | Text/label button for settings UI                        |
| `Toggle`           | Panels (Settings)   | On/off toggle with label                                 |
| `Panel`            | Panels              | Sliding overlay window with tension fillets and dismiss overlay |
| `AnimatedElement`  | Panels              | Wraps content with slide/scale/fade entrance animation   |
| `ScreenBorder`     | shell.qml           | Renders thin border + rounded corners around each screen |
| `ScrollText`       | Media module        | Clipping text that scrolls when content overflows        |

### Component tiers

There are two tiers in practice:

**Engine components** (`DynamicChip`, `StaticChip`) — these are the engine's rendering contract with backend-only modules. A module's backend returns item descriptors; the engine passes them here.

**UI components** (`Chip`, `IconButton`, `Button`, `Toggle`, `Panel`, `AnimatedElement`) — used by panels and settings UI. Custom `*View.qml` modules should not depend on these; they should inline what they need.

---

## `/panels`

Full overlay surfaces that appear on top of the bar. Each panel uses `Panel.qml` as its window container and is toggled via `EventBus`.

| Panel          | Description                                      |
| -------------- | ------------------------------------------------ |
| `Dashboard`    | System overview overlay                          |
| `Settings`     | Bar configuration (location, layout, borders)    |
| `TrayPanel`    | Expanded system tray                             |

Panels are opened/closed by emitting `EventBus.togglePanel(panelId)` from any module or component.

---

## Design Decisions

### Config vs Style separation

`config.json` owns behaviour (where is the bar, which layout). `style.json` owns appearance (how big, what font, what spacing). Keeping these separate means you can swap fonts or sizing without touching anything that affects bar structure, and vice versa.

### Backend-only modules

Most modules don't need a `*View.qml`. The engine's chip pattern handles rendering entirely from data — the module just exposes reactive properties and item descriptors. This keeps module code focused on system integration rather than UI.

### Custom views own their visuals

When a module does need a custom view, it owns its visual logic completely and doesn't depend on shared chip components. This means `Chip` and `IconButton` stay as panel/settings primitives rather than leaking into module internals.

### Live reloading

`config.json`, `style.json`, and `Colors` (wallust) all use `FileView` with file watching. Any change to these files takes effect immediately without restarting the shell.
