import numpy as np
import pandas as pd
import os
import re
import preprocessor as p

import nltk
from nltk.corpus import stopwords

from keras.preprocessing.text import Tokenizer
from keras.preprocessing.sequence import pad_sequences

from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.svm import SVC
from sklearn.metrics import accuracy_score, classification_report

df = pd.read_csv('sentiment_tweets3.csv')
df.drop(['Unnamed: 0'], axis=1, inplace=True)
df.info()

"""#Preprocessing data"""
data_dir = "./input"
contractions = pd.read_json(os.path.join(data_dir, 'english-contractions/contractions.json'), typ='series')
contractions = contractions.to_dict()

c_re = re.compile('(%s)' % '|'.join(contractions.keys()))


def expandContractions(text, c_re=c_re):
    def replace(match):
        return contractions[match.group(0)]

    return c_re.sub(replace, text)


BAD_SYMBOLS_RE = re.compile('[^0-9a-z #+_]')


def clean_tweets(tweets):
    cleaned_tweets = []
    for tweet in tweets:
        tweet = str(tweet)
        tweet = tweet.lower()
        tweet = BAD_SYMBOLS_RE.sub(' ', tweet)
        tweet = p.clean(tweet)
        # expand contraction
        tweet = expandContractions(tweet)
        # remove punctuation
        tweet = ' '.join(re.sub("([^0-9A-Za-z \t])", " ", tweet).split())
        # stop words
        stop_words = set(stopwords.words('english'))
        word_tokens = nltk.word_tokenize(tweet)
        filtered_sentence = [w for w in word_tokens if not w in stop_words]
        tweet = ' '.join(filtered_sentence)

        cleaned_tweets.append(tweet)

    return cleaned_tweets


X = clean_tweets([tweet for tweet in df['message']])

"""#Tokenisation"""
MAX_NUM_WORDS = 10000
tokenizer = Tokenizer(num_words=MAX_NUM_WORDS)
tokenizer.fit_on_texts(X)
word_vector = tokenizer.texts_to_sequences(X)
word_index = tokenizer.word_index
vocab_size = len(word_index)  # num of unique tokens
MAX_SEQ_LENGTH = 140
input_tensor = pad_sequences(word_vector, maxlen=MAX_SEQ_LENGTH)

"""#TF-IDF classifier"""
corpus = df['message'].values.astype('U')
tfidf = TfidfVectorizer(max_features=MAX_NUM_WORDS)
tdidf_tensor = tfidf.fit_transform(corpus)

"""#Training baseline model"""
# Split data into training and testing sets
x_train, x_test, y_train, y_test = train_test_split(tdidf_tensor, df['label'].values, test_size=0.3)

baseline_model = SVC()
baseline_model.fit(x_train, y_train)
predictions = baseline_model.predict(x_test)
accuracy_score(y_test, predictions)
print(classification_report(y_test, predictions, digits=5)) # Accuracy so far is 0.99612

# Testing with input string - needs to be corrected
def classify_tweet(tweet):
    tweet = list(tweet)
    cleaned_tweet = clean_tweets(tweet)
    tweet_sequence = tokenizer.texts_to_sequences(cleaned_tweet)
    input_tweet = pad_sequences(tweet_sequence, maxlen=MAX_NUM_WORDS)# will return error if variable is MAX_SEQ_LENGTH
    tweet_classified = baseline_model.predict(input_tweet)  # returns error
    print(tweet_classified)#prints 0s

classify_tweet("Hi @everyone, I am very sad today and I want to give up #depression") #example of input string from app

"""#Flask framework"""
"""
from flask import Flask
app = Flask(__name__)

@app.route('/')
def index():
  return '<h1>MoodSmart API</h1>'

@app.route('/predict',methods=['POST'])
def predict():
    #prediction = model.predict(tweet)

    return render_template('index.html', prediction_text='Sales should be $ {}'.format(output))

@app.route('/results',methods=['POST'])
def results():
    data = request.get_json(force=True)
    prediction = model.predict([np.array(list(data.values()))])

    output = prediction[0]
    return jsonify(output)

if __name__ == '__main__':
  app.debug = True
  app.run(host='127.0.0.1', port=5000)
"""
