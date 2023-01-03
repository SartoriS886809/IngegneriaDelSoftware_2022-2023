from tests.conftest import post_request, get_request, delete_request

def test_logout():
	json = {
		"email": "mario@gmail.com"
	}

	response = post_request('/logout', json=json)
	assert response["status"] == "success"

	response = post_request('/logout', json={
		"email": "dario@gmail.com"
	})
	assert response["status"] == "success"

def test_logout_failure():
	json = {
		"email": "none@gmail.com"
	}

	response = post_request('/logout', json=json)
	assert response["status"] == "failure"
	assert response["reason"] == "user does not exist"