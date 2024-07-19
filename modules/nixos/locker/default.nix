{ lib
, ...
}:

{
  options = {
    locker = lib.mkOption {
      type = lib.types.enum [
        "gtklock"
      ];
      description = "The locker to use.";
    };
  };
}
