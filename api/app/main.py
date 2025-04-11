from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy import create_engine, Column, Integer, String, Text, ForeignKey, TIMESTAMP, func
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship, Session
from dotenv import load_dotenv
from pydantic import BaseModel
from typing import List, Optional
import os

# Cargar variables de entorno
load_dotenv()
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql+psycopg2://admin:admin@localhost:5432/blog")

# Configuración de SQLAlchemy
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# Modelos de la base de datos
class Usuario(Base):
    __tablename__ = "usuarios"
    id = Column(Integer, primary_key=True, index=True)
    usuario = Column(String(50), unique=True, nullable=False)
    nombre = Column(String(100), nullable=False)
    correo = Column(String(100), unique=True, nullable=False)
    password = Column(String(255), nullable=False)
    fecha_creacion = Column(TIMESTAMP, server_default=func.now())

class Publicacion(Base):
    __tablename__ = "publicaciones"
    id = Column(Integer, primary_key=True, index=True)
    titulo = Column(String(255), nullable=False)
    contenido = Column(Text, nullable=False)
    url_imagen = Column(String(255), nullable=True)
    id_usuario = Column(Integer, ForeignKey("usuarios.id"), nullable=False)
    fecha_creacion = Column(TIMESTAMP, server_default=func.now())
    usuario = relationship("Usuario", back_populates="publicaciones")

class Comentario(Base):
    __tablename__ = "comentarios"
    id = Column(Integer, primary_key=True, index=True)
    comentario = Column(Text, nullable=False)
    id_publicacion = Column(Integer, ForeignKey("publicaciones.id"), nullable=False)
    id_usuario = Column(Integer, ForeignKey("usuarios.id"), nullable=False)
    fecha_creacion = Column(TIMESTAMP, server_default=func.now())
    publicacion = relationship("Publicacion", back_populates="comentarios")
    usuario = relationship("Usuario", back_populates="comentarios")

Usuario.publicaciones = relationship("Publicacion", back_populates="usuario")
Usuario.comentarios = relationship("Comentario", back_populates="usuario")
Publicacion.comentarios = relationship("Comentario", back_populates="publicacion")

# Crear tablas
Base.metadata.create_all(bind=engine)

# Dependencia para obtener la sesión de la base de datos
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Inicializar FastAPI
app = FastAPI(title="API del Blog de Sistemas Operativos")

# Esquema para Usuarios
class UsuarioBase(BaseModel):
    usuario: str
    nombre: str
    correo: str
    password: str

class UsuarioCreate(UsuarioBase):
    pass

class UsuarioResponse(UsuarioBase):
    id: int
    fecha_creacion: str

    class Config:
        orm_mode = True

# Esquema para Publicaciones
class PublicacionBase(BaseModel):
    titulo: str
    contenido: str
    url_imagen: Optional[str]

class PublicacionCreate(PublicacionBase):
    id_usuario: int

class PublicacionResponse(PublicacionBase):
    id: int
    fecha_creacion: str
    id_usuario: int

    class Config:
        orm_mode = True

# Esquema para Comentarios
class ComentarioBase(BaseModel):
    comentario: str

class ComentarioCreate(ComentarioBase):
    id_publicacion: int
    id_usuario: int

class ComentarioResponse(ComentarioBase):
    id: int
    fecha_creacion: str
    id_publicacion: int
    id_usuario: int

    class Config:
        orm_mode = True

# ENDPOINTS CRUD PARA USUARIOS

@app.get("/users", response_model=List[UsuarioResponse])
def get_users(db: Session = Depends(get_db)):
    return db.query(Usuario).all()

@app.get("/users/{user_id}", response_model=UsuarioResponse)
def get_user(user_id: int, db: Session = Depends(get_db)):
    user = db.query(Usuario).filter(Usuario.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")
    return user

@app.post("/users", response_model=UsuarioResponse)
def create_user(user: UsuarioCreate, db: Session = Depends(get_db)):
    nuevo_usuario = Usuario(**user.dict())
    db.add(nuevo_usuario)
    try:
        db.commit()
        db.refresh(nuevo_usuario)
    except:
        db.rollback()
        raise HTTPException(status_code=400, detail="El usuario o correo ya existe")
    return nuevo_usuario

@app.put("/users/{user_id}", response_model=UsuarioResponse)
def update_user(user_id: int, user: UsuarioCreate, db: Session = Depends(get_db)):
    usuario_existente = db.query(Usuario).filter(Usuario.id == user_id).first()
    if not usuario_existente:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")
    for key, value in user.dict().items():
        setattr(usuario_existente, key, value)
    db.commit()
    db.refresh(usuario_existente)
    return usuario_existente

@app.delete("/users/{user_id}")
def delete_user(user_id: int, db: Session = Depends(get_db)):
    usuario = db.query(Usuario).filter(Usuario.id == user_id).first()
    if not usuario:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")
    db.delete(usuario)
    db.commit()
    return {"detail": "Usuario eliminado correctamente"}

# ENDPOINTS CRUD PARA PUBLICACIONES

@app.get("/posts", response_model=List[PublicacionResponse])
def get_posts(db: Session = Depends(get_db)):
    return db.query(Publicacion).all()

@app.get("/posts/{post_id}", response_model=PublicacionResponse)
def get_post(post_id: int, db: Session = Depends(get_db)):
    post = db.query(Publicacion).filter(Publicacion.id == post_id).first()
    if not post:
        raise HTTPException(status_code=404, detail="Publicación no encontrada")
    return post

@app.post("/posts", response_model=PublicacionResponse)
def create_post(post: PublicacionCreate, db: Session = Depends(get_db)):
    nueva_publicacion = Publicacion(**post.dict())
    db.add(nueva_publicacion)
    try:
        db.commit()
        db.refresh(nueva_publicacion)
    except:
        db.rollback()
        raise HTTPException(status_code=400, detail="Error al crear la publicación")
    return nueva_publicacion

@app.put("/posts/{post_id}", response_model=PublicacionResponse)
def update_post(post_id: int, post: PublicacionCreate, db: Session = Depends(get_db)):
    publicacion_existente = db.query(Publicacion).filter(Publicacion.id == post_id).first()
    if not publicacion_existente:
        raise HTTPException(status_code=404, detail="Publicación no encontrada")
    for key, value in post.dict().items():
        setattr(publicacion_existente, key, value)
    db.commit()
    db.refresh(publicacion_existente)
    return publicacion_existente

@app.delete("/posts/{post_id}")
def delete_post(post_id: int, db: Session = Depends(get_db)):
    publicacion = db.query(Publicacion).filter(Publicacion.id == post_id).first()
    if not publicacion:
        raise HTTPException(status_code=404, detail="Publicación no encontrada")
    db.delete(publicacion)
    db.commit()
    return {"detail": "Publicación eliminada correctamente"}

# ENDPOINTS CRUD PARA COMENTARIOS

@app.get("/comments", response_model=List[ComentarioResponse])
def get_comments(db: Session = Depends(get_db)):
    return db.query(Comentario).all()

@app.get("/comments/{comment_id}", response_model=ComentarioResponse)
def get_comment(comment_id: int, db: Session = Depends(get_db)):
    comment = db.query(Comentario).filter(Comentario.id == comment_id).first()
    if not comment:
        raise HTTPException(status_code=404, detail="Comentario no encontrado")
    return comment

@app.post("/comments", response_model=ComentarioResponse)
def create_comment(comment: ComentarioCreate, db: Session = Depends(get_db)):
    nuevo_comentario = Comentario(**comment.dict())
    db.add(nuevo_comentario)
    try:
        db.commit()
        db.refresh(nuevo_comentario)
    except:
        db.rollback()
        raise HTTPException(status_code=400, detail="Error al crear el comentario")
    return nuevo_comentario

@app.put("/comments/{comment_id}", response_model=ComentarioResponse)
def update_comment(comment_id: int, comment: ComentarioCreate, db: Session = Depends(get_db)):
    comentario_existente = db.query(Comentario).filter(Comentario.id == comment_id).first()
    if not comentario_existente:
        raise HTTPException(status_code=404, detail="Comentario no encontrado")
    for key, value in comment.dict().items():
        setattr(comentario_existente, key, value)
    db.commit()
    db.refresh(comentario_existente)
    return comentario_existente

@app.delete("/comments/{comment_id}")
def delete_comment(comment_id: int, db: Session = Depends(get_db)):
    comentario = db.query(Comentario).filter(Comentario.id == comment_id).first()
    if not comentario:
        raise HTTPException(status_code=404, detail="Comentario no encontrado")
    db.delete(comentario)
    db.commit()
    return {"detail": "Comentario eliminado correctamente"}

# Endpoint raíz
@app.get("/")
def read_root():
    return {"message": "Bienvenido a la API del Blog"}