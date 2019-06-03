#coding=utf-8

import stockinfo
import stock
import threading
import http.server as hs


#########################################################################################

class ServerException(Exception):
    '''服务器内部错误'''
    pass

class RequestHandler(hs.BaseHTTPRequestHandler):

    def send_content(self, page, status=200):

        self.send_response(status)
        self.send_header("Content-type", "text/html")
        self.send_header("Content-Length", str(len(page)))
        self.end_headers()
        self.wfile.write(bytes(page, encoding='utf-8'))
        # print(page)

    def do_GET(self):
        content_str = '''<!DOCTYPE HTML>
                        <html>
                        <head><title>Get page</title></head>
                        <body>
                        "总持仓: " + str(stock_obj.s.position) + " 成本: " + str(stock_obj.s.primecost) + \
                        " 市值: " + str(stock_obj.s.tolvalue) + " 买入总税费: " + str(stock_obj.s.buy_charge) + \
                        " 浮动盈亏: " + str(stock_obj.s.floating_income) + " 波段盈亏: " + str(stock_obj.s.interval_income)

                        </body>
                        </html>'''
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.send_header("test", "This is test!")
        self.end_headers()
        buf = '''<!DOCTYPE HTML>
                        <html>
                        <head><title>Get page</title></head>
                        <body>

                        <form action="post_page" method="post">
                          username: <input type="text" name="username" /><br />
                          password: <input type="text" name="password" /><br />
                          <input type="submit" value="POST" />
                        </form>

                        </body>
                        </html>'''
        self.wfile.write(content_str.encode('utf-8'))


    Error_Page = """ \
<html>
<body>
<h1>Error accessing {path}</h1>
<p>{msg}</p>
</body>
</html>
"""

    def handle_error(self, msg):
        content = self.Error_Page.format(path=self.path, msg=msg)
        self.send_content(content, 404)

#########################################################################################

def run():
    stock_obj.run()

if __name__ == '__main__':
    startinfo = stockinfo.startinfos()

    startinfo.set_stock_code('300096') # 股票代码
    startinfo.set_minimum_profit(100) # 单次交易最小盈利
    startinfo.set_minimum_volume(1000) # 单次交易数量
    startinfo.set_maximum_capital(100000) # 资金总额

    stock_obj = stock.BaseStock(startinfo)

    s = threading.Thread(target=run, name='main.run')
    s.start()

    # httpAddress = ('', 8030)
    # httpd = hs.HTTPServer(httpAddress, RequestHandler)
    # httpd.serve_forever()




