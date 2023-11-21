# CS2 Server Routine

This Bash script automates CS2 server updates, integrates Discord notifications, and provides a streamlined way to manage your Counter-Strike 1.6 (CS2) server.

## Features

- **Automatic Updates:** Utilizes various scripts for checking and performing updates from GitHub repositories. 
- **Discord Integration:** Sends update status notifications to Discord via webhooks.
- **Cronjob Setup:** Includes guidance for setting up periodic execution using cron.

## Prerequisites

- **Bash:** Ensure your system supports and has Bash installed.
- **Access to CS2 Server Files:** Access to the directories containing CS2 server files.
- **Discord Webhook URL:** Obtain a Discord webhook URL for notifications.
- **GLST Token:** Have a valid GLST token for server management.
- **CS2-AutoUpdater Script:** https://github.com/dran1x/CS2-AutoUpdater
- **ACMRS metammod update fix:** https://github.com/ghostcap-gaming/ACMRS-cs2-metamod-update-fix

## Usage

### Configuration

1. Replace `YOUR_DISCORD_WEBHOOK_URL_HERE` with your actual Discord webhook URL.
2. Replace `YOUR_GLST_TOKEN_HERE` with your GLST token in the script.

### Script Execution

Run the script (`cs2_server_routine.sh`) using Bash:

```bash
./cs2_server_routine.sh

