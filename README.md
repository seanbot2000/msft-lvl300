# Azure Cache for Redis Hands-on Lab LevelUp Workshop ( L300) 
This is the publicly available repo for MS Learn Level 300 workshop containing presentation links and workshop outline

**Prerequisites:**
- Azure Subscription
  - https://portal.azure.com/
- Redis Insight
  - https://redis.com/redis-enterprise/redis-insight/

**Expected Infrastructure:**
- Cluster Group for AA
- Redis Cluster w/Search + JSON

**Included Code:**
- --code
  - senators.py - loads senator data in JSON format (depends on senators.json in data dir)
  - iss-trigger.py - loads current iss data into redis cluster
  - import.py - leverages the open beer db (https://github.com/redis-developer/redis-datasets/tree/master/redisearch/openbeerdb/beerloader/data)


  
Redis Application Workshop Outline
------------------------------------------

- **Level Set**
  - **Deck:** https://docs.google.com/presentation/d/1QAq8o_e3Oqgz1Fgp7cyRDi1OebEuC2f5c2j2nRDSVPw/edit?usp=sharing
- **Portal Tour/Demo**
  - https://portal.azure.com/
- **Workshop Activity**
	- Stand up ACRE (AA)
    	- https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/quickstart-create-redis-enterprise
    	- https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-how-to-active-geo-replication
- **Extended Data Types (focus on RediSearch + RedisJSON)**
  - (Deck continuing) https://docs.google.com/presentation/d/1QAq8o_e3Oqgz1Fgp7cyRDi1OebEuC2f5c2j2nRDSVPw/edit?usp=sharing

Workshop Activities
--------------------------------------------------
**Access Cluster**
- Connect to own cluster w/Redis Insight 
  		- Download and install https://redis.com/redis-enterprise/redis-insight/
      		- Get endpoints and keys
      		- Set up cluster connection in Redis Insight
	- Set exercise
	- Access both clusters to see AA
  
**Query Exercises**
- Attempt these queries (solutions below)
- RediSearch
    - Get the beers that have IPA in a field
    - Get the beers that are “North American Ales”
    - Get the beers with “Amreica” as the style (note the misspelling)
    - Get the beers that have a category of Lager
    - Get the beers that have a style of Lager but omit Amber
    - Get the beers that have an abv between 4 and 8
    - Find your favorite beer
    - Find all the beers of your favorite category
    - Find all the beers of your favorite category at your favorite brewery
    - Find all of the beers where the ABV is greater than 4.5
    - Find all the beers that have a style of Lager but omit Amber AND have an ABV between 6 and 10


- RedisJSON
    - Male senators over 50 years old
    - Female senators born in 1947
    - Senators with the name that sounds like Frank (Not sure if we want to show phonic search)
    - Total Count of Senators in the East Coast
    - Senators born after 1947 and name not starting with F

**Write Behind Demo**
  - Walkthrough
  
**Lastly**
- Tear Down cluster assets!

Follow up
--------------------------------------------------

- Seed Data
  - https://developer.redis.com/explore/redisinsight/redisearch/
  - https://www.govtrack.us/api/v2/role?current=true&role_type=senator

- Share Repo
- Office Hours Schedule


Solutions
---------------------------------------------------

**RediSearch**
- Get the beers that have IPA in a field:
FT.SEARCH "idx:beers" IPA
- Get the beers that are “North American Ales”:
FT.SEARCH "idx:categories" “North American Ales”
- Get the beers with “Amreica” as the style (note the misspelling):
FT.SEARCH "idx:styles" Amreica
- Get the beers that have a category of Lager:
FT.SEARCH "idx:categories" Lager
- Get the beers that have a style of Lager but omit Amber:
FT.SEARCH "idx:styles" "Lager -Amber"
- Get the beers that have an abv between 4 and 8:
FT.SEARCH idx:beers "@abv:[4 8]"
- Find your favorite beer
FT.Search idx:beers Pils
- Find all the beers of your favorite category
FT.Search idx:styles Pilsner
- Find all the beers of your favorite category at your favorite brewery
FT.SEARCH "idx:beers" "@category:Lager @brewery:Boulevard Brewing Company"
- Find all of the beers where the ABV is greater than 4.5
FT.SEARCH idx:beers "@abv:[(4 inf]"
- Find all the beers that have a style of Lager but omit Amber AND have an ABV between 6 and 10
FT.SEARCH idx:beers "@abv:[6 10] @style:Lager -Amber"

**RedisJSON**
- Find all male senators over 50 years old
FT.SEARCH idx:senators “@gender:(male) 

- Find all female senators born in 1947
FT.SEARCH idx:senators “@gender:(female) 

- Find the Total Count of Senators in the East Coast
 FT.AGGREGATE idx:senators "@state:(ME) | @state:(NH) | @state:(MA) | @state:(RI) | @state:(CT) | @state:(NY) | @state:(NJ) | @address:(DE) | @state:(MD) | @state:(VA) | @state:(NC) | @state:(SC) | @state:(GA)| @state:(FL)" GROUPBY 1 @state REDUCE count 0

- Find all senators born after 1947 and name not starting with F
FT.SEARCH idx:senators “@name:(-F*)


**Bonus**

(Using the index iss:<timestamp> and the list of recent keys iss:keys)

Find the distance travelled between the last 2 5 minute intervals of the ISS
- lrange iss:keys 0 1
- json.get iss:1669747791 $.iss_position.longitude $.iss_position.latitude
- geoadd sgn:iss 66.1868 -1.3440 first
- json.get iss:1669747495 $.iss_position.longitude $.iss_position.latitude
- geoadd sgn:iss 55.3572 13.5664 second
- geodist sgn:iss "first" "second" mi

Find the distance from your location to the most recent location of the ISS
- GEOADD {iss}:sean -94.593530 38.916890 home
- ZUNIONSTORE {iss}:sean:distance 2 {iss}:location {iss}:sean aggregate min
- GEODIST {iss}:sean:distance "home" "current" mi



