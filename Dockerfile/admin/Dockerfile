# admin-frontend/Dockerfile

# Stage 1: Build the Vite app
FROM node:18 AS build
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Vite app for production
RUN npm run build

# Stage 2: Serve the Vite app using Nginx
FROM nginx:alpine
WORKDIR /usr/share/nginx/html

# Copy the built Vite app from the build stage
COPY --from=build /app/dist .

# Copy the Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]