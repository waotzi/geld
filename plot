#!/usr/bin/env python3

import matplotlib.pyplot as plt
from matplotlib.ticker import StrMethodFormatter, NullFormatter
from matplotlib.dates import DateFormatter, AutoDateLocator
from datetime import datetime
import requests
import sys
import json

coin ="litecoin"
if len(sys.argv) > 1:
   coin=sys.argv[1]

days=100
if len(sys.argv) > 2:
   days=sys.argv[2]

vs_currency="usd"
if len(sys.argv) > 3:
   vs_currency=sys.argv[3]

def get_data():
   x = []
   y = []
   if coin=="fng":
      res=requests.get('https://api.alternative.me/fng/?limit=' + str(days))
      data = json.loads(res.content)['data']
      for val in data:
         x.append(datetime.fromtimestamp(int(val['timestamp'])))
         y.append(int(val['value']))
   else:
      res=requests.get('https://api.coingecko.com/api/v3/coins/' + coin + '/market_chart?vs_currency=' + vs_currency + '&days=' + str(days))
      data = json.loads(res.content)['prices']
      if data:
         for i in data:
            xval=datetime.fromtimestamp(i[0]/1000)
            x.append(xval)
            y.append(i[1])
   return x, y
   



def plot_data():


   fig, ax = plt.subplots()

   if coin == 'fng':
      plt.title("Fear and Greed Index, " + str(days) + " day/s")
   else:
      plt.title(coin + " vs " + vs_currency + " " + str(days) + " day/s")
   plt.plot(x, y)
   plt.yscale('log')
   plt.xlabel('time')
   plt.ylabel(coin)

   min_y = min(y)
   sf = int(f'{min_y:e}'.split('e')[-1])
   if sf < 0:
      sf = abs(sf)
      sf += 1
   else:
      sf = 0

   ax.yaxis.set_major_formatter(StrMethodFormatter('{x:.' + str(sf) + 'f}'))
   ax.yaxis.set_minor_formatter(StrMethodFormatter('{x:.' + str(sf) + 'f}'))

   if int(days) <= 2:
      formatter = DateFormatter('%H:%M')
   elif int(days) <= 40:
      formatter = DateFormatter('%d')
   elif int(days) <= 400:
      formatter = DateFormatter('%d/%m')
   else:
      formatter = DateFormatter('%m/%y')

   ax.xaxis.set_major_formatter(formatter)


   plt.show()

x, y  = get_data()
if x and y:
   plot_data()
