{
  description = "My NixOS infrastructure";

  inputs = {

    ### Essential inputs

    # Nix Packages collection & NixOS
    # https://github.com/nixos/nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # A collection of NixOS modules covering hardware quirks.
    # https://github.com/NixOS/nixos-hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Manage a user environment using Nix
    # https://github.com/nix-community/home-manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### You may want to add inputs here if you want to use packages or modules from outside nixpkgs.
    ### Unless the README of the imported flake tells you not to do this, it's probably a good idea
    ###   to add `<input name>.inputs.nixpkgs.follows = "nixpkgs";`, just like with home-manager above.
    ### Doing so can greatly reduce the time and storage space taken by each rebuild.
  };

  outputs =
    { self, ... }@inputs:
    with inputs;
    let
      supportedSystems = [
        "aarch64-linux"
        "x86_64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          overlays = [ ];
        }
      );
    in
    {
      # This allows you to run `nix fmt` to format the entire repository.
      formatter = forAllSystems (system: nixpkgsFor.${system}.nixfmt-tree);

      ################################################################################################
      # Everything below this line is just boilerplate to import the other files in this repository. #
      # You can safely ignore it unless you want to change the folder structure                      #
      ################################################################################################

      # Each subdirectory in ./modules is a NixOS module.
      # Modules are reusable pieces of NixOS configuration.
      # Each module needs a default.nix file that is read first.
      # It is recommended to add an "enable" option to each module, as the configuration
      #   would be activated for all machines by default otherwise
      nixosModules = builtins.listToAttrs (
        map (name: {
          inherit name;
          value = import (./modules + "/${name}");
        }) (builtins.attrNames (builtins.readDir ./modules))
      );

      # Each subdirectory in ./machines is a host.
      # Host configurations need a file called configuration.nix that will be read first.
      nixosConfigurations = builtins.listToAttrs (
        map (machineName: {
          name = machineName;
          value = nixpkgs.lib.nixosSystem {

            # Make inputs and the flake itself accessible as module parameters.
            # Technically, adding the inputs is redundant as they can be also
            # accessed with flake-self.inputs.X, but adding them individually
            # allows to only pass what is needed to each module.
            specialArgs = {
              flake-self = self;
            }
            // inputs;

            modules = [
              (import "${./.}/machines/${machineName}/configuration.nix")
              { imports = builtins.attrValues self.nixosModules; }
            ];

          };
        }) (builtins.attrNames (builtins.readDir ./machines))
      );

      # Each .nix file in ./home-manager/profiles is a home-manager profile.
      # The common.nix file is special, as it will be imported as part of ALL profiles
      homeConfigurations = builtins.listToAttrs (
        map
          (filename: {
            name = nixpkgs.lib.strings.removeSuffix ".nix" filename;
            value =
              {
                ...
              }:
              {
                imports = [
                  # always import the "common" profile
                  "${./.}/home-manager/profiles/common.nix"
                  # and import the chosen profile
                  "${./.}/home-manager/profiles/${filename}"
                ]
                ++ (builtins.attrValues self.homeManagerModules);
              };
          })
          (
            # get the names of all nix files in the profiles directory
            builtins.filter (nixpkgs.lib.strings.hasSuffix ".nix") (
              builtins.attrNames (builtins.readDir ./home-manager/profiles)
            )
          )
      );

      # Each subdirectory in ./home-manager/modules is a home-manager module.
      # Modules are reusable pieces of NixOS configuration.
      # Each module needs a default.nix file that is read first.
      # It is recommended to add an "enable" option to each module, as the configuration
      #   would be activated for all machines by default otherwise
      homeManagerModules = builtins.listToAttrs (
        map (name: {
          inherit name;
          value = import (./home-manager/modules + "/${name}");
        }) (builtins.attrNames (builtins.readDir ./home-manager/modules))
      );

    };
}
