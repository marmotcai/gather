import easyquotation
import json
import time

class BaseStock():
    def __init__(self, stock_code, minimum_profit):
        self.stock_code = stock_code
        self.minimum_profit = minimum_profit
        self.quotation = easyquotation.use('sina')
        self.bid_dict = {}

        stock_value = self.quotation.stocks([self.stock_code])[self.stock_code]
        print(str(stock_value['name']))
        self.run()

    def run(self):
        self.output()

    def bid(self, type, price, volume):
        def charge_buy(price, volume):
            total_sum = price * volume
            commission = round(total_sum * 0.03) / 100 #佣金
            if (commission < 5): commission = 5

            transfer = 0
            if (int(self.stock_code) >= 600000):
                transfer = round(volume * 0.06) / 100 #过户费

            stamp = 0
            total_charge = round((commission + transfer + stamp) * 100) / 100
            print("买入总税费：" + str(total_charge))

        def charge_sell(price, volume):
            total_sum = price * volume
            commission = round(total_sum * 0.03) / 100 #佣金
            if (commission < 5): commission = 5

            transfer = 0
            if (int(self.stock_code) >= 600000):
                transfer = round(volume * 0.06) / 100 #过户费

            stamp = round(total_sum * 0.1) / 100 #印花税

            total_charge = round((commission + transfer + stamp) * 100) / 100
            print("卖出总税费：" + str(total_charge))
        charge = {'buy': charge_buy,
                  'sell': charge_sell}

        print("下单：" + str(price) + " * ", str(volume))

        c = charge[type]
        c(price, volume)

        self.bid_dict['type'] = type
        self.bid_dict['price'] = price
        self.bid_dict['volume'] = volume



    def output(self):
        for num in range(1,100):
            stock_value = self.quotation.stocks([self.stock_code])[self.stock_code]

            buy = stock_value['buy']  # 竞买价
            sell = stock_value['sell']  # 竞卖价

            now = stock_value['now'] # 现价
            open = stock_value['now'] # 开盘价
            close = stock_value['now'] # 昨日收盘价
            high = stock_value['now'] # 今日最高价
            low = stock_value['now'] # 今日最低价
            bid1 = stock_value['bid1'] # 买一价
            bid1_volume = stock_value['bid1_volume'] # 买一量
            ask1 = stock_value['ask1'] # 卖一价
            ask1_volume = stock_value['ask1_volume'] # 卖一量

            print("----------------------")

            self.bid("buy", buy, 10000)

            self.bid("sell", sell, 10000)

            print("----------------------")
   
            time.sleep(50)

if __name__ == "__main__":
    s = BaseStock('300104', 300)


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
