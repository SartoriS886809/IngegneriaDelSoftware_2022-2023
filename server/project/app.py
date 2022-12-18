from flask import Flask
from flask_login import LoginManager

class FlaskApp():   

    def __init__(self):
        self.app = Flask(__name__)
        login_manager = LoginManager(self.app)
        login_manager.login_view = "login"
        login_manager.login_message_category = "info"    
    
    def get_app(self):
        return self.app
