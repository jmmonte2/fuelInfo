from flask_wtf import FlaskForm
from wtforms import StringField, IntegerField, DateField, FloatField
from wtforms.validators import DataRequired, Length, Email, Regexp, Optional

class QuoteForm(FlaskForm):
    gallons = IntegerField('Gallons', validators=[DataRequired()])
    address = StringField('Address', validators=[DataRequired()])
    date = DateField('Date', validators=[DataRequired()])
    suggested = FloatField('Suggested', validators=[DataRequired()])
    total = FloatField('Total', validators=[DataRequired()])

class QuoteCreate(FlaskForm):
    gallons = IntegerField('Gallons', validators=[DataRequired()])
    address = StringField('Address', validators=[DataRequired()])
    date = DateField('Date', validators=[DataRequired()])

class SignUpForm(FlaskForm):
    # Form fields for signup
    username = StringField('Username', validators=[DataRequired(), Length(min=4, max=20), Regexp(r'^\w+$')])  # Field for username with validation for required and length constraints
    password = StringField('Password', validators=[DataRequired(), Length(min=8, max=30)])  # Field for password with validation for required and length constraints
    email = StringField('Email', validators=[DataRequired(), Length(max=50), Email()])  # Field for email with validation for required, length constraints, and email format

class LoginForm(FlaskForm):
    # Form fields for login
    username = StringField('Username', validators=[DataRequired(), Length(min=4, max=20)])  # Field for username with validation for required and length constraints
    password = StringField('Password', validators=[DataRequired(), Length(min=8, max=30)])  # Field for password with validation for required and length constraints

class UserProfileForm(FlaskForm):
    user_id = IntegerField('User_Id', validators=[DataRequired()])
    fullname = StringField('Full Name', validators=[DataRequired(), Length(max=50)])
    address1 = StringField('Address 1', validators=[DataRequired(), Length(max=100)])
    address2 = StringField('Address 2', validators=[Optional(), Length(max=100)])
    city = StringField('City', validators=[DataRequired(), Length(max=100)])
    stateCode = StringField('State Code', validators=[DataRequired()])
    zipcode = StringField('Zip Code', validators=[DataRequired(), Length(min=5, max=9)])
