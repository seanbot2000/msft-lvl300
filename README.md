# msft-lvl300
This is the publicly available repo for MS Learn Level 300 workshop

**Prerequisites:**
- Azure Subscription
  - https://portal.azure.com/
- Redis Insight
  - https://redis.com/redis-enterprise/redis-insight/

**Expected Infrastructure:**
- Cluster Group for AA
- Redis Cluster w/Search + JSON
  
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
- **Extended Data Types (focus Search + JSON)**
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
  
**Tear Down cluster assets**

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
- Query

