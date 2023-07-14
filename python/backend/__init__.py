from flask import Flask 
from flask_sqlalchemy import SQLAlchemy
from os import path
from flask_cors import CORS, cross_origin

db = SQLAlchemy()
DB_NAME = "fuel_system.db"

def create_app():
    app = Flask(__name__)
    CORS(app, supports_credentials=True)
    app.config['SECRET_KEY'] = 'apples'
    # by default this creates db if it does not exist
    app.config['SQLALCHEMY_DATABASE_URI'] = f'sqlite:///{DB_NAME}'
    # Disable CSRF on validation, ideal for production standards, but this project is not about cyber security.
    app.config['WTF_CSRF_ENABLED'] = False

    db.init_app(app)

    from .views import views

    app.register_blueprint(views)
    # create the database if it does not already exist (Using default directory)
    if not path.exists('instance/' + DB_NAME):
        with app.app_context():
            db.create_all()

    return app