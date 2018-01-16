#!/bin/sh

# setup recurring with
# launchctl bootstrap gui/$UID home-backup.plist

# -X needed for OS X package files/directories
exit;

rsync \
  -e 'ssh -p 22' \
  --compress \
  --numeric-ids \
  --links \
  --hard-links \
  --one-file-system \
  --itemize-changes \
  --times \
  --recursive \
  --perms \
  --owner \
  --group \
  --stats \
  --human-readable \
  --delete \
  --inplace \
  --exclude-from="$HOME/Mage/spellbook/backup/backup.ignorelist" \
  /Users/$USER dscott@myriadmobile.com:/srv/backups/remote-servers/macbook

touch /tmp/home-backup.date
