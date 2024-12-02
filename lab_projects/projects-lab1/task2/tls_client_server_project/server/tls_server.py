import socket
import ssl

# Define server IP and Port
ipAddress = '127.0.0.1'
port = 12345

# Create a TLS context
context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)

context.load_cert_chain(certfile="../certs/cert.pem", keyfile="../certs/clearkey.pem")

# Create a server socket
serverSocket = socket.socket()
serverSocket.bind((ipAddress, port))
serverSocket.listen(1)

print("TLS-enabled server listening on {}:{}".format(ipAddress, port))

while True:
    # Accept a client connection
    clientConnection, clientAddress = serverSocket.accept()
    print("Incoming connection from:", clientAddress)
    
    # Wrap the client socket with TLS
    tlsConnection = context.wrap_socket(clientConnection, server_side=True)
    
    # Receive and send encrypted messages
    try:
        msgReceived = tlsConnection.recv(1024).decode()
        print("Received from client:", msgReceived)
        
        msgSend = "Hello, Client! (Secure)"
        tlsConnection.send(msgSend.encode())
        print("Sent to client:", msgSend)
    except ssl.SSLError as e:
        print("SSL error:", e)
    finally:
        # Close the TLS connection
        tlsConnection.close()

