# Use official Node.js LTS image
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy package files from backend folder (for better caching)
COPY backend/package*.json ./

# Install dependencies
RUN npm install --production

# Copy the backend source code
COPY backend/ .

# Expose the port
EXPOSE 5000

# Start the server
CMD ["node", "src/server.js"]
