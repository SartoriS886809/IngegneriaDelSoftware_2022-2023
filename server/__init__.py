from flask import Flask
from flask_bcrypt import Bcrypt
from flask_login import LoginManager
import os
from server import config


def create_app():
    app = Flask(__name__)
    app.config['SECRET_KEY'] = os.environ['SECRET_KEY']

    return app


app = create_app()
bcrypt = Bcrypt(app)

login_manager = LoginManager(app)
login_manager.login_view = "login"
login_manager.login_message_category = "info"

from . import engine
from . import api
