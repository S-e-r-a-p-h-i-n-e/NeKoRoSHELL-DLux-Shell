// modules/tray/Tray.qml — BACKEND ONLY
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

QtObject {
    readonly property string moduleType: "custom"
    readonly property var    items:      SystemTray.items.values

    // Keyed on lowercased title or id fragment — whichever matches first.
    // Covers the most commonly installed tray apps.
    readonly property var iconMap: ({
        // ── Network ───────────────────────────────────────────────────────
        "nm-applet":                    "󰤨",
        "network manager":              "󰤨",
        "networkmanager":               "󰤨",
        "connman":                      "󰤨",
        "wicd":                         "󰤨",

        // ── Bluetooth ─────────────────────────────────────────────────────
        "blueman":                      "󰂯",
        "bluetooth":                    "󰂯",

        // ── Audio ─────────────────────────────────────────────────────────
        "pavucontrol":                  "󰕾",
        "pulseaudio":                   "󰕾",
        "pipewire":                     "󰕾",
        "easyeffects":                  "󱡫",
        "jamesdsp":                     "󱡫",
        "helvum":                       "󰕾",

        // ── Storage / Drives ──────────────────────────────────────────────
        "udiskie":                      "󰕓",
        "udisks":                       "󰕓",
        "disk":                         "󰕓",

        // ── Clipboard ─────────────────────────────────────────────────────
        "copyq":                        "󰅌",
        "parcellite":                   "󰅌",
        "clipman":                      "󰅌",
        "cliphist":                     "󰅌",
        "klipper":                      "󰅌",

        // ── Screenshots ───────────────────────────────────────────────────
        "flameshot":                    "󰄄",
        "ksnip":                        "󰄄",
        "spectacle":                    "󰄄",

        // ── VPN ───────────────────────────────────────────────────────────
        "openvpn":                      "󰦝",
        "nordvpn":                      "󰦝",
        "protonvpn":                    "󰦝",
        "mullvad":                      "󰦝",
        "expressvpn":                   "󰦝",
        "wireguard":                    "󰦝",
        "vpn":                          "󰦝",

        // ── Cloud / Sync ──────────────────────────────────────────────────
        "dropbox":                      "󰇣",
        "megasync":                     "󰇣",
        "insync":                       "󰇣",
        "nextcloud":                    "󰇣",
        "onedrive":                     "󰇣",
        "syncthing":                    "󰒖",

        // ── Chat / Social ─────────────────────────────────────────────────
        "discord":                      "󰙯",
        "vesktop":                      "󰙯",
        "telegram":                     "󰔁",
        "signal":                       "󰍡",
        "slack":                        "󰒱",
        "teams":                        "󰊻",
        "element":                      "󰍡",
        "fractal":                      "󰍡",

        // ── Music ─────────────────────────────────────────────────────────
        "spotify":                      "󰓇",
        "strawberry":                   "󰝚",
        "rhythmbox":                    "󰝚",
        "clementine":                   "󰝚",
        "lollypop":                     "󰝚",
        "deadbeef":                     "󰝚",

        // ── Password Managers ─────────────────────────────────────────────
        "keepassxc":                    "󰌋",
        "bitwarden":                    "󰌋",
        "enpass":                       "󰌋",
        "1password":                    "󰌋",

        // ── System / Power ────────────────────────────────────────────────
        "redshift":                     "󰌵",
        "gammastep":                    "󰌵",
        "caffeine":                     "󰛊",
        "xfce4-power-manager":          "󰁹",
        "tlp":                          "󰁹",
        "auto-cpufreq":                 "󰍛",
        "thermald":                     "󰔏",
        "cpupower":                     "󰍛",

        // ── Printers ──────────────────────────────────────────────────────
        "system-config-printer":        "󰐪",
        "cups":                         "󰐪",
        "print":                        "󰐪",

        // ── Input Method ──────────────────────────────────────────────────
        "ibus":                         "󰌌",
        "fcitx":                        "󰌌",
        "fcitx5":                       "󰌌",

        // ── Gaming ────────────────────────────────────────────────────────
        "steam":                        "󰓓",
        "lutris":                       "󰮂",
        "heroic":                       "󰮂",
        "bottles":                      "󰮂",
        "minigalaxy":                   "󰮂",

        // ── GPU / Display ─────────────────────────────────────────────────
        "nvidia-settings":              "󰾲",
        "supergfxctl":                  "󰾲",
        "optimus-manager":              "󰾲",
        "amdgpu":                       "󰾲",
        "corectrl":                     "󰾲",

        // ── Torrents / Downloads ──────────────────────────────────────────
        "qbittorrent":                  "󰇚",
        "deluge":                       "󰇚",
        "transmission":                 "󰇚",
        "filezilla":                    "󰇚",

        // ── Misc ──────────────────────────────────────────────────────────
        "mailspring":                   "󰇰",
        "thunderbird":                  "󰇰",
        "evolution":                    "󰇰",
        "mail":                         "󰇰",
        "solaar":                       "󰍽",
        "piper":                        "󰍽",
        "openrgb":                      "󰌁",
        "polychromatic":                "󰌁",
    })

    function iconFor(item) {
        // Try title first, then id fragments
        let key = (item.title ?? "").toLowerCase().trim()
        if (iconMap[key]) return iconMap[key]

        // Try matching any iconMap key as a substring of title or id
        let id = (item.id ?? "").toLowerCase()
        for (let k in iconMap) {
            if (key.includes(k) || id.includes(k)) return iconMap[k]
        }

        // Fallback: first letter of title
        return (item.title ?? "?").substring(0, 1).toUpperCase()
    }
}
