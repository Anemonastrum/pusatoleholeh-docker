# backend/Dockerfile
FROM node:18

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the API port
EXPOSE 8000
EXPOSE 9000

# Start the backend server
CMD ["npm", "start"]