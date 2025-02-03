from flask import Flask, jsonify
import socket
import datetime
import getpass
import os

app = Flask(__name__)

# Simple Flask webserver is created using a function 
@app.route('/', methods=['GET'])
def simpletimeservice():

  # For getting Timestamp 
    timestamp = datetime.datetime.now()

  # for obtaining User's machine IP Address
    user_ip_addr = socket.gethostbyname(socket.gethostname())

  # (optional addition) this is added to obtain the username. This is for rectifying if the user in root user or non-root user
    username = getpass.getuser()
  
  # (Optional addition) this is to rectify if the app is running in the directory specified in the Dockerfile. 
    pwd = os.getcwd()

  # (optional) to check if the user is root user or not. Works only in Linux systems. 
    is_root = os.geteuid()
    if is_root == 0:
        user_type = "root"
    else:
        user_type = "non-root"

  # response in JSON
    response = {
        "timestamp": timestamp,
        "ip": user_ip_addr,
        "username": username,
        "user_type": user_type,
        "present_working_directory": pwd
    }
  
  # using jsonify for returning response in JSON format in the webserver
    return jsonify(response)


# declaring the webserver to run with appropriate parameters. 
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
