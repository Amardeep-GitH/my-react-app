# Use an official Node.js runtime as the base image
FROM node:14-alpine AS build

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Serve the React app using a lightweight HTTP server
FROM nginx:alpine

# Fix for OpenShift file permission issues
RUN mkdir -p /var/cache/nginx/client_temp && \
    chmod -R 777 /var/cache/nginx

# 🔧 Add this line to override nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf

COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
