import pymongo
import time
from sqlalchemy import create_engine
import logging
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
import os

#use some delay to wait for the monodb container setting up the db
time.sleep(10)

#connect to mongodb as defined in get_tweets_streaming.py
client = pymongo.MongoClient("mongodb")
db = client.tweets_stream
collection = db.tweet_stream_data
entries = collection.find()

#database in mongo: tweets_stream
#       collection: tweet_stream_data
#get all tweets (all stored data) in collection 'tweet_stream_data'
#db.tweet_stream_data.find()
#get field 'text' of collection 'tweet_stream_data'... does not work with find
#db.tweet_stream_data.findOne()['text']
#find({},{}).... filter everyting by first {} and show "columns" {key_x: 1= ja, key_y: 0=nein}
#db.tweet_stream_data.find({},{text: 1,_id:0})

#connect to psql
password_psql = os.getenv('POSTGRES_PASSWORD') 
    #score = 1.0 #placeholder value
pg_db = create_engine(f'postgresql://postgres:{password_psql}@postgresdb:5432/analyzed_tweets', echo=True)

#create table
pg_db.execute('''
        CREATE TABLE IF NOT EXISTS analyzed_tweets_table (
        text VARCHAR(500),
        sentiment NUMERIC
);
''')

#sentiment analyis
s = SentimentIntensityAnalyzer()

#insert data
#entries = collection.find()
for item in entries:
    #sentiment analysis of single tweets
    sentiment = s.polarity_scores(item['text'])
    score = sentiment['compound']
    text = item['text']
    query = "INSERT INTO analyzed_tweets_table VALUES (%s,%s);"
    pg_db.execute(query, (text, score))

#TODO: clean the data, transform the data 
#idea: maybe set MaxTweetsListener a timeframe? 

