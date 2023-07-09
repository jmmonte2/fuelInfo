from backend import db


class Customer(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(105), nullable=False)
    password = db.Column(db.String(105), nullable=False)
    username = db.Column(db.String(105), nullable=False)

    