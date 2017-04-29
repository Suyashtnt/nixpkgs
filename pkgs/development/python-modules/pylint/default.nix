{ stdenv, fetchurl, buildPythonPackage, python, astroid, isort,
  pytest,  mccabe, configparser, backports_functools_lru_cache }:

  buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "pylint";
    version = "1.6.5";

    src = fetchurl {
      url = "mirror://pypi/p/${pname}/${name}.tar.gz";
      sha256 = "06b78nl996949a7h01c4ycy8779hl5cm7vpxij5lm3npim59hwx6";
    };

    buildInputs = [ pytest mccabe configparser backports_functools_lru_cache ];

    propagatedBuildInputs = [ astroid isort ];

    postPatch = ''
      # Remove broken darwin tests
      sed -i -e '/test_parallel_execution/,+2d' pylint/test/test_self.py
      sed -i -e '/test_py3k_jobs_option/,+4d' pylint/test/test_self.py
      rm -vf pylint/test/test_functional.py
    '';

    checkPhase = ''
      cd pylint/test
      ${python.interpreter} -m unittest discover -p "*test*"
    '';

    postInstall = ''
      mkdir -p $out/share/emacs/site-lisp
      cp "elisp/"*.el $out/share/emacs/site-lisp/
    '';

    meta = with stdenv.lib; {
      homepage = http://www.logilab.org/project/pylint;
      description = "A bug and style checker for Python";
      platforms = platforms.all;
      license = licenses.gpl1Plus;
      maintainers = with maintainers; [ nand0p ];
    };
  }
