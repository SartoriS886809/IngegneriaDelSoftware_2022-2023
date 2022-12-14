from . import login
elem = "reports"
email = "mario@gmail.com"
token = None

def test_create_report(client):
    global token
    token = login(client).json["token"]
    response = client.post("/new/" + elem , json={
        "token": token,
        "title": "Incendio",
        "priority" : 1,
        "address" : "via 74",
        "category" : "Danger"
        })
    #print(response.json)
    assert response.status_code == 200
    assert response.json["status"] == "success"
    
def test_view_my_reports(client):
    response = client.post("/mylist/" + elem, json={
        "token": token
    })
    #print(old_response.json)
    assert response.status_code == 200
    assert response.json["status"] == "success"
    assert response.json["list"] != []
    
def test_view_reports(client):
    response = client.post("/list/reports", json={
        "token": token
    })
    assert response.status_code == 200
    assert response.json["status"] == "success"
    assert response.json["list"] != []

def test_delete_report(client):
    response1 = client.post("/mylist/" + elem, json={
        "token": token
    })
    response2 = client.delete("/delete/" + elem, json={
        "token": token,
        "id": response1.json["list"][0]["id"]
    })
    assert response2.status_code == 200
    assert response2.json["status"] == "success"

    response3 = client.post("/mylist/" + elem, json={
        "token": token
    })
    assert response3.json["list"] == []