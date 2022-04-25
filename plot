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

vs_currency="usd"
if len(sys.argv) > 2:
   vs_currency=sys.argv[2]

days=100
if len(sys.argv) > 3:
   days=sys.argv[3]

x=requests.get('https://api.coingecko.com/api/v3/coins/' + coin + '/market_chart?vs_currency=' + vs_currency + '&days=' + str(days))
data=json.loads(x.content)["prices"]


x = []
y = []
for i in data:
   xval=datetime.fromtimestamp(i[0]/1000)
   x.append(xval)
   y.append(i[1])


fig, ax = plt.subplots()

plt.title(coin + " vs " + vs_currency + " " + str(days) + " day/s")
plt.plot(x, y)
plt.yscale('log')
plt.xlabel('time')
plt.ylabel(coin)

ax.yaxis.set_major_formatter(StrMethodFormatter('{x:.0f}'))
ax.yaxis.set_minor_formatter(StrMethodFormatter('{x:.0f}'))

if int(days) <= 2:
   formatter = DateFormatter('%H:%M')
elif int(days) <= 40:
   formatter = DateFormatter('%d')
elif int(days) <= 400:
   formatter = DateFormatter('%m/%d')
else:
   formatter = DateFormatter('%m/%y')

ax.xaxis.set_major_formatter(formatter)


plt.show()

