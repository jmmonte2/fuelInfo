from flask_wtf import FlaskForm
from wtforms import StringField, IntegerField, DateField, FloatField
from wtforms.validators import DataRequired

class QuoteForm(FlaskForm):
    user_id = IntegerField('User_Id', validators=[DataRequired()])
    gallons = IntegerField('Gallons', validators=[DataRequired()])
    address = StringField('Address', validators=[DataRequired()])
    date = DateField('Date', validators=[DataRequired()])
    suggested = FloatField('Suggested', validators=[DataRequired()])
    total = FloatField('Total', validators=[DataRequired()])
