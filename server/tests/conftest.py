import pytest, requests

url = 'http://neighborhood.azurewebsites.net'


def post_request(route, json):
    return requests.post(url+route, json=json).json()


def get_request(route):
    return requests.get(url+route).json()


def delete_request(route, json):
    return requests.delete(url+route, json=json).json()