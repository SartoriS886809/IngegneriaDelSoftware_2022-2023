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

    def __init__(self, name, area):
        self.name = name
        self.area = area


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
    id_neighborhoods = Column(ForeignKey(Neighborhood.id, ondelete='CASCADE'), nullable=False)

    neigh = relationship('Neighborhood', backref='user')
    services = relationship('Service', backref='creator')
    reports = relationship('Report', backref='creator')
    
    def __init__(self, email, password, username, name, lastname, birth_date, address, family, house_type, token, id_neighborhoods):
        self.email = email
        self.password = password
        self.username = username
        self.name = name
        self.lastname = lastname
        self.birth_date = birth_date
        self.address = address
        self.family = family
        self.house_type = house_type
        self.token = token
        self.id_neighborhoods = id_neighborhoods
        
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

    def get_all_elements(self):
        return {'username': self.username, 'name': self.name, 'lastname': self.lastname, 'birth_date': self.birth_date,
                'address': self.address, 'family': self.family, 'house_type': self.house_type, 'neighborhood': self.neigh.name}


class Report(Base):
    __tablename__ = 'reports'

    id = Column(Integer, primary_key=True)
    title = Column(String, nullable=False)
    postdate = Column(Date, nullable=False)
    id_creator = Column(ForeignKey(User.email, ondelete='CASCADE'), nullable=False)
    priority = Column(Integer, CheckConstraint('priority >= 1 and priority <= 3'), nullable=False)
    category = Column(String, nullable=False)
    address = Column(String, nullable=False)

    def __init__(self, title, postdate, id_creator, priority, cat, addr):
        self.title = title
        self.postdate = postdate
        self.id_creator = id_creator
        self.priority = priority
        self.category = cat
        self.address = addr

    def get_all_elements(self):
        return {'id': self.id, 'title': self.title, 'postdate': self.postdate, 'creator': self.creator.username,
                'priority': self.priority, 'category': self.category, 'address': self.address}


class Service(Base):
    __tablename__ = 'services'
    
    id = Column(Integer, primary_key=True)
    title = Column(String, nullable=False)
    postdate = Column(Date, nullable=False)
    id_creator = Column(ForeignKey(User.email, ondelete='CASCADE'), nullable=False)
    desc = Column(String, nullable=False)
    link = Column(String, nullable=False)
    
    def __init__(self, title, postdate, id_creator, desc, link):
        self.title = title
        self.postdate = postdate
        self.id_creator = id_creator
        self.desc = desc
        self.link = link

    def get_all_elements(self):
        return {'id': self.id, 'title': self.title, 'postdate': self.postdate, 'creator': self.creator.username,
                'desc': self.desc, 'link': self.link}


class Need(Base):
    __tablename__ = 'needs'
    
    id = Column(Integer, primary_key=True)
    title = Column(String, nullable=False)
    postdate = Column(Date, nullable=False)
    # TODO check idAssistant != idCreator
    id_assistant = Column(ForeignKey(User.email, ondelete='CASCADE'), nullable=True)
    id_creator = Column(ForeignKey(User.email, ondelete='CASCADE'), nullable=False)
    address = Column(String, nullable=False)
    desc = Column(String, nullable=False)

    creator = relationship('User', backref='needs', foreign_keys=[id_creator])
    assistant = relationship('User', backref='assistant_needs', foreign_keys=[id_assistant])
    
    def __init__(self, title, postdate, id_assistant, id_creator, address, desc):
        self.title = title
        self.postdate = postdate
        self.is_creator = id_creator
        self.desc = desc
        self.address = address
        self.id_assistant = id_assistant

    def get_all_elements(self):
        return {'id': self.id, 'title': self.title, 'postdate': self.postdate, 'creator': self.creator.username,
                'assistant': self.assistant.username, 'desc': self.desc, 'address': self.address}


Base.metadata.create_all(engine)
create_neigh(Neighborhood)
populate()

