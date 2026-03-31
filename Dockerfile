# Use a specific lightweight version instead of latest
FROM node:18-alpine

# Create app directory
WORKDIR /app

# Copy only package files first (better caching)
COPY package*.json ./

# Install dependencies
RUN npm install --only=production

# Copy remaining files
COPY . .

# Remove unnecessary packages (no curl/vim/wget)
# (Nothing installed here intentionally)

# Do NOT store secrets in image
# Secrets should be passed at runtime

# Expose only required port
EXPOSE 3000

# Run as non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Start application
CMD ["node", "server.js"]
