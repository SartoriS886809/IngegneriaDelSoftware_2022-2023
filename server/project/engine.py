from project.config import *
from sqlalchemy import create_engine, text, DDL
from sqlalchemy.orm import sessionmaker
from sqlalchemy_utils import database_exists, create_database
from sqlalchemy.ext.declarative import declarative_base

#url = f"postgresql://{owner}:{password_owner}@{db_ip}:{db_port}/{db_name}"
url = "postgresql+psycopg2://postgres:games_123@neighdbserver.postgres.database.azure.com:5432/neighdb"
if not database_exists(url):
    create_database(url)

engine = create_engine(url)

Base = declarative_base()

Session = sessionmaker(bind=engine)
session = Session()

def delete_schema():
    engine.execute(DDL("DROP SCHEMA IF EXISTS public CASCADE"))

def create_schema():
    engine.execute(DDL("CREATE SCHEMA IF NOT EXISTS public"))

def populate():
    engine.execute(text(open("db_scripts/populate.sql").read()))
    
def create_neigh(table):
    session.add(table(name='San Polo', area=0.70))
    session.add(table(name='Dorsoduro', area=0.70))
    session.add(table(name='San Marco', area=0.71))
    session.add(table(name='Santa Croce', area=0.68))
    session.add(table(name='Castello', area=0.93))
    session.add(table(name='Cannaregio', area=1.1))
    session.add(table(name='Giudecca', area=0.59))
    session.commit()
