#!/usr/bin/env sh
# Installs the SDDM config + astronaut theme override (needs root).
set -e
dir="$(cd "$(dirname "$0")" && pwd)"
theme=/usr/share/sddm/themes/sddm-astronaut-theme
install -Dm644 "$dir/sddm.conf" /etc/sddm.conf
install -Dm644 "$dir/theme.conf" "$theme/Themes/dark.conf"
install -Dm644 "$dir/bg.png" "$theme/Backgrounds/dark.png"
sed -i 's|^ConfigFile=.*|ConfigFile=Themes/dark.conf|' "$theme/metadata.desktop"
# only offer shutdown + reboot (drop suspend/hibernate)
sed -i 's|^\(\s*model: \)\[shutdown, reboot, suspend, hibernate\]|\1[shutdown, reboot]|' "$theme/Components/SystemButtons.qml"
# pointing-hand cursor over the power buttons (no-op if already patched)
grep -q PointingHandCursor "$theme/Components/SystemButtons.qml" ||
  sed -i '/hoverEnabled: true/a\
\
            MouseArea {\
                anchors.fill: parent\
                acceptedButtons: Qt.NoButton\
                cursorShape: Qt.PointingHandCursor\
            }' "$theme/Components/SystemButtons.qml"
# thicker, less sci-fi shutdown/reboot icons
install -Dm644 "$dir/icons/Shutdown.svg" "$theme/Assets/Shutdown.svg"
install -Dm644 "$dir/icons/Reboot.svg" "$theme/Assets/Reboot.svg"
# field-style session dropdown with a chevron
install -Dm644 "$dir/SessionButton.qml" "$theme/Components/SessionButton.qml"
# session selector above the fields, and narrower boxes (was parent.width / 2)
install -Dm644 "$dir/LoginForm.qml" "$theme/Components/LoginForm.qml"
sed -i 's|width: parent.width / 2$|width: parent.width / 3|' "$theme/Components/Input.qml"
