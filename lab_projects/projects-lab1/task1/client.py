import socket

# IP address and the port number of the server
serverIP = '127.0.0.1'
serverPort = 12345

# Create a client socket
clientSocket = socket.socket()

# Connect to the server
clientSocket.connect((serverIP, serverPort))

# Send a message
msgSend = "Hello, Server!"
clientSocket.send(msgSend.encode())
print("Sent to server:", msgSend)

# Receive response
msgReceived = clientSocket.recv(1024)
print("Received from server:", msgReceived.decode())

# Close the socket
clientSocket.close()
