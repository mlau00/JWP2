import math


class Vector3D:
    def __init__(self, x, y, z):
        self.__x = x  # __x is a hidden value and can be accessed by v = Vector3D(), x = v_Vector3D__x
        self.__y = y
        self.__z = z

    def __str__(self):
        return f'Vector3D({self.__x}, {self.__y}, {self.__z})'

    def get_x(self):
        return self.__x

    def get_y(self):
        return self.__y

    def get_z(self):
        return self.__z

    def set_x(self, x):
        self.__x = x

    def set_y(self, y):
        self.__y = y

    def set_z(self, z):
        self.__z = z

    def norm(self):
        return math.sqrt(self.__x * self.__x + self.__y * self.__y + self.__z * self.__z)

    def __add__(self, a, b):
        return a + b

    def __sub__(self, a, b):
        return a - b

    def dot(self, vector2):
        return self.__x * vector2.get_x() + self.__y * vector2.get_y() + self.__z * vector2.get_z()

    @staticmethod
    def are_orthogonal(v1, v2):
        dot = v1.dot(v2)
        if dot == 0:
            return True
        return False

    def cross(self, v2):
        x3 = self.__y * v2.get_z() - self.__z * v2.get_y()
        y3 = self.__z * v2.get_x() - self.__x * v2.get_z()
        z3 = self.__x * v2.get_y() - self.__y * v2.get_x()
        return Vector3D(x3, y3, z3)


v1 = Vector3D(1, 2, 0)
# a = v1._Vector3D__x  # it is possible to access
print(v1.__str__())
# v1.set_z(10)
print(v1.__str__())
print(v1.norm())
v2 = Vector3D(0, 0, 5)
dot_product = v1.dot(v2)
print(dot_product)

is_orthogonal = Vector3D.are_orthogonal(v1, v2)
print(is_orthogonal)
v3 = v1.cross(v2)
print(v3.__str__())
