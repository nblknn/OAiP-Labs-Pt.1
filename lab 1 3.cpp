#include <iostream>
using namespace std;

int main()
{
    setlocale(LC_ALL, "Russian");
    int fstNum = 0;
    int secNum = 0;
    int fstDen = 0;
    int secDen = 0;
    int sumNum = 0;
    int sumDen = 0;
    int fstNod = 0;
    int secNod = 0;
    int nod = 0;
    bool isIncorrect;
    cout << "Данная программа вычисляет сумму двух рациональных дробей." << endl;
    do{
        isIncorrect = false;
        cout << "Условие ввода: числители и знаменатели дробей являются натуральными числами." << endl;
        cout << "Введите первую дробь: ";
        cin >> fstNum >> fstDen;
        if (cin.get() != '\n') {
            cin.clear();
            while (cin.get() != '\n');
            isIncorrect = true;
            cout << "Введенные данные не соответствуют условию. Повторите попытку." << endl;
        }
        else {
            cout << "Введите вторую дробь: ";
            cin >> secNum >> secDen;
            if (!isIncorrect && cin.get() != '\n') {
                cin.clear();
                while (cin.get() != '\n');
                isIncorrect = true;
                cout << "Введенные данные не соответствуют условию. Повторите попытку." << endl;
            }
        }
        if (!isIncorrect && ((fstDen < 0) || (secDen < 0) || (fstNum < 0) || (secNum < 0))) {
            isIncorrect = true;
            cout << "Введенные данные не соответствуют условию. Повторите попытку." << endl;
        }
    } while (isIncorrect);
    cout << fstNum << "/" << fstDen << " + " << secNum << "/" << secDen << " = ";
    fstNum *= secDen;
    secNum *= fstDen;
    sumNum = fstNum + secNum;
    sumDen = fstDen * secDen;
    fstNod = sumDen;
    secNod = sumNum;

    while ((fstNod != 0) && (secNod != 0))
    {
        if (fstNod > secNod)
            fstNod %= secNod;
        else
            secNod %= fstNod;
    }
    nod = fstNod + secNod;
    cout << sumNum << "/" << sumDen << endl;
    sumNum /= nod;
    sumDen /= nod;
    cout << "Полученный результат: " << sumNum << "/" << sumDen;

    return 0;
}