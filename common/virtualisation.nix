{pkgs, ...}: {
  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = false;
      # enableNvidia = true; # deprecated in favor of hardware.nvidia-container-toolkit.enable

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
    docker = {
      enable = true;
      #storageDriver = "btrfs";
      #rootless = {
      #  enable = true;
      #  setSocketVariable = true;
      #  # Optionally customize rootless Docker daemon settings
      #  #daemon.settings = {
      #  #  dns = [ "1.1.1.1" "8.8.8.8" ];
      #  #  registry-mirrors = [ "https://mirror.gcr.io" ];
      #};
    };
  };
  environment.systemPackages = with pkgs; [
    # Podman and Docker
    dive # look into docker image layers
    #podman-tui # status of containers in the terminal
    docker-compose # start group of containers for dev
    #podman-compose # start group of containers for dev
  ];
}
