from server.engine import *
from server import login_manager, bcrypt
from flask_login import UserMixin
from sqlalchemy import Column, String, Integer, Date, ForeignKey, Boolean, Table, CheckConstraint, Text, UniqueConstraint
from sqlalchemy.orm import relationship
import json
from datetime import date


create_schema()


class User(Base, UserMixin):
    __tablename__ = 'users'

    email = Column(String(length=30), primary_key=True)
    hashed_password = Column(Text, nullable=False)
    username = Column(String(length=30), nullable=False)
    name = Column(String(length=30), nullable=False)
    lastname = Column(String(length=30), nullable=False)
    birth_date = Column(Date, nullable=False)
    address = Column(String(length=30), nullable=False)
    family = Column(String(length=30), nullable=False)
    token = Column(String, nullable=False)

    def get_id(self):
        return self.email

    @property
    def password(self):
        return self.password

    @password.setter
    def password(self, psw):
        self.hashed_password = bcrypt.generate_password_hash(psw).decode('utf-8')

    def password_check(self, psw):
        return bcrypt.check_password_hash(self.hashed_password, psw)

    def __repr__(self):
        ret = {
            'username': self.username,
            'password': self.hashed_password,
            'email': self.email
        }
        return json.dumps(ret, indent=4)




# Base.metadata.create_all()


# populate()
