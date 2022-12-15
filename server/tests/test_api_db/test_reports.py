from . import login
from tests.conftest import post_request, get_request, delete_request

elem = "reports"
email = "mario@gmail.com"
token = None

def test_create_report():
    global token
    token = login(post_request)["token"]

    response = post_request('/new/' + elem, json={
        "token": token,
        "title": "Incendio",
        "priority": 1,
        "address": "via 74",
        "category": "Danger"
    })
    assert response["status"] == "success"
    
def test_view_my_reports():
    response = post_request('/mylist/' + elem, json={
        "token": token
    })
    assert response["status"] == "success"
    assert response["list"] != []
    
def test_view_reports():
    response = post_request('/list/' + elem, json={
        "token": token
    })
    assert response["status"] == "success"
    assert response["list"] != []

def test_delete_report():
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