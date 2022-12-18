from sqlalchemy import create_engine, text, DDL
from sqlalchemy.orm import sessionmaker
from sqlalchemy_utils import database_exists, create_database
from project.models import Base, User, Neighborhood, Service, Report, Need


class Engine():
    
    def __init__(self, url="postgresql+psycopg2://postgres:games_123@neighdbserver.postgres.database.azure.com:5432/neighdb"):
        self.create_engine(url)
        self.create_session()
        # create models
        self.delete_schema()
        self.create_schema()
        self.Base = Base.metadata.create_all(self.engine)
        # populate
        self.create_neigh(Neighborhood)
        self.populate()
    
    def create_engine(self, url):
        if not database_exists(url):
            create_database(url)
        self.engine = create_engine(url)
    
    def create_session(self):
        Session = sessionmaker(bind=self.engine)
        self.session = Session()
        
    def delete_schema(self):
        self.engine.execute(DDL("DROP SCHEMA IF EXISTS public CASCADE"))

    def create_schema(self):
        self.engine.execute(DDL("CREATE SCHEMA IF NOT EXISTS public"))

    def populate(self):
        self.engine.execute(text(open("db_scripts/populate.sql").read()))
        
    def create_neigh(self, table):
        self.session.add(table(name='San Polo', area=0.70))
        self.session.add(table(name='Dorsoduro', area=0.70))
        self.session.add(table(name='San Marco', area=0.71))
        self.session.add(table(name='Santa Croce', area=0.68))
        self.session.add(table(name='Castello', area=0.93))
        self.session.add(table(name='Cannaregio', area=1.1))
        self.session.add(table(name='Giudecca', area=0.59))
        self.session.commit()