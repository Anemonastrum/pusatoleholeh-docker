# frontend/Dockerfile

# Stage 1: Build the React app
FROM node:18 AS build
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the React app for production
RUN npm run build

# Stage 2: Serve the React app using Nginx
FROM nginx:alpine
WORKDIR /usr/share/nginx/html

# Copy the built React app from the build stage
COPY --from=build /app/build .

# Copy the Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]