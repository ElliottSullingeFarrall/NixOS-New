{ config
, lib
, ...
}:

{
  config = {
    environment.etc."greetd/environments".text = lib.mkIf config.services.greetd.enable (lib.mkAfter "bash");
  };
}
