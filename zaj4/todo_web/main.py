from flask import Flask, render_template, request, redirect, jsonify, url_for
from sqlalchemy import create_engine, text

from app_elements.database import db
from app_elements.models.response_body import ResponseBody
from app_elements.models.task_model import TaskModel
from flask_cors import CORS

from app_elements.models.user_model import UserModel

app = Flask(__name__)
CORS(app)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///todo_tasks_db'
db.init_app(app)

# engine = create_engine('sqlite:///todo_tasks_db')
# connection = engine.connect()

with app.app_context():
    db.create_all()


@app.route('/tasks')
def show_all_tasks():
    # query = "SELECT * FROM tasks"
    # proxy_results = connection.execute(text(query))
    # results = proxy_results.fetchall()
    tasks = db.session.query(TaskModel).all()
    tasks_json = []

    for task in tasks:
        tasks_json.append(task.serialize())

    return jsonify(
        ResponseBody(200, "Lista zadań", tasks_json).serialize()
    ), 200


@app.route('/tasks/add', methods=['POST'])
def add_task():
    if request.method == 'POST':
        data = request.get_json()
        task_name = data['name']

        task = TaskModel(name=task_name)
        db.session.add(task)
        db.session.commit()
        print(task.id)

    return jsonify({'message': 'Task added'}, {'status': '200'}), 200


@app.route('/tasks/delete', methods=['POST'])
def delete_task():
    if request.method == 'POST':
        data = request.get_json()
        task_id = data['id']

        db.session.delete(TaskModel.query.filter_by(id=task_id).first())

        db.session.commit()

        return jsonify(ResponseBody(200, "Zadanie usunięte", True).serialize()), 200


@app.route('/tasks/update', methods=['POST'])
def update_task():
    if request.method == 'POST':
        data = request.get_json()
        task_id = data['id']
        task_name = data['name']

        task = db.session.query(TaskModel).filter_by(id=task_id).first()
        task.name = task_name
        updated_task = task.serialize()
        db.session.commit()
        return jsonify(ResponseBody(200, "Zadanie zmienione", updated_task).serialize()), 200


@app.route('/users/login', methods=['POST'])
def login_user():
    if request.method == 'POST':
        data = request.get_json()
        login = data['login']
        password = data['password']

        user = db.session.query(UserModel).filter_by(user_login=login, user_password=password).first()

        return jsonify(ResponseBody(200, "Zalogowany", user.serialize()).serialize()), 200


@app.route('/users/create', methods=['POST'])
def create_user():
    if request.method == 'POST':
        data = request.get_json()
        login = data['login']
        password = data['password']
        user = UserModel(user_login=login, user_password=password)
        db.session.add(user)
        db.session.commit()
        print(user.user_id)

        return jsonify(ResponseBody(200, "Użytkownik utworzony", user.serialize()).serialize()), 200


if __name__ == '__main__':
    app.run()
