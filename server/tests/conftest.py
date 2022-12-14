import pytest, requests

url = 'http://neighborhood.azurewebsites.net'

@pytest.fixture()
def post_request(route, json):
    return requests.post(url+route, json=json).json()
