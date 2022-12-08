from . import login
elem = "needs"
email = "mario@gmail.com"

token = None

def test_create_need(client):
    global token
    token = login(client).json["token"]
    response = client.post("/new/" + elem , data={
        "token": token,
        "title": "Idraulico",
        "desc" : "Offro il mio supporto per tagliare l'erba del giardino",
        "address" : "via Genova 1"
        })
    #print(response.json)
    assert response.status_code == 200
    assert response.json["status"] == "success"  
      
def test_view_my_needs(client):
    response = client.post("/mylist/" + elem, data={
        "token": token
    })
    #print(old_response.json)
    assert response.status_code == 200
    assert response.json["status"] == "success"
    assert response.json["list"] != []
    
def test_view_needs(client):
    response = client.post("/list/needs", data={
        "token": token,
    })
    assert response.status_code == 200
    assert response.json["status"] == "success"
    assert response.json["list"] != []

def test_modify_need(client):
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
    
def test_resolved_need(client):
    old_response = client.post("/mylist/" + elem, data={
        "token": token
    })
    response = client.post("/assist", data={
        "token": "token",
        "id": old_response.json["list"][0]["id"]
    })
    assert response.status_code == 200
    assert response.json["status"] == "success"
    
    # update old_response
    old_response = client.post("/mylist/" + elem, data={
        "token": token
    })
    assert old_response.json["list"][0]["assistant"] == "username1"

    
def test_delete_need(client):
    response1 = client.post("/mylist/" + elem, data={
        "token": token
    })
    response2 = client.delete("/delete/" + elem + "/" + str(response1.json["list"][0]["id"]))
    assert response2.status_code == 200
    assert response2.json["status"] == "success"

    response3 = client.post("/mylist/" + elem, data={
        "token": token
    })
    assert response3.json["list"] == []