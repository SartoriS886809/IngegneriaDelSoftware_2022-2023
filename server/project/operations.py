from project.engine import Engine, User, Neighborhood, Service, Report, Need
from sqlalchemy.exc import IntegrityError

engine = Engine()
session = engine.session

tables = {'users': User,
          'neighborhoods': Neighborhood,
          'services': Service,
          'reports': Report,
          'needs': Need
          }


def convert_table(table):
    if table in tables.values():
        return table
    if table in tables.keys():
        return tables[table]
    return None


def commit():
    session.commit()


def rollback():
    session.rollback()


def flush():
    session.flush()


def add_and_commit(table, **kwargs):
    try:
        table = convert_table(table)
        elem = table(**kwargs)
        session.add(elem)
        commit()
        return elem
    except IntegrityError as e:
        raise e


def add_no_commit(table, **kwargs):
    try:
        table = convert_table(table)
        elem = table(**kwargs)
        session.add(elem)
        flush()
        return elem
    except IntegrityError as e:
        raise e


def delete_tuple(table, code):
    try:
        table = convert_table(table)
        if table == User:
            session.query(table).filter_by(email=code).delete()
        else:
            session.query(table).filter_by(id=code).delete()
        commit()
    except IntegrityError as e:
        raise e


def update_tuple(table, code, **kwargs):
    try:
        table = convert_table(table)
        if table == User:
            row = session.query(table).filter_by(email=code).first()
        else:
            row = session.query(table).filter_by(id=code).first()
        for attribute, value in kwargs.items():
            setattr(row, attribute, value)
        commit()
    except IntegrityError as e:
        raise e


def get_all(table='needs', creator=None, not_creator=None, assistant=None):
    table = convert_table(table)

    if not_creator and assistant:
        return session.query(table).where(table.id_creator != not_creator and table.id_assistant != assistant).all()

    if creator is not None:
        return session.query(table).filter(table.id_creator == creator).all()

    if not_creator is not None:
        return session.query(table).where(table.id_creator != not_creator).all()

    if assistant is not None:
        return session.query(table).where(table.id_assistant == assistant).all()

    return session.query(table).all()


def get_table(table, code):
    table = convert_table(table)
    return session.query(table).filter_by(email=code).first() if table == User else session.query(table).filter_by(id=code).first()


def get_user_by_token(token):
    return session.query(User).filter(User.token == token).first()

