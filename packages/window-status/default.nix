{ writeShellScriptBin
, pkgs
, ...
}:

writeShellScriptBin "window-status" /*sh*/''
  ${pkgs.hyprland}/bin/hyprctl -j clients | ${pkgs.jq}/bin/jq '[.[] | {Window: .initialTitle, Status: (if .xwayland then "XWayland" else "Native" end)}]' | ${pkgs.internal.jtbl}/bin/jtbl -t
''
