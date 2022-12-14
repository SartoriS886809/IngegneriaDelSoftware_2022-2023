def login(client):
    return client.post("/login", json={
        "email": "mario@gmail.com",
        "password": "ciaociao123",
    })