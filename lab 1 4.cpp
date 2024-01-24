#include <iostream>
using namespace std;

const int MIN = 3;
const int MAX = 10;

int main()
{
    setlocale(LC_ALL, "Russian");
    int size = 0;
    bool isIncorrect;
    cout << "Данная программа формирует 'сглаженный' массив из введенного." << endl;
    do {
        isIncorrect = false;
        cout << "Введите количество элементов массива от 3 до 10." << endl;
        cin >> size;
        if (cin.get() != '\n') {
            cin.clear();
            while (cin.get() != '\n');
            cout << "Введенные данные не соответствуют условию. Повторите попытку." << endl;
            isIncorrect = true;
        }
        if (!isIncorrect && (size < MIN || size > MAX)) {
            isIncorrect = true;
            cout << "Введенные данные не соответствуют условию. Повторите попытку." << endl;
        }
    } while (isIncorrect);
    int *arr = new int[size];
    float* arrSgl = new float[size];
    cout << "Введите элементы массива." << endl;

    for (int i=1; i<size+1; i++)
    {
        do{
            isIncorrect = false;
            cout << "Введите " << i << " элемент массива: ";
            cin >> arr[i - 1];
            if (!isIncorrect && cin.get() != '\n') {
                cin.clear();
                while (cin.get() != '\n');
                isIncorrect = true;
                cout << "Введенные данные не соответствуют условию. Повторите попытку." << endl;
            }
        } while (isIncorrect);
    }

    arrSgl[0] = arr[0];
    arrSgl[size-1] = arr[size-1];

    for (int i=1; i<=(size-2); i++)
        arrSgl[i]  = (arr[i - 1] + arr[i] + arr[i + 1]) / 3.0;

    cout << "Вывод сглаженного массива: ";

    for (int i = 0; i < size; i++)
        printf ("%.2f ", arrSgl[i]);

    return 0;
}