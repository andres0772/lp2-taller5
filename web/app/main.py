from flask import Flask, render_template, request
import requests

app = Flask(__name__)

# La URL de la API donde Flask realizará las solicitudes (esto podría estar configurado en un archivo de entorno)
API_URL = "http://api:8000"  # Asegúrate de que la URL es correcta

@app.route('/')
def index():
    # Hacemos una solicitud a la API para obtener la lista de usuarios
    response = requests.get(f"{API_URL}/users")
    
    # Si la respuesta es exitosa (200 OK)
    if response.status_code == 200:
        users = response.json()  # Convierte la respuesta en formato JSON
    else:
        users = []
    
    # Renderiza una plantilla con los datos de los usuarios
    return render_template("index.html", users=users)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
