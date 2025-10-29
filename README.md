# NixOS Configuration Template

## What is this?

I've been using NixOS for a while now and have helped a few of my friends to get started with it as well.
Every time I've done that, I ended up taking [my own NixOS configuration](https://github.com/paulmiro/nixos) and removing everything I didn't consider essential to create a starting point for my friend.

This process can be rather tedious though, which is why I decided to create this template repository.

This repository contains quite a bit of opinionanted configuration, but I tried my best to keep it clean and keep unexpected behaviour to a minimum.
I decided to comment out quite a bit of my configuration instead of removing it completely, so that you can find some cool optional while readint through this repo.

## How to use

1. click "Use this template > Create a new repository" above
2. find every instance of `TODO` in this repository and follow the comment's instructions
3. download and use the [Graphical Installer](https://nixos.org/download/#nixos-iso) (even on machines that won't use a desktop environment later)
   - make sure to choose in the same username as you did in step 2
   - make sure your boot partition is big enough to hold a few kernels (512MB should be enough, but more won't hurt you if you have space to spare)
4. clone your flake to your new machine: `nix-shell -p gitMinimal --run "git clone https://github.com/YOUR-GITHUB-USERNAME/YOUR-REPO-NAME.git" && cd YOUR-REPO-NAME`
5. copy your machine configuration to the repository: `install -D -m 644 /etc/nixos/* -t machines/YOUR-MACHINE-HOSTNAME`
   - make sure to add the new files to the git index: `nix-shell -p gitMinimal --run "git add ."` (flakes use the git index to list files, forgetting to add files is a common pitfall)
6. edit your `configuration.nix` file: (see the example configuration)
   - add the line `my-config.common.enable = true;` somewhere in the main body of the file
     - without this, none of the config in this repository will be applied to your machine
     - you can also use `comon-desktop` instead of `common` if you want to use the GNOME dekstop environment
7. run `nixos-rebuild switch --use-remote-sudo --flake ".#YOUR-MACHINE-HOSTNAME"` to build the NixOS configuration in this repository and switch to it
8. if everything worked, you can `sudo reboot now`
   - technically, this isn't neccessary, but it makes sure you get dropped into the proper shell/desktop environment
9. run `nix-channel --list` and then `nix-channel --remove NAME` for each listed channel
   - also do this again with sudo, to remove channels for the root user
10. Your machine is now ready to use 🎉

## Helpful Resources

- [Nix Package Search](https://search.nixos.org/packages?channel=unstable)
- [NixOS Option Search](https://search.nixos.org/options?channel=unstable)
- [NixOS Wiki (official)](https://wiki.nixos.org/wiki/NixOS_Wiki)
- [NixOS Wiki (unofficial)](https://nixos.wiki/)
- [NixOS manual](https://nixos.org/nixos/manual/)
- [Home Manager Option Search](https://home-manager-options.extranix.com/?query=&release=master)
- [Home Manager Option Documentation](https://rycee.gitlab.io/home-manager/options.xhtml)
- [Home Manager manual](https://nix-community.github.io/home-manager/)
- [Nix Function Search](https://noogle.dev/)
- [nix.dev (General Nix Documentation)](https://nix.dev/)
- [Even More Resources](https://wiki.nixos.org/wiki/Resources)

## Other Peoples' NixOS Repositories

One of the great things about NixOS is the ability to steal other peoples modules to get the same functionality for yourself!
Here are some of my friends' repositories for you to get some inspiration from

- [paulmiro](https://github.com/paulmiro/nixos) (that's me :D)
- [mayniklas](https://github.com/mayniklas/nixos) (the one who got me into NixOS)
- [pinpox](https://github.com/pinpox/nixos) (the one who got mayniklas into NixOS)
- [ALinkbetweenNets](https://github.com/ALinkbetweenNets/nix)
- [alexanderwallau](https://github.com/alexanderwallau/nix)
- [lgoette](https://github.com/lgoette/nixos)
