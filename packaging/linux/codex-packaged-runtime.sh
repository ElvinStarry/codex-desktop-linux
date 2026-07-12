#!/bin/bash

codex_packaged_runtime_prelaunch() {
    codex_packaged_runtime_prelaunch_background >/dev/null 2>&1 &
}

codex_packaged_runtime_prelaunch_background() {
    if ! command -v systemctl >/dev/null 2>&1; then
        return 0
    fi

    if [ -z "${XDG_RUNTIME_DIR:-}" ] || [ ! -d "$XDG_RUNTIME_DIR" ]; then
        return 0
    fi

    if ! systemctl --user show-environment >/dev/null 2>&1; then
        return 0
    fi

    local import_path="${CODEX_LINUX_USER_PATH-${PATH:-}}"

    (
        export PATH="$import_path"

        systemctl --user import-environment \
            PATH \
            DISPLAY \
            WAYLAND_DISPLAY \
            DBUS_SESSION_BUS_ADDRESS \
            XAUTHORITY \
            XDG_RUNTIME_DIR \
            HYPRLAND_INSTANCE_SIGNATURE \
            YDOTOOL_SOCKET >/dev/null 2>&1 || true

        if command -v dbus-update-activation-environment >/dev/null 2>&1; then
            dbus-update-activation-environment --systemd \
                PATH \
                DISPLAY \
                WAYLAND_DISPLAY \
                DBUS_SESSION_BUS_ADDRESS \
                XAUTHORITY \
                XDG_RUNTIME_DIR \
                HYPRLAND_INSTANCE_SIGNATURE \
                YDOTOOL_SOCKET >/dev/null 2>&1 || true
        fi
    )

}

codex_packaged_runtime_export_env() {
    export CHROME_DESKTOP="codex-desktop.desktop"
    export BAMF_DESKTOP_FILE_HINT="/usr/share/applications/codex-desktop.desktop"
}
