import random

import stockinfo

import datetime

import easyquotation
import time

class BaseStock():

    def __init__(self, startinfos):

        self.quotation = easyquotation.use('sina')

        self.s = stockinfo.statistics()

        self.s.startinfo = startinfos

        self.calc = stockinfo.calc(self.s)
        stock_value = self.quotation.stocks([self.s.startinfo.stock_code])[self.s.startinfo.stock_code]

        name = stock_value['name']  # 名字
        now = stock_value['now']  # 现价

        print(str(stock_value['name']))

    #########################################################################################

    def istringtime(self):
        date = datetime.datetime.now()
        day = date.weekday()
        if (day > 4):
            return 0

        am_time1 = datetime.datetime.strptime(str(datetime.datetime.now().date()) + '9:30', '%Y-%m-%d%H:%M')
        am_time2 = datetime.datetime.strptime(str(datetime.datetime.now().date()) + '11:30', '%Y-%m-%d%H:%M')
        pm_time1 = datetime.datetime.strptime(str(datetime.datetime.now().date()) + '13:00', '%Y-%m-%d%H:%M')
        pm_time2 = datetime.datetime.strptime(str(datetime.datetime.now().date()) + '15:00', '%Y-%m-%d%H:%M')

        if date >= am_time1 and date <= am_time2:
            return 1
        if date >= pm_time1 and date <= pm_time2:
            return 1

        return 0

    #########################################################################################

    def judge(self, marketinfos):

        def judge_buy(marketinfo):

            for b in self.s.sell_order: # 检查是否有卖出单可以买回获利的
                profit = -1 * self.calc.calc_profit(b, marketinfo.now, self.s.startinfo.minimum_volume)
                if (profit > self.s.startinfo.minimum_profit):
                    self.s.sell_order.pop(b)  # 从卖单列表里删除卖单
                    self.bid("buy", marketinfo, self.s.startinfo.minimum_volume)
                    self.s.interval_income = self.s.interval_income + profit  # 计算波段盈利
                    self.s.interval_income = round(self.s.interval_income, 2)
                    return

            for b in self.s.buy_order:
                space = round(b - marketinfo.now, 2)
                if ( abs(space) < self.s.startinfo.premium_space):
                    print(" 价格空间小于阈值(" + str(abs(space)) + ") 不予买入:(" + str(b) + "-" + str(marketinfo.now) + ")")
                    return

            quota = self.s.get_quota()
            if (quota < 0.8): # 判断资金余量是否超过80%
                order = self.s.buy_order.get(marketinfo.now) # 判断这个价格是否已经买入
                if (not order):
                    self.bid("buy", marketinfo, self.s.startinfo.minimum_volume)
                    print(" 价格空间大于阈值,买入:(" + str(marketinfo.now) + "-" + str(self.s.startinfo.minimum_volume) + ")")

        def judge_sell(marketinfo):

            for b in self.s.buy_order: # 检查是否有买入单可以卖出获利的
                profit = self.calc.calc_profit(b, marketinfo.now, self.s.startinfo.minimum_volume)
                if (profit > self.s.startinfo.minimum_profit):
                    self.s.buy_order.pop(b)  # 从买单列表里删除买单
                    self.bid("sell", marketinfo, self.s.startinfo.minimum_volume) # 下卖单
                    self.s.interval_income = self.s.interval_income + profit  # 计算波段盈利
                    self.s.interval_income = round(self.s.interval_income, 2)
                    return

        #########################################################################################

        print("-------买入卖出判断-------")

        judge_buy(marketinfos)
        judge_sell(marketinfos)

        print("-------买入卖出判断-------")

    #########################################################################################

    def bid(self, type, marketinfo, volume):

        #########################################################################################

        def new_order(type, price, volume):
            order = stockinfo.orders()
            order.code = self.s.startinfo.stock_code
            order.type = type
            order.price = round(price, 2)
            order.volume = volume
            order.time = datetime.datetime.now()
            order.charge = self.calc.calc_charge(type, price, volume)

            return order

        def bid_buy(price, volume):
            print("开始下单买入,价格：" + str(price), " 数量: " + str(volume))
            order = new_order("buy", price, volume)
            self.s.buy_order[order.price] = order
            self.s.buy_count = self.s.buy_count + 1
            self.s.buy_charge = self.s.buy_charge + order.charge
            self.s.buy_charge = round(self.s.buy_charge, 2)

            return order

        def bid_sell(price, volume):
            print("开始下单卖出,价格：" + str(price), " 数量: " + str(volume))
            order = new_order("sell", price, volume)
            self.s.sell_order[order.price] = order
            self.s.sell_count = self.s.sell_count + 1
            self.s.sell_charge = self.s.sell_charge + order.charge
            self.s.sell_charge = round(self.s.sell_charge, 2)

            return order

        #########################################################################################

        bid = {'buy': bid_buy, 'sell': bid_sell}
        c = bid[type]

        order = c(marketinfo.now, volume)
        if order:
            order.marketinfo = marketinfo
            key = str(order.time)
            self.s.bid[key] = order # 交易记录

        self.s.current_cost = self.calc.calc_cost(type, marketinfo.now, volume)

    #########################################################################################

    def run(self):
        for num in range(1, 1000):
            if not self.istringtime():
                time.sleep(30)
                continue

            stock_value = self.quotation.stocks([self.s.startinfo.stock_code])[self.s.startinfo.stock_code]

            self.s.marketinfo.buy = stock_value['buy']  # 竞买价
            self.s.marketinfo.sell = stock_value['sell']  # 竞卖价

            self.s.marketinfo.now = stock_value['now']  # 现价
            self.s.marketinfo.open = stock_value['open']  # 开盘价
            self.s.marketinfo.close = stock_value['close']  # 昨日收盘价
            self.s.marketinfo.high = stock_value['high']  # 今日最高价
            self.s.marketinfo.low = stock_value['low']  # 今日最低价
            self.s.marketinfo.bid1 = stock_value['bid1']  # 买一价
            self.s.marketinfo.bid1_volume = stock_value['bid1_volume']  # 买一量
            self.s.marketinfo.ask1 = stock_value['ask1']  # 卖一价
            self.s.marketinfo.ask1_volume = stock_value['ask1_volume']  # 卖一量
            self.s.marketinfo.date = stock_value['date']  # 日期
            self.s.marketinfo.time = stock_value['time']  # 时间

            self.s.marketinfo.now = self.s.marketinfo.now + round(random.randrange(-10, 10) / 100, 2)
            self.s.marketinfo.now = round(self.s.marketinfo.now, 2)

            print("\r\n")

            self.judge(self.s.marketinfo)

            print("\r\n")

            print("#######当前状态信息########")

            self.s.position = 0
            self.s.primecost = 0
            for b in self.s.buy_order:
                order = self.s.buy_order.get(b)
                self.s.primecost = self.s.primecost + (order.price * order.volume) + order.charge  # 计算总成本
                self.s.position = self.s.position + order.volume  # 计算总持仓

            self.s.primecost = round(self.s.primecost, 2)

            self.s.tolvalue = self.s.position * self.s.marketinfo.now
            self.s.tolvalue = round(self.s.tolvalue, 2)

            self.s.floating_income = round(self.s.tolvalue - self.s.primecost, 2)

            print(" 当前价格：" + str(self.s.marketinfo.now) + " 成本单价: " + str(self.s.current_cost))

            print(" 当前买入单: " + str(self.s.buy_order.__len__()) + "/" + str(self.s.buy_count) +
                  " 当前卖出单: " + str(self.s.sell_order.__len__()) + "/" + str(self.s.sell_count) +
                  " 交易次数: " + str(self.s.bid.__len__()))

            print(" 总持仓: " + str(self.s.position) + " 成本: " + str(self.s.primecost) + " 市值: " + str(self.s.tolvalue) + "\r\n"
                  + " 买入总税费: " + str(self.s.buy_charge) + " 卖出总税费: " + str(self.s.sell_charge) + "\r\n"
                  + " 浮动盈亏: " + str(self.s.floating_income) + " 波段盈亏: " + str(self.s.interval_income))

            print("#######当前状态信息########")

            time.sleep(3)
