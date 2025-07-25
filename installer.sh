#!/bin/env sh

# Set global variables based on sudo usage
if [ -n "$SUDO_USER" ]; then
    export RUN_AS="$SUDO_USER"
else
    export RUN_AS="$USER"
fi
RUN_AS_HOME=$(eval echo ~"$RUN_AS")
export RUN_AS_HOME

# Check for git command to be installed
if ! command -v git >/dev/null 2>&1; then
    printf "\n\e[31m[fail]\e[0m git command not found..."
    printf "\n       Please install git package before running the installer.\n\n"
    exit 1
fi

# Remove ovos-installer directory if exists
installer_path="$RUN_AS_HOME/ovos-installer"
if [ -d "$installer_path" ]; then
    rm -rf "$installer_path"
fi

# Clone the latest version of ovos-installer git repository
git clone --quiet https://github.com/this-is-koa/ovos-installer.git "$installer_path"
cd "$installer_path" || exit 1

# Execute the installer entrypoint
bash setup.sh "$@"

# Delete ovos-installer directory once the installer is successfull
exit_status="$?"
if [ "$exit_status" -eq 0 ]; then
    cd "$RUN_AS_HOME" || exit 1
    rm -rf "$installer_path"
fi
