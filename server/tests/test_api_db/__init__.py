def login(post_request):
    return post_request('/login', json={
        "email": "mario@gmail.com",
        "password": "ciaociao123"
    })