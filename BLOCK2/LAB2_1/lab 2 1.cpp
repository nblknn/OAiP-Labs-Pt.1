#include <iostream>
using namespace std;

const int MINMARK = 0;
const int MAXMARK = 10;
const int MIN = 5;
const int MAX = 15;
const int MINSUCCESS = 3;

int main() {
    setlocale(LC_ALL, "Russian");
    int num = 0;
    bool isIncorrect;
    bool isSuccessful;
    cout << "Данная программа определяет, является ли студент неуспевающим." << endl;
    cout << "Неуспевающим считается студент, имеющий оценки ниже 4." << endl;
    do {
        isIncorrect = false;
        cout << "Введите количество оценок студента (от 5 до 15)." << endl;
        cin >> num;
        if (cin.get() != '\n') {
            cin.clear();
            while (cin.get() != '\n');
            isIncorrect = true;
            cout << "Введенные данные не соответствуют условию. Повторите попытку." << endl;
        }
        if (!isIncorrect && (num < MIN || num > MAX)) {
            isIncorrect = true;
            cout << "Введенные данные не соответствуют условию. Повторите попытку." << endl;
        }
    } while (isIncorrect);
    int* marks = new int[num];
    cout << "Введите оценки студента от 0 до 10." << endl;
    for (int i = 0; i < num; i++)
        do {
            isIncorrect = false;
            cout << "Введите " << i + 1 << " оценку студента: ";
            cin >> marks[i];
            if (!isIncorrect && cin.get() != '\n') {
                cin.clear();
                while (cin.get() != '\n');
                isIncorrect = true;
                cout << "Введенные данные не соответствуют условию. Повторите попытку." << endl;
            }
            if (!isIncorrect && (marks[i] < MINMARK || marks[i] > MAXMARK)) {
                isIncorrect = true;
                cout << "Введенные данные не соответствуют условию. Повторите попытку." << endl;
            }
        } while (isIncorrect);
    isSuccessful = true;
    int i = 0;
    while (isSuccessful && (i < num)) {
        isSuccessful = (marks[i] > MINSUCCESS);
        i++;
    }
    if (isSuccessful)
        cout << "Студент является успевающим." << endl;
    else
        cout << "Студент является неуспевающим." << endl;
    delete[] marks;
    return 0;
}
