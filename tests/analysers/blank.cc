
#include <iostream>
using namespace std;

class MyClass
{
public:
    // Ignoring the rule: cppcoreguidelines-explicit-virtual-functions
    virtual void printHello()
    {
        cout << "Hello from base class!" << endl;
    }
};

int main()
{
    MyClass obj;
    obj.printHello(); // This will violate cppcoreguidelines-explicit-virtual-functions

    return 0;
}
