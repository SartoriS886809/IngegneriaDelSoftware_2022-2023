elem = "needs"
email = "mario@gmail.com"

def test_create_need(client):
    response = client.post("/new/" + elem , data={
        "title": "Idraulico", 
        "postdate": "01/9/2000",
        "id_creator": email, 
        "desc" : "Offro il mio supporto per tagliare l'erba del giardino",
        "address" : "via Genova 1"
        })
    #print(response.json)
    assert response.status_code == 200
    assert response.json["status"] == "success"  
      
def test_view_my_needs(client):
    response = client.get("/mylist/" + elem + "/" + email)
    #print(old_response.json)
    assert response.status_code == 200
    assert response.json["status"] == "success"
    assert response.json["list"] != []
    
def test_view_needs(client):
    response = client.get("/list/" + elem + "/" + email)
    assert response.status_code == 200
    assert response.json["status"] == "success"
    assert response.json["list"] != []

def test_modify_need(client):
   # get list of elem
    old_response = client.get("/mylist/" + elem + "/" + email)

    # return the single element
    new_response = client.post("/mylist/" + elem + "/" + email, data={
        "id": old_response.json["list"][0]["id"],
        "desc": "new desc",
    })
    # print(new_response.json)
    assert new_response.status_code == 200
    assert new_response.json["status"] == "success"
    assert old_response.json["list"][0]["desc"] != new_response.json["desc"]
    
def test_resolved_need(client):
    email1 = "email1@email.com"
    old_response = client.get("/mylist/" + elem + "/" + email)
    response = client.post("/assist", data={
        "id": old_response.json["list"][0]["id"],
        "email": email1,
    })
    assert response.status_code == 200
    assert response.json["status"] == "success"
    
    # update old_response
    old_response = client.get("/mylist/" + elem + "/" + email)
    assert old_response.json["list"][0]["assistant"] == "username1"

    
def test_delete_need(client):
    response1 = client.get("/mylist/" + elem + "/" + email)
    response2 = client.delete("/delete/" + elem + "/" + str(response1.json["list"][0]["id"]))
    assert response2.status_code == 200
    assert response2.json["status"] == "success"

    response3 = client.get("/mylist/" + elem + "/" + email)
    assert response3.json["list"] == []