import datetime

import easyquotation
import json
import time

class orders:
    def __init__(self):
        self.code = 0 # 代码
        self.type = -1 # 交易类型 0：卖出 1：买入
        self.price = 0 # 委托价格
        self.time = 0 # 委托时间
        self.volume = 0 # 委托数量
        self.charge = 0 # 手续费
        self.marketinfo = 0 # 当前行情信息

class marketinfos:
    def __init__(self):
        self.buy = 0  # 竞买价
        self.sell = 0  # 竞卖价
        self.now = 0  # 现价
        self.open = 0  # 开盘价
        self.close = 0  # 昨日收盘价
        self.high = 0  # 今日最高价
        self.low = 0  # 今日最低价
        self.bid1 = 0  # 买一价
        self.bid1_volume = 0  # 买一量
        self.ask1 = 0  # 卖一价
        self.ask1_volume = 0  # 卖一量

class BaseStock():
    def __init__(self, stock_code, minimum_profit):
        self.stock_code = stock_code
        self.minimum_profit = minimum_profit
        self.quotation = easyquotation.use('sina')
        self.bid_dict = {}

        stock_value = self.quotation.stocks([self.stock_code])[self.stock_code]
        print(str(stock_value['name']))
        self.run()

    #########################################################################################

    def run(self):
        self.output()

    #########################################################################################

    def bid(self, type, marketinfo, volume):
        def charge_buy(price, volume):
            total_sum = price * volume
            commission = round(total_sum * 0.03) / 100 # 佣金
            if (commission < 5): commission = 5

            transfer = 0
            if (int(self.stock_code) >= 600000):
                transfer = round(volume * 0.06) / 100 # 过户费

            stamp = 0
            total_charge = round((commission + transfer + stamp) * 100) / 100
            print("买入总税费：" + str(total_charge))

            order = orders()
            order.code = self.stock_code
            order.type = 1
            order.price = price
            order.volume = volume
            order.charge = total_charge
            order.time = datetime.datetime.now()

            return order

        #########################################################################################

        def charge_sell(price, volume):
            total_sum = price * volume
            commission = round(total_sum * 0.03) / 100 # 佣金
            if (commission < 5): commission = 5

            transfer = 0
            if (int(self.stock_code) >= 600000): # 只有沪市收取
                transfer = round(volume * 0.06) / 100 # 过户费

            stamp = round(total_sum * 0.1) / 100 # 印花税

            total_charge = round((commission + transfer + stamp) * 100) / 100
            print("卖出总税费：" + str(total_charge))

            order = orders()
            order.code = self.stock_code
            order.type = 0
            order.price = price
            order.volume = volume
            order.charge = total_charge
            order.time = datetime.datetime.now()

            return order

        #########################################################################################

        charge = {'buy': charge_buy,
                  'sell': charge_sell}

        print("下单：" + str(marketinfo.buy) + " * ", str(volume))

        c = charge[type]
        order = c(marketinfo.buy, volume)
        order.marketinfo = marketinfo
        key = str(order.type) + "-" + str(self.stock_code) + "-" + str(order.price)
        self.bid_dict[key] = order

    #########################################################################################

    def output(self):
        for num in range(1,100):
            stock_value = self.quotation.stocks([self.stock_code])[self.stock_code]
            marketinfo = marketinfos()
            marketinfo.buy = stock_value['buy']  # 竞买价
            marketinfo.sell = stock_value['sell']  # 竞卖价

            marketinfo.now = stock_value['now'] # 现价
            marketinfo.open = stock_value['now'] # 开盘价
            marketinfo.close = stock_value['now'] # 昨日收盘价
            marketinfo.high = stock_value['now'] # 今日最高价
            marketinfo.low = stock_value['now'] # 今日最低价
            marketinfo.bid1 = stock_value['bid1'] # 买一价
            marketinfo.bid1_volume = stock_value['bid1_volume'] # 买一量
            marketinfo.ask1 = stock_value['ask1'] # 卖一价
            marketinfo.ask1_volume = stock_value['ask1_volume'] # 卖一量

            print("----------------------")

            self.bid("buy", marketinfo, 10000)

            self.bid("sell", marketinfo, 10000)

            print("----------------------")
   
            time.sleep(50)

#########################################################################################

if __name__ == "__main__":
    s = BaseStock('601988', 300)


#for i in stock_dict:
#    value = i.get('601988'))
#    resultData = json.loads(value)

   # print((value)

#print(stock_dict)
#print(type(stock_dict))

# dumps 将数据转换成字符串
#json_str = json.dumps(stock_dict)
#print(json_str)
#print(type(json_str))

#new_dict = json.loads(json_str)
#print(new_dict)
#print(type(new_dict))
