# web/app/main.py
from flask import Flask, render_template, redirect
import sqlite3
from pprint import pprint


conexion = sqlite3.connect('web2.sqlite3')
conexion.row_factory = sqlite3.Row #modo diccionario
cursor = conexion.cursor()


# aplicación
app = Flask(__name__)


# rutas
@app.route('/')
def ruta_raiz():
  return render_template('index.html')



# programa principal
if __name__ == '__main__':
  app.run(host='0.0.0.0', debug=True)