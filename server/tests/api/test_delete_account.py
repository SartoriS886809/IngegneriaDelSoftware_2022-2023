import pytest
from . import login

@pytest.mark.order('last')
def test_delete_account(client):
    token = login(client).json["token"]
    response = client.delete("/delete-account", data={
        "token": token
    })

    assert response.status_code == 200
    assert response.json["status"] == "success"

    assert login(client).json["status"] == "failure"