#!/bin/bash

# Correct Faucet URL
URL="https://pwrfaucet.pwrlabs.io/claimPWR/"

# Data payload
DATA="userAddress=yourwallet"

# Track last claim time
LAST_CLAIM_FILE="last_claim_time.txt"

# Define 24 hours in seconds
TWENTY_FOUR_HOURS=86400

# Function to perform the claim
claim_faucet() {
  response=$(curl -s -X POST -d "$DATA" -H "Content-Type: application/x-www-form-urlencoded" "$URL")
  echo "Response: $response"
  # Update the last claim time
  current_time=$(date +%s)
  echo "$current_time" > "$LAST_CLAIM_FILE"
}

# Main loop
while true; do
  # Get current time
  current_time=$(date +%s)

  # Check if the last claim time file exists
  if [ -f "$LAST_CLAIM_FILE" ]; then
    # Read the last claim time
    last_claim_time=$(cat "$LAST_CLAIM_FILE")
  else
    # Default to a time far in the past if the file does not exist
    last_claim_time=0
  fi

  # Calculate the elapsed time since the last claim
  elapsed_time=$((current_time - last_claim_time))

  if [ $elapsed_time -ge $TWENTY_FOUR_HOURS ]; then
    # Make the claim
    claim_faucet
  else
    # Notify user of the remaining time
    remaining_time=$((TWENTY_FOUR_HOURS - elapsed_time))
    echo "You can only claim once every 24 hours. Waiting for $((remaining_time / 3600)) hours and $((remaining_time % 3600 / 60)) minutes."
  fi

  # Wait for 1 hour before checking again
  sleep 3600
done
