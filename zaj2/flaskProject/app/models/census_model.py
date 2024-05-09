import uuid

from flask_sqlalchemy.model import Model
from sqlalchemy import Column, Integer, String, VARCHAR
from sqlalchemy.orm import declarative_base

from ..database import db


class CensusModel(db.Model):
    __tablename__ = 'census'
    state = Column('state', String(30), primary_key=True)
    sex = Column('sex', String(1))
    age = Column('age', Integer)
    pop2000 = Column('pop2000', Integer)
    pop2008 = Column('pop2008', Integer)

    def __init__(self, state, sex, age, pop2000, pop2008):
        self.state = state
        self.sex = sex
        self.age = age
        self.pop2000 = pop2000
        self.pop2008 = pop2008

    def serialize(self):
        return {
            'state': self.state,
            'sex': self.sex,
            'age': str(self.age),
            'pop2000': str(self.pop2000),
            'pop2008': str(self.pop2008)
        }
