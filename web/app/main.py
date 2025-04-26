# web/app/main.py
from flask import Flask, render_template, request
import requests

app = Flask(__name__)

API_URL = "http://api:8000"  # Asegúrate de que sea el nombre del servicio en Docker

@app.route("/")
def home():
    publicaciones = requests.get(f"{API_URL}/publicaciones").json()
    return render_template("index.html", publicaciones=publicaciones)

@app.route("/publicacion/<int:id>")
def publicacion(id):
    pub = requests.get(f"{API_URL}/publicaciones").json()
    comentarios = requests.get(f"{API_URL}/comentarios/{id}").json()
    publicacion = next((p for p in pub if p["id"] == id), None)
    return render_template("publicacion.html", publicacion=publicacion, comentarios=comentarios)

