from . import login
from tests.conftest import post_request, get_request, delete_request

def test_view_profile():
    response = post_request('/profile', json={
        "token": login(post_request)["token"]
    })
    assert response["status"] == "success"
    assert response["email"] != ""
    assert response["username"] != ""
    assert response["name"] != ""
    assert response["lastname"] != ""
    assert response["birth_date"] != ""
    assert response["address"] != ""
    assert response["family"] is not None
    assert response["house_type"] != ""
    assert response["neighborhood"] != ""
    assert response["id_neighborhoods"] != ""

def test_modify_profile():
    token = login(post_request)["token"]
    old_response = post_request('/profile', json={
        "token": token
    })
    assert old_response["status"] == "success"

    new_response = post_request('/profile', json={
        "token": token,
        "address": "new_address",
        "family": 5
    })
    assert new_response["status"] == "success"
    assert old_response["address"] != new_response["address"]
    assert old_response["family"] != new_response["family"]