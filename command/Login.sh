#!/usr/bin/env bash

# Shutdown
/usr/local/bin/chunkwm stop

# Wait a second for shit to chill
/bin/sleep 15

# Restart ChunkWM
/usr/local/bin/chunkwm restart

# Notify on Complete
terminal-notifier -message "Login script finished"  -title "Hola!"