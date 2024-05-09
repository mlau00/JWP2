from flask import Flask, jsonify
from sqlalchemy import create_engine, inspect, text
from sqlalchemy.engine import row

from app.database import db
from app.models.census_model import CensusModel
from app.models.student_model import Student

app = Flask(__name__)

# db.init_app(app)

engine = create_engine('sqlite:///census.sqlite')
connection = engine.connect()

inspector = inspect(engine)
table_names = inspector.get_table_names()
print(table_names)


@app.route('/')
def hello_world():  # put application's code here
    stmt = text('SELECT * FROM census')
    result_proxy = connection.execute(stmt)
    results = result_proxy.fetchall()
    # print(results)

    census_objects = []

    for row in results:
        census_object = CensusModel(
            state=row.state,
            sex=row.sex,
            age=row.age,
            pop2000=row.pop2000,
            pop2008=row.pop2008
        )
        census_objects.append(census_object.serialize())
        # print(census_object.serialize())

    return jsonify(census_objects)
    # return 'Hello World!'


@app.route('/state/<state_var>/sum/<int:year>')
def sum_state(state_var, year):
    if year == 2000 or year == 2008:
        pop_year = f'pop{year}'
        state = f"'{state_var}'"
        stmt = text(f'select sum({pop_year}) as Total from census where state like {state}')
        result_proxy = connection.execute(stmt)
        results = result_proxy.fetchall()

        # for row in results:
        #     value = results[0].Total
        #     print(value)

        value = results[0].Total

        return f'Populacja {state_var} w {year} = {value}'

    return 'Niepoprawne dane stanu lub roku'


@app.route('/state/<state_var>/sum/<int:year>/<sex>')
def sum_state_sex(state_var, year, sex):
    if year == 2000 or year == 2008:
        pop_year = f'pop{year}'
        state = f"'{state_var}'"
        sex = f"'{sex}'"
        stmt = text(f'select sum({pop_year}) as Total from census where state like {state} and sex like {sex}')
        result_proxy = connection.execute(stmt)
        results = result_proxy.fetchall()

        # for row in results:
        #     value = results[0].Total
        #     print(value)

        value = results[0].Total

        return f'Populacja {state_var} w {year} = {value}'

    return 'Niepoprawne dane stanu lub roku'


@app.route('/students/add/<name>/<age>/<grade>')
def add_student(name, age, grade):
    query = text(f"INSERT INTO students (name, age, grade) VALUES ('{name}', {age}, {grade})")
    connection.execute(query)
    connection.commit()
    return 'Student dodany!'


@app.route('/students')
def get_students():
    query = text(f"SELECT * FROM students")
    result_proxy = connection.execute(query)
    results = result_proxy.fetchall()

    students = []
    for row in results:
        student = Student(id=row.id, name=row.name, age=row.age, grade=row.grade)
        students.append(student.serialize())

    return jsonify(students)


@app.route('/students/<id>')
def get_student(id):
    query = text(f"SELECT * FROM students WHERE id = {id}")
    result_proxy = connection.execute(query)
    results = result_proxy.fetchall()
    print(results)
    if len(results) > 0:
        student = Student(id=results[0].id, name=results[0].name, age=results[0].age, grade=results[0].grade)

        return jsonify(student.serialize())

    return 'Niepoprawne dane'


@app.route('/students/delete/<id>')
def delete_student(id):
    query = text(f"DELETE FROM students WHERE id = {id}")
    connection.execute(query)
    connection.commit()

    return 'Student usunięty'


if __name__ == '__main__':
    app.run()
