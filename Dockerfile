# Use an official Node.js runtime as a parent image
# Using a slim version for a smaller image size
FROM node:18-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Install http-server globally, which will be used to serve your static files
RUN npm install -g http-server

# Copy all your application files from the current directory (where the Dockerfile is)
# to the working directory inside the container
COPY . .

# Make the start-server.sh script executable
# This script is responsible for creating env-config.js and starting the server
RUN chmod +x /usr/src/app/start-server.sh

# Expose port 8080 to the Docker host. This is the port http-server will use.
EXPOSE 8080

# Define the command to run when the container starts.
# This will execute the start-server.sh script.
CMD [ "/usr/src/app/start-server.sh" ]