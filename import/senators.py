import json
import argparse
import redis
import re
from redis.commands.json.path import Path

def load():
    f = open('../data/senators.json')
    data = json.load(f)
    f.close()
    return data

def parseState(state):
    abbr = re.search("(?<=\[.\-).+?(?=\])", state)
    print(abbr.group())
    return abbr.group()

def main():
    
    data = load()

    # Parse arguments
    parser = argparse.ArgumentParser()
    parser.add_argument('--host', help='Redis URL', type=str, default='redis://127.0.0.1')
    parser.add_argument('--port', help='Redis Port', type=str, default='10000')
    parser.add_argument('--password', help='Redis Access Key', type=str, default='')
    args = parser.parse_args()
    
    url = args.host
    port = args.port
    password = args.password

    # Set up Redis connection
    r = redis.StrictRedis(host=url, port=port, password=password)

    for d in data['objects']:
        sid = d["person"]["cspanid"]
        party = d["party"]
        state = parseState(d["person"]["name"])
        # delete
        r.delete('senator:' + party + ':' + str(sid))
        r.delete('senator:' + str(sid))
        senator = {
            'enddate': d["enddate"],
            'address': d["extra"]["address"],
            'office': d["extra"]["office"],
            'state' : state,
            'details' : {
                'birthday': d["person"]["birthday"],
                'gender': d["person"]["gender"],
                'name': d["person"]["name"]
            }
        }
        
        r.json().set('senator:' + party + ':' + str(sid), Path.root_path(), senator)

    r.close()
  


if __name__=="__main__":
    main()