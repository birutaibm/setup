
## Initial Notices

First of all, this script was created to suit my own needs. Anyone with similar needs and preferences is free to use these scripts. However, since everyone has their own preferences, feel free to fork and adapt everything to your own requirements.

This script is meant to be run on a freshly installed Ubuntu 24.04. Depending on your system's state, additional adjustments may be necessary.

The `vscode` directory contains my current configuration files. Check the `Preparation` section to replace them with the appropriate files for your setup.

## Preparation

Before starting the installation of your new Ubuntu system or migrating to a new computer, you should back up your personal VSCode settings.  
On Ubuntu, these are located in the `~/.config/Code/User/` directory. In my case, I only copied the `settings.json` file and the `snippets` directory, but you can copy everything you consider necessary into the `vscode` directory of your local copy of this project, replacing mine. If you'd like to try out my configuration, just leave the project as is.

The file `vscode/extensions.txt` lists the extensions I'm currently using in my VSCode and that will be installed on the new system. If you'd like to create your own list, use the command `code --list-extensions > extensions.txt`. This is a good time to review your extensions and remove any you no longer want to use.

If you're already using the `fish` terminal with the `tide` theme and want to keep the same configuration in your new installation, run the script `./export-tide-config.sh` on your current system and copy the output into the file `fish/exported-tide-config.txt`. The version in this repository reflects what I'm currently using. If you prefer to install it as is and adjust the configuration later, you can use the `tide config` command in your new terminal (after running the script and rebooting the system).

## Instructions

- Copy this repository to your USB stick
- In the directory where you saved it, run `chmod +x *.sh`
- Follow the Preparation steps described above
- Take your prepared USB stick to the new machine
- With the terminal open in the directory of this copy, run `./dev-setup.sh`
- Reboot the system and test your new environment

## Result

At the end of the process, you will have `fish` configured as your default terminal, with auto-complete and automatic `.nvmrc` detection for switching Node.js versions, which will be installed using the `asdf` version manager.

Docker will be installed and ready to use, including Docker Compose.

VSCode will be installed and configured, including your extensions.
