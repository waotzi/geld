#!/bin/python

import sys
from bs4 import BeautifulSoup
from pycoingecko import CoinGeckoAPI
from forex_python.converter import CurrencyRates


file_path = sys.argv[1]
file_name = sys.argv[2]

cg = CoinGeckoAPI()
c = CurrencyRates()

with open(file_path + file_name, 'r') as f:
    data = f.read()

file = open(file_path + '.~' + file_name, 'w')
file.write(str(data))
file.close()

bs_data = BeautifulSoup(data, "xml")

rows = []
symbols = []
for tag in bs_data.find_all('gnm:Cell', {'Col':'1'}):
    if tag.string != "coin":
        symbols.append(tag.contents[0])
        rows.append(tag['Row'])

# data from coingecko
ex_data = cg.get_price(ids=symbols, vs_currencies='usd')
forex_data = c.get_rates('USD')

changes = []
for tag in bs_data.find_all('gnm:Cell', {'Col':'3'}):
    if tag['Row'] in rows:
        i = rows.index(tag['Row'])
        new_ex = float(tag.string)
        if symbols[i] in ex_data:
            new_ex = ex_data[symbols[i]]['usd']

        elif symbols[i].upper() in forex_data:
            new_ex = 1 / forex_data[symbols[i].upper()]
        else:
            print('exchange rate not found for: ' + symbols[i])
        changes.append(new_ex - float(tag.string))
        tag.string = str(new_ex)

for tag in bs_data.find_all('gnm:Cell', {'Col':'6'}):
    if tag['Row'] in rows:
        i = rows.index(tag['Row'])
        tag.string = str(changes[i])

file = open(file_path + file_name, 'w')
file.write(str(bs_data))
file.close()
