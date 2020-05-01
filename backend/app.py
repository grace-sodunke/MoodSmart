from keras.preprocessing.text import Tokenizer
from keras.preprocessing.sequence import pad_sequences

from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.svm import SVC
from sklearn.metrics import accuracy_score, classification_report



# classify_tweet("Hi @everyone, I am very sad today and I want to give up #depression") #example of input string from app

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
