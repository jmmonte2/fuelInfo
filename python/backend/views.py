from flask import Blueprint, request, json, jsonify
from .models import Customer, Quote, Profile
from backend import db
from flask_cors import CORS, cross_origin
from .form_validate import QuoteForm, LoginForm, SignUpForm
from passlib.hash import bcrypt
from wtforms import PasswordField

views = Blueprint('views', __name__)


# username  email  password
hardcoded_accts = {"Tester": ["Tester@Test.com", "Test123456"], "matcha": ["abc123@gmail.com", "red321"]}

@views.route('/signup', methods=["GET", "POST"])
@cross_origin(supports_credentials=True)
def register():
    print("Useing Sign Up")
    d={}
    # only care anout post for register
    if request.method =="POST":
    
        # need to be edited
        username = request.form["username"]
        password = request.form["password"]
        email = request.form["email"]

        form = SignUpForm(request.form)
        if form.validate():
            username = form.username.data
            #Password Encryption
            #To match passwords use "bcrypt.verify(user_password, stored_password)""
            password = bcrypt.hash(form.password.data)
            email = form.email.data

            # email = Student.query.filter_by(email=mail).first()

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
        else:
            errors = form.errors
            return jsonify([str(errors)])

@views.route('/login', methods=["GET", "POST"])
def login():
    d = {}
    # handles when customer attempts to login 
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]

        form = LoginForm(request.form)
        if form.validate():
            username = form.username.data
            password = form.password.data
        
            # login = Customer.query.filter_by(email=mail, password=password).first()

            # hardcoded user info
            if username in hardcoded_accts and hardcoded_accts[username][1] == password:
                return jsonify([ "success"])
            else:
                
                return jsonify(["Wrong Credentials"]) 
            
        else:
            errors = form.errors
            return jsonify([str(errors)])

#Post Single Quote From Fuel Quote Form and Pull All Quotes Of A Given Id        
@views.route('/quote/<int:id>', methods=["GET", "POST"])
@cross_origin(supports_credentials=True)
def quote(id):

    #Post Request
    if request.method == "POST":
        user_id = id
        gallons = request.form["gallons"]
        address = request.form["address"]
        date = request.form["date"]
        suggested = request.form["suggested"]
        total = request.form["total"]

        #Backend Validation
        form = QuoteForm(request.form)
        if form.validate():
            gallons = form.gallons.data
            address = form.address.data
            date = form.date.data
            suggested = form.suggested.data
            total = form.total.data
            
            #Database Add
            db.session.add(Quote(user_id = user_id, gallons = gallons, address = address, date = date, suggested = suggested, total = total))
            db.session.commit()

            return jsonify([ "Fuel Quote created"])
        
        else:
            errors = form.errors
            return jsonify([str(errors)])

    #Get Request       
    if request.method == "GET":
        quotes = []
        rows = Quote.query.filter_by(user_id=1)
        for row in rows:
            quote = {
                'id': row.id,
                'gallons': row.gallons,
                'address': row.address,
                'date': row.date,
                'suggested': row.suggested,
                'total': row.total,
            }
            quotes.append(quote)
        return jsonify (quotes)

#Gets Customer Profile Data For Auto Fill Fields In Fuel Quote Form Of A Given Id  
@views.route('/fuelquote/<int:id>', methods=["GET"])
@cross_origin(supports_credentials=True)
def getFuelQuoteData(id):

    #Get Request    
    if request.method == "GET":
        d = {}
        row = Profile.query.filter_by(user_id = id).first()
        if row:
            address1 = row.address1
            d['address1'] = address1
            address2 = row.address2
            d['address2'] = address2
            #Hardcoded For Now
            suggested = 3.43
            d['suggested'] = str(suggested)
        return jsonify (d)

#Gets Three Most Recent Quotes For Dash Screen Of A Given Id     
@views.route('/dashboard/<int:id>', methods=["GET"])
@cross_origin(supports_credentials=True)
def getDashData(id):

    #Get Request    
    if request.method == "GET":
        quotes = []
        rows = Quote.query.filter_by(user_id=id).order_by(Quote.id.desc()).limit(3)
        for row in rows:
            quote = {
                'id': row.id,
                'gallons': row.gallons,
                'address': row.address,
                'date': row.date,
                'suggested': row.suggested,
                'total': row.total,
            }
            quotes.append(quote)
        return jsonify (quotes)

#Gets Customer Data For General Use Of A Given Id  
@views.route('/customer/<int:id>', methods=["GET"])
@cross_origin(supports_credentials=True)
def getCustomerData(id):
    if request.method == "GET":
        d = {}
        row = Customer.query.filter_by(id = id).first()
        if row:
            email = row.email
            d['email'] = email
            username = row.username
            d['username'] = username
        return jsonify (d)