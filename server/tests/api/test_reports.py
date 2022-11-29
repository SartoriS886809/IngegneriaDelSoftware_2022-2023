elem = "reports"
email = "mario@gmail.com"

def test_create_report(client):
    response = client.post("/new/" + elem , data={
        "title": "Incendio", 
        "postdate": "07/10/2022",
        "id_creator": email, 
        "priority" : 1,
        "address" : "via 74",
        "category" : "Danger"
        })
    #print(response.json)
    assert response.status_code == 200
    assert response.json["status"] == "success"
    
def test_view_my_reports(client):
    response = client.get("/mylist/" + elem + "/" + email)
    #print(old_response.json)
    assert response.status_code == 200
    assert response.json["status"] == "success"
    assert response.json["list"] != []
    
def test_view_reports(client):
    response = client.get("/list/" + elem + "/" + email)
    assert response.status_code == 200
    assert response.json["status"] == "success"
    assert response.json["list"] != []

def test_delete_report(client):
    response1 = client.get("/mylist/" + elem + "/" + email)
    response2 = client.delete("/delete/" + elem + "/" + str(response1.json["list"][0]["id"]))
    assert response2.status_code == 200
    assert response2.json["status"] == "success"

    response3 = client.get("/mylist/" + elem + "/" + email)
    assert response3.json["list"] == []