from flask import Blueprint, request, jsonify
from .models import Customer, Quote, Profile
from backend import db
from flask_cors import CORS, cross_origin
from .form_validate import QuoteForm, LoginForm, SignUpForm, UserProfileForm
from passlib.hash import bcrypt

views = Blueprint('views', __name__)

hardcoded_accts = {"Tester": ["Tester@Test.com", "Test123456"], "matcha": ["abc123@gmail.com", "red321"]}

@views.route('/signup', methods=["GET", "POST"])
@cross_origin(supports_credentials=True)
def register():
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]
        email = request.form["email"]

        form = SignUpForm(request.form)
        if form.validate():
            existing_user = Customer.query.filter_by(username=username).first()
            if existing_user:
                return jsonify(["Username already exists"])
            else:
                password_hashed = bcrypt.hash(password)
                new_customer = Customer(username=username, email=email, password=password_hashed)
                db.session.add(new_customer)
                db.session.commit()
                return jsonify(["Register success. Login now"])
        else:
            errors = form.errors
            return jsonify([str(errors)])

@views.route('/login', methods=["POST"])
def login():
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]

        form = LoginForm(request.form)
        if form.validate():
            user = Customer.query.filter_by(username=username).first()
            if user and bcrypt.verify(password, user.password):
                return jsonify(["success"])
            else:
                return jsonify(["Invalid credentials"])
        else:
            errors = form.errors
            return jsonify([str(errors)])

@views.route('/quote/<int:id>', methods=["GET", "POST"])
@cross_origin(supports_credentials=True)
def quote(id):
    if request.method == "POST":
        user_id = id
        gallons = request.form["gallons"]
        address = request.form["address"]
        date = request.form["date"]
        suggested = request.form["suggested"]
        total = request.form["total"]

        form = QuoteForm(request.form)
        if form.validate():
            gallons = form.gallons.data
            address = form.address.data
            date = form.date.data
            suggested = form.suggested.data
            total = form.total.data

            db.session.add(Quote(user_id=user_id, gallons=gallons, address=address, date=date, suggested=suggested, total=total))
            db.session.commit()

            return jsonify(["Fuel Quote created"])

        else:
            errors = form.errors
            return jsonify([str(errors)])

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
        return jsonify(quotes)

@views.route('/fuelquote/<int:id>', methods=["GET"])
@cross_origin(supports_credentials=True)
def getFuelQuoteData(id):
    if request.method == "GET":
        d = {}
        row = Profile.query.filter_by(user_id=id).first()
        if row:
            address1 = row.address1
            d['address1'] = address1
            address2 = row.address2
            d['address2'] = address2
            # Hardcoded For Now
            suggested = 3.43
            d['suggested'] = str(suggested)
        return jsonify(d)

@views.route('/dashboard/<int:id>', methods=["GET"])
@cross_origin(supports_credentials=True)
def getDashData(id):
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
        return jsonify(quotes)

@views.route('/customer/<int:id>', methods=["GET"])
@cross_origin(supports_credentials=True)
def getCustomerData(id):
    if request.method == "GET":
        d = {}
        row = Customer.query.filter_by(id=id).first()
        if row:
            email = row.email
            d['email'] = email
            username = row.username
            d['username'] = username
        return jsonify(d)

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

        form = UserProfileForm(request.form)
        if form.validate():
            user_id = form.user_id.data
            fullname = form.fullname.data
            address1 = form.address1.data
            address2 = form.address2.data
            city = form.city.data
            stateCode = form.stateCode.data
            zipcode = form.zipcode.data

            db.session.add(Profile(user_id=user_id, fullname=fullname, address1=address1, address2=address2, city=city, stateCode=stateCode, zipcode=zipcode))
            db.session.commit()

            return jsonify(["Profile created"])

        else:
            errors = form.errors
            return jsonify([str(errors)])

@views.route('/profileInfo/<int:id>', methods=["GET"])
@cross_origin(supports_credentials=True)
def getProfile(id):
    if request.method == "GET":
        info = {}
        found_user = Profile.query.filter_by(user_id=id).first()
        if found_user:
            info['fullname'] = found_user.fullname
            info['address1'] = found_user.address1
            info['address2'] = found_user.address2
            info['city'] = found_user.city
            info['stateCode'] = found_user.stateCode
            info['zipcode'] = found_user.zipcode

        return jsonify (info)


@views.route('/editProfile/<int:id>', methods=["GET", "POST"])
@cross_origin(supports_credentials=True)
def editProfile(id):
    if request.method == "POST":
        user_id = id
        fullname = request.form["fullname"]
        address1 = request.form["address1"]
        address2 = request.form["address2"]
        city = request.form["city"]
        stateCode = request.form["stateCode"]
        zipcode = request.form["zipcode"]

        print("Profile Successfully Pulled")
        form = UserProfileForm(request.form)
        if form.validate():
            user_id = form.user_id.data
            fullname = form.fullname.data
            address1 = form.address1.data
            address2 = form.address2.data
            city = form.city.data
            stateCode = form.stateCode.data
            zipcode = form.zipcode.data

            found_user = Profile.query.filter_by(user_id = user_id).first()
            if found_user:
                found_user.fullname = fullname
                found_user.address1 = address1
                found_user.address2 = address2
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
           

        return jsonify(info)

