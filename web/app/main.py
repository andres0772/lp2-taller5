app = Flask(__name__)

API_URL = "http://api:8000"

@app.route("/")
def home():
    publicaciones = requests.get(f"{API_URL}/posts").json() 
    return render_template("index.html", publicaciones=publicaciones)

@app.route("/publicacion/<int:id>")
def publicacion(id):
    pub = requests.get(f"{API_URL}/posts").json()  
    comentarios = requests.get(f"{API_URL}/comments", params={"post_id": id}).json()  
    publicacion = next((p for p in pub if p["id"] == id), None)
    return render_template("publicacion.html", publicacion=publicacion, comentarios=comentarios)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
