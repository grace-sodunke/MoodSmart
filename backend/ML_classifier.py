import numpy as np
import pandas as pd
import os
import matplotlib.pyplot as plt
import re

import nltk
from nltk.corpus import stopwords
from nltk import PorterStemmer


import preprocessor as p

from gensim.models import KeyedVectors

from keras.preprocessing.text import Tokenizer
from keras.preprocessing.sequence import pad_sequences
from keras.layers import Dense, Input, LSTM, Embedding, Dropout, Activation
from keras.layers import Bidirectional, GlobalMaxPool1D
from keras.models import Model

from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.cluster import KMeans
from sklearn.svm import SVC
from sklearn.metrics import accuracy_score, classification_report
"""
data_dir = "C:/Users/User/PycharmProjects/MoodSmartML/input"

Contents of input folder
depressive-tweets-processed  googles-trained-word2vec-model-in-python
english-contractions	     sentiment140
"""

"""
encoding = 'ISO-8859-1'
col_names = ['target', 'id', 'date', 'flag', 'user', 'text']
dataset = pd.read_csv(os.path.join(data_dir, 'sentiment140/training.1600000.processed.noemoticon.csv'), encoding=encoding, names=col_names) #import dataset into program
print(dataset.head())#test line

#Take random sample of 8000 tweets
df = dataset.copy().sample(8000, random_state=42)
df["label"] = 0
df = df[['text', 'label']]
df.dropna(inplace=True)
print(df.head())
"""

df = pd.read_csv('./data/sentiment_tweets3.csv')
df.drop(['Unnamed: 0'], axis = 1, inplace = True)
df.info()


"""#Preprocessing data"""
data_dir = "./data"
contractions = pd.read_json(os.path.join(data_dir, 'contractions.json'), typ='series')
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


nltk.download('stopwords')
nltk.download('punkt')

X = clean_tweets([tweet for tweet in df['message']])


"""#Tokenisation"""
MAX_NUM_WORDS = 10000
tokenizer= Tokenizer(num_words=MAX_NUM_WORDS)
tokenizer.fit_on_texts(X)
word_vector = tokenizer.texts_to_sequences(X)
word_index = tokenizer.word_index
vocab_size = len(word_index)
print(vocab_size)   # num of unique tokens
MAX_SEQ_LENGTH = 140
input_tensor = pad_sequences(word_vector, maxlen=MAX_SEQ_LENGTH)
print(input_tensor.shape)


"""#TF-IDF classifier"""
corpus = df['message'].values.astype('U')
tfidf = TfidfVectorizer(max_features = MAX_NUM_WORDS)
tdidf_tensor = tfidf.fit_transform(corpus)
print(tdidf_tensor.shape)


"""#Training baseline model"""
# Split data into training and testing sets
x_train, x_test, y_train, y_test = train_test_split(tdidf_tensor, df['label'].values, test_size=0.3)

baseline_model = SVC()
baseline_model.fit(x_train, y_train)
predictions = baseline_model.predict(x_test)
accuracy_score(y_test, predictions)
print(classification_report(y_test, predictions, digits=5))

#Accuracy so far is 0.99451


"""#Improving our model with LSTM"""
#Word Embedding
EMBEDDING_FILE = os.path.join(data_dir, 'GoogleNews-vectors-negative300.bin.gz')
word2vec = KeyedVectors.load_word2vec_format(EMBEDDING_FILE, binary=True)

EMBEDDING_DIM = 300
embedding_matrix = np.zeros((MAX_NUM_WORDS, EMBEDDING_DIM))

for (word, idx) in word_index.items():
    if word in word2vec.vocab and idx < MAX_NUM_WORDS:
        embedding_matrix[idx] = word2vec.word_vec(word)

"""#Training our deep neural network"""
inp = Input(shape=(MAX_SEQ_LENGTH,))
x = Embedding(MAX_NUM_WORDS, EMBEDDING_DIM, weights=[embedding_matrix])(inp)
x = Bidirectional(LSTM(100, return_sequences=True, dropout=0.25, recurrent_dropout=0.1))(x)
x = GlobalMaxPool1D()(x)
x = Dense(100, activation="relu")(x)
x = Dropout(0.25)(x)
x = Dense(1, activation="sigmoid")(x)

# Compile the model
model = Model(inputs=inp, outputs=x)
model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])

# Split data into training and testing sets
x_train, x_test, y_train, y_test = train_test_split(input_tensor, df['label'].values, test_size=0.3)

model.fit(x_train, y_train, batch_size=16, epochs=2)

preds = model.predict(x_test)
preds = np.round(preds.flatten())
print(classification_report(y_test, preds, digits=5))