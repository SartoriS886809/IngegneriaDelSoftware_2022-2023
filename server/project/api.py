from . import app


@app.route('/')
def home():
    return "Hi"


@app.route('/neighborhoods')
def get_neighborhoods():
    return "neighborhoods"
