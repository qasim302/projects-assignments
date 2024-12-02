import socket

# IP address and the port number for the server to bind
ipAddress = '127.0.0.1'
port = 12345

# Create a server socket
serverSocket = socket.socket()
serverSocket.bind((ipAddress, port))

# Listen for incoming connections
serverSocket.listen()
print("Server listening on {}:{}".format(ipAddress, port))

while True:
    # Accept a connection from a client
    clientConnection, clientAddress = serverSocket.accept()
    print("Incoming connection from:", clientAddress)

    # Receive a message from the client
    msgReceived = clientConnection.recv(1024)
    print("Received from client:", msgReceived.decode())

    # Send a response to the client
    msgSend = "Hello, Client!"
    clientConnection.send(msgSend.encode())
    print("Sent to client:", msgSend)

    # Close the connection to the client
    clientConnection.close()
