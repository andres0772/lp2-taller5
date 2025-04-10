# Dockerfile
# Usamos la imagen oficial de Nginx como base
FROM nginx:alpine

# Copiamos la configuración de Nginx personalizada al contenedor
COPY nginx.conf /etc/nginx/nginx.conf

# Exponemos el puerto 80 para que Nginx escuche en este puerto
EXPOSE 80

# Nginx ya está configurado para ejecutarse en su contenedor por defecto
CMD ["nginx", "-g", "daemon off;"]
