from . import login
from tests.conftest import post_request, get_request, delete_request

elem = "services"
email = "mario@gmail.com"
token = None

def test_create_service():
    global token
    token = login(post_request)["token"]

    response = post_request('/new/' + elem, json={
        "token": token,
        "title": "Giardiniere",
        "desc": "Offro il mio supporto per tagliare l'erba del giardino",
        "link": "https://www.google.com"
    })
    assert response["status"] == "success"
    
def test_view_my_services():
    response = post_request('/mylist/' + elem, json={
        "token": token
    })
    assert response["status"] == "success"
    assert response["list"] != []
    
def test_modify_my_service():
    old_response = post_request('/mylist/' + elem, json={
        "token": token
    })

    new_response = post_request('/mylist/' + elem, json={
        "token": token,
        "id": old_response["list"][0]["id"],
        "desc": "new desc",
    })
    assert new_response["status"] == "success"
    assert old_response["list"][0]["desc"] != new_response["desc"]

def test_view_services():
    response = post_request('/list/' + elem, json={
        "token": token
    })
    assert response["status"] == "success"
    assert response["list"] != []
    
def test_delete_service():
    response1 = post_request('/mylist/' + elem, json={
        "token": token
    })

    response2 = delete_request('/delete/' + elem, json={
        "token": token,
        "id": response1["list"][0]["id"]
    })
    assert response2["status"] == "success"

    response3 = post_request('/mylist/' + elem, json={
        "token": token
    })
    assert response3["list"] == []
