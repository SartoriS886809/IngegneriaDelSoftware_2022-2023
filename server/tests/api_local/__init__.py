def login(client):
    return client.post("/login", data={
        "email": "mario@gmail.com",
        "password": "ciaociao123",
    })