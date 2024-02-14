#!/bin/sh

set -e

# Create package dir
mkdir ./package

# Copy built content into package dir
cd ./package
mkdir ./sm64
cp -r ../build/us_pc/* ./sm64

# Create 351ELEC launch script
touch ./sm64.sh
cat > ./sm64.sh << EOF
#!/bin/bash

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
elif [ -d "/roms/ports/PortMaster" ]; then
  controlforlder="/roms/ports/PortMaster"
elif [ -d "/roms2/ports/PortMaster" ]; then
  controlfolder="/roms2/ports/PortMaster"
else
  controlfolder="/storage/roms/ports/PortMaster"
fi

source \$controlfolder/control.txt
get_controls

GAMEDIR="/\$directory/ports/sm64"
cd "\$GAMEDIR"

\$ESUDO chmod 666 /dev/uinput

echo "Starting" | tee ./log.txt

SDL_GAMECONTROLLERCONFIG_FILE="controller/gamecontrollerdb.txt" ./sm64.us.f3dex2e 2>&1 | tee -a ./log.txt

unset SDL_GAMECONTROLLERCONFIG_FILE
\$ESUDO systemctl restart oga_events &
printf "\033c" >> /dev/tty1

EOF

# Zip the package
zip -r ../../sm64-ArkOS.zip ./*
