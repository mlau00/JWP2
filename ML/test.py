# pylint: disable=missing-module-docstring
# pylint: disable=missing-class-docstring
# pylint: disable=missing-function-docstring


class MyClass:
     
    """A simple example class"""
    i = 12345

    
    def f(self):
        return 'hello world'
    
    #print(f)
    print(i)
    print()
    
    def my_function():
      print("Hello from a function")

    my_function()
    
    #*kids mean that I do not specify how many arguments will be passed here 
    def my_function2(*kids): 
    
      print("The youngest child is " + kids[2])

    my_function2("Emil", "Tobias", "Linus")
    
    
    def my_function3( country = "Norway"):
      print("I am from " + country)

    my_function3("Sweden")
    my_function3("India")
    my_function3()
    my_function3("Brazil")
    
