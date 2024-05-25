import uuid

from flask_sqlalchemy.model import Model
from sqlalchemy import Column, Integer, String, VARCHAR
from sqlalchemy.orm import declarative_base

from ..database import db


class Teacher(db.Model):
    __tablename__ = 'teachers'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    name = Column('name', VARCHAR(36))
    subject = Column('subject', VARCHAR(36))
    time = Column('time', VARCHAR(11))

    def __init__(self, name, subject, time):
        self.name = name
        self.subject = subject
        self.time = time

    def serialize(self, id):
        return {
            'id': id,
            'name': self.name,
            'subject': self.subject,
            'time': self.time
        }
