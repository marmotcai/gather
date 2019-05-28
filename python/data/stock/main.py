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
        self.marketinfo = 0 # 当前行情信息
        self.charge = 0 # 手续费

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

class Statistics:
    def __init__(self):
        self.floating_income = 0  # 浮动收益，代表市值和成本差
        self.interval_income = 0  # 区间收益，代表波段操作收益
        self.bid = {}  # 下单记录
        self.buy_order = {}  # 买入记录
        self.sell_order = {}  # 卖出记录

class BaseStock():

    def __init__(self, stock_code, minimum_profit):
        self.stock_code = stock_code
        self.minimum_profit = minimum_profit
        self.quotation = easyquotation.use('sina')

        self.s = Statistics()

        stock_value = self.quotation.stocks([self.stock_code])[self.stock_code]
        print(str(stock_value['name']))
        self.run()

    #########################################################################################

    def calc_charge(self, type, price, volume):

        def charge_buy(price, volume):
            total_sum = price * volume
            commission = round(total_sum * 0.03) / 100 # 佣金
            if (commission < 5): commission = 5

            transfer = 0
            if (int(self.stock_code) >= 600000):
                transfer = round(volume * 0.06) / 100 # 过户费

            stamp = 0
            total_charge = round((commission + transfer + stamp) * 100) / 100

            return total_charge

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

            return total_charge

        charge = {'buy': charge_buy,
                  'sell': charge_sell}

        c = charge[type]
        return c(price, volume)

    def calc_profit(self, buy, sell, volume):
        order_buy = buy
        order_sell = sell
        charge_buy = self.calc_charge("buy", buy, volume)
        charge_sell = self.calc_charge("sell", sell, volume)

        profit = volume * (order_sell - order_buy) - charge_buy - charge_sell
        profit = round(profit * 100) / 100
        # print("买入总税费：" + str(charge_buy))
        # print("卖出总税费：" + str(charge_sell))
        # print("本次利润：" + str(profit))
        return profit

    #########################################################################################

    def bid(self, type, marketinfo, volume):
        def bid_buy(price, volume):
            print("开始下单买入,价格： ：" + str(price), " 数量: " + str(volume))
            order = orders()
            order.code = self.stock_code
            order.type = 1
            order.price = price
            order.volume = volume
            order.time = datetime.datetime.now()
            order.charge = self.calc_charge("buy", price, volume)

            key = order.price
            self.s.buy_order[key] = order

            return order

        #########################################################################################

        def bid_sell(price, volume):
            for b in self.s.buy_order:
                profit = self.calc_profit(b, price, volume)
                if (profit > self.minimum_profit):
                    print("开始下单卖出,价格： ：" + str(marketinfo.now), " 数量: " + str(volume))
                    order = self.s.buy_order.pop(b)
                    order.code = self.stock_code
                    order.type = 0
                    order.price = price
                    order.volume = volume
                    order.time = datetime.datetime.now()
                    order.charge = self.calc_charge("sell", price, volume)

                    key = str(order.price)
                    self.s.sell_order[key] = order

                    self.s.interval_income = self.s.interval_income + profit

                    return order

        #########################################################################################

        bid = {'buy': bid_buy, 'sell': bid_sell}

        print("当前价格：" + str(marketinfo.now))

        c = bid[type]
        order = c(marketinfo.now, volume)
        if order:
            order.marketinfo = marketinfo
            key = str(order.time)
            self.s.bid[key] = order

    #########################################################################################

    def judge(self, marketinfos):
        marketinfo = marketinfos

        order = self.s.buy_order.get(marketinfo.now)

        if (not order):
            self.bid("buy", marketinfo, 10000)

        # time.sleep(1)
        # marketinfo.now = marketinfo.now + 0.05

        self.bid("sell", marketinfo, 10000)

    #########################################################################################

    def run(self):
        for num in range(1,1000):
            stock_value = self.quotation.stocks([self.stock_code])[self.stock_code]

            marketinfo = marketinfos()
            marketinfo.buy = stock_value['buy']  # 竞买价
            marketinfo.sell = stock_value['sell']  # 竞卖价

            marketinfo.now = stock_value['now'] # 现价
            marketinfo.open = stock_value['open'] # 开盘价
            marketinfo.close = stock_value['close'] # 昨日收盘价
            marketinfo.high = stock_value['high'] # 今日最高价
            marketinfo.low = stock_value['low'] # 今日最低价
            marketinfo.bid1 = stock_value['bid1'] # 买一价
            marketinfo.bid1_volume = stock_value['bid1_volume'] # 买一量
            marketinfo.ask1 = stock_value['ask1'] # 卖一价
            marketinfo.ask1_volume = stock_value['ask1_volume'] # 卖一量

            print("----------------------")

            self.judge(marketinfo)

            print("当前买入单: " + str(self.s.buy_order.__len__()) + " 当前卖出单: " + str(self.s.sell_order.__len__()))

            position = 0
            primecost = 0
            buy_charge = 0
            for b in self.s.buy_order:
                order = self.s.buy_order.get(b)
                primecost = primecost + (order.price * order.volume) + order.charge
                position = position + order.volume
                buy_charge = buy_charge + order.charge

            primecost = round(primecost)

            tolvalue = position * marketinfo.now
            tolvalue = round(tolvalue)

            self.s.floating_income = tolvalue - primecost
            print("总持仓: " + str(position) + " 成本: " + str(primecost) + " 市值: " + str(tolvalue)
                  + " 浮动盈亏: " + str(self.s.floating_income) + " 波段盈亏: "  + str(self.s.interval_income)
                  + " 交易次数: " + str(self.s.bid.__len__()))

            print("----------------------")
   
            time.sleep(5)

#########################################################################################

if __name__ == "__main__":
    s = BaseStock('300096', 300)
