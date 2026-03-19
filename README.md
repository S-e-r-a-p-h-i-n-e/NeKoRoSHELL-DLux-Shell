# YAQC

### Yet Another Quickshell Configuration

YAQC is a **modular, layout-driven Quickshell configuration** designed around separation of concerns and composable UI systems.

The project originally started as a **fork**, but has since evolved into its own architecture focused on:

* layout-driven UI construction
* modular system widgets
* reusable UI components
* clean separation between structure and functionality

Instead of hardcoding UI structure in QML, YAQC treats the shell more like a **runtime UI engine** that assembles the interface dynamically.

---

## 📷 Showcase


<https://github.com/user-attachments/assets/c00e5be8-12e1-4f28-bbb1-35e37a188b6b>

![Screenshot](Showcase/Default%20+%20Borders.png)
![Screenshot](Showcase/Default%20+%20Transparent.png)

---

## 📜 Philosophy

YAQC follows a few key ideas:

### Layouts are data

UI structure is defined through **layout definitions**, not hardcoded QML.

This allows:

* multiple layouts
* quick experimentation
* cleaner UI logic

---

### Modules are self-contained

Modules provide **functionality**, not layout control.

Examples:

* clock
* media player
* workspaces
* system controls

Modules can be placed anywhere in a layout without modification.

---

### Components are reusable primitives

Components act as the shell’s **UI toolkit**, providing shared building blocks used across modules.

Examples include buttons, toggles, panels, and animated elements.

---

### The shell is an assembly system

Rather than defining a static UI, the shell dynamically builds the interface by loading:

1. layouts
2. modules
3. components

This allows the interface to behave more like a **composable system** than a fixed bar configuration.

---

## 🛠️ Features

* Layout-driven interface
* Modular widget system
* Dynamic module loading
* Reusable UI components
* Multiple layout support
* Panels for extended interfaces
* Clean and maintainable project structure

---

## 🎯 Project Goals

<div align="center">

| 📋 **TODO** | **STATUS** |
| :---: | :---: |
| Replace swww | ✅ |
| Replace mpvpaper | ✅ |
| Replace waybar | ✅ |
| Replace rofi | ✅ |
| Replace wlogout | ✅ |
| Replace SwayNC | ✅ |
| Port all necessary bash scripts into native QML modules/functionality | ✅ |

</div>

---

## 🌲 Project Structure

```
quickshell/
├ components/   # reusable UI elements
├ engine/       # layout engine and module loading
├ globals/      # shared services and configuration
├ layouts/      # layout definitions
├ modules/      # functional UI widgets
├ panels/       # dashboard / overlay panels
├ shell/        # shell entry point
│
├ config.json
├ style.json
└ shell.qml
```

A full explanation of how these parts interact is documented in:

