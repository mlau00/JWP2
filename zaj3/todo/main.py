from flask import Flask, render_template, request, redirect, jsonify, url_for
from sqlalchemy import create_engine, text

from app.models.task_model import TaskModel

app = Flask(__name__)

engine = create_engine('sqlite:///todo_tasks_db')
connection = engine.connect()


@app.route('/')
def show_all_tasks():  # put application's code here
    query = "SELECT * FROM tasks"
    proxy_results = connection.execute(text(query))
    results = proxy_results.fetchall()

    tasks = []

    for result in results:
        id = result[0]
        task = TaskModel(result[1])
        tasks.append(task.serialize(id))

    return render_template('tasks_list.html', tasks=tasks)
    # return jsonify(tasks), 200


@app.route('/add_task', methods=['GET', 'POST'])
def add_task():
    if request.method == 'GET':
        return render_template('add_task.html')
    elif request.method == 'POST':
        task_name = request.form['task_name']
        query = f"INSERT INTO tasks (name) values ('{task_name}')"
        res = connection.execute(text(query))
        connection.commit()

        return redirect(url_for('show_all_tasks'))
    else:
        return 'Method not allowed!!'


def get_task_name(task_id):
    query = f"SELECT * FROM tasks WHERE id = {task_id}"
    proxy_result = connection.execute(text(query))
    result = proxy_result.fetchall()
    task_name = result[0].name
    print(task_name)

    return task_name


@app.route('/edit_task/<task_id>', methods=['GET', 'POST'])
def edit_task(task_id):
    if request.method == 'GET':
        task_name = get_task_name(task_id)
        return render_template('edit_task.html', task_id=task_id, task_name=task_name)
    elif request.method == 'POST':
        task_name = request.form['task_name']
        query = f"UPDATE tasks SET name = '{task_name}' WHERE id = {task_id}"
        res = connection.execute(text(query))
        connection.commit()

        return redirect(url_for('show_all_tasks'))
    else:
        return 'Method not allowed!!'


@app.route('/delete/<task_id>')
def delete_task(task_id):
    query = f"DELETE FROM tasks WHERE id = {task_id}"
    res = connection.execute(text(query))
    connection.commit()

    if res.rowcount > 0:
        return redirect(url_for("show_all_tasks"))
    else:
        return jsonify('Zadanie nie istnieje')


if __name__ == '__main__':
    app.run()
