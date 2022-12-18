import requests

url = 'http://neighborhood.azurewebsites.net'
#url = 'http://127.0.0.1:5000'

def post_request(route, json):
    return requests.post(url+route, json=json).json()


def get_request(route):
    return requests.get(url+route).json()


def delete_request(route, json):
    return requests.delete(url+route, json=json).json()