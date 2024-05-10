from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return "Witaj w mojej aplikacji Flask!"
    
    
@app.route('/about')
def about():
    return "Zaprogramowano przez Mateusza Laudana"
    
    
@app.route('/contact')
def contact():
    return  "Email: kontakt@example.com."


if __name__ == '__main__':
    app.run(debug=True)