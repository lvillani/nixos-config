{
  inputs,
  pkgs,
  ...
}:
let
  npinsSchemaAdapter = pkgs.writeShellApplication {
    name = "npins";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.jq
      pkgs.npins
    ];
    text = ''
      lock_file=
      previous_argument=
      for argument in "$@"; do
        if [[ "$previous_argument" == "--lock-file" ]]; then
          lock_file=$argument
          break
        fi
        previous_argument=$argument
      done

      set_lock_version() {
        local version=$1
        local temporary_lock
        temporary_lock=$(mktemp "''${lock_file}.XXXXXX")
        jq --argjson version "$version" '.version = $version' "$lock_file" >"$temporary_lock"
        mv -f -- "$temporary_lock" "$lock_file"
      }

      if [[ -n "$lock_file" && -f "$lock_file" ]] && jq -e '.version == 8' "$lock_file" >/dev/null; then
        set_lock_version 7
      fi

      npins "$@"

      if [[ -n "$lock_file" && -f "$lock_file" ]] && jq -e '.version == 7' "$lock_file" >/dev/null; then
        set_lock_version 8
      fi
    '';
  };
in

inputs.agent-skills-nix.lib.agent-skills.mkSourceLockProgram {
  inherit pkgs;
  manifestsDir = "skills/registry";
  lockFile = "skills/registry/sources.lock.json";
  npins = npinsSchemaAdapter;
}
