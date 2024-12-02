import socket
import ssl

# Step 1: Define server details
server_host = 'www.murdoch.edu.au'  # Server hostname
server_port = 443  # Standard HTTPS port

# Step 2: Create a TCP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Step 3: Set up the SSL context
context = ssl.SSLContext(ssl.PROTOCOL_TLS_CLIENT)
# Load system CA certificates for server verification
context.load_verify_locations('/etc/ssl/certs/ca-certificates.crt')

# Step 4: Wrap the socket with the SSL context for secure connection
ssl_sock = context.wrap_socket(sock, server_hostname=server_host)

# Step 5: Connect to the HTTPS server
ssl_sock.connect((server_host, server_port))
print(f"Connected to {server_host} on port {server_port}")

# Step 6: Format and send an HTTP GET request
request = f"GET / HTTP/1.1\r\nHost: {server_host}\r\nConnection: close\r\n\r\n"
ssl_sock.sendall(request.encode())
print(f"Sent request: {request}")

# Step 7: Receive and display the server's response
response = b""
while True:
    data = ssl_sock.recv(4096)
    if not data:
        break
    response += data

print("Server response received:")
print(response.decode())

# Step 8: Close the SSL socket
ssl_sock.close()
