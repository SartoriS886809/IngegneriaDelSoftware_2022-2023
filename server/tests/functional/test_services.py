elem = "services"
email = "mario@gmail.com"

def test_create_my_service(client):
    response = client.post("/new/" + elem , data={
        "id": 6,
        "title": "Giardiniere", 
        "postdate": "01/12/2000",
        "id_creator": email, 
        "desc" : "Offro il mio supporto per tagliare l'erba del giardino",
        "link" : "https://www.google.com"
        })
    print(response.json)
    assert response.status_code == 200
    #assert response.json["status"] == "success"

def test_modify_my_service(client):
    old_response = client.get("/mylist/" + elem + "/" + email)
    print(old_response.json)
    assert old_response.status_code == 200
    assert old_response.json["status"] == "success"

    new_response = client.post("/mylist/" + elem + "/" + email, data={
        "desc": "new desc",
    })
    #print(new_response.json)
    assert new_response.status_code == 200
    assert new_response.json["status"] == "success"
    assert old_response.json["desc"] != new_response.json["desc"]
    
def test_view_my_services(client):
    response = client.get("/mylist/" + elem + "/" + email)
    assert response.status_code == 200
    assert response.json["status"] == "success"
    print(response.json)

def test_view_services(client):
    response = client.get("/list/" + elem + "/" + email)
    assert response.status_code == 200
    assert response.json["status"] == "success"
    
def test_contact_supplier(client):
    None
    
def test_delete_service(client):
    None