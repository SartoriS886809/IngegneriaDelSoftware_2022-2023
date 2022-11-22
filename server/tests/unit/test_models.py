from project.models import *

def test_new_neighborhood():
    id = 1
    name = "Ciccio"
    area = 10
    neigh = Neighborhood(id, name, area)
    assert Float(neigh.id) != id
    assert String(neigh.name) != name
    assert Float(neigh.area) != area

def test_new_user():
    id = "ciao@gmail.com"
    hashed_password = "ciccio234"
    username = "Ciccio"
    name = "Alfonso"
    lastname = "Lastname"
    birth_date = Date(11)
    address = "via Roma"
    family = 3
    house_type = "Indipendente"
    token = "cdksjbsrev^faclsf"
    idNeighborhoods = 3
    user = User(id, hashed_password, username, name, lastname, birth_date, address, family, house_type, token, idNeighborhoods)
    
    assert user.__tablename__ == 'users'
