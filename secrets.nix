let
  systems = {
    elliotts-laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJgnRcttMN98rmRJEqafrsxvtiGrWT/iGJH6thNE/1wZ";
  };

  users = {
    elliott = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC6ZP8YiM5PTp6ZrgVVdJq8UVifTK8IvEiKN5i1vTnMX";
  };

  keys = builtins.attrValues systems ++ builtins.attrValues users;
in
{

  /* ----------------------------- User Passwords ----------------------------- */

  "systems/x86_64-linux/elliotts-laptop/users/elliott/password-elliott.age".publicKeys = keys;

  /* ------------------------------- GitHub PAT ------------------------------- */

  "homes/x86_64-linux/elliott@elliotts-laptop/config/nix/github-pat.age".publicKeys = keys;

  /* -------------------------------- SSH Keys -------------------------------- */

  "homes/x86_64-linux/elliott@elliotts-laptop/config/ssh/keys/beanmachine.age".publicKeys = keys;
  "homes/x86_64-linux/elliott@elliotts-laptop/config/ssh/keys/github.age".publicKeys = keys;
  "homes/x86_64-linux/elliott@elliotts-laptop/config/ssh/keys/python-anywhere.age".publicKeys = keys;
  "homes/x86_64-linux/elliott@elliotts-laptop/config/ssh/keys/remarkable.age".publicKeys = keys;
  "homes/x86_64-linux/elliott@elliotts-laptop/config/ssh/keys/uos.age".publicKeys = keys;

  /* ------------------------------ rClone Tokens ----------------------------- */

  "homes/x86_64-linux/elliott@elliotts-laptop/config/rclone/id-Work.age".publicKeys = keys;
  "homes/x86_64-linux/elliott@elliotts-laptop/config/rclone/id-OneDrive.age".publicKeys = keys;

  "homes/x86_64-linux/elliott@elliotts-laptop/config/rclone/token-Work.age".publicKeys = keys;
  "homes/x86_64-linux/elliott@elliotts-laptop/config/rclone/token-OneDrive.age".publicKeys = keys;
  "homes/x86_64-linux/elliott@elliotts-laptop/config/rclone/token-Google.age".publicKeys = keys;
  "homes/x86_64-linux/elliott@elliotts-laptop/config/rclone/token-DropBox.age".publicKeys = keys;

}
