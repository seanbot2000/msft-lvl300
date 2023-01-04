#!/usr/bin/env bash

#################################
# include the -=magic=-
# you can pass command line args
#
# example:
# to disable simulated typing
# . ../demo-magic.sh -d
#
# pass -h to see all options
#################################
. ~/tools/demo-magic/demo-magic.sh


########################
# Configure the options
########################

#
# speed at which to simulate typing. bigger num = faster
#
TYPE_SPEED=80

#
# custom prompt
#
# see http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html for escape sequences
#
DEMO_PROMPT="${GREEN}➜ ${CYAN}\W ${COLOR_RESET}"

# text color
# DEMO_CMD_COLOR=$BLACK

# hide the evidence
clear

pe "redis-cli -h $REDIS_HOST -p 10000 PING"

# drop indexes
redis-cli -h $REDIS_HOST -p 10000 FT.DROPINDEX idx:beers
redis-cli -h $REDIS_HOST -p 10000 FT.DROPINDEX idx:categories
redis-cli -h $REDIS_HOST -p 10000 FT.DROPINDEX idx:styles
redis-cli -h $REDIS_HOST -p 10000 FT.DROPINDEX idx:breweries

# create indexes
p "FT.CREATE idx:beers ON hash PREFIX 1 "beer:" SCHEMA name TEXT SORTABLE brewery TEXT SORTABLE breweryid NUMERIC SORTABLE category TEXT SORTABLE categoryid NUMERIC SORTABLE style TEXT SORTABLE styleid NUMERIC SORTABLE abv NUMERIC SORTABLE"
redis-cli -h $REDIS_HOST -p 10000 FT.CREATE idx:beers ON hash PREFIX 1 "beer:" SCHEMA name TEXT SORTABLE brewery TEXT SORTABLE breweryid NUMERIC SORTABLE category TEXT SORTABLE categoryid NUMERIC SORTABLE style TEXT SORTABLE styleid NUMERIC SORTABLE abv NUMERIC SORTABLE

p "FT.CREATE idx:categories ON hash PREFIX 1 "beer:" SCHEMA category TEXT PHONETIC dm:en"
redis-cli -h $REDIS_HOST -p 10000 FT.CREATE idx:categories ON hash PREFIX 1 "beer:" SCHEMA category TEXT PHONETIC dm:en

p "FT.CREATE idx:styles ON hash PREFIX 1 "beer:" SCHEMA style TEXT PHONETIC dm:en"
redis-cli -h $REDIS_HOST -p 10000 FT.CREATE idx:styles ON hash PREFIX 1 "beer:" SCHEMA style TEXT PHONETIC dm:en

p "FT.CREATE idx:breweries ON HASH PREFIX 1 "brewery:" SCHEMA name TEXT state TEXT"
redis-cli -h $REDIS_HOST -p 10000 FT.CREATE idx:breweries ON HASH PREFIX 1 "brewery:" SCHEMA name TEXT state TEXT

# search queries on beer
p "FT.SEARCH "idx:beers" IPA"
redis-cli -h $REDIS_HOST -p 10000 FT.SEARCH "idx:beers" IPA

p "FT.SEARCH "idx:categories" "North American Ales""
redis-cli -h $REDIS_HOST -p 10000 FT.SEARCH "idx:categories" "North American Ales"

p "redis-cli FT.SEARCH "idx:styles" Amreica"
redis-cli -h $REDIS_HOST -p 10000 FT.SEARCH "idx:styles" Amreica

p "redis-cli FT.SEARCH "idx:categories" Lager"
redis-cli -h $REDIS_HOST -p 10000 FT.SEARCH "idx:categories" Lager

p "redis-cli FT.SEARCH "idx:styles" "Lager -Amber""
redis-cli -h $REDIS_HOST -p 10000 FT.SEARCH "idx:styles" "Lager -Amber"

p "redis-cli FT.SEARCH idx:beers \"@abv:[4 8]\""
redis-cli -h $REDIS_HOST -p 10000 FT.SEARCH idx:beers "@abv:[4 8]"

p "FT.SEARCH idx:breweries \"@state:Maine | @state:New Hampshire | @state:Massachusetts | @state:Rhode Island | @state:Connecticut | @state:New York | @state:New Jersey | @state: Delaware | @state: Maryland | @state:Virginia | @state:North Carolina | @state:South Carolina | @state: Georgia | @state:Florida\"" 
redis-cli -h $REDIS_HOST -p 10000 FT.SEARCH idx:breweries "@state:Maine | @state:New Hampshire | @state:Massachusetts | @state:Rhode Island | @state:Connecticut | @state:New York | @state:New Jersey | @state: Delaware | @state: Maryland | @state:Virginia | @state:North Carolina | @state:South Carolina | @state: Georgia | @state:Florida"

p "FT.Search idx:beers Pils"
redis-cli -h $REDIS_HOST -p 10000 FT.Search idx:beers Pils

p "FT.Search idx:styles Pilsner"
redis-cli -h $REDIS_HOST -p 10000 FT.Search idx:styles Pilsner

p "FT.SEARCH "idx:beers" "@category:Lager @brewery:Boulevard Brewing Company""
redis-cli -h $REDIS_HOST -p 10000 FT.SEARCH "idx:beers" "@category:Lager @brewery:Boulevard Brewing Company"

p "FT.SEARCH idx:beers \"@abv:[(4 inf]\""
redis-cli -h $REDIS_HOST -p 10000 FT.SEARCH idx:beers "@abv:[(4 inf]"

p "FT.SEARCH idx:beers \"@abv:[6 10] @style:Lager -Amber\""
redis-cli -h $REDIS_HOST -p 10000 FT.SEARCH idx:beers "@abv:[6 10] @style:Lager -Amber"

p "FT.SEARCH idx:breweries \"@country:United States @name:Sn*\""
redis-cli -h $REDIS_HOST -p 10000 FT.SEARCH idx:breweries "@country:United States @name:Sn*"

p "FT.SEARCH idx:breweries \"@state:california\""
redis-cli -h $REDIS_HOST -p 10000 FT.SEARCH idx:breweries "@state:california"

p "FT.SEARCH idx:breweries \"(@state:florida | @state:atlanta | @state:new york)\" RETURN 2 name state"
redis-cli -h $REDIS_HOST -p 10000 FT.SEARCH idx:breweries "(@state:florida | @state:atlanta | @state:new york)" RETURN 2 name state

p "FT.AGGREGATE idx:breweries \"@state:California | @state:Oregon | @state:Washington | @state:Alaska | @state:Hawaii\" GROUPBY 1 @state REDUCE count 0"
redis-cli -h $REDIS_HOST -p 10000 FT.AGGREGATE idx:breweries "@state:California | @state:Oregon | @state:Washington | @state:Alaska | @state:Hawaii" GROUPBY 1 @state REDUCE count 0

# search queries on senators
p "FT.AGGREGATE idx:senators "@gender:(male)" LOAD 2 @birthday @name APPLY 'floor((parsetime("2022-11-29", "%Y-%m-%d") - parsetime(@birthday, "%Y-%m-%d")) / 31556952)' as Age FILTER "@Age > 50""
redis-cli -h $REDIS_HOST -p 10000 FT.AGGREGATE idx:senators "@gender:(male)" LOAD 2 @birthday @name APPLY 'floor((parsetime("2022-11-29", "%Y-%m-%d") - parsetime(@birthday, "%Y-%m-%d")) / 31556952)' as Age FILTER "@Age > 50"

p "FT.AGGREGATE idx:senators "@gender:(female)" LOAD 2 @birthday @name APPLY 'timefmt(parsetime(@birthday, "%Y-%m-%d"), "%Y")' as BirthdayYear FILTER "@BirthdayYear == 1947""
redis-cli -h $REDIS_HOST -p 10000 FT.AGGREGATE idx:senators "@gender:(female)" LOAD 2 @birthday @name APPLY 'timefmt(parsetime(@birthday, "%Y-%m-%d"), "%Y")' as BirthdayYear FILTER "@BirthdayYear == 1947"

p "FT.AGGREGATE idx:senators "@state:(ME) | @state:(NH) | @state:(MA) | @state:(RI) | @state:(CT) | @state:(NY) | @state:(NJ) | @address:(DE) | @state:(MD) | @state:(VA) | @state:(NC) | @state:(SC) | @state:(GA)| @state:(FL)" GROUPBY 1 @state REDUCE count 0"
redis-cli -h $REDIS_HOST -p 10000 FT.AGGREGATE idx:senators "@state:(ME) | @state:(NH) | @state:(MA) | @state:(RI) | @state:(CT) | @state:(NY) | @state:(NJ) | @address:(DE) | @state:(MD) | @state:(VA) | @state:(NC) | @state:(SC) | @state:(GA)| @state:(FL)" GROUPBY 1 @state REDUCE count 0

p "FT.AGGREGATE idx:senators * LOAD 2 @birthday @name APPLY 'timefmt(parsetime(@birthday, "%Y-%m-%d"), "%Y")' as BirthdayYear FILTER "@BirthdayYear >1947 && substr(@name,5,1) != 'F'""
redis-cli -h $REDIS_HOST -p 10000 FT.AGGREGATE idx:senators * LOAD 2 @birthday @name APPLY 'timefmt(parsetime(@birthday, "%Y-%m-%d"), "%Y")' as BirthdayYear FILTER "@BirthdayYear >1947 && substr(@name,5,1) != 'F'"

# JSON indexes
p "FT.CREATE idx:senators ON JSON PREFIX 1 "senator:" SCHEMA $.details.gender AS gender TEXT $.details.birthday AS birthday TAG $.details.name AS name TEXT $.state AS state TEXT"
redis-cli -h $REDIS_HOST -p 10000 FT.CREATE idx:senators ON JSON PREFIX 1 "senator:" SCHEMA $.details.gender AS gender TEXT $.details.birthday AS birthday TAG $.details.name AS name TEXT $.state AS state TEXT

# JSON queries
p "json get senator:Democrat:1023023"
redis-cli -h $REDIS_HOST -p 10000 json get senator:Democrat:1023023

p "json set senator:Democrat:1023023 . {"enddate":"2025-01-03","address":"309 Hart Senate Office Building Washington DC 20510","office":"309 Hart Senate Office Building","state":"MA","details":{"birthday":"1949-06-22","gender":"female","name":"Sen. Elizabeth Warren [D-MA]"}""
redis-cli -h $REDIS_HOST -p 10000 json set senator:Democrat:1023023 . {"enddate":"2025-01-03","address":"309 Hart Senate Office Building Washington DC 20510","office":"309 Hart Senate Office Building","state":"MA","details":{"birthday":"1949-06-22","gender":"female","name":"Sen. Elizabeth Warren [D-MA]"}"

p "json.set senator:Democrat:1023023 $.details.birthday '{\"birthday\":\"1949-06-22\"}'"
redis-cli -h $REDIS_HOST -p 10000 json.set senator:Democrat:1023023 $.details.birthday '{"birthday":"1949-06-22"}'

p "json.get senator:Democrat:1023023 $.details.birthday"
redis-cli -h $REDIS_HOST -p 10000 json.get senator:Democrat:1023023 $.details.birthday

# show a prompt so as not to reveal our true nature after
# the demo has concluded
p ""
