from backend.models import Quote, Customer

#test the functions by importing pytest and running pytest --cov in terminal


def test_quote(client, app):
    response = client.post("/quote", data={"user_id": "1", "gallons": "12", "address": "321 Elmo Street", "date": "2023-07-13", "suggested": "1.5", "total": "24"})

    with app.app_context():
        assert Quote.query.count() == 1

def test_quote_bad(client, app):
    response = client.post("/quote", data={"user_id": "a", "gallons": "12", "address": "321 Elmo Street", "date": "2023-07-13", "suggested": "1.5", "total": "24"})

    with app.app_context():
        assert Quote.query.count() == 1

def test_register(client, app):
    response = client.post("/signup", data = {"username": "John", "password": "12345", "email": "jdksf@ymail.com"})

    with app.app_context():
        assert response.status_code == 200

def test_register_bad(client, app):
    response = client.post("/signup", data = {"username": "Apples", "password": "12345", "email": "jdksf@ymail.com"})

    with app.app_context():
        assert response.status_code == 200

def test_login(client, app):
    response = client.post("/login", data = {"username": "Apples", "password": "12345"})
    
    with app.app_context():
        assert response.status_code == 200

def test_login_bad(client, app):
    response = client.post("/login", data = {"username": "Jhon", "password": "12345"})
    
    with app.app_context():
        assert response.status_code == 200
