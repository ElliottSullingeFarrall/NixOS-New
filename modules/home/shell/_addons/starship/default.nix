{ ...
}:

{
  config = {
    programs.starship = {
      enable = true;
      settings = {
        nix_shell = {
          format = "via [$symbol($name)]($style) ";
          symbol = "❄️ ";
        };
      };
    };
  };
}
