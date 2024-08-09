{ config
, ...
}:

{
  age.secrets = {
    beanmachine = {
      file = ./keys/beanmachine.age;
      path = "${config.home.homeDirectory}/.ssh/keys/beanmachine";
    };
    github = {
      file = ./keys/github.age;
      path = "${config.home.homeDirectory}/.ssh/keys/github";
    };
    python-anywhere = {
      file = ./keys/python-anywhere.age;
      path = "${config.home.homeDirectory}/.ssh/keys/python-anywhere";
    };
    remarkable = {
      file = ./keys/remarkable.age;
      path = "${config.home.homeDirectory}/.ssh/keys/remarkable";
    };
    uos = {
      file = ./keys/uos.age;
      path = "${config.home.homeDirectory}/.ssh/keys/uos";
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {

      beannet = {
        hostname = "bean-machine.tail4ae93.ts.net";
        user = "root";
      };

      beanmachine = {
        hostname = "192.168.1.2";
        user = "root";
        identityFile = "${config.age.secrets.beanmachine.path}";
        # proxyJump = "beannet";
      };

      reMarkable = {
        hostname = "10.11.99.1";
        user = "root";
        identityFile = "${config.age.secrets.remarkable.path}";
        extraOptions = {
          PubkeyAcceptedKeyTypes = "ssh-rsa";
        };
      };

      AccessEPS = {
        hostname = "access.eps.surrey.ac.uk";
        user = "es00569";
        identityFile = "${config.age.secrets.uos.path}";
        forwardX11 = true;
        forwardX11Trusted = true;
      };

      MathsCompute01 = {
        hostname = "maths-compute01";
        user = "es00569";
        identityFile = "${config.age.secrets.uos.path}";
        forwardX11 = true;
        forwardX11Trusted = true;
        proxyJump = "AccessEPS";
      };

      "github.com" = {
        hostname = "github.com";
        identityFile = "${config.age.secrets.github.path}";
      };

      PythonAnywhere = {
        hostname = "ssh.eu.pythonanywhere.com";
        user = "ElliottSF";
        identityFile = "${config.age.secrets.python-anywhere.path}";
        # forwardAgent = false;
      };

    };
  };
}
