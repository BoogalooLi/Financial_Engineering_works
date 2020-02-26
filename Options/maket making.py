# This is a python algorithm using REST API for the market making

import signal
import requests
from time import sleep

# this class definition allows us to print error messages and stop the program when needed
class ApiException(Exception):
    pass

# this signal handler allows for a graceful shutdown when CTRL+C is pressed
def signal_handler(signum, frame):
    global shutdown
    signal.signal(signal.SIGINT, signal.SIG_DFL)
    shutdown = True

# set your API key to authenticate to the RIT client
# this is my own key
API_KEY = {'X-API-Key': 'FAA7IF8C'}
shutdown = False
# other settings for market making algo
SPREAD = 0.01
# this is the volume for each time
BUY_VOLUME = 1200
SELL_VOLUME = 1200

# this helper method returns the current 'tick' of the running case
def get_tick(session):
    resp = session.get('http://localhost:9999/v1/case')
    if resp.status_code == 401:
        raise ApiException('The API key provided in this Python code must match that in the RIT client (please refer to the API hyperlink in the client toolbar and/or the RIT – User Guide – REST API Documentation.pdf)')
    case = resp.json()
    return case['tick']

# this helper method returns the current 'position' of the running case
def get_position(session):
    resp = session.get('http://localhost:9999/v1/securities')
    if resp.status_code == 401:
        raise ApiException('The API key provided in this Python code must match that in the RIT client (please refer to the API hyperlink in the client toolbar and/or the RIT – User Guide – REST API Documentation.pdf)')
    case = resp.json()
    return case[0]['position']

# this helper method returns the last close price for the given security, one tick ago
def ticker_close(session, ticker):
    payload = {'ticker': ticker, 'limit': 1}
    resp = session.get('http://localhost:9999/v1/securities/history', params=payload)
    if resp.status_code == 401:
        raise ApiException('The API key provided in this Python code must match that in the RIT client (please refer to the API hyperlink in the client toolbar and/or the RIT – User Guide – REST API Documentation.pdf)')
    ticker_history = resp.json()
    if ticker_history:
        return ticker_history[0]['close']
    else:
        raise ApiException('Response error. Unexpected JSON response.')

# this helper method submits a pair of limit orders to buy and sell VOLUME of each security, at the last price +/- SPREAD
# this is for normal condition that net position far less than the limit(25000)
def buy_sell(session, to_buy, to_sell, last):
    # TODO (LiYanvchen) may exist more good parameters
    i = 0
    for i in range(4):
        buy_payload = {'ticker': to_buy, 'type': 'LIMIT', 'quantity': BUY_VOLUME, 'action': 'BUY', 'price': last - SPREAD * i}
        sell_payload = {'ticker': to_sell, 'type': 'LIMIT', 'quantity': SELL_VOLUME, 'action': 'SELL', 'price': last + SPREAD * i}
        session.post('http://localhost:9999/v1/orders', params=buy_payload)
        session.post('http://localhost:9999/v1/orders', params=sell_payload)

# this is for alarm condition that net position is near to the limit(25000)
def buy_sell_too_much(session, to_buy, to_sell, last):
    # TODO (LiYanchen) may exist more good parameters
    i = 0
    for i in range(1, 6):
        buy_payload = {'ticker': to_buy, 'type': 'LIMIT', 'quantity': BUY_VOLUME / 10, 'action': 'BUY', 'price': last - SPREAD * i}
        sell_payload = {'ticker': to_sell, 'type': 'LIMIT', 'quantity': SELL_VOLUME * 1.5, 'action': 'SELL', 'price': last + SPREAD * i}
        session.post('http://localhost:9999/v1/orders', params=buy_payload)
        session.post('http://localhost:9999/v1/orders', params=sell_payload)

def buy_sell_too_little(session, to_buy, to_sell, last):
    # TODO (LiYanchen) may exist more good parameters
    i = 0
    for i in range(1, 6):
        buy_payload = {'ticker': to_buy, 'type': 'LIMIT', 'quantity': BUY_VOLUME * 1.5 , 'action': 'BUY', 'price': last - SPREAD * i}
        sell_payload = {'ticker': to_sell, 'type': 'LIMIT', 'quantity': SELL_VOLUME / 10, 'action': 'SELL', 'price': last + SPREAD * i}
        session.post('http://localhost:9999/v1/orders', params=buy_payload)
        session.post('http://localhost:9999/v1/orders', params=sell_payload)

# this helper method gets all the orders of a given type (OPEN/TRANSACTED/CANCELLED)
def get_orders(session, status):
    payload = {'status': status}
    resp = session.get('http://localhost:9999/v1/orders', params=payload)
    if resp.status_code == 401:
        raise ApiException('The API key provided in this Python code must match that in the RIT client (please refer to the API hyperlink in the client toolbar and/or the RIT – User Guide – REST API Documentation.pdf)')
    orders = resp.json()
    return orders

# this is the main method containing the actual market making strategy logic
def main():
    # creates a session to manage connections and requests to the RIT Client
    with requests.Session() as s:
        # add the API key to the session to authenticate during requests
        s.headers.update(API_KEY)
        # get the current time of the case
        tick = get_tick(s)


        # while the time is between 5 and 295, do the following
        # while tick >0 and tick < 300:
        while 1:
            if tick > 0 and tick < 300:
                # get the open order book and ALGO last tick's close price
                orders = get_orders(s, 'OPEN')
                algo_close = ticker_close(s, 'ALGO')

                # get the current position for controlling the position next
                position = get_position(s)

                # check if you have 0 open orders
                if len(orders) == 0 and -20000 <= position <= 20000:
                    # submit a pair of orders and update your order book
                    buy_sell(s, 'ALGO', 'ALGO', algo_close)
                    orders = get_orders(s, 'OPEN')
                    sleep(0.5)
                elif len(orders) == 0 and position <= -20000:
                    # submit a pair of orders and update your order book
                    buy_sell_too_little(s, 'ALGO', 'ALGO', algo_close)
                    orders = get_orders(s, 'OPEN')
                    sleep(0.5)
                elif len(orders) == 0 and -20000 <= position:
                    # submit a pair of orders and update your order book
                    buy_sell_too_much(s, 'ALGO', 'ALGO', algo_close)
                    orders = get_orders(s, 'OPEN')
                    sleep(0.5)

                # check if you don't have a pair of open orders
                # higher the threshold, quicker the cancel and post
                if len(orders) > 0:
                    # submit a POST request to the order cancellation endpoint to cancel all open orders
                    s.post('http://localhost:9999/v1/commands/cancel?all=1')
                    sleep(0.5)

                # refresh the case time. THIS IS IMPORTANT FOR THE WHILE LOOP
                tick = get_tick(s)
            else:
                sleep(0.5)
                tick = get_tick(s)

# this calls the main() method when you type 'python algo2.py' into the command prompt
if __name__ == '__main__':
    signal.signal(signal.SIGINT, signal_handler)
    main()
