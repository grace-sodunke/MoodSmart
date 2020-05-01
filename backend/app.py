import json
import os
import preprocessor
import re

from flask import Flask
from flask import request

from keras.preprocessing.text import tokenizer_from_json
from keras.preprocessing.sequence import pad_sequences
from keras.models import load_model

MAX_SEQ_LENGTH = 140
MODEL_DIR = '../models'
TOKENIZER_FILE = 'tokenizer.json'
CONTRACTIONS_FILE = 'contractions.json'
MODEL_FILE = 'modelGPU.h5'

BAD_SYMBOLS_RE = re.compile('[^0-9a-z #+_]')


# Define functions to perform the cleaning and classifications
def load_contractions(path_to_file):
    # Read file
    with open(path_to_file, 'r') as file:
        contra = json.load(file)
    # Convert everything to lowercase
    contra = {key.lower(): value.lower() for key, value in contra.items()}
    # Compile list of contractions
    c_r = re.compile('(%s)' % '|'.join(contra.keys()))
    return contra, c_r


contractions, c_re = load_contractions(os.path.join(MODEL_DIR, CONTRACTIONS_FILE))


def expand_contractions(text):
    def replace(match):
        return contractions[match.group(0)]
    return c_re.sub(replace, text)


def clean_tweet(tweet):
    # Remove URLs and mentions
    tweet = preprocessor.clean(tweet)
    # Remove bad symbols
    tweet = BAD_SYMBOLS_RE.sub(' ', tweet)
    # Expand contractions
    tweet = expand_contractions(tweet)
    # Remove punctuation
    tweet = ' '.join(re.sub("([^0-9A-Za-z \t])", " ", tweet).split())
    # For RNN models such as LSTM we do not remove stopwords
    return tweet


def load_tokenizer(path_to_file):
    with open(path_to_file, 'r') as file:
        tok = tokenizer_from_json(json.load(file))
    return tok


tokenizer = load_tokenizer(os.path.join(MODEL_DIR, TOKENIZER_FILE))

model = load_model(os.path.join(MODEL_DIR, MODEL_FILE))


app = Flask(__name__)


@app.route('/')
def index():
    return '<h1>Welcome to MoodSmart API</h1>'


@app.route('/predict', methods=['POST'])
def classify_tweet():
    # Receive tweet from request
    data = request.get_json(force=True)
    tweet = data['tweet']

    # Compute the prediction
    tweet = clean_tweet(tweet)
    sequence = tokenizer.texts_to_sequences([tweet])
    padded = pad_sequences(sequence, maxlen=MAX_SEQ_LENGTH)
    prediction = model.predict(padded)

    # Package the response into a JSON
    response = {'prediction': float(prediction[0][0])}

    return json.dumps(response)


if __name__ == '__main__':
    app.debug = True
    app.run(host='127.0.0.1', port=5000)

