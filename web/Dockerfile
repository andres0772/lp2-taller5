# Dockerfile
# Usamos una imagen base de Python
FROM python:3.9-slim

# Definimos el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiamos el archivo requirements.txt al contenedor
COPY requirements.txt /app/

# Instalamos las dependencias necesarias desde requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copiamos el resto de los archivos de la aplicación al contenedor
COPY . /app/

# Exponemos el puerto en el que Flask va a correr (por defecto, Flask usa el puerto 5000)
EXPOSE 5000

# Comando para ejecutar la aplicación Flask
CMD ["python", "app.py"]
