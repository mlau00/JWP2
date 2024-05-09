import uuid

from flask_sqlalchemy.model import Model
from sqlalchemy import Column, Integer, String, VARCHAR, Float
from sqlalchemy.orm import declarative_base

from ..database import db


class Student(db.Model):
    __tablename__ = 'students'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    name = Column('name', String(20))
    age = Column('age', Integer)
    grade = Column('grade', Float)

    def __init__(self, id, name, age, grade):
        self.id = id,
        self.name = name
        self.age = age
        self.grade = grade

    def serialize(self):
        return {
            'id': self.id,
            'name': self.name,
            'age': str(self.age),
            'grade': str(self.grade)

        }
