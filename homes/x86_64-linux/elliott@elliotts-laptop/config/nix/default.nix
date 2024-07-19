{ config
, ...
}:

{
  age.secrets.github-pat = {
    file = ./github-pat.age;
    substitutions = [ "${config.xdg.configHome}/nix/nix.conf" ];
  };

  nix.settings.access-tokens = "github.com=@github-pat@";
  xdg.configFile."nix/nix.conf".force = true;
}
