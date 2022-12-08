import pytest
from project import *


@pytest.fixture()
def application():
    #app = create_app()
    app.config.update({
        "TESTING": True,
    })

    # other setup can go here

    yield app
    
    # clean up / reset resources here


@pytest.fixture()
def client(application):
    return application.test_client()


@pytest.fixture()
def runner(application):
    return application.test_cli_runner()
