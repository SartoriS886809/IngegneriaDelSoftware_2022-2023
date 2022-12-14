import requests

def test_signup():
        url = 'http://neighborhood.azurewebsites.net/signup'
        send = {'email': 'email1000@email.com',
                'password': 'passpass',
                'username' : 'username1',
                'name' : 'name1',
                'lastname' : 'lastname1',
                'birth_date' : '01/12/1998',
                'address' : 'address1',
                'family' : 4,
                'house_type' : 'house type',
                'id_neighborhoods' : 1}
        resp = requests.post( url, json=send)
        #assert resp.json()["status"] == "success"
