elem = "services"
email = "mario@gmail.com"

def test_create_service(client):
    response = client.post("/new/" + elem , data={
        "title": "Giardiniere", 
        "postdate": "01/12/2000",
        "id_creator": email, 
        "desc" : "Offro il mio supporto per tagliare l'erba del giardino",
        "link" : "https://www.google.com"
        })
    #print(response.json)
    assert response.status_code == 200
    assert response.json["status"] == "success"
    
def test_view_my_services(client):
    old_response = client.get("/mylist/" + elem + "/" + email)
    #print(old_response.json)
    assert old_response.status_code == 200
    assert old_response.json["status"] == "success"
    assert old_response.json["list"] != []
    
def test_modify_my_service(client):
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

def test_view_services(client):
    response = client.get("/list/" + elem + "/" + email)
    assert response.status_code == 200
    assert response.json["status"] == "success"
    assert response.json["list"] != []
    
def test_delete_service(client):
    response1 = client.get("/mylist/" + elem + "/" + email)
    response2 = client.delete("/delete/" + elem + "/" + str(response1.json["list"][0]["id"]))
    assert response2.status_code == 200
    assert response2.json["status"] == "success"

    response3 = client.get("/mylist/" + elem + "/" + email)
    assert response3.json["list"] == []
