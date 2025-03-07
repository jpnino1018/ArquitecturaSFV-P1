#Basado en una imagen oficial de Node.js
FROM node:20

#Establecer el directorio de trabajo en el contenedor
WORKDIR /app

#Se copian los archivos de dependencias
COPY package.json ./

#Instalar las dependencias
RUN npm install --only=production

#Se copia el resto del código de la aplicación
COPY . .

#Exponer el puerto en el que corre la aplicación
EXPOSE 3000

#Definir la variable de entorno por default
ENV NODE_ENV=production

#Comando para iniciar la aplicación
CMD ["npm", "start"]
