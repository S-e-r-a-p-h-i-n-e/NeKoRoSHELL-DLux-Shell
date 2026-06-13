# components/

Reusable visual primitives. Components know how to draw things but nothing about what they're displaying. They have no knowledge of specific modules, panels, or system state.

## Component tiers

There are two tiers in practice:

### Engine components

The engine's rendering contract with modules. `ModuleRegistry` uses these directly.

| Component    | Used by              | Description                                                               |
|--------------|----------------------|---------------------------------------------------------------------------|
| `DynamicChip`| Engine (most modules)| Renders a list of `{ icon, label, bgColor, fgColor, onClicked, onRightClicked, onScrolled }` descriptors as chips. Handles horizontal/vertical orientation and `inPill` transparency |
| `StaticChip` | Engine (icon modules)| Single circular icon button driven by one item descriptor. Supports `active` state and `activeColor` |
| `CCToggle`   | Engine (dashboard)   | Square toggle card with icon + label. Used by `ModuleRegistry.resolveWidget()` for 1×1 dashboard control center tiles |

### UI components

Used by panels and settings UI. Custom `*View.qml` modules should not depend on these — they should inline whatever they need.

| Component        | Used by          | Description                                                          |
|------------------|------------------|----------------------------------------------------------------------|
| `Panel`          | All panels       | Sliding overlay window. Handles dismiss overlay, animation, tension fillets, keyboard focus, and Escape key |
| `AnimatedElement`| Panel.qml        | Wraps content with slide/scale/fade entrance animation. Exposes `isSurfaceVisible` so the parent can keep the window alive during exit animation |
| `Button`         | Settings panels  | Simple text/icon button                                              |
| `Toggle`         | Settings panel   | On/off toggle row with label and disabled state                      |
| `Dropdown`       | Settings Panel   | Dropdown toggle with label and selected state
| `ScreenBorder`   | shell.qml        | Thin decorative border + rounded corners rendered around each screen |

## Rules

- Components take data as properties and emit signals. They never import module singletons or read from `EventBus` directly.
- `DynamicChip` and `StaticChip` are engine primitives — don't use them inside custom `*View.qml` files.
- `Panel` is the only correct way to create a new overlay panel window. Don't create `PanelWindow` directly in a panel file.
