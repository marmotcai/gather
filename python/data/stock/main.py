import easyquotation
import json
import time

stock_code = '300096' 
quotation = easyquotation.use('sina')
stock_dict = quotation.stocks([stock_code])
print(stock_dict)

for num in range(1,100):
    stock_value = quotation.stocks([stock_code])[stock_code]
    print("----------------------")
    print(str(stock_value['bid1']) + " " + str(stock_value['bid1_volume']))
    print(str(stock_value['ask1']) + " " + str(stock_value['ask1_volume']))
    print(str(stock_value['low']) + " " + str(stock_value['high']))
    print("----------------------")
   
    time.sleep(5)

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
