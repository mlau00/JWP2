from flask import Flask, jsonify, request, render_template, redirect, url_for
from sqlalchemy import create_engine, text

from app.models.teacher_model import Teacher

app = Flask(__name__)

engine = create_engine('sqlite:///teachers_db.sqlite')
connection = engine.connect()


#
# @app.route('/')
# def hello_world():  # put application's code here
#     if request.method == 'POST':
#         username = request.form['name']
#         subject = request.form['subject']
#         time = request.form['time']
#         print(username, subject, time)
#
#     return render_template('add_teacher.html')


@app.route('/teachers')
def teachers_list():
    query = 'Select * from teachers'
    proxy_result = connection.execute(text(query))
    results = proxy_result.fetchall()

    teachers_list = []

    for result in results:
        id = result[0]
        teacher = Teacher(result[1], result[2], result[3])
        teachers_list.append(teacher.serialize(id))

    # return jsonify(teachers_list), 200
    return render_template('list_teachers.html', teachers=teachers_list)


@app.route('/teachers/create', methods=['GET', 'POST'])
def create_teacher():
    if request.method == 'POST':
        data = request.form
        query = f"INSERT INTO teachers (name, subject, time) VALUES ('{data['name']}', '{data['subject']}', '{data['time']}')"

        connection.execute(text(query))
        connection.commit()

        return redirect(url_for('teachers_list'))

    return render_template('add_teacher.html')


# def create_teacher():
#     data = request.get_json()
#     query = f"INSERT INTO teachers (name, subject, time) values ('{data['name']}', '{data['subject']}', '{data['time']}')"
#     res = connection.execute(text(query))
#     connection.commit()
#
#     return jsonify('Nauczyciel dodany!'), 200


@app.route('/teachers/delete', methods=['GET', 'POST'])
def delete_teacher():
    if request.method == 'POST':
        data = request.form
        query = f"DELETE FROM teachers WHERE id = {data['id']}"
        res = connection.execute(text(query))
        print(res.rowcount)
        connection.commit()

        if res.rowcount == 0:
            return render_template('delete_teacher.html')
        else:
            return redirect(url_for('teachers_list'))

    return render_template('delete_teacher.html')


# @app.route('/teachers/delete/<id>', methods=['POST'])
# def delete_teacher(id):
#     query = f"DELETE FROM teachers WHERE id = {id}"
#     res = connection.execute(text(query))
#     print(res.rowcount)
#     connection.commit()
#
#     if res.rowcount == 0:
#         return jsonify('Nauczyciel nie został znaleziony'), 400
#     else:
#         return jsonify('Nauczyciel usunięty!'), 200


if __name__ == '__main__':
    app.run()
