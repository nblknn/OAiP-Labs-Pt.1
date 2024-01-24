#include <iostream>
#include <fstream>
#include <set>
using namespace std;

const set<int> X1 {1, 2, 3, 4, 5, 6};
const set<int> X2 {1, 3, 4, 5, 6};

void outputSet(set<int> setOfNum, string setName) {
    cout << setName << "{ ";
    for (int i : setOfNum)
        cout << i << " ";
    cout << "}" << endl;
}

set<int> findSumOfSets() {
    set<int> y;
    y.insert(X1.begin(), X1.end());
    y.insert(X2.begin(), X2.end());
    return y;
}

set<int> findSubSet(set<int> y) {
    set<int> y1;
    for (int i : y)
        if ((i % 2 == 0) && (i % 3 == 0))
            y1.insert(i);
    return y1;
}

void writeCondition() {
    cout << "Данная программа формирует объединение двух множеств, и выделяет из него подмножество четных чисел, кратных 3." << endl;
    cout << "Даны множества:" << endl;
    outputSet(X1, "X1: ");
    outputSet(X2, "X2: ");
}

int checkChoiceInput() {
    int num = 0;
    bool isIncorrect;
    do {
        isIncorrect = false;
        cout << "Если Вы хотите вывести результат в консоль, введите 0. Если в файл, введите 1." << endl;
        cin >> num;
        if (cin.get() != '\n') {
            cin.clear();
            while (cin.get() != '\n');
            isIncorrect = true;
            cout << "Введенные данные не соответствуют условию. Повторите попытку." << endl;
        }
        if ((!isIncorrect) && (num != 0) && (num != 1)) {
            isIncorrect = true;
            cout << "Введенные данные не соответствуют условию. Повторите попытку." << endl;
        }
    } while (isIncorrect);
    return num;
}

string checkFilePath() {
    string path;
    bool isIncorrect;
    do {
        isIncorrect = false;
        cout << "Введите путь к файлу, в который нужно записать результат." << endl;
        cin >> path;
        ofstream fout(path);
        fout.open(path);
        if (!fout.is_open()) {
            cout << "Произошла ошибка. Повторите попытку." << endl;
            isIncorrect = true;
        }
        if ((!isIncorrect) && (path.substr(path.size() - 4) != ".txt")) {
            cout << "Введенный Вами файл не является текстовым. Повторите попытку." << endl;
            isIncorrect = true;
        }
        fout.close();
    } while (isIncorrect);
    return path;
}

void writeSetIntoFile(set<int> setOfNum, string setName, ofstream& fout) {
    fout << setName << "{ ";
    for (int i : setOfNum)
        fout << i << " ";
    fout << "}" << endl;
}

void writeResultIntoFile(set<int> y, set<int> y1, string path) {
    bool isIncorrect;
    do {
        isIncorrect = false;
        ofstream fout(path);
        try {
            writeSetIntoFile(y, "Полученное объединение множеств: ", fout);
            writeSetIntoFile(y1, "Полученное подмножество: ", fout);
        }
        catch (string errorMessage) {
            cout << "Произошла ошибка. Повторите попытку." << endl;
            isIncorrect = true;
        }
        fout.close();
        if (isIncorrect)
            path = checkFilePath();
    } while (isIncorrect);
    cout << "Результат записан.";
}

int main()
{
    setlocale(LC_ALL, "Russian");
    int choice = 0;
    string foutPath;
    set<int> y;
    set<int> y1;
    writeCondition();
    y = findSumOfSets();
    y1 = findSubSet(y);
    choice = checkChoiceInput();
    if (choice == 0) {
        outputSet(y, "Полученное объединение множеств: ");
        outputSet(y1, "Полученное подмножество: ");
    }
    else {
        foutPath = checkFilePath();
        writeResultIntoFile(y, y1, foutPath);
    }
    return 0;
}