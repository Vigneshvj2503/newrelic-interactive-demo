#!/bin/bash

# Check for the correct number of arguments
if [ "$#" -ne 1 ]; then
    echo "Specify the hostname, for example: ./loadgen.sh ae18d6ea916684ebab4f2aaff0c49234-1581885670.us-east-1.elb.amazonaws.com"
    exit 1
fi

# Set variables
HOST="$1"
USER_AGENT="Mozilla/5.0 (Linux; Android 5.0; SM-G900P Build/LRX21T) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Mobile Safari/537.36"

# Initialize hit count
HIT_COUNT=0

while true; do
    # Use 'curl' to send an HTTP request and store the output in a variable
    response=$(curl -A "$USER_AGENT" -I "http://$HOST")

    # Check if the request was successful by looking for "HTTP/1.1 200 OK" in the response
    if [[ "$response" == *"HTTP/1.1 200 OK"* ]]; then
        # Increment the hit count
        ((HIT_COUNT++))
        echo "Request $HIT_COUNT successful"
    else
        echo "Request failed"
    fi

    # Sleep for 0.1 seconds (100 milliseconds)
    sleep 0.1
done

# Print the hit count when the script is manually stopped
trap "echo 'Total hits: $HIT_COUNT'; exit" INT
