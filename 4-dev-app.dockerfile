# Image officielle Node.js (alpine pour légèreté)
FROM node:20-alpine

# Créer un groupe et un utilisateur non-root
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Créer le répertoire de l'application
WORKDIR /app

# Copier uniquement les fichiers de dépendances d'abord (cache Docker)
COPY package*.json ./

# Installer les dépendances (si package-lock.json existe, npm ci est préférable)
# Utiliser --omit=dev pour éviter les dépendances de dev en prod
RUN if [ -f package-lock.json ]; then npm ci --omit=dev; else npm install --omit=dev; fi

# Copier le reste des fichiers de l'application
COPY . .

# Donner la propriété du dossier à l'utilisateur non-root (incluant node_modules)
RUN chown -R appuser:appgroup /app

# Passer à l'utilisateur non-root
USER appuser

# Exposer le port utilisé par l'app
EXPOSE 3000

# Démarrer l'application
CMD ["node", "server.js"]
# Image officielle Node.js (alpine pour légèreté)
FROM node:20-alpine

# Créer un groupe et un utilisateur non-root
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Créer le répertoire de l'application
WORKDIR /app

# Copier uniquement les fichiers de dépendances d'abord (cache Docker)
COPY package*.json ./

# Utiliser --omit=dev pour éviter les dépendances de dev en prod
RUN if [ -f package-lock.json ]; then npm ci --omit=dev; else npm install --omit=dev; fi

# Copier le reste des fichiers de l'application
COPY . .

# Donner la propriété du dossier à l'utilisateur non-root (incluant node_modules)
RUN chown -R appuser:appgroup /app

# Passer à l'utilisateur non-root
USER appuser

# Exposer le port utilisé par l'app
EXPOSE 3000

# Démarrer l'application
CMD ["node", "server.js"]
