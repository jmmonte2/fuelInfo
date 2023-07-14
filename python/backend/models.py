from backend import db


class Customer(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(105), nullable=False)
    password = db.Column(db.String(105), nullable=False)
    username = db.Column(db.String(105), nullable=False)
    quotes = db.relationship('Quote', backref = 'customer', lazy = True)

class Quote(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('customer.id'), nullable=False)
    gallons = db.Column(db.Integer, nullable=False)
    address = db.Column(db.String(100), nullable=False)
    date = db.Column(db.Date, nullable=False)
    suggested = db.Column(db.Float, nullable=False)
    total = db.Column(db.Float, nullable=False)


    