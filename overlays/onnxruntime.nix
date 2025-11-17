final: prev: {
    pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
      (python-final: python-prev: {
        rapidocr-onnxruntime = python-prev.rapidocr-onnxruntime.overridePythonAttrs (oldAttrs: rec {
          version = "2.1.0";
          src = prev.fetchFromGitHub {
            owner = "RapidAI";
            repo = "RapidOCR";
            tag = "v${version}";
            hash = "sha256-4R2rOCfnhElII0+a5hnvbn+kKQLEtH1jBvfFdxpLEBk=";
          };

          doCheck = false;
        });
      })
    ];
  }