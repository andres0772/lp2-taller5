from fastapi import FastAPI, Depends, HTTPException, Query
from sqlalchemy import create_engine, Column, Integer, String, Text, ForeignKey, TIMESTAMP, func, asc, desc
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

class PublicacionResponse(PublicacionBase):
    id: int
    fecha_creacion: str
    id_usuario: int

    class Config:
        orm_mode = True

# Esquema para Comentarios
class ComentarioBase(BaseModel):
    comentario: str

class ComentarioResponse(ComentarioBase):
    id: int
    fecha_creacion: str
    id_publicacion: int
    id_usuario: int

    class Config:
        orm_mode = True

# ENDPOINTS CRUD CON PAGINACIÓN, FILTRADO Y ORDENACIÓN

# Usuarios
@app.get("/users", response_model=List[UsuarioResponse])
def get_users(
    nombre: Optional[str] = None,
    correo: Optional[str] = None,
    limit: int = Query(default=10, ge=1),
    offset: int = Query(default=0, ge=0),
    order_by: str = Query(default="id"),
    order: str = Query(default="asc"),
    db: Session = Depends(get_db)
):
    query = db.query(Usuario)
    if nombre:
        query = query.filter(Usuario.nombre.like(f"%{nombre}%"))
    if correo:
        query = query.filter(Usuario.correo.like(f"%{correo}%"))
    if order == "asc":
        query = query.order_by(asc(getattr(Usuario, order_by, "id")))
    else:
        query = query.order_by(desc(getattr(Usuario, order_by, "id")))
    return query.offset(offset).limit(limit).all()

# Publicaciones
@app.get("/posts", response_model=List[PublicacionResponse])
def get_posts(
    titulo: Optional[str] = None,
    id_usuario: Optional[int] = None,
    limit: int = Query(default=10, ge=1),
    offset: int = Query(default=0, ge=0),
    order_by: str = Query(default="id"),
    order: str = Query(default="asc"),
    db: Session = Depends(get_db)
):
    query = db.query(Publicacion)
    if titulo:
        query = query.filter(Publicacion.titulo.like(f"%{titulo}%"))
    if id_usuario:
        query = query.filter(Publicacion.id_usuario == id_usuario)
    if order == "asc":
        query = query.order_by(asc(getattr(Publicacion, order_by, "id")))
    else:
        query = query.order_by(desc(getattr(Publicacion, order_by, "id")))
    return query.offset(offset).limit(limit).all()

# Comentarios
@app.get("/comments", response_model=List[ComentarioResponse])
def get_comments(
    comentario: Optional[str] = None,
    id_publicacion: Optional[int] = None,
    id_usuario: Optional[int] = None,
    limit: int = Query(default=10, ge=1),
    offset: int = Query(default=0, ge=0),
    order_by: str = Query(default="id"),
    order: str = Query(default="asc"),
    db: Session = Depends(get_db)
):
    query = db.query(Comentario)
    if comentario:
        query = query.filter(Comentario.comentario.like(f"%{comentario}%"))
    if id_publicacion:
        query = query.filter(Comentario.id_publicacion == id_publicacion)
    if id_usuario:
        query = query.filter(Comentario.id_usuario == id_usuario)
    if order == "asc":
        query = query.order_by(asc(getattr(Comentario, order_by, "id")))
    else:
        query = query.order_by(desc(getattr(Comentario, order_by, "id")))
    return query.offset(offset).limit(limit).all()

# Endpoint raíz
@app.get("/")
def read_root():
    return {"message": "Bienvenido a la API del Blog"}