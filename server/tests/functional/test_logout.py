def test_logout(client):
	response = client.post("/logout", data={
		"email": "mario@gmail.com",
	})
	assert response.status_code == 200
	assert response.json["status"] == "success"


def test_logout_failure(client):
	response = client.post("/logout", data={
		"email": "none@gmail.com",
	})
	assert response.status_code == 200
	assert response.json["status"] == "failure"
	assert response.json["reason"] == "user does not exist"

 
def test_automatic_logout(client):
	None