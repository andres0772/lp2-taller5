from fastapi import FastAPI
from pydantic import BaseModel
from typing import List

app = FastAPI(title="API del blog de sistemas operativos")

class User(BaseModel):
    id: int
    username: str
    email: str

class Post(BaseModel):
    id: int
    title: str  # corregido
    content: str
    user_id: int

class Comment(BaseModel):
    id: int
    content: str
    post_id: int
    user_id: int

# Datos simulados
users = [
    {"id": 1, "username": "andres77", "email": "andres77@example.com"},
    {"id": 2, "username": "lina89", "email": "lina89@example.com"},
    {"id": 3, "username": "juan23", "email": "juan23@example.com"},
    {"id": 4, "username": "sofia99", "email": "sofia99@example.com"},
    {"id": 5, "username": "mario_king", "email": "mario_king@example.com"}
]

posts = [
    {"id": 1, "title": "Primer post", "content": "Este es el primer artículo del blog.", "user_id": 1},
    {"id": 2, "title": "Tecnología 2025", "content": "Las tendencias de tecnología en 2025 incluyen...", "user_id": 2},
    {"id": 3, "title": "¿Vale la pena Linux?", "content": "Comparación de Windows, Mac y Linux...", "user_id": 3},
    {"id": 4, "title": "Mi experiencia con Docker", "content": "Configurando contenedores en mi proyecto...", "user_id": 4},
    {"id": 5, "title": "Cómo aprender a programar", "content": "Consejos para principiantes en programación...", "user_id": 5}
]

comments = [
    {"id": 1, "content": "¡Muy interesante!", "post_id": 1, "user_id": 2},
    {"id": 2, "content": "Gracias por compartir.", "post_id": 2, "user_id": 3},
]

@app.get("/", tags=["Root"])
def read_root():
    return {"message": "Bienvenido a la API del Blog de Sistemas Operativos"}

@app.get("/users", response_model=List[User], tags=["Users"])
def get_users():
    return users

@app.get("/posts", response_model=List[Post], tags=["Posts"])
def get_posts():
    return posts

@app.get("/comments", response_model=List[Comment], tags=["Comments"])
def get_comments():
    return comments
