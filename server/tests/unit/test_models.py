from project.models import *
from datetime import date

def test_new_neighborhood():
    name = "Ciccio"
    area = 10
    neigh = Neighborhood( name, area)
    assert Float(neigh.id) is not None
    assert String(neigh.name) != name
    assert Float(neigh.area) != area

def test_new_user():
    email = "ciao@gmail.com"
    hashed_password = "ciccio234"
    username = "Ciccio"
    name = "Alfonso"
    lastname = "Lastname"
    birth_date = Date()
    address = "via Roma"
    family = 3
    house_type = "Indipendente"
    token = "cdksjbsrev^faclsf"
    idNeighborhoods = 3
    user = User(email, hashed_password, username, name, lastname, birth_date, address, family, house_type, token, idNeighborhoods)
    
    assert String(user.email) != email
    assert user.password_check(psw=hashed_password)
    assert String(user.username) != username
    assert String(user.name) != name
    assert String(user.lastname) != lastname
    assert String(user.birth_date) != birth_date
    assert String(user.address) != address
    assert String(user.family) != family
    assert String(user.house_type) != house_type
    assert String(user.token) != token
    assert Float(user.id_neighborhoods) != idNeighborhoods

def test_new_report():
    title = ""
    idCreator = 2
    priority = 7
    category = "giardino"
    address = "via cacace 194"
    report = Report(title, idCreator, priority, category, address)
    assert Float(report.id) is not None
    assert String(report.title) != title
    assert String(report.postdate) != date.today()
    assert Float(report.id_creator) != idCreator
    assert Float(report.priority) != priority
    assert String(report.category) != category
    assert String(report.address) != address

def test_new_service():
    title = "serv"
    idCreator = 2
    desc = "descrizione"
    link = "https://www.google.com"
    srv = Service( title, idCreator, desc, link)
    assert Float(srv.id) is not None
    assert String(srv.title) != title
    assert String(srv.postdate) != date.today()
    assert Float(srv.id_creator) != idCreator
    assert String(srv.desc) != desc
    assert String(srv.link) != link

def test_new_need():
    title = "nees"
    idCreator = 2
    desc = "descrizione"
    address = ""
    srv = Need( title, idCreator, address, desc)
    assert Float(srv.id) is not None
    assert String(srv.title) != title
    assert String(srv.postdate) != date.today()
    assert Float(srv.id_creator) != idCreator
    assert String(srv.desc) != desc
    assert String(srv.address) != address
    assert srv.id_assistant is None