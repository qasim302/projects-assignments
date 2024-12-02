Your mission is to implement more secure versions of the client and server with the following
requirement:
•
•
All traffic between client and server must be encrypted with TLS v1.2/1.3
The client must be able to authenticate the server based on a certificate the server provides
(for the purpose of this lab this will be a self-signed certificate)
Use context=ssl.SSLContext(ssl.PROTOCOL_TLS) to establish the TLS context and then use
context.wrap_socket function to wrap the existing clientSocket/serverSocket. Note that on the
server you need to wrap the socket created when a client connection is accepted rather than the
original socket
As a side note we are using PROTOCOL_TLS instead of PROTOCOL_TLS_CLIENT or
PROTOCOL_TLS_SERVER to avoid things like a client host name check on our fictious server
hostname (see below). You can try PROTOCOL_TLS_CLIENT in task 3.
On the client-side, you need to make sure to set context.verify_mode=ssl.CERT_REQUIRED
and you use the context.load_verify_locations function on the context to load the CA cert
(which is our cert as we created a self-signed cert).
The client must check that the Common Name (CN) is the proper name (to make sure we are
communicating with the right server) and that the certificate is active and has not expired. The
certificate can be accessed with getpeercert() on the SSL socket after a successful connect()
The following code snippets will help you in extracting the info from the cert:
•
•
•
commonName = dict(item[0] for item in server_cert['subject'])['commonName']
notAfterTimestamp = ssl.cert_time_to_seconds(server_cert['notAfter'])
notBeforeTimestamp = ssl.cert_time_to_seconds(server_cert['notBefore'])
Print out the full cert to see what it contains. Then implement sensible checks for the above.
On the server-side you also need to use the context.load_verify_locations function on the
context to load the cert created and you need to use the context.load_cert_chain function on
the context to load the server’s certificate.
To generate the certificate for the server, use the openssl tool:
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -sha256
-subj "/C=AU/ST=WA/L=Perth/O=Test Organisation/OU=Org/CN=www.test.org"
You can change the subject data as you like, but whatever CN you choose you must test for that
name in the client. For convenience we get rid of the passphrase on the private key file, otherwise
the server would prompt us for the key for every connection:
openssl rsa -in key.pem -out clearkey.pem
Use Wireshark to inspect the TLS handshake and verify that the connection is now secure, i.e., an
observer can’t read the messages.
