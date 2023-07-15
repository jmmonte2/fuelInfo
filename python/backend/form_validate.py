from flask_wtf import FlaskForm
from wtforms import StringField, IntegerField, DateField, FloatField
from wtforms.validators import DataRequired, Optional, Length

class QuoteForm(FlaskForm):
    user_id = IntegerField('User_Id', validators=[DataRequired()])
    gallons = IntegerField('Gallons', validators=[DataRequired()])
    address = StringField('Address', validators=[DataRequired()])
    date = DateField('Date', validators=[DataRequired()])
    suggested = FloatField('Suggested', validators=[DataRequired()])
    total = FloatField('Total', validators=[DataRequired()])

class UserProfileForm(FlaskForm):
    user_id = IntegerField('User_Id', validators=[DataRequired()])
    fullname = StringField('Full Name', validators=[DataRequired()])
    address1 = StringField('Address 1', validators=[DataRequired()])
    address2 = StringField('Address 2', validators=[Optional()])
    city = StringField('City', validators=[DataRequired()])
    stateCode = StringField('State Code', validators=[DataRequired()])
    zipcode = StringField('Zip Code', validators=[DataRequired(), Length(min=5)])
