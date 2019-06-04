# coding=utf-8
from socket import *

import re
import stock

class BaseServer():

    def __init__(self, stock_obj):
        self.s = stock_obj.s

    def handle_client(self, client_socket):
        """为一个客户端服务"""
        # 接收对方发送的数据
        recv_data = client_socket.recv(1024).decode("utf-8")  # 1024表示本次接收的最大字节数
        # 打印从客户端发送过来的数据内容
        # print("client_recv:",recv_data)
        request_header_lines = recv_data.splitlines()
        for line in request_header_lines:
            print(line)

        # 返回浏览器数据
        # 设置内容body
        # 使用正则匹配出文件路径
        ret = re.match(r"[^/]+/([^\s]*)", request_header_lines[0])
        if ret:
            file_path = "./html/" + ret.group(1)
            if file_path == "./html/":
                file_path = "./html/index.html"
        try:
            # 设置返回的头信息 header
            #response_headers = "HTTP/1.1 200 OK\r\n"  # 200 表示找到这个资源
            #response_headers += "content-type=\"text/html;charset=utf-8;\"\r\n"
            #response_headers += "\r\n"  # 空一行与body隔开

            stockinfo_body = ""
            stockinfo_body += "<div>当前价格：" + str(self.s.marketinfo.now) + "</div>\r\n"
            stockinfo_body += "<div>成本单价: " + str(self.s.current_cost) + "</div>\r\n"
            stockinfo_body += "<div>总持仓: " + str(self.s.position) + "</div>\r\n"
            stockinfo_body += "<div>成本: " + str(self.s.primecost) + "</div>\r\n"
            stockinfo_body += "<div>市值: " + str(self.s.tolvalue) + "</div>\r\n"
            stockinfo_body += "<div>买入总税费: " + str(self.s.buy_charge) + "</div>\r\n"
            stockinfo_body += "<div>卖出总税费: " + str(self.s.sell_charge) + "</div>\r\n"
            stockinfo_body += "<div>当前买入单: " + str(self.s.buy_order.__len__()) + "/" + str(self.s.buy_count) + "</div>\r\n"
            stockinfo_body += "<div>当前卖出单: " + str(self.s.sell_order.__len__()) + "/" + str(self.s.sell_count) + "</div>\r\n"
            stockinfo_body += "<div>交易次数: " + str(self.s.bid.__len__()) + "</div>\r\n"

            if (self.s.floating_income > 0):
                stockinfo_body += "<div>浮动盈亏: <span style=\"color:red;\">" + str(self.s.floating_income) + "</span></div>\r\n"
            else:
                stockinfo_body += "<div>浮动盈亏: <span style=\"color:green;\">" + str(self.s.floating_income) + "</span></div>\r\n"

            if (self.s.interval_income > 0):
                stockinfo_body += "<div>波段盈亏: <span style=\"color:red;\">" + str(self.s.interval_income) + "</span></div>\r\n"
            else:
                stockinfo_body += "<div>波段盈亏: <span style=\"color:green;\">" + str(self.s.interval_income) + "</span></div>\r\n"

            income = round(self.s.floating_income + self.s.interval_income, 2)
            if (income > 0):
                stockinfo_body += "<div>总盈亏: <span style=\"color:red;\">" + str(income) + "</span></div>\r\n"
            else:
                stockinfo_body += "<div>总盈亏: <span style=\"color:green;\">" + str(income) + "</span></div>\r\n"

            response_headers = "HTTP/1.1 200 OK\r\n"  # 200 表示找到这个资源
            response_headers += "\r\n"  # 空一行与body隔开

            # 读取html文件内容
            file_name = file_path  # 设置读取的文件路径
            f = open(file_name, "r")  # 以二进制读取文件内容
            response_body = ""
            try:
                text_lines = f.readlines()
                for line in text_lines:
                    if ("#stockinfo#" in line):
                        response_body += stockinfo_body + "\r\n"
                    else:
                        response_body += line

            finally:
                f.close()

            response = response_headers + response_body

            # 返回数据给浏览器
            client_socket.send(response.encode("gb2312"))  # 转码utf-8并send数据到浏览器

        except:
            # 如果没有找到文件，那么就打印404 not found
            # 设置返回的头信息 header
            response_headers = "HTTP/1.1 404 not found\r\n"
            response_headers += "\r\n"  # 空一行与body隔开
            response_body = "<h1>sorry,file not found</h1>"
            response = response_headers + response_body
            client_socket.send(response.encode("utf-8"))

        client_socket.close()


    def run(self):
        # 创建套接字
        server_socket = socket(AF_INET, SOCK_STREAM)
        # 设置当服务器先close 即服务器端4次挥手之后资源能够立即释放，这样就保证了，下次运行程序时 可以立即绑定7788端口
        server_socket.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
        # 设置服务端提供服务的端口号
        server_socket.bind(('', 7788))
        # 使用socket创建的套接字默认的属性是主动的，使用listen将其改为被动，用来监听连接
        server_socket.listen(128)  # 最多可以监听128个连接
        # 开启while循环处理访问过来的请求
        while True:
            # 如果有新的客户端来链接服务端，那么就产生一个新的套接字专门为这个客户端服务
            # client_socket用来为这个客户端服务
            # server_socket就可以省下来专门等待其他新的客户端连接while True:
            client_socket, clientAddr = server_socket.accept()
            self.handle_client(client_socket)