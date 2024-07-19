{ lib
, python3
, fetchFromGitHub

, sources ? import ../nix/sources.nix

, ...
}:

python3.pkgs.buildPythonApplication rec {
  pname = "jtbl";
  inherit (sources.${pname}) version;
  pyproject = true;

  src = fetchFromGitHub { inherit (sources.${pname}) owner repo rev sha256; };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    tabulate
  ];

  pythonImportsCheck = [ "jtbl" ];

  meta = with lib; {
    description = "CLI tool to convert JSON and JSON Lines to terminal, CSV, HTTP, and markdown tables";
    homepage = "https://github.com/kellyjonbrazil/jtbl";
    changelog = "https://github.com/kellyjonbrazil/jtbl/blob/${src.rev}/CHANGELOG";
    license = licenses.mit;
    # maintainers = with maintainers; [ ];
    mainProgram = "jtbl";
  };
}
