# web/app/main.py
from flask import Flask, render_template, redirect, request, jsonify
import sqlite3
from pprint import pprint
from fastapi import FastAPI, Depends
from sqlalchemy import create_engine, Column, Integer, String, Text, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship, Session

# conexión a la base de datos
def get_connection():
    conn = sqlite3.connect("blog.sqlite3")
    conn.row_factory = sqlite3.Row
    return conn


# aplicación
app = Flask(__name__)


# rutas
@app.route('/')
def ruta_raiz():
  return render_template('index.html')



# programa principal
if __name__ == '__main__':
  app.run(host='0.0.0.0', debug=True)