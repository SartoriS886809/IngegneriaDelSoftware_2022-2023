from project.engine import *
from . import login_manager, bcrypt
from flask_login import UserMixin
from sqlalchemy import Column, String, Integer, Date, ForeignKey, Float, Boolean, Table, CheckConstraint, Text, UniqueConstraint
from sqlalchemy.orm import relationship
import json
from datetime import date
import inspect



create_schema()


class Neighborhood(Base):
    __tablename__ = 'neighborhoods'
    
    id = Column(Integer, primary_key=True)
    name = Column(String(length=30), nullable=False)
    area = Column(Float, nullable=False)

    def __init__(self, id, name, area):
        self.id = id
        self.name = name
        self.area = area

    #def __repr__(self):
    #    ret = { "id": self.id, 
    #            "name": self.name,
    #            "area" : self.area}
    #    return json.dumps( ret )


class User(Base, UserMixin):
    __tablename__ = 'users'

    email = Column(String(length=30), primary_key=True)
    hashed_password = Column(Text, nullable=False)
    username = Column(String(length=30), nullable=False)
    name = Column(String(length=30), nullable=False)
    lastname = Column(String(length=30), nullable=False)
    birth_date = Column(Date, nullable=False)
    address = Column(String, nullable=False)
    family = Column(Integer, nullable=False)
    house_type = Column(String, nullable=False)
    token = Column(String, nullable=False)
    idNeighborhoods = Column(ForeignKey(Neighborhood.id, ondelete='CASCADE'), nullable=False)
    
    def __init__(self, email, hp, username, name, lname, bdate, addr, fam, houset, token, idNeigh):
        self.id = email
        self.hashed_password = hp
        self.username = username
        self.name = name
        self.lastname = lname
        self.birth_date = bdate
        self.address = addr
        self.family = fam
        self.house_type = houset
        self.token = token
        self.idNeighborhoods = idNeigh
        
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

    #def __repr__(self):
    #    return json.dumps(self.__dict__)


class Report(Base):
    __tablename__ = 'reports'

    id = Column(Integer, primary_key=True)
    title = Column(String, nullable=False)
    postDate = Column(Date, nullable=False)
    idCreator = Column(ForeignKey(User.email, ondelete='CASCADE'), nullable=False)
    priority = Column(Integer, nullable=False)
    category = Column(String, nullable=False)
    address = Column(String, nullable=False)

    def __repr__(self):
        return json.dumps(__dict__)


class Service(Base):
    __tablename__ = 'services'
    
    id = Column(Integer, primary_key=True)
    title = Column(String, nullable=False)
    postDate = Column(Date, nullable=False)
    IdCreator = Column(ForeignKey(User.email, ondelete='CASCADE'), nullable=False)
    desc = Column(String, nullable=False)
    link = Column(String, nullable=False)
    
    def __repr__(self):
        return json.dumps(__dict__)   


class Need(Base):
    __tablename__ = 'needs'
    
    id = Column(Integer, primary_key=True)
    title = Column(String, nullable=False)
    postDate = Column(Date, nullable=False)
    # TODO check idAssistant != idCreator
    idAssistant = Column(ForeignKey(User.email, ondelete='CASCADE'), nullable=True)
    idCreator = Column(ForeignKey(User.email, ondelete='CASCADE'), nullable=False)
    address = Column(String, nullable=False)
    desc = Column(String, nullable=False)
    
    def __repr__(self):
        return json.dumps(__dict__)


Base.metadata.create_all(engine)
#populate()

