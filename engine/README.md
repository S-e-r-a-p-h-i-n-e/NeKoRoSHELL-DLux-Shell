# engine/

The machinery that constructs the bar, drives the dashboard, and manages wallpaper rendering, clipboard history, and app discovery. You don't touch engine files to add a new module or panel — only if the structural or infrastructure behaviour of these systems needs to change.

## Files

| File                  | Type      | Description                                                                              |
|-----------------------|-----------|------------------------------------------------------------------------------------------|
| `LayoutLoader.qml`    | component | Reads the active layout JSON, creates a `PanelWindow` per screen, positions three `BarSlot` instances (left/center/right) for each orientation |
| `SlotLayout.qml`      | component | Receives a module list and renders each entry as either a `PillGroup` (array) or a bare module (string) via `ModuleRegistry` |
| `PillGroup.qml`       | component | Wraps a group of modules in a pill-shaped background with configurable radius and opacity. Injects `inPill: true` into chip-based modules |
| `ModuleRegistry.qml`  | singleton | Single registry for all renderable components. `resolve(name)` → navbar component; `resolveWidget(id)` → dashboard card |
| `DashboardEngine.qml` | singleton | Grid packer, placement algorithm, widget registry, edit mode state. Pure logic — no visual output |
| `AppEngine.qml`       | singleton | Discovers installed applications by scanning `.desktop` files from standard XDG paths and Flatpak. Powers the Launcher panel |
| `ClipboardEngine.qml` | singleton | Manages clipboard history via cliphist and favorites via a flat text file. Powers the ClipManager panel |
| `WallpaperEngine.qml` | singleton | File discovery for the wallpaper picker. `apply(path)` saves to `Config.wallpaperPath` which `WallpaperWindow` reacts to |
| `WallpaperWindow` | component | Self-contained background renderer. Spawns one `PanelWindow` at `WlrLayer.Background` per screen internally. Crossfade, parallax, smart video pause |

## Adding a new engine subsystem

If a new always-on system needs its own background window or persistent data management (similar to wallpaper or clipboard), it belongs here. Follow the pattern of separating the data/logic singleton from any window-spawning component.
