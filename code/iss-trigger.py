import datetime
import logging
import json
import json
import redis
import os

from redis.commands.json.path import Path
from urllib.request import Request, urlopen
from time import time, sleep

def location():
    req = Request("http://api.open-notify.org/iss-now.json")
    response = urlopen(req)

    location = json.loads(response.read())

    print(location['timestamp'])
    print(location['iss_position']['latitude'], location['iss_position']['longitude'])

    return location

def main():
    utc_timestamp = datetime.datetime.utcnow().replace(
        tzinfo=datetime.timezone.utc).isoformat()
        
    iss  = location()
    
    port = 10000
    url = os.getenv('REDIS_ENDPOINT')
    password = os.getenv('REDIS_KEY')

    # Set up Redis connection
    r = redis.StrictRedis(host=url, port=port, password=password)
    
    r.json().set('iss:' + str(iss["timestamp"]) , Path.root_path(), iss)
    r.execute_command('LPUSH iss:keys ' + str(iss["timestamp"]))
    r.execute_command('LTRIM iss:keys 0 9')
    r.execute_command('GEOADD {iss}:location ' + iss['iss_position']['longitude'] + ' ' + iss['iss_position']['latitude'] + ' current')
    r.close()

    print('Python function ran at ' + utc_timestamp)

if __name__=="__main__":
    while True:
      start_time = time()
      main()
      sleep(max(0, 5 * 60 + start_time - time()))
