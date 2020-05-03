# MoodSmart
Team 20's application for the 2020 Teens In AI Global COVID Hackathon.

## Environment setup

### Conda environment
MoodSmart was developed in Python 3.7. We highly recommend creating a separate Conda
environment using the YML file provided in the repo and the following command:
```
conda env create -f teensinai.yml
```  
This will automatically install all the required modules. If you don't have a Conda
distribution installed in your system, we recommend installing Miniconda following
the instructions at this page: https://docs.conda.io/en/latest/miniconda.html.

Once the environment is available, activate it as follows:
```
conda activate teensinai
```

### External data needed
To run the training of the deep learning models we use for tweet sentiment
analysis, you will need the following two data sources. 

1. The Sentiment140 data set, containing 1.6 million tweets labelled as either
positive or negative. It can be found at this page on Kaggle:
https://www.kaggle.com/kazanova/sentiment140.

2. A set of pre-trained word embeddings from Google News, also available on
Kaggle: https://www.kaggle.com/umbertogriffo/googles-trained-word2vec-model-in-python.

These files should be downloaded and placed in a subfolder called `data`. They are
only required to train the models. They are not required to use the Flask API.

## Using the MoodSmart Flask API

### Starting the API

To start serving the trained tweet sentiment analysis model, open a Terminal,
navigate to the `backend` subfolder and run:
```
flask run --without-threads
```

The option `--without-threads` is required due to a bug in the latest version of
Keras. This will start the API at the localhost address `127.0.0.1`, port `5000`.

### Querying the API

To query the MoodSmart Flask API, make a `POST` request to the following endpoint:
```
http://127.0.0.1:5000/predict
```
The tweet you want to classify should be sent to the API via JSON in the
following format:
```
{'tweet': "MoodSmart is the coolest thing ever!"} 
```
Upon successful completion of your request, you will receive a JSON response
like this:
```
{'prediction': 0.9921677708625793}
```
This value represents the probability that the tweet is positive according to
the model. Therefore it will be a number between 0 and 1, where 0 indicates
really negative and 1 indicates really positive.