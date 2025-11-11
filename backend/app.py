from flask import Flask, jsonify, request
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
import os

app = Flask(__name__)
CORS(app)

# ---------------- DATABASE SETUP ----------------
# Create a SQLite DB file inside the backend folder
BASE_DIR = os.path.abspath(os.path.dirname(__file__))
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + os.path.join(BASE_DIR, 'data.db')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# ---------------- MODEL ----------------
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)

# Create the database tables (only the first time)
with app.app_context():
    db.create_all()

# ---------------- ROUTES ----------------
@app.route('/api/hello', methods=['GET'])
def hello():
    return jsonify({"message": "Hello from Flask backend with SQLite!"})

@app.route('/api/data', methods=['POST'])
def receive_data():
    data = request.get_json()
    name = data.get('name')

    # Save the name in the database
    new_user = User(name=name)
    db.session.add(new_user)
    db.session.commit()

    return jsonify({"reply": f"Hey {name}, Flask stored your data in SQLite!"})

@app.route('/api/users', methods=['GET'])
def get_users():
    users = User.query.all()
    user_list = [{"id": u.id, "name": u.name} for u in users]
    return jsonify(user_list)

if __name__ == '__main__':
    app.run(debug=True)
