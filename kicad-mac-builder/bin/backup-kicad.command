#!/bin/bash

#It looks complicated, but it copies files from the default locations for the KiCad applications, support files, and preferences into your home directory, in a directory that starts with kicad-backup and then the date and time.

BACKUP_DIR=~/kicad-backup-$(date +%Y%m%d-%H%M%S)
mkdir -p $BACKUP_DIR
if [ -e /Applications/KiCad ]; then
  echo "Backing up /Applications/KiCad"
  mkdir -p $BACKUP_DIR/Applications
  cp -r /Applications/KiCad $BACKUP_DIR/Applications/
fi

if [ -e /Applications/Kicad ]; then
  echo "Backing up /Applications/Kicad"
  mkdir -p $BACKUP_DIR/Applications
  cp -r /Applications/Kicad $BACKUP_DIR/Applications/
fi

if [ -e "/Library/Application Support/kicad" ]; then
  echo "Backing up /Library/Application Support/kicad"
  mkdir -p "$BACKUP_DIR/Library/Application Support"
  cp -r "/Library/Application Support/kicad" "$BACKUP_DIR/Library/Application Support/"
fi

if [ -e "$HOME/Library/Application Support/kicad" ]; then
  echo "Backing up $HOME/Library/Application Support/kicad"
  mkdir -p "$BACKUP_DIR/$HOME/Library/Application Support"
  cp -r "$HOME/Library/Application Support/kicad" "$BACKUP_DIR/$HOME/Library/Application Support/"
fi

if [ -e "$HOME/Library/Preferences/org.kicad-pcb.*" ]; then
  echo "Backing up $HOME/Library/Preferences/org.kicad-pcb.*"
  mkdir -p "$BACKUP_DIR/$HOME/Library/Preferences"
  cp -r "$HOME/Library/Preferences/org.kicad-pcb.*" "$BACKUP_DIR/$HOME/Library/Preferences/"
fi

if [ -e "$HOME/Library/Preferences/kicad" ]; then
  echo "Backing up $HOME/Library/Preferences/kicad"
  mkdir -p "$BACKUP_DIR/$HOME/Library/Preferences"
  cp -r "$HOME/Library/Preferences/kicad" "$BACKUP_DIR/$HOME/Library/Preferences/"
fi

echo "Backup into $BACKUP_DIR complete."
