from flask import Flask
from flask_bcrypt import Bcrypt
from flask_login import LoginManager
import os
from . import config


def create_app():
    app = Flask(__name__)
    return app


app = create_app()
bcrypt = Bcrypt(app)

login_manager = LoginManager(app)
login_manager.login_view = "login"
login_manager.login_message_category = "info"

from project.models import *
from project.api import *
