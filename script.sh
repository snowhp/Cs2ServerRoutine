#!/bin/bash

STEAMCMD_PATH="./steamcmd/steamcmd.sh" # steamcmd.sh file
CSGO_INSTALL_PATH="../csgo" # Server location
SCREEN_NAME="csgo_server" # Screen name for your server
CSGO_COMMAND="/home/steam/csgo/game/bin/linuxsteamrt64/cs2 -dedicated -console -secure -maxplayers 24 +exec server.cfg +game_type 0 +game_mode 0 +sv_setsteamaccount ADDYOURTOKEN +map de_mirage" # Executable for your cs2 server 
#ACMRS_COMMAND="/bin/bash /home/steam/csgo/game/acmrs.sh" # Option for ACMRS to automatically modify gameinfo.gi
LOG_FILE="/home/steam/logs/csgo_server_casual.log" # Log file if needed
CONSOLE_LOG_FILE="/home/steam/logs/csgo_server_console.log" # Console log file if needed
WEBHOOK_URL="https://discord.com/api/webhooks/" # Discord Webhook
SERVER_FILES_PERMISSIONS="chmod 777 /home/steam/csgo -R" # Add permissions to the files

# Function to log messages with timestamp
log() {
    local message="$1"
    local timestamp="$(date +"%Y-%m-%d %H:%M:%S")"
    # echo "$timestamp - $message" >> "$LOG_FILE"
    # Send message to Discord webhook
    curl -H "Content-Type: application/json" -X POST -d "{\"content\":\"[$timestamp] $message\"}" "$WEBHOOK_URL"
}

# Function to stop the server if an update is detected
stop_server_on_update() {
    local update_state_count=$(grep -o "Update state" <<< "$1" | wc -l)
    if [ "$update_state_count" -gt 1 ]; then
        log "Server is being updated... <@888068660432883773>"
        if screen -list | grep -q "$SCREEN_NAME"; then
            screen -S "$SCREEN_NAME" -X quit
            log "'$SCREEN_NAME' stopped due to update."
        fi
    fi
}

# Your SteamCMD command with output redirection
# log "Checking for server update..."
# Running SteamCMD command in the background
("$STEAMCMD_PATH" +force_install_dir "$CSGO_INSTALL_PATH" +login anonymous +app_update 730 +quit 2>&1) &

# Execute stop_server_on_update function in parallel to check for updates
# Passing the output of the SteamCMD command to the function
stop_server_on_update "$steamcmd_output" &

# Wait for background processes to finish
wait

# Execute acmrs.sh before starting CS:GO server
#$ACMRS_COMMAND
$SERVER_FILES_PERMISSIONS

# Check if the screen session is already running
if ! screen -list | grep -q "$SCREEN_NAME"; then
    # If not running, start the screen session and execute the CSGO command
    screen -dmS "$SCREEN_NAME" bash -c "$CSGO_COMMAND" #| tee -a $CONSOLE_LOG_FILE
    log "'$SCREEN_NAME' started."
else
    # If the screen session is running, check if the CS:GO process is still alive
    if ! screen -S "$SCREEN_NAME" -Q select . && ! pgrep -f "$CSGO_COMMAND" > /dev/null; then
        # If the process is not running, restart the screen session and execute the CSGO command
        screen -S "$SCREEN_NAME" -X quit
        screen -dmS "$SCREEN_NAME" bash -c "$CSGO_COMMAND | tee -a $CONSOLE_LOG_FILE"
        log "'$SCREEN_NAME' restarted."
    fi
fi
