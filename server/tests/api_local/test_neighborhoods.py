def test_neighborhoods(client):
    response = client.get('/neighborhoods')
    assert response.status_code == 200
    assert response.json["status"] == "success"
    assert response.json["neighborhoods"] != []