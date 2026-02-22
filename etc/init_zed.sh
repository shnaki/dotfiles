#!/usr/bin/env bash

set -eu

DOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

normalize_windows_path() {
    local p="$1"

    if command -v cygpath >/dev/null 2>&1; then
        cygpath -u "${p}"
        return 0
    fi

    case "${p}" in
        [A-Za-z]:\\*)
            local drive rest
            drive="$(printf '%s' "${p}" | cut -c1 | tr 'A-Z' 'a-z')"
            rest="$(printf '%s' "${p}" | cut -c3- | tr '\\' '/')"
            printf '/%s/%s\n' "${drive}" "${rest}"
            ;;
        *)
            printf '%s\n' "${p}"
            ;;
    esac
}

APPDATA_DIR="${APPDATA:-}"
if [ -n "${APPDATA_DIR}" ]; then
    APPDATA_DIR="$(normalize_windows_path "${APPDATA_DIR}")"
fi

if [ -z "${APPDATA_DIR}" ] && command -v powershell.exe >/dev/null 2>&1; then
    APPDATA_WIN="$(powershell.exe -NoProfile -Command '[Environment]::GetFolderPath("ApplicationData")' 2>/dev/null | tr -d '\r\n')"
    if [ -n "${APPDATA_WIN}" ]; then
        APPDATA_DIR="$(normalize_windows_path "${APPDATA_WIN}")"
    fi
fi

if [ -z "${APPDATA_DIR}" ]; then
    APPDATA_DIR="$HOME/AppData/Roaming"
fi

if [ ! -d "${APPDATA_DIR}" ]; then
    APPDATA_DIR="$HOME/AppData/Roaming"
fi

ZED_CONFIG_DIR="${APPDATA_DIR}/Zed"

mkdir -p "${ZED_CONFIG_DIR}"

link_only() {
    local src="$1"
    local dst="$2"

    if ln -snf "${src}" "${dst}" 2>/dev/null; then
        echo "linked: ${dst}"
        return 0
    fi

    echo "failed to link: ${dst}" >&2
    return 1
}

link_only "${DOT_DIR}/.config/zed/settings.json" "${ZED_CONFIG_DIR}/settings.json"
link_only "${DOT_DIR}/.config/zed/keymap.json" "${ZED_CONFIG_DIR}/keymap.json"
