from flask import Blueprint, request, json, jsonify
from .models import Customer
from backend import db

views = Blueprint('views', __name__)


# username  email  password
hardcoded_accts = {"Apples": ["jdksf@ymail.com", "12345"], "matcha": ["abc123@gmail.com", "red321"]}

@views.route('/signup', methods=["GET", "POST"])
def register():
    # only care anout post for register
    if request.method =="POST":
    
        # need to be edited
        username = request.form["username"]
        password = request.form["password"]
        email = request.form["email"]

        # email = Customer.query.filter_by(email=mail).first()

        if username not in hardcoded_accts:
            # add accouuunt
            # register = Student(email=mail, password=password)
            # db.session.add(register)
            # db.session.commit()
            
            hardcoded_accts[username] = [email, password]
            return jsonify(["Register success. Login now"])
        else:
            # already exist
            
            
            return jsonify(["Username already exist"])


@views.route('/login', methods=["GET", "POST"])
def login():
    # handles when customer attempts to login 
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]
        
        # login = Customer.query.filter_by(email=mail, password=password).first()

        # hardcoded user info
        if username in hardcoded_accts and hardcoded_accts[username][1] == password:
            return jsonify([ "success"])
        else:
            
            return jsonify(["Wrong Credentials"]) 
            
           