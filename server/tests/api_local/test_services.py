from . import login
elem = "services"
email = "mario@gmail.com"
token = None

def test_create_service(client):
    global token
    token = login(client).json["token"]
    response = client.post("/new/" + elem , data={
        "token": token,
        "title": "Giardiniere",
        "desc" : "Offro il mio supporto per tagliare l'erba del giardino",
        "link" : "https://www.google.com"
        })
    #print(response.json)
    assert response.status_code == 200
    assert response.json["status"] == "success"
    
def test_view_my_services(client):
    response = client.post("/mylist/" + elem, data={
        "token": token
    })
    #print(old_response.json)
    assert response.status_code == 200
    assert response.json["status"] == "success"
    assert response.json["list"] != []
    
def test_modify_my_service(client):
    # get list of elem
    old_response = client.post("/mylist/" + elem, data={
        "token": token
    })

    # return the single element
    new_response = client.post("/mylist/" + elem, data={
        "token": token,
        "id": old_response.json["list"][0]["id"],
        "desc": "new desc",
    })
    # print(new_response.json)
    assert new_response.status_code == 200
    assert new_response.json["status"] == "success"
    assert old_response.json["list"][0]["desc"] != new_response.json["desc"]

def test_view_services(client):
    response = client.post("/list/services", data={
        "token": token
    })
    assert response.status_code == 200
    assert response.json["status"] == "success"
    assert response.json["list"] != []
    
def test_delete_service(client):
    response1 = client.post("/mylist/" + elem, data={
        "token": token
    })
    response2 = client.delete("/delete/" + elem, data={
        "token": token,
        "id": response1.json["list"][0]["id"]
    })
    assert response2.status_code == 200
    assert response2.json["status"] == "success"

    response3 = client.post("/mylist/" + elem, data={
        "token": token
    })
    assert response3.json["list"] == []
