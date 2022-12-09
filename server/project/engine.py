from project.config import *
from sqlalchemy import create_engine, text, DDL
from sqlalchemy.orm import sessionmaker
from sqlalchemy_utils import database_exists, create_database
from sqlalchemy.ext.declarative import declarative_base

url = f"postgresql://{owner}:{password_owner}@{db_ip}:{db_port}/{db_name}"
#url = "postgresql://postgres%40neighdb:games_123@neighdb.postgres.database.azure.com:5432/neighdb"
if not database_exists(url):
    create_database(url)

engine = create_engine(url)

Base = declarative_base()

Session = sessionmaker(bind=engine)
session = Session()


def create_schema():
    engine.execute(DDL("DROP SCHEMA IF EXISTS public CASCADE; CREATE SCHEMA IF NOT EXISTS public"))


def populate():
    engine.execute(text(open("db_scripts/populate.sql").read()))
    
def create_neigh(table):
    session.add(table(name='neigh1', area=23))
    session.add(table(name='neigh2', area=23))
    session.add(table(name='neigh3', area=23))
    session.commit()
