from flask import Blueprint, request, json, jsonify
from .models import Customer, Quote, Profile
from backend import db
from flask_cors import CORS, cross_origin
from .form_validate import QuoteForm, LoginForm, SignUpForm, UserProfileForm, QuoteCreate
from passlib.hash import bcrypt

views = Blueprint('views', __name__)

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
            password = bcrypt.hash(form.password.data)
            email = form.email.data
            existing_user = Customer.query.filter_by(username=username).first()

            if existing_user:
                return jsonify(["Username already exists"])
            
            else:
                new_customer = Customer(username=username, email=email, password=password)
                db.session.add(new_customer)
                db.session.commit()
                return jsonify(["Register success. Login now"])
            
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
            user = Customer.query.filter_by(username=username).first()
            if user and bcrypt.verify(password, user.password):
                return jsonify(["success"])
            
            else:
                return jsonify(["Invalid credentials"])
            
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
        rows = Quote.query.filter_by(user_id=id)
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
    
#Gets Customer ID for cookie
@views.route('/customerid/<string:username>', methods=["GET"])
@cross_origin(supports_credentials=True)
def getCustomerID(username):
    if request.method == "GET":
        d = {}
        row = Customer.query.filter_by(username = username).first()
        if row:
            id = row.id
            d['id'] = id
        return jsonify (d)
    
@views.route('/profileCreation/<int:id>', methods=["GET", "POST"])
@cross_origin(supports_credentials=True)
def profileCreation(id):
    if request.method == "POST":
        user_id = id
        fullname = request.form["fullname"]
        address1 = request.form["address1"]
        address2 = request.form["address2"]
        city = request.form["city"]
        stateCode = request.form["stateCode"]
        zipcode = request.form["zipcode"]

        #Backend Validation
        print("Profile Successfully Pulled")
        form = UserProfileForm(request.form)
        if form.validate():
            fullname = form.fullname.data
            address1 = form.address1.data
            address2 = form.address2.data
            city = form.city.data
            stateCode = form.stateCode.data
            zipcode = form.zipcode.data

            db.session.add(Profile(user_id = user_id, fullname = fullname, address1 = address1, address2 = address2, city = city, stateCode = stateCode, zipcode = zipcode))
            db.session.commit()
            print("Profile Successfully Created")

            return jsonify([ "Profile created"])

        else:
            print("Profile Failed Validation")
            errors = form.errors
            return jsonify([str(errors)])
        
@views.route('/profileInfo/<int:id>', methods=["GET"])
@cross_origin(supports_credentials=True)
def getProfile(id):
    if request.method == "GET":
        info = {}
        print(id)
        found_user = Profile.query.filter_by(user_id = id).first()
        if found_user:
            info['fullname'] = found_user.fullname
            info['address1'] = found_user.address1
            info['address2'] = found_user.address2
            info['city'] = found_user.city
            info['stateCode'] = found_user.stateCode
            info['zipcode'] = found_user.zipcode
        return jsonify (info)

@views.route('/quoteCreate/<int:id>', methods=["POST"])
@cross_origin(supports_credentials=True)
def createQuote(id):
    #Post Request
    d = {}
    if request.method == "POST":
        gallons = float(request.form["gallons"])
        address = request.form["address"]
        date = request.form["date"]

        #Backend Validation
        quote = QuoteCreate(request.form)
        if quote.validate():
            gallons = quote.gallons.data
            address = quote.address.data
            date = quote.date.data
            profile = Profile.query.filter_by(user_id = id).first()
            quotes = Quote.query.filter_by(user_id = id).first()
            location = 0.04
            rate = 0
            galReq = 0.03
            if profile:
                stateCode = profile.stateCode
                print(stateCode)
                if stateCode == 'TX':
                    location = 0.02
                if quotes:
                    rate = 0.01
                if gallons >= 1000:
                    galReq = 0.02
                print(location, rate, galReq)
                margin = (location - rate + galReq + 0.1) * 1.50
                print(margin)
                suggested = 1.50 + margin
                total = gallons * suggested
                d['suggested'] = suggested
                d['total'] = total
                return jsonify (d)
            else:
                return jsonify(["Profile Info Not Provided"])     
            
        else:
            errors = quote.errors
            return jsonify([str(errors)])          

@views.route('/editProfile/<int:id>', methods=["GET", "POST"])
@cross_origin(supports_credentials=True)
def editProfile(id):
    if request.method == "POST":
        id = id
        fullname = request.form["fullname"]
        address1 = request.form["address1"]
        address2 = request.form["address2"]
        city = request.form["city"]
        stateCode = request.form["stateCode"]
        zipcode = request.form["zipcode"]

        print("Profile Successfully Pulled")
        form = UserProfileForm(request.form)
        if form.validate():
            fullname = form.fullname.data
            address1 = form.address1.data
            address2 = form.address2.data
            city = form.city.data
            stateCode = form.stateCode.data
            zipcode = form.zipcode.data

            found_user = Profile.query.filter_by(user_id = id).first()
            if found_user:
                found_user.fullname = fullname
                found_user.address1 = address1
                if address2 != "":
                    found_user.address2 = address2
                else:
                    print("Null")
                    found_user.address2 = None
                found_user.city = city
                found_user.stateCode = stateCode
                found_user.zipcode = zipcode
                db.session.commit()
                print("Profile Successfully edited")

                return jsonify([ "Profile edited"])

            else:
                print("Profile Verification Failed")
                errors = form.errors
                return jsonify([str(errors)])
     