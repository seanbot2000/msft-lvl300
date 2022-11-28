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
- Seed Data
  - https://developer.redis.com/explore/redisinsight/redisearch/
  - https://www.govtrack.us/api/v2/role?current=true&role_type=senator
  
Redis Application Workshop Outline
------------------------------------------

- **Level Set**
  - https://docs.google.com/presentation/d/1QAq8o_e3Oqgz1Fgp7cyRDi1OebEuC2f5c2j2nRDSVPw/edit?usp=sharing
- **Portal Tour/Demo**
  - https://portal.azure.com/
- **Workshop Activity**
	- Stand up ACRE (AA)
    	- https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/quickstart-create-redis-enterprise
    	- https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-how-to-active-geo-replication
- **Extended Data Types (focus Search + JSON) **
  - https://docs.google.com/presentation/d/1V7IECKTPcNQnIrktSxSy7FxlawW4zIHw/edit?usp=sharing&ouid=102108161234886405976&rtpof=true&sd=true
- **Workshop Activity**
	- Access Cluster
		- Connect to own cluster w/Redis Insight 
    		- Download and install https://redis.com/redis-enterprise/redis-insight/
        		- Get endpoints and keys
        		- Set up cluster connection in Redis Insight
			- Set exercise
			- Access both clusters to see AA
		- Query Exercises
			- RediSearch
			- RedisJSON
- **Write Behind Demo **
	- Demo
	- Share Repo
	- Office Hours Follow Up
- **Tear Down cluster assets**
