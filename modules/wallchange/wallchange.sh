set -eu

# --- Paths ---
WALL_DIR="$HOME/.config/YASD/wallpapers" # Change this to your wallpapers directory
THEME="$HOME/.config/quickshell/modules/wallchange/wallpaper.rasi"

# --- Build & Display Rofi Menu (No Arrays Used) ---
CHOICE=$(find "$WALL_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) | while IFS= read -r img; do
    name=${img##*/}
    # \037 is POSIX octal for unit separator (Rofi's \x1f)
    printf '%s\0icon\037%s\n' "$name" "$img"
done | rofi -dmenu -i -p "Select Wallpaper" -theme "$THEME" -show-icons)

# --- Apply Wallpaper ---
if [ -n "$CHOICE" ]; then
    # Grab the exact path again since we aren't caching it in memory
    FULL_PATH=$(find "$WALL_DIR" -type f -name "$CHOICE" | head -n 1)

    if [ -n "$FULL_PATH" ]; then
        swww img "$FULL_PATH" --transition-type grow --transition-pos 0.5,0.5 --transition-step 90
    fi
fi