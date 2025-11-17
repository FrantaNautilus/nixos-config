{
  config,
  pkgs,
  private,
  ...
}: {
  # AI services
  # disabled because harbor does not need to be build.
  services.ollama = {
    enable = true;
    acceleration = if pkgs.config.cudaSupport then null else "cuda";
    #user = ${private.userv.userName};
    #home = "/home/${private.userv.userName}"
    #models = "\${config.services.ollama.home}/models";
    #loadModels = [];
  };

  #nixpkgs.overlays = if pkgs.config.cudaSupport then [ (import ../overlays/onnxruntime.nix) ] else null;

  nixpkgs.overlays = [
    (final: prev: {
    pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
      (python-final: python-prev: {
        rapidocr-onnxruntime = python-prev.rapidocr-onnxruntime.overridePythonAttrs (oldAttrs: {
          doCheck = false;
        });
      })
      ];
    })
    # (final: prev: {
    # pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    #   (python-final: python-prev: {
    #     rapidocr-onnxruntime = python-prev.rapidocr-onnxruntime.overridePythonAttrs (oldAttrs: rec {
    #       # version = "2.1.0";
    #       # src = prev.fetchFromGitHub {
    #       #   owner = "RapidAI";
    #       #   repo = "RapidOCR";
    #       #   tag = "v${version}";
    #       #   hash = "sha256-4R2rOCfnhElII0+a5hnvbn+kKQLEtH1jBvfFdxpLEBk=";
    #       # };

    #       doCheck = false;
    #     });
    #   })
    #   ];
    # })
    # (final: prev: {
    # pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    #   (python-final: python-prev: {
    #     einops = python-prev.einops.overridePythonAttrs (oldAttrs: {
    #       doCheck = false;
    #     });
    #   })
    #   ];
    # })
    # (final: prev: {
    # pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    #   (python-final: python-prev: {
    #     pgvector = python-prev.pgvector.overridePythonAttrs (oldAttrs: {
    #       doCheck = false;
    #     });
    #   })
    #   ];
    # })
    # (final: prev: {
    # pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    #   (python-final: python-prev: {
    #     sentence-transformers = python-prev.sentence-transformers.overridePythonAttrs (oldAttrs: {
    #       doCheck = false;
    #     });
    #   })
    #   ];
    # })
    # (final: prev: {
    # pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    #   (python-final: python-prev: {
    #     chromadb = python-prev.chromadb.overridePythonAttrs (oldAttrs: {
    #       doCheck = false;
    #     });
    #   })
    #   ];
    # })
    # (final: prev: {
    # pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    #   (python-final: python-prev: {
    #     opensearch-py = python-prev.opensearch-py.overridePythonAttrs (oldAttrs: {
    #       doCheck = false;
    #     });
    #   })
    #   ];
    # })
    # (final: prev: {
    # pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    #   (python-final: python-prev: {
    #     accelerate = python-prev.accelerate.overridePythonAttrs (oldAttrs: {
    #       doCheck = false;
    #     });
    #   })
    #   ];
    # })
  ];

  services.open-webui = {
    enable = true;
    #package = (pkgs.open-webui.overrideAttrs (_: { doCheck = false; }));
    package = pkgs.open-webui.overridePythonAttrs (old: {
      dependencies = old.dependencies ++ [
        pkgs.python3Packages.itsdangerous
      ];
    });
    environment = {
      ANONYMIZED_TELEMETRY = "False";
      BYPASS_MODEL_ACCESS_CONTROL = "True";
      DO_NOT_TRACK = "True";
      SCARF_NO_ANALYTICS = "True";
      STATIC_DIR = "${config.services.open-webui.stateDir}/static";
      DATA_DIR = "${config.services.open-webui.stateDir}/data";
      HF_HOME = "${config.services.open-webui.stateDir}/hf_home";
  		SENTENCE_TRANSFORMERS_HOME = "${config.services.open-webui.stateDir}/transformers_home";
    };
  };

  environment.systemPackages = with pkgs; [
    jan
    openai-whisper
    piper-tts
    koboldcpp
    video2x
    aider-chat
    fabric-ai
    aichat
    gemini-cli
  ];

  systemd.services.ollama-suspend-hook = {
    description = "Stop ollama before suspend";
    before = [ "sleep.target" "hibernate.target" ];
    wantedBy = [ "sleep.target" "hibernate.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/systemctl stop ollama.service";
    };
  };

  systemd.services.ollama-resume-hook = {
    description = "Start ollama after resume";
    after = [ "sleep.target" "hibernate.target" ];
    wantedBy = [ "sleep.target" "hibernate.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/systemctl start ollama.service";
    };
  };

  systemd.services.open-webui-suspend-hook = {
    description = "Stop open-webui before suspend";
    before = [ "sleep.target" "hibernate.target" ];
    wantedBy = [ "sleep.target" "hibernate.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/systemctl stop open-webui.service";
    };
  };

  systemd.services.open-webui-resume-hook = {
    description = "Start open-webui service after resume";
    after = [ "sleep.target" "hibernate.target" ];
    wantedBy = [ "sleep.target" "hibernate.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/systemctl start open-webui.service";
    };
  };

}
