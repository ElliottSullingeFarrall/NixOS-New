{ pkgs
, ...
}:

let
  check_xwayland = pkgs.writeShellScriptBin "check_xwayland" /*sh*/''
    # Initialize arrays to store applications running under Wayland and XWayland
    wayland_apps=()
    xwayland_apps=()

    # Get the list of clients in JSON format
    clients=$(${pkgs.hyprland}/bin/hyprctl -j clients)

    # Parse the JSON and loop through each client
    while IFS=" " read -r app xwayland; do
      # Check if the client is running under XWayland or Wayland and add it to the appropriate array
      if [ "$xwayland" == true ]; then
        xwayland_apps+=("$app")
      else
        wayland_apps+=("$app")
      fi
    done < <(echo "$clients" | ${pkgs.jq}/bin/jq -r '.[] | (if .initialClass == "" then "Unknown" else (.initialClass | tostring) end) + " " + "\(.xwayland)"')

    # Print the headers
    printf "%-50s | %-50s\n" "Applications running under Wayland" "Applications running under XWayland"
    printf "%s\n" "---------------------------------------------------|--------------------------------------------------"

    # Get the maximum number of applications in Wayland and XWayland
    max_apps=$((''${#wayland_apps[@]} > ''${#xwayland_apps[@]} ? ''${#wayland_apps[@]} : ''${#xwayland_apps[@]}))

    # Print the applications in two columns
    for ((i=0; i<$max_apps; i++)); do
      wayland_app=''${wayland_apps[i]:-" "}
      xwayland_app=''${xwayland_apps[i]:-" "}
      printf "%-50s | %-50s\n" "$wayland_app" "$xwayland_app"
    done
  '';
in

{
  home.packages = [
    check_xwayland
  ];
}