**[Docs/ARCHITECTURE.md](https://github.com/S-e-r-a-p-h-i-n-e/YAQC/blob/main/Docs/ARCHITECTURE.md)**

---

## 📦 Requirements

### Required

| Dependency | Purpose |
|---|---|
| [Quickshell](https://quickshell.outfoxxed.me) | Shell framework — the only hard requirement |
| [Hyprland](https://hyprland.org) | Compositor — workspaces, window tracking, active toplevel detection |
| A [Nerd Font](https://www.nerdfonts.com) | All icons are nerd font glyphs — JetBrainsMono Nerd Font is the default |
| `pactl` | Audio volume and mute control (part of `pipewire-pulse` or `pulseaudio`) |
| `nmcli` + `iwgetid` | Network status (part of `networkmanager` + `wireless_tools`) |
| `bluetoothctl` | Bluetooth state and toggle (part of `bluez-utils`) |
| `cliphist` | Clipboard history backend |
| `wl-copy` | Clipboard write (part of `wl-clipboard`) |
| `checkupdates` | Pending update count (part of `pacman-contrib`, Arch only) |

### Optional

| Dependency | Purpose | Falls back to |
|---|---|---|
| `cava` | Audio visualizer bar module | Module hidden if not installed |
| `kitty` | Terminal for the updates module (`topgrade`) | Updates module won't open a terminal |
| `topgrade` | System updater launched from the updates module | Updates module shows count only |
| `pavucontrol` | Audio settings opened from the audio module | Right-click does nothing |
| `blueman-manager` | Bluetooth settings opened from the bluetooth module | Right-click does nothing |
| `nm-connection-editor` | Network settings opened from the network module | Right-click does nothing |
| `nmgui` | Wi-Fi settings opened from the dashboard Wi-Fi | Right-click does nothing |
| `nvidia-smi` / `sensors` | GPU temperature in the systeminfo module | Temperature shows as unavailable |
| `hyprlock` / `swaylock` | Screen lock in the power menu | Falls back to `loginctl lock-session` |
| `swayidle` | Idle inhibitor module support | Module still works, idle daemon optional |

### Wallpaper

YAQC includes a native wallpaper system — no `swww` or `mpvpaper` needed. Place wallpapers in `~/.config/quickshell/wallpapers/`. Supported formats: `jpg`, `jpeg`, `png`, `webp`, `gif`, `mp4`, `webm`, `mkv`, `mov`, `avi`.

---

## ⚙️ Configuration
 
Both config files live-reload via `FileView` — changes take effect immediately without restarting.
 
### `config.json` — behaviour
 
| Key                | Description                                          |
|--------------------|------------------------------------------------------|
| `navbarLocation`   | Bar position: `top`, `bottom`, `left`, `right`       |
| `enableBorders`    | Whether screen border decorations are shown          |
| `transparentNavbar`| Whether the bar background is transparent           |
| `activeLayout`     | Which file in `layouts/` to load                    |
| `dashboardLayout`  | JSON string defining dashboard widget order         |
| `wallpaperPath`    | Path to the current wallpaper (set by the engine)   |
 
### `style.json` — appearance
 
| Key               | Description                                        |
|-------------------|----------------------------------------------------|
| `barSize`         | Full bar thickness in px                           |
| `moduleSize`      | Thickness of individual modules/chips              |
| `barFont`         | Font family used across all bar text               |
| `barPadding`      | Margin between bar edge and first module           |
| `slotSpacing`     | Gap between modules within a slot                  |
| `pillPadding`     | Padding inside a pill group                        |
| `pillSpacing`     | Gap between modules inside a pill group            |
| `pillOpacity`     | Background opacity of pill groups                  |
| `pillRadius`      | Corner radius of pill groups (999 = fully round)   |
| `chipSpacing`     | Gap between chip items in DynamicChip              |
| `chipInnerSpacing`| Gap between icon and label inside a chip           |
| `borderWidth`     | Thickness of screen border edges                   |
| `cornerRadius`    | Radius of screen border corners                    |
| `panelWidth`      | Width of overlay panels in px                      |
| `panelHeight`     | Height of overlay panels in px                     |
| `panelRadius`     | Corner radius of overlay panels                    |
| `panelPadding`    | Inner padding of overlay panels                    |
 
---

## 📝 Documentation

The architecture and internal design of the system are documented in:

**[Docs/ARCHITECTURE.md](https://github.com/S-e-r-a-p-h-i-n-e/YAQC/blob/main/Docs/ARCHITECTURE.md)**

This includes:

* layout engine internals
* module system
* component hierarchy
* shell initialization

---

## 📊 Project Status

YAQC began as a fork but has since diverged significantly in structure and design.

The project now serves as an exploration of how a **Quickshell configuration can be structured as a modular UI system** rather than a single static layout. Safe to say that this is its stable stage with modifications and new features appearing here and there while I work on [SeraDOTS](https://github.com/S-e-r-a-p-h-i-n-e/SeraDOTS)

---

## 🤍 Credits

Big Thanks to:

* **[NeKoRoSyS](https://github.com/NeKoRoSYS)** for starting this project and being collaborative, the amount of ideas you have for both our projects is honestly insane and commendable
