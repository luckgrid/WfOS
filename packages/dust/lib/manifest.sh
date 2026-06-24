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

# detect token for a tool id (manifest field 5), or empty if the id is not a manifest tool.
dust_detect_of() {
  dust_manifest_tsv | awk -F'\037' -v id="$1" '$2==id {print $5; exit}'
}

# Replaceability matrix: one record per swappable role (a module-default tool with a non-empty
# `alternatives` list). Resolves the ACTIVE member = installed default, else first installed
# alternative, else the (missing) default. Requires dust_detect (common.sh, sourced first).
# Emits US-delimited:  module \037 default_id \037 alternatives \037 active_id \037 active_kind
# active_kind ∈ {default, alternative, none}.
dust_role_matrix() {
  # shellcheck disable=SC2034  # fields bound positionally; not all used here
  while IFS=$'\037' read -r module id def brew detect agent_safe alts purpose; do
    [ -n "$id" ] || continue
    [ "$def" = "true" ] || continue
    [ -n "$alts" ] || continue
    local active="" kind="none" a adet
    if dust_detect "$detect"; then
      active="$id"; kind="default"
    else
      IFS=',' read -r -a _arr <<< "$alts"
      for a in "${_arr[@]}"; do
        [ -n "$a" ] || continue
        adet="$(dust_detect_of "$a")"
        if [ -n "$adet" ] && dust_detect "$adet"; then active="$a"; kind="alternative"; break; fi
      done
    fi
    [ -n "$active" ] || active="$id"
    printf '%s\037%s\037%s\037%s\037%s\n' "$module" "$id" "$alts" "$active" "$kind"
  done < <(dust_manifest_tsv)
}
