from . import login
from tests.conftest import post_request, get_request, delete_request

elem = "needs"
email = "mario@gmail.com"

token = None

def test_create_need():
    global token
    token = login(post_request)["token"]

    json = {
        "token": token,
        "title": "Idraulico",
        "desc" : "Offro il mio supporto per tagliare l'erba del giardino",
        "address" : "via Genova 1"
    }

    response = post_request('/new/' + elem, json=json)
    assert response["status"] == "success"
      
def test_view_my_needs():
    json = {
        "token": token
    }

    response = post_request('/mylist/' + elem, json=json)
    assert response["status"] == "success"
    assert response["list"] != []
    
def test_view_needs():
    json = {
        "token": token
    }

    response = post_request('/list/' + elem, json=json)
    assert response["status"] == "success"
    assert response["list"] != []

def test_modify_need():
    old_response = post_request('/mylist/' + elem, json={
        "token": token
    })

    new_response = post_request('/mylist/' + elem, json={
        "token": token,
        "id": old_response["list"][0]["id"],
        "desc": "new desc"
    })
    assert new_response["status"] == "success"
    assert old_response["list"][0]["desc"] != new_response["desc"]
    
def test_resolved_need():
    old_response = post_request('/mylist/' + elem, json={
        "token": token
    })

    response = post_request('/assist', json={
        "token": "token1",
        "id": old_response["list"][0]["id"]
    })
    assert response["status"] == "success"

    updated_response = post_request('/mylist/' + elem, json={
        "token": token
    })
    assert updated_response["list"][0]["assistant"] == "username1"


def test_get_assist_list():
    old_response = post_request('/mylist/' + elem, json={
        "token": token
    })["list"][0]

    response = post_request('/assist-list', json={
        "token": "token1"
    })

    assert response["status"] == "success"
    assert response["list"][0]["id"] == old_response["id"]
    assert response["list"][0]["title"] == old_response["title"]
    assert response["list"][0]["creator"] == old_response["creator"]
    assert response["list"][0]["assistant"] == old_response["assistant"]


def test_delete_assist():
    old_response = post_request('/mylist/' + elem, json={
        "token": token
    })
    assert old_response["list"][0]["assistant"] == "username1"

    response = delete_request('/assist', json={
        "token": "token1",
        "id": old_response["list"][0]["id"]
    })
    assert response["status"] == "success"

    old_response = post_request('/mylist/' + elem, json={
        "token": token
    })
    assert old_response["list"][0]["assistant"] == ""

    
def test_delete_need():
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