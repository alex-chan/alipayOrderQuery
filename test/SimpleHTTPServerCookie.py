#Modifed SimpleHTTPServer which returns cookies passed on the request

import SimpleHTTPServer
import logging

cookieHeader = 'acct=t=youareabigsb;expires=Thu, 08-Sep-2016 10:05:01 GMT; path=/; HttpOnly'

class MyHTTPRequestHandler(SimpleHTTPServer.SimpleHTTPRequestHandler):
    def do_GET(self):
        self.cookieHeader = self.headers.get('Cookie')

        if self.cookieHeader:
            print("Request cookie:" + self.cookieHeader)
        else:
            print("request cookies is null")

        SimpleHTTPServer.SimpleHTTPRequestHandler.do_GET(self)

    def end_headers(self):
        self.send_my_headers()

        SimpleHTTPServer.SimpleHTTPRequestHandler.end_headers(self)

    def send_my_headers(self):
        self.send_header('Set-Cookie',  cookieHeader )
        # SimpleHTTPServer.SimpleHTTPRequestHandler.flush_headers(self)



if __name__ == '__main__':
    SimpleHTTPServer.test(HandlerClass=MyHTTPRequestHandler)
