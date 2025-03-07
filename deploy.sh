#!/bin/bash

IMAGE_NAME="devops-evaluation-app"
CONTAINER_NAME="devops-container"
PORT=8080

#Verificar si Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "Error: Docker no está instalado."
    exit 1
fi
echo "Docker está instalado."

#Construir la imagen de Docker
docker build -t $IMAGE_NAME .

if [ $? -ne 0 ]; then
    echo "Error: Falló la construcción de la imagen."
    exit 1
fi
echo "Imagen Docker construida correctamente."

#Verificar si ya hay un contenedor corriendo con el mismo nombre y eliminarlo
docker rm -f $CONTAINER_NAME &> /dev/null

#Ejecutar el contenedor
echo "Ejecutando el contenedor..."
docker run -d --name $CONTAINER_NAME -p $PORT:3000 -e PORT=3000 -e NODE_ENV=production $IMAGE_NAME
if [ $? -ne 0 ]; then
    echo "Error: No se pudo iniciar el contenedor."
    exit 1
fi
echo "Contenedor iniciado correctamente en el puerto $PORT."

#Esperar a que el servicio arranque y ejecutar prueba
sleep 5
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$PORT/health)

if [ "$RESPONSE" == "200" ]; then
    echo "La aplicación está corriendo correctamente."
    exit 0
else
    echo "Error: La aplicación no respondió correctamente. Código de estado: $RESPONSE"
    exit 1
fi
