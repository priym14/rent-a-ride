# ---------- Stage 1: Build Dependencies ----------
FROM node:20-alpine AS builder

WORKDIR /app

# Copy only package files (better caching)
COPY backend/package*.json ./

# Install all deps (including dev if needed)
RUN npm install

# Copy full backend code
COPY backend ./backend


# ---------- Stage 2: Production Image ----------
FROM node:20-alpine

WORKDIR /app

# Copy only production dependencies
COPY --from=builder /app/node_modules ./node_modules

# Copy application code
COPY --from=builder /app/backend ./backend

# Expose app port
EXPOSE 5000

# Run app
CMD ["node", "backend/server.js"]