# Etapa 1: Construir la aplicación
FROM node:18 AS build

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar el package.json y package-lock.json (o yarn.lock)
COPY package*.json ./

# Instalar dependencias
RUN npm install

# Copiar el resto de la aplicación
COPY . .

# Construir la aplicación (esto generará el directorio 'dist')
RUN npm run build

# Etapa 2: Preparar la imagen final
FROM node:18 AS production

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar solo lo necesario para la producción (archivos de build y dependencias)
COPY --from=build /app/package*.json ./
COPY --from=build /app/dist ./dist

# Instalar las dependencias necesarias para producción
RUN npm install --production

# Exponer el puerto 3001
EXPOSE 3001

# Iniciar el servidor Next.js
CMD ["npm", "start"]
