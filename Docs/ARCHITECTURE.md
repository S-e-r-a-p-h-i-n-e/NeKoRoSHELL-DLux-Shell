# Architecture

This document describes the current architecture of this Fork of NeKoRoSHELL-DLux-Shell.

The shell is **layout-driven and data-configured** — bar structure is defined by JSON, appearance is controlled by JSON, and QML files are responsible only for behaviour and rendering, not for hardcoded values.

---

## Structure

```
quickshell/
 ├ shell.qml          ← entry point
 ├ config.json        ← behaviour config
 ├ style.json         ← appearance config
 ├ globals/           ← singletons available everywhere
 ├ engine/            ← bar and dashboard construction machinery
 ├ layouts/           ← JSON layout definitions
 ├ modules/           ← individual bar widgets
 ├ components/        ← reusable visual primitives
 └ panels/            ← overlay surfaces (dashboard, settings)
```

---

## Layers

```
shell.qml
 └ globals/          (Config, Style, Colors — read by everything)
 └ engine/           (reads layouts/, instantiates modules/, drives dashboard)
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

| Key              | Description                                          |
| ---------------- | ---------------------------------------------------- |
| `navbarLocation` | Where the bar sits: `top`, `bottom`, `left`, `right` |
| `enableBorders`  | Whether screen border decorations are shown          |
| `activeLayout`   | Which file in `layouts/` to load                     |

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
  "cornerRadius": 20,
  "panelWidth": 400,
  "panelHeight": 500,
  "panelRadius": 15,
  "panelPadding": 25
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
| `panelWidth`      | Width of overlay panels in px                      |
| `panelHeight`     | Height of overlay panels in px                     |
| `panelRadius`     | Corner radius of overlay panels                    |
| `panelPadding`    | Inner padding of overlay panels                    |

Parsed by `globals/Style.qml`.

---

## `/globals`

Singletons registered in `globals/qmldir` and available to every QML file in the project without a local import path.

| Singleton    | Responsibility                                                        |
| ------------ | --------------------------------------------------------------------- |
| `Config`     | Behaviour values from `config.json` + `isHorizontal` derived property |
| `Style`      | Appearance values from `style.json` with hardcoded defaults           |
| `Colors`     | Theme colors from wallust                                               |
| `Animations` | Shared animation durations and easing curves                          |
| `Time`       | Reactive time/date strings                                            |
| `EventBus`   | Cross-module signal bus (panel open/close events etc.)                |

`Config` and `Style` are the distinction between *how the bar behaves* and *how it looks*. Neither should contain logic belonging to the other.

---

## `/engine`

The machinery that reads a layout file, constructs the bar, and drives the dashboard. You don't touch engine files to add features — only if the bar's or dashboard's structural behaviour needs to change.

### Files

| File                   | Responsibility                                                       |
| ---------------------- | -------------------------------------------------------------------- |
| `LayoutLoader.qml`     | Reads the active layout JSON, creates a `PanelWindow` per screen, positions three `BarSlot` instances (left/center/right) for each orientation |
| `SlotLayout.qml`       | Receives a module list, renders them as a `Row` or `Column`, resolves each entry as either a `PillGroup` (array) or a bare module (string) |
| `PillGroup.qml`        | Wraps a group of modules in a pill-shaped background, injects `inPill: true` into chip-based modules |
| `ModuleRegistry.qml`   | Single registry for all renderable components. `resolve(name)` maps module names to navbar components; `resolveWidget(id)` maps widget ids to dashboard card components |
| `DashboardEngine.qml`  | Owns the dashboard grid packer, placement algorithm, widget registry (`widgetDefs`), active widget list, edit mode state, and `add`/`remove`/`move` operations. Pure logic — no visual output |

### Navbar flow

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

### Dashboard flow

```
DashboardEngine — reads Config.dashboardLayout, computes placements[]
    ↓
Dashboard.qml — Repeater over placements
    ↓
ModuleRegistry.resolveWidget(id) → Loader → widget card
```

### Prop injection

The engine injects three props into every loaded navbar module via `Binding`:

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

The module exposes data as reactive properties. The engine renders it using `DynamicChip` or `StaticChip` via `ModuleRegistry.resolve()` for the navbar, and via `ModuleRegistry.resolveWidget()` for the dashboard — no frontend QML needed in either case. The same backend singleton feeds both contexts. Examples: `audio`, `network`, `power`, `updates`, `notifications`.

### Pattern B — backend + custom view

```
module-name/
 ├ ModuleName.qml      ← singleton: data, state
 ├ ModuleNameView.qml  ← custom visual logic
 └ qmldir
