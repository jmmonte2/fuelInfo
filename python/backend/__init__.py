from flask import Flask 
from flask_sqlalchemy import SQLAlchemy
from os import path

db = SQLAlchemy()
DB_NAME = "fuel_system.db"

def create_app():
    app = Flask(__name__)
    app.config['SECRET_KEY'] = 'apples'
    # by default this creates db if it does not exist
    app.config['SQLALCHEMY_DATABASE_URI'] = f'sqlite:///{DB_NAME}'

    db.init_app(app)

    from .views import views

    app.register_blueprint(views)
    # create_database(app)

    return app
    
    
def create_database(app):
    if not path.exists('software/' + DB_NAME):
        db.create_all(app=app)