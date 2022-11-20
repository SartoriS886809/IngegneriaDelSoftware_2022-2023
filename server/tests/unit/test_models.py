from project.models import User
from flask import Flask, jsonify

def test_new_user():
    user = User()
    assert user.__tablename__ == 'users'
    assert user.__repr__ != {}