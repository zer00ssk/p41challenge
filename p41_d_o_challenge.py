from flask import Flask, jsonify
import socket
import datetime
import getpass
import os

app = Flask(__name__)


@app.route('/', methods=['GET'])
def simpletimeservice():
    timestamp = datetime.datetime.now()
    user_ip_addr = socket.gethostbyname(socket.gethostname())
    username = getpass.getuser()
    pwd = os.getcwd()
    is_root = os.geteuid()
    if is_root == 0:
        user_type = "root"
    else:
        user_type = "non-root"
    response = {
        "timestamp": timestamp,
        "ip": user_ip_addr,
        "username": username,
        "user_type": user_type,
        "present_working_directory": pwd
    }

    return jsonify(response)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
