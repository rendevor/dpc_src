from flask import Flask

app = Flask(__name__)


@app.route('/')
def hello():
    return 'Hello, World! version:'+read_version()

def read_version():
    with open('dpc-app-current-version.txt') as file:
        return file.readline().strip('\n')