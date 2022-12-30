import pytest
from . import login
from tests.conftest import post_request, get_request, delete_request

@pytest.mark.order('last')
def test_delete_account():
    token = login(post_request)["token"]
    response = delete_request('/delete-account', json={
        "token": token
    })
    assert response["status"] == "success"
    assert login(post_request)["status"] == "failure"

    other_token = post_request('/login', json={
        "email": "dario@gmail.com",
        "password": "ciaociao123"
    })["token"]
    response = delete_request('/delete-account', json={
        "token": other_token
    })
    assert response["status"] == "success"