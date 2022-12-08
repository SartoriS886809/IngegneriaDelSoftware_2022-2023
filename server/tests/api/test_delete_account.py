import pytest

@pytest.mark.order('last')
def test_delete_account(client):
    email = "mario@gmail.com"
    response = client.delete("/delete-account/" + email)

    assert response.status_code == 200
    assert response.json["status"] == "success"
