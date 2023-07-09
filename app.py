from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/test', methods=['GET'])

def index():
    d = {}
    d['Query'] = str(request.args['Query'] + ' API Call')
    return jsonify (d)

if __name__ == "__main__":
    app.run(debug=True)