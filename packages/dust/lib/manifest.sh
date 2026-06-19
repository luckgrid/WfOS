#!/usr/bin/env bash
# Parse the flat [[tool]] manifest into delimited records (dependency-free).
# Sourced after common.sh (uses $DUST_MANIFEST).
#
# Records use the US control char (0x1f) as field separator, NOT tab: tab is an
# IFS-whitespace char, so `read` would collapse consecutive tabs and drop empty
# fields (e.g. empty `alternatives`). Consumers read with IFS=$'\037'.

# Field order emitted by dust_manifest_tsv (consumers read with IFS=$'\037'):
#   module  id  default  brew  detect  agent_safe  alternatives  purpose

dust_manifest_tsv() {
  awk '
    BEGIN { FS_OUT="\037" }
    function flush() {
      if (in_tool) {
        printf "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n", \
          f["module"], FS_OUT, f["id"], FS_OUT, f["default"], FS_OUT, f["brew"], FS_OUT, \
          f["detect"], FS_OUT, f["agent_safe"], FS_OUT, f["alternatives"], FS_OUT, f["purpose"]
      }
    }
    /^[[:space:]]*#/ { next }
    /^[[:space:]]*\[\[tool\]\][[:space:]]*$/ {
      flush(); in_tool=1; delete f; next
    }
    /^[[:space:]]*[A-Za-z_]+[[:space:]]*=/ {
      if (!in_tool) next
      key=$0; sub(/[[:space:]]*=.*/, "", key); gsub(/[[:space:]]/, "", key)
      val=$0; sub(/^[^=]*=[[:space:]]*/, "", val)
      sub(/[[:space:]]+$/, "", val)
      gsub(/^"|"$/, "", val)
      f[key]=val
      next
    }
    END { flush() }
  ' "$DUST_MANIFEST"
}

dust_manifest_version() {
  awk -F'=' '
    /^[[:space:]]*version[[:space:]]*=/ {
      v=$2; gsub(/[[:space:]"]/, "", v); print v; exit
    }
  ' "$DUST_MANIFEST"
}

# List distinct modules in manifest order.
dust_manifest_modules() {
  dust_manifest_tsv | awk -F'\037' '!seen[$1]++ { print $1 }'
}
