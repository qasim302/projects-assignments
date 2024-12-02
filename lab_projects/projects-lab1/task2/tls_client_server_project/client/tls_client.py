import socket
import ssl
import time

# Define server IP and Port
serverIP = '127.0.0.1'
serverPort = 12345

# Create a TLS context for the client
context = ssl.SSLContext(ssl.PROTOCOL_TLS)
context.verify_mode = ssl.CERT_REQUIRED
context.load_verify_locations(cafile="../certs/cert.pem")

# Create a client socket
clientSocket = socket.socket()

# Wrap the socket with TLS
tlsClientSocket = context.wrap_socket(clientSocket, server_hostname="www.test.org")

# Connect to the server
tlsClientSocket.connect((serverIP, serverPort))

# Verify the server certificate
server_cert = tlsClientSocket.getpeercert()
commonName = dict(item[0] for item in server_cert['subject'])['commonName']
notAfterTimestamp = ssl.cert_time_to_seconds(server_cert['notAfter'])
notBeforeTimestamp = ssl.cert_time_to_seconds(server_cert['notBefore'])
currentTime = time.time()

if commonName != "www.test.org":
    raise ssl.SSLError("Server CN mismatch")
if not (notBeforeTimestamp <= currentTime <= notAfterTimestamp):
    raise ssl.SSLError("Server certificate is expired or not yet valid")

# Send and receive encrypted messages
msgSend = "Hello, Server! (Secure)"
tlsClientSocket.send(msgSend.encode())
print("Sent to server:", msgSend)

msgReceived = tlsClientSocket.recv(1024).decode()
print("Received from server:", msgReceived)

# Close the connection
tlsClientSocket.close()
