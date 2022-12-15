from tests.conftest import post_request, get_request, delete_request

def test_neighborhoods():
    response = get_request('/neighborhoods')
    assert response["status"] == "success"
    assert response["neighborhoods"] != []