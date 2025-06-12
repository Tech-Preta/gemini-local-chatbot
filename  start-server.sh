#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

# Define the path for the env-config.js file
CONFIG_FILE="/usr/src/app/env-config.js"

echo "Attempting to create ${CONFIG_FILE}..."

# Check if the API_KEY environment variable is set
if [ -z "${API_KEY}" ]; then
  echo "Error: API_KEY environment variable is not set."
  echo "Please provide the API_KEY when running the Docker container using -e API_KEY=\"YOUR_API_KEY\""
  echo "Creating ${CONFIG_FILE} with API_KEY as null."
  echo "window.API_KEY = null;" > "${CONFIG_FILE}"
  echo "console.warn('API_KEY was not provided. Chatbot will show an error message.');" >> "${CONFIG_FILE}"
else
  echo "API_KEY found. Creating ${CONFIG_FILE} with the provided key."
  # Create the env-config.js file with the API key
  # Using a heredoc for clarity and to handle potential special characters in the API key,
  # though for a simple string assignment, direct echo is often fine.
  # Make sure the API_KEY is properly quoted if it contains special characters.
  # For robustness, one might consider additional escaping if keys could be very complex,
  # but for typical API keys, this should be sufficient.
  cat > "${CONFIG_FILE}" <<EOF
window.API_KEY = "${API_KEY}";
console.log("env-config.js created successfully with API_KEY.");
EOF
fi

echo "${CONFIG_FILE} content:"
cat "${CONFIG_FILE}"
echo "---------------------------"


# Start the http-server to serve the static files from the current directory (/usr/src/app)
# -p 8080: Serve on port 8080
# -c-1: Disable caching, which is useful for development
echo "Starting http-server on port 8080..."
exec http-server . -p 8080 -c-1