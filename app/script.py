"""System module."""
import os

from http.server import BaseHTTPRequestHandler, HTTPServer

HOST_NAME = "0.0.0.0"
SERVER_PORT = 80

class MyServer(BaseHTTPRequestHandler):
    def do_get(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(bytes("<html><head><title>VARIABLES:</title></head>", "utf-8"))
        self.wfile.write(bytes("<p>----------------------</p>", "utf-8"))
        self.wfile.write(bytes("<p>Request: %s</p>" % self.path, "utf-8"))
        self.wfile.write(bytes("<body>", "utf-8"))
        for item, value in os.environ.items():
            self.wfile.write(bytes("<div style='color:red;font-size:15px;'> %s:
            </div> <div style='color:black;font-size:15px;'> %s </div>" % (item, value), "utf-8"))
        self.wfile.write(bytes("<p>----------------------</p>", "utf-8"))
        self.wfile.write(bytes("</body></html>", "utf-8"))

if __name__ == "__main__":
    webServer = HTTPServer((HOST_NAME, SERVER_PORT), MyServer)
    print("Server started http://%s:%s" % (HOST_NAME, SERVER_PORT))

    try:
        webServer.serve_forever()
    except KeyboardInterrupt:
        pass

    webServer.server_close()
    print("Server stopped.")
