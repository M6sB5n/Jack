from tweepy import OAuthHandler, Cursor, API
from tweepy.streaming import StreamListener
import logging
import pymongo

#connect to database
client = pymongo.MongoClient("mongodb")
db = client.tweets
collection = db.tweet_data

def authenticate():
    """Function for handling Twitter Authentication.:

       1. API_KEY
       2. API_SECRET
     
    """
    auth = OAuthHandler(config.API_KEY, config.API_SECRET)
    return auth

if __name__ == '__main__':
    auth = authenticate()
    api = API(auth)

    cursor = Cursor(
        api.user_timeline,
        id = 'garfield',
        tweet_mode = 'extended'
    )

    for status in cursor.items(10):
        #debugging: for finding status.()-keys:
        #for key,value in status.__dict__.items():  #same thing as `vars(status)`
        #    print(key)
        text = status.full_text

        # take extended tweets into account
        # TODO: CHECK
        if 'extended_tweet' in dir(status):
            text =  status.extended_tweet.full_text
        if 'retweeted_status' in dir(status):
            r = status.retweeted_status
            if 'extended_tweet' in dir(r):
                text =  r.extended_tweet.full_text

        tweet = {
            'text': text,
            'username': status.user.screen_name,
            'followers_count': status.user.followers_count,
            'created at': status.created_at
        }
        #print(tweet['text'])
        collection.insert_one(tweet)


