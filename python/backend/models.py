from backend import db


class Customer(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(105), nullable=False)
    password = db.Column(db.String(105), nullable=False)
    username = db.Column(db.String(105), nullable=False)
    quotes = db.relationship('Quote', backref = 'customer', lazy = True)
    profile = db.relationship('Profile', backref = 'customer', lazy = True)

class Quote(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('customer.id'), nullable=False)
    gallons = db.Column(db.Integer, nullable=False)
    address = db.Column(db.String(100), nullable=False)
    date = db.Column(db.Date, nullable=False)
    suggested = db.Column(db.Float, nullable=False)
    total = db.Column(db.Float, nullable=False)

class Profile(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('customer.id'), nullable=False)
    name = db.Column(db.String(50), nullable=False)
    address1 = db.Column(db.String(100), nullable=False)
    address2 = db.Column(db.String(100), nullable=True)
    city = db.Column(db.String(100), nullable=False)
    state = db.Column(db.String(50), nullable=False)
    zip = db.Column(db.String(9), nullable=False)

    