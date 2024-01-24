#include <iostream>
using namespace std;

int main()
{
    setlocale(LC_ALL, "Russian");
    const int LIMIT{ 12 };
    int n = 0, m = 0, placements = 0;
    bool isIncorrect;

    cout << "Данная программа вычисляет число размещений из N по M." << endl;
    do {
        isIncorrect = false;
        cout << "Условия ввода: N и M натуральные числа, N больше M, N и M меньше 12." << endl;
        cout << "Введите N: ";
        cin >> n;
        if (cin.get() != '\n') {
            cin.clear();
            while (cin.get() != '\n');
            cout << "Введенные данные не соответствуют условию. Повторите попытку." << endl;
            isIncorrect = true;
        }
        else {
            cout << "Введите M: ";
            cin >> m;
        }
        if (!isIncorrect && cin.get() != '\n') {
            cin.clear();
            while (cin.get() != '\n');
            cout << "Введенные данные не соответствуют условию. Повторите попытку." << endl;
            isIncorrect = true;
        }
        if (!isIncorrect &&
            ((n < m + 1) || (n < 0) || (m < 0) || (n > LIMIT) || (m > LIMIT))) {
            cout << "Введенные данные не соответствуют условию. Повторите попытку." << endl;
            isIncorrect = true;
        }
    } while (isIncorrect);
    placements = n;

    int temp = n - m;
    
    for (int i = n - 1; i > temp; i--)
    {
        n--;
        placements = placements * n;
    }

    cout << "Число размещений равно " << placements << endl;

    return 0;
}
