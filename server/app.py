from project import app

if __name__ == '__main__':
    try:
        app.run(debug=True)
    except:
        print("An exception occurred")
        app.run(debug=True) #temporany
