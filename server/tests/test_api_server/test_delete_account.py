import requests, pytest

@pytest.mark.order('last')
def test_delete_account():
    url_login = 'http://neighborhood.azurewebsites.net/login'
    send = {'email': 'email1000@email.com',
            'password': 'passpass'}
    resp = requests.post(url_login, json=send)
    #assert resp.json()["status"] == "success"

    url = 'http://neighborhood.azurewebsites.net/delete-account'
    #send = {'token': resp.json()['token']}
    #resp = requests.post(url, json=send)
    #assert resp.json()["status"] == "success"