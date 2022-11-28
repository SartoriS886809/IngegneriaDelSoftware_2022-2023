def test_view_profile(client):
    response = client.get("/profile/mario@gmail.com")
    assert response.status_code == 200
    assert response.json["status"] == "success"
    assert response.json["username"] != ""
    assert response.json["name"] != ""
    assert response.json["lastname"] != ""
    assert response.json["birth_date"] != ""
    assert response.json["address"] != ""
    assert response.json["family"] is not None
    assert response.json["house_type"] != ""
    assert response.json["neighborhood"] != ""


def test_modify_profile(client):
    old_response = client.get("/profile/mario@gmail.com")
    assert old_response.status_code == 200
    assert old_response.json["status"] == "success"

    new_response = client.post("/profile/mario@gmail.com", data={
        "address": "new_address",
        "family": 5
    })
    print(new_response.json)
    assert new_response.status_code == 200
    assert new_response.json["status"] == "success"
    assert old_response.json["address"] != new_response.json["address"]
    assert old_response.json["family"] != new_response.json["family"]
