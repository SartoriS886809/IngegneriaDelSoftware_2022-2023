from server.config import *
from sqlalchemy import create_engine, text, DDL
from sqlalchemy.orm import sessionmaker
from sqlalchemy_utils import database_exists, create_database
from sqlalchemy.ext.declarative import declarative_base

url = f"postgresql://{owner}:{password_owner}@{db_ip}:{db_port}/{db_name}"

if not database_exists(url):
    create_database(url)

engine = create_engine(url)

Base = declarative_base()

Session = sessionmaker(bind=engine)
session = Session()


def create_schema():
    engine.execute(DDL("DROP SCHEMA IF EXISTS public CASCADE; CREATE SCHEMA IF NOT EXISTS public"))


def populate():
    engine.execute(text(open("server/db_scripts/populate.sql").read()))