```

Used when the module's bar appearance is too complex for a chip pattern — custom layout, animation, interaction, or per-orientation rendering that can't be expressed through item descriptors. Examples: `clock`, `media`, `workspaces`, `cava`.

Custom views own their visual logic entirely. They don't import `qs.components` and don't depend on chip components — they inline whatever primitives they need. This keeps the component layer out of module internals.

---

## `/components`

Reusable visual primitives. These know how to draw things but nothing about what they're displaying.

| Component        | Used by                   | Description                                                          |
| ---------------- | ------------------------- | -------------------------------------------------------------------- |
| `DynamicChip`    | Engine (most modules)     | Renders a list of `{ icon, label, bgColor, onClicked }` item descriptors as chips. Handles horizontal/vertical layout and `inPill` transparency |
| `StaticChip`     | Engine (icon-only modules)| Single circular icon button driven by one item descriptor. Handles active state |
| `CCToggle`       | ModuleRegistry (dashboard)| Square toggle card with icon + label for dashboard control center widgets. Active state highlights the icon |
| `Button`         | Panels                    | Text/label button for settings UI                                    |
| `Toggle`         | Panels (Settings)         | On/off toggle with label                                             |
| `Panel`          | Panels                    | Sliding overlay window with tension fillets and dismiss overlay      |
| `AnimatedElement`| Panels                    | Wraps content with slide/scale/fade entrance animation               |
| `ScreenBorder`   | shell.qml                 | Renders thin border + rounded corners around each screen             |

### Component tiers

There are two tiers in practice:

**Engine components** (`DynamicChip`, `StaticChip`, `CCToggle`) — these are the engine's rendering contract with modules. A module's backend returns item descriptors; the engine passes them to the appropriate chip. `CCToggle` is the dashboard equivalent — a simple toggle card used by `ModuleRegistry.resolveWidget()` for 1×1 control center widgets.

**UI components** (`Button`, `Toggle`, `Panel`, `AnimatedElement`) — used by panels and settings UI. Custom `*View.qml` modules should not depend on these; they should inline what they need.

---

## `/panels`

Full overlay surfaces that appear on top of the bar. Each panel uses `Panel.qml` as its window container and is toggled via `EventBus`.

| Panel              | Description                                                                 |
| ------------------ | --------------------------------------------------------------------------- |
| `Dashboard`        | Control center + media player + notification list. Structure only — widget components live in `ModuleRegistry`, grid logic lives in `DashboardEngine` |
| `Settings`         | Bar configuration (location, layout, borders, transparency)                 |
| `AdvancedSettings` | Extended configuration options                                               |

Panels are opened/closed by emitting `EventBus.togglePanel(panelId, screen)` from any module or component. The `screen` argument ensures panels appear on the correct monitor in multi-screen setups.

---

## Design Decisions

### Config vs Style separation

`config.json` owns behaviour (where is the bar, which layout). `style.json` owns appearance (how big, what font, what spacing). Keeping these separate means you can swap fonts or sizing without touching anything that affects bar structure, and vice versa.

### Backend-only modules

Most modules don't need a `*View.qml`. The engine's chip pattern handles rendering entirely from data — the module just exposes reactive properties and item descriptors. This keeps module code focused on system integration rather than UI.

### Single registry, two modes

`ModuleRegistry` is the single source of truth for all renderable components. `resolve(name)` handles the navbar; `resolveWidget(id)` handles the dashboard. Both modes live in one file so adding a new module or widget always means touching one place. The same backend singleton can serve both modes — the registry decides how to render it per context.

### Dashboard engine separation

The dashboard's grid packer, placement algorithm, and edit mode state live in `DashboardEngine` rather than in `Dashboard.qml`. The panel file contains only structure (scrollview, header, grid shell, media card, notifications) and has no logic. This mirrors how `LayoutLoader` owns the bar's structural logic while the panel files stay declarative.

### Custom views own their visuals

When a module does need a custom view, it owns its visual logic completely and doesn't depend on shared chip components. This means `DynamicChip` and `StaticChip` stay as engine primitives rather than leaking into module internals.