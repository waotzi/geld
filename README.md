# Simple Crypto Managment Tool
### prerequisits
 - gnumeric
 - python3
 - shell

## pip dependencies
```
pip install beautifulsoup4
pip install pycoingecko
 ```

# User Manual
the `money.xml` file is designed to automatically calculate the value of each crypto asset you have and using the python script you can update this file automatically to have current exchange rate for each crypto asset and the change from the last time you run the python script

The coin column should only contain the coingecko api id of the token you want, anything else will not work.

In the units column you should type in how much you have of the coin.

The ex rate coulmn is automatically updated with the python script. it will only work if there is a value present, so if you make a new row, add a random number value such as 0.

the ex change column should also be filled with 0 if you have made a new row, otherwise it will also update automatically.

for convenience i recommend simply runnig the `./run.sh` script, this will run the python script and then launch the money.xml file with gnumeric

![screenshot](screen.jpg)
