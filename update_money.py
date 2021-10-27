#!/bin/python

from bs4 import BeautifulSoup
from pycoingecko import CoinGeckoAPI

cg = CoinGeckoAPI()

with open('money.xml', 'r') as f:
    data = f.read()

file = open('~money.xml', 'w')
file.write(str(data))
file.close()

bs_data = BeautifulSoup(data, "xml")

rows = []
symbols = []
for tag in bs_data.find_all('gnm:Cell', {'Col':'1'}):
    if tag.string != "coin":
        symbols.append(tag.contents[0])
        rows.append(tag['Row'])

ex_data = cg.get_price(ids=symbols, vs_currencies='usd')

changes = []
for tag in bs_data.find_all('gnm:Cell', {'Col':'3'}):
    if tag['Row'] in rows:
        i = rows.index(tag['Row'])
        new_ex = ex_data[symbols[i]]['usd']
        changes.append(new_ex - float(tag.string))

        tag.string = str(new_ex)
        
for tag in bs_data.find_all('gnm:Cell', {'Col':'6'}):
    if tag['Row'] in rows:
        i = rows.index(tag['Row'])
        tag.string = str(changes[i])

file = open('money.xml', 'w')
file.write(str(bs_data))
file.close()
