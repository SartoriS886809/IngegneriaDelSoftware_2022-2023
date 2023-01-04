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


def get_all(table, user='', mylist=False, assistant_list=False):
    table = convert_table(table)

    if table not in [Need, Service, Report]:
        return session.query(table).all()

    neigh = get_table(User, user).id_neighborhoods

    if mylist:
        q = session.query(table).filter(table.id_creator == user).all()
    elif assistant_list:
        q = session.query(table).filter(table.id_assistant == user).all()
    else:
        q = session.query(table).all()

    ans = []

    for x in q:
        if x.creator.id_neighborhoods != neigh:
            continue
        if not mylist and not assistant_list and (x.id_creator == user or (table == Need and x.id_assistant == user)):
            continue
        ans.append(x)

    return ans

def get_table(table, code):
    table = convert_table(table)
    return session.query(table).filter_by(email=code).first() if table == User else session.query(table).filter_by(id=code).first()


def get_user_by_token(token):
    return session.query(User).filter(User.token == token).first()

