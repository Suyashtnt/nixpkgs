{ lib
, fetchPypi
, python3Packages
, latexminted
, testers
}:

python3Packages.buildPythonApplication rec {
  pname = "latexminted";
  version = "0.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vJziNgVYcnJfmAnok2OeYZEOwGtGfhZyup3D3+BuZsU=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    pygments
    latex2pydata
    latexrestricted
  ];

  passthru = {
    tests.version = testers.testVersion { package = latexminted; };
  };

  meta = {
    description = "Python executable for LaTeX minted package";
    homepage = "https://pypi.org/project/latexminted";
    license = lib.licenses.lppl13c;
    mainProgram = "latexminted";
    maintainers = with lib.maintainers; [ romildo ];
  };
}
