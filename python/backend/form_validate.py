from flask_wtf import FlaskForm
from wtforms import StringField, IntegerField, DateField, FloatField
from wtforms.validators import DataRequired, Length, Email, Regexp

class QuoteForm(FlaskForm):
    gallons = IntegerField('Gallons', validators=[DataRequired()])
    address = StringField('Address', validators=[DataRequired()])
    date = DateField('Date', validators=[DataRequired()])
    suggested = FloatField('Suggested', validators=[DataRequired()])
    total = FloatField('Total', validators=[DataRequired()])

class SignUpForm(FlaskForm):
    # Form fields for signup
    username = StringField('Username', validators=[DataRequired(), Length(min=4, max=20), Regexp(r'^\w+$')])  # Field for username with validation for required and length constraints
    password = StringField('Password', validators=[DataRequired(), Length(min=8, max=30)])  # Field for password with validation for required and length constraints
    email = StringField('Email', validators=[DataRequired(), Length(max=50), Email()])  # Field for email with validation for required, length constraints, and email format

class LoginForm(FlaskForm):
    # Form fields for login
    username = StringField('Username', validators=[DataRequired(), Length(min=4, max=20)])  # Field for username with validation for required and length constraints
    password = StringField('Password', validators=[DataRequired(), Length(min=8, max=30)])  # Field for password with validation for required and length constraints