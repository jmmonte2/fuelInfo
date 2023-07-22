from backend.models import Quote, Customer

#test the functions by importing pytest and running pytest --cov in terminal

#----------------- Register Tests -----------------

def test_register_post(client, app):
    response = client.post("/signup", data = {"username": "JohnMaster", "password": "Password123456", "email": "jdksf@ymail.com"})

    with app.app_context():
        assert response.status_code == 200

def test_register_post_bad(client, app):
    response = client.post("/signup", data = {"username": "Tester", "password": "Test123456", "email": "Tester@Test.com"})

    with app.app_context():
        assert response.status_code == 200

def test_register_post_bad_input(client, app):
    response = client.post("/signup", data = {"username": "", "password": "12345", "email": "jdksf@ymail.com"})

    with app.app_context():
        assert response.data != "Username already exist" or response.data != "Register success. Login now"

#----------------- Login Tests -----------------

def test_login_get(client, app):
    response = client.post("/login", data = {"username": "Tester", "password": "Test123456"})
    
    with app.app_context():
        assert response.status_code == 200

def test_login_get_bad(client, app):
    response = client.post("/login", data = {"username": "Jhon", "password": "Test123456"})
    
    with app.app_context():
        assert response.status_code == 200

def test_login_get_bad_input(client, app):
    response = client.post("/login", data = {"username": "", "password": "12345"})
    
    with app.app_context():
        assert response.data != "Wrong Credentials" or response.data != "success"

#----------------- Quote Tests -----------------

def test_quote_post(client, app):
    response = client.post("/quote/1", data={"gallons": "12", "address": "321 Elmo Street", "date": "2023-07-13", "suggested": "1.5", "total": "24"})

    with app.app_context():
        assert Quote.query.count() > 0

def test_quote_post_bad(client, app):
    response = client.post("/quote/1", data={"gallons": "", "address": "321 Elmo Street", "date": "2023-07-13", "suggested": "1.5", "total": "24"})

    with app.app_context():
        assert response.status_code == 200

def test_quote_get(client, app):
    response = client.get("/quote/1")

    with app.app_context():
        assert response.status_code == 200

#----------------- getFuelQuoteData Tests -----------------

def test_fuel_quote_data_get(client, app):
    response = client.get("/fuelquote/1")

    with app.app_context():
        assert response.status_code == 200

#----------------- getDashData Tests -----------------

def test_dash_data_get(client, app):
    response = client.get("/dashboard/1")

    with app.app_context():
        assert response.status_code == 200

#----------------- getCustomerData Tests -----------------

def test_customer_data_get(client, app):
    response = client.get("/customer/1")

    with app.app_context():
        assert response.status_code == 200

#----------------- getCustomerID Tests -----------------

def test_customer_id_get(client, app):
    response = client.get("/customerid/Debugger")

    with app.app_context():
        assert response.status_code == 200

#----------------- profileCreation Tests -----------------

def test_profile_post(client, app):
    response = client.post("/profileCreation/2", data={"fullname": "Bob Builder", "address1": "Some address", "address2": "Some address again", "city": "houston", "stateCode": "TX", "zipcode": "77777"})

    with app.app_context():
        assert Quote.query.count() > 0

def test_profile_post_bad(client, app):
    response = client.post("/profileCreation/2", data={"fullname": "", "address1": "Some address", "address2": "Some address again", "city": "houston", "stateCode": "TX", "zipcode": "77777"})

    with app.app_context():
        assert Quote.query.count() > 0

#----------------- getProfile Tests -----------------

def test_profile_info_get(client, app):
    response = client.get("/profileInfo/1")

    with app.app_context():
        assert response.status_code == 200

#----------------- createQuote Tests -----------------

def test_create_quote_post(client, app):
    response = client.post("/quoteCreate/1", data={"gallons": "12", "address": "321 Elmo Street", "date": "2023-07-13"})

    with app.app_context():
        assert response.status_code == 200

def test_create_quote_post_bad_id(client, app):
    response = client.post("/quoteCreate/400", data={"gallons": "12", "address": "321 Elmo Street", "date": "2023-07-13"})

    with app.app_context():
        assert response.status_code == 200

def test_create_quote_post_bad(client, app):
    response = client.post("/quoteCreate/1", data={"gallons": "12", "address": "", "date": "2023-07-13"})

    with app.app_context():
        assert response.status_code == 200

#----------------- editProfile Tests -----------------

def test_edit_profile_post(client, app):
    response = client.post("/editProfile/1", data={"fullname": "Debug Account", "address1": "Some address", "address2": "Some address again"
                                                 , "city": "Houston", "stateCode": "TX", "zipcode": "77777"})

    with app.app_context():
        assert response.status_code == 200

def test_edit_profile_post_bad(client, app):
    response = client.post("/editProfile/1", data={"fullname": "Debug Account", "address1": "Some address", "address2": "Some address again"
                                                 , "city": "Houston", "stateCode": "TX", "zipcode": "7777a7"})

    with app.app_context():
        assert response.status_code == 200