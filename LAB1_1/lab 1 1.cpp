#include <iostream>
using namespace std;

int main() {
    setlocale(LC_ALL, "Russian");
    int x = 0, y = 0;
    bool isIncorrect;

    cout << "Данная программа определяет, принадлежит ли точка замкнутому множеству D." << endl;
    cout << "Условия принадлежности множеству: X+Y<=1; 2*X-Y<=1; Y>=0." << endl;
        do {
            cout << "Введите координаты точки: X и Y являются целыми числами." << endl;
            isIncorrect = false;
            cin >> x >> y;
            if (cin.get() != '\n') {
                cin.clear();
                while (cin.get() != '\n');
                cout << "Введенные данные не соответствуют условию. Повторите попытку." << endl;
                isIncorrect = true;
            }
        } while (isIncorrect);

    if ((x + y < 2)
        && (2 * x - y < 2)
        && (y > -1))
        cout << "Точка принадлежит множеству D.";
    else
        cout << "Точка не принадлежит множеству D.";

    return 0;
}
