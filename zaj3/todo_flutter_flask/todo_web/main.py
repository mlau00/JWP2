from flask import Flask, render_template, request, redirect, jsonify, url_for
from sqlalchemy import create_engine, text

from app.models.task_model import TaskModel
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

engine = create_engine('sqlite:///todo_tasks_db')
connection = engine.connect()


@app.route('/tasks')
def show_all_tasks():  # put application's code here
    query = "SELECT * FROM tasks"
    proxy_results = connection.execute(text(query))
    results = proxy_results.fetchall()

    tasks = []

    for result in results:
        id = result[0]
        task = TaskModel(result[1])
        tasks.append(task.serialize(id))

    return jsonify(tasks), 200


@app.route('/add', methods=['POST'])
def add_task():
    if request.method == 'POST':
        data = request.get_json()
        task_name = data['name']
        query = f"INSERT INTO tasks (name) VALUES ('{task_name}')"
        connection.execute(text(query))
        connection.commit()

        return jsonify({'message': 'Task added'}, {'status': '200'}), 200


@app.route('/delete', methods=['POST'])
def delete_task():
    if request.method == 'POST':
        data = request.get_json()
        task_id = data['id']
        query = f"DELETE FROM tasks WHERE id={task_id}"
        connection.execute(text(query))
        connection.commit()

        return jsonify({'message': 'Task deleted', 'status': '200'}), 200


@app.route('/update', methods=['POST'])
def update_task():
    if request.method == 'POST':
        data = request.get_json()
        task_id = data['id']
        task_name = data['name']
        query = f"UPDATE tasks SET name='{task_name}' WHERE id={task_id}"

        connection.execute(text(query))
        connection.commit()

        return jsonify({'message': 'Task updated', 'status': '200'}), 200


if __name__ == '__main__':
    app.run()
