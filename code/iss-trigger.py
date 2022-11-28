import datetime
import logging
import json
import json
import redis

from redis.commands.json.path import Path
from urllib.request import Request, urlopen

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
    
    url = 'lvl300.eastus2.redisenterprise.cache.azure.net'
    port = 10000
    password = 'kM6ntsszed57SHRKk1xpiNxNnqCt6gkLhiTglrp8NRU='

    # Set up Redis connection
    r = redis.StrictRedis(host=url, port=port, password=password)
    
    r.json().set('iss:' + str(iss["timestamp"]) , Path.root_path(), iss)

    r.close()

    print('Python function ran at ' + utc_timestamp)

if __name__=="__main__":
    main()
