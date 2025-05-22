# Use an official Node.js runtime as the base image
FROM node:14-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install the project dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Build the React app for production
RUN npm run build

# Serve the React app using a lightweight HTTP server
FROM nginx:alpine

# Ensure permissions for /var/cache/nginx (required for Nginx on some systems)
RUN mkdir -p /var/cache/nginx/client_temp && \
    chmod -R 777 /var/cache/nginx

# Copy the build output from the previous stage to the nginx HTML directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx server in the foreground
CMD ["nginx", "-g", "daemon off;"]
