#include <iostream>
#include <fstream>
#include <locale>
#include <Windows.h>
using namespace std;

const int MINSIZE = 3;
const int MAXSIZE = 20;
const int MINPOINT = 0;
const int MAXPOINT = 100;
const int MAXSURNAMELENGTH = 30;

struct participant {
    string surname;
    int points;
};

void writeCondition() {
    cout << "Данная программа упорядочивает список участников с их баллами на соревновании.\n";
}

bool isNumRangeIncorrect(const int MIN, const int MAX, int num, string errorMessage, bool& isIncorrect) {
    if (!isIncorrect && ((num < MIN) || (num > MAX))) {
        cout << errorMessage;
        isIncorrect = true;
    }
    return isIncorrect;
}

int inputNum(const int MIN, const int MAX, string outputMessage) {
    int num;
    num = 0;
    bool isIncorrect;
    do {
        isIncorrect = false;
        cout << outputMessage;
            cin >> num;
        if (cin.get() != '\n') {
            cin.clear();
            while (cin.get() != '\n');
            isIncorrect = true;
            cout << "Введенное значение должно быть целым числом! Повторите попытку.\n";
        }  
        isIncorrect = isNumRangeIncorrect(MIN, MAX, num, "Диапазон введенного числа не соответствует условию! Повторите попытку.\n", isIncorrect);
    } while (isIncorrect);
    return num;
}

bool isSurnameIncorrect(string surname) {
    bool isIncorrect;
    isIncorrect = false;
    if ((surname == "") || (surname.size() > MAXSURNAMELENGTH)) {
        isIncorrect = true;
        cout << "Фамилия должна содержать от 1 до 30 символов! Повторите попытку.\n";
    }
    return isIncorrect;
}

string inputSurname(int i) {
    string surname;
    do {
        cout << "Введите фамилию " << i + 1 << " участника: ";
        cin >> surname;
    } while (isSurnameIncorrect(surname));
    return surname;
}

participant* getListFromConsole(int listSize) {
    participant* list = new participant[listSize];
    cout << "Условия ввода: фамилия участника должна быть не длиннее 30 символов, количество баллов - целое число от 0 до 100.\n";
    for (int i = 0; i < listSize; i++) {
        list[i].surname = inputSurname(i);
        list[i].points = inputNum(MINPOINT, MAXPOINT, "Введите количество баллов участника: ");
    }
    return list;
}

bool isFileExtIncorrect(string path, bool isIncorrect) {
    if (!isIncorrect) {
        if (path.substr(path.size() - 4) == ".txt")
            isIncorrect = false;
        else
            cout << "Введенный Вами файл не является текстовым. Повторите попытку.\n";
    }
    return isIncorrect;
}

string checkFileInputPath() {
    string path;
    bool isIncorrect;
    do {
        isIncorrect = false;
        cout << "Условия: в первой строке должно быть записано количество участников (от 3 до 20).\n";
        cout << "В строках с участниками сначала записывается фамилия (до 30 символов), затем количество набранных баллов (целое число от 0 до 100).\n";
        cout << "Введите путь к файлу, содержащему список участников.\n";
        cin >> path;
        ifstream fin(path);
        fin.open(path);
        if (!fin.is_open()) {
            cout << "Произошла ошибка. Повторите попытку.\n";
            isIncorrect = true;
        }
        isIncorrect = isFileExtIncorrect(path, isIncorrect);
        fin.close();
    } while (isIncorrect);
    return path;
}

participant* getListFromFile(string path, int& listSize) {
    participant* list = new participant();
    bool isIncorrect;
    do {
        isIncorrect = false;
        ifstream fin(path);
        try {
            fin >> listSize;
            isIncorrect = isNumRangeIncorrect(MINSIZE, MAXSIZE, listSize, "Размер, записанный в файле, не соответствует диапазону. Повторите попытку.", isIncorrect);
            list = new participant[listSize];
            int i = 0;
            while ((!isIncorrect) && (i < (listSize))) {   
                fin >> list[i].surname;
                isIncorrect = isSurnameIncorrect(list[i].surname);
                fin >> list[i].points;
                isIncorrect = isNumRangeIncorrect(MINPOINT, MAXPOINT, list[i].points, "Баллы, записанные в файле, не соответстуют диапазону. Повторите попытку.", isIncorrect);
                i++;
            }
            if (!isIncorrect && !fin.eof()) {
                cout << "Количество участников не совпадает с записанным в файле размером. Повторите попытку.\n";
                isIncorrect = true;
            }
        }
        catch (string errorMessage) {
            cout << "Данные выбранного файла не соответствуют условию. Повторите попытку.\n";
                isIncorrect = true;
        }
        fin.close();
        if (isIncorrect)
            path = checkFileInputPath();
    } while (isIncorrect);
    cout << "Данные из файла успешно считаны.\n";
    return list;
}

participant* inputList(int& listSize) {
    int choice;
    choice = 0;
    participant* list;
    choice = inputNum(0, 1, "Если Вы хотите вводить данные в консоль, введите 0. Если использовать файл, введите 1: ");
    if (choice == 0) {
        listSize = inputNum(MINSIZE, MAXSIZE, "Введите количество участников (от 3 до 20): ");
        list = getListFromConsole(listSize);
    }
    else {
        string finPath;
        finPath = checkFileInputPath();
        list = getListFromFile(finPath, listSize);
    }
    return list;
}

string upcaseWord(string word) {
    locale locRus("Russian");
    for (int i = 0; i < (word.size() + 1); i++)
        word[i] = toupper(word[i], locRus);
    return word;
}

participant* sortList(participant* list, int listSize) {
    for (int i = 1; i < listSize; i++)
        for (int j = 1; j < listSize; j++)
            if (list[j].points > list[j - 1].points)
                swap(list[j - 1], list[j]);
            else if ((list[j].points == list[j - 1].points) && (upcaseWord(list[j].surname) < upcaseWord(list[j - 1].surname)))
                    swap(list[j - 1], list[j]);
    return list;
}

void outputList(participant* list, string listName, int listSize) {
    cout << "\n" << listName;
    for (int i = 0; i < listSize; i++)
        cout << list[i].surname << " " << list[i].points << "\n";
    cout << "\n";
}

string checkFileOutputPath() {
    string path;
    bool isIncorrect;
    do {
        isIncorrect = false;
        cout << "Введите путь к файлу, в который нужно записать результат.\n";
        cin >> path;
        ofstream fout(path);
        fout.open(path);
        if (!fout.is_open()) {
            cout << "Произошла ошибка. Повторите попытку.\n";
            isIncorrect = true;
        }
        isIncorrect = isFileExtIncorrect(path, isIncorrect);
        fout.close();
    } while (isIncorrect);
    return path;
}

void writeResultIntoFile(participant* list, string path, int listSize) {
    bool isIncorrect;
    do {
        isIncorrect = false;
        ofstream fout(path);
        try {
            for (int i = 0; i < listSize; i++)
                fout << list[i].surname << " " << list[i].points << "\n";
        }
        catch (string errorMessage) {
            cout << "Произошла ошибка. Повторите попытку.\n";
            isIncorrect = true;
        }
        fout.close();
        if (isIncorrect)
            path = checkFileOutputPath();
    } while (isIncorrect);
    cout << "Результат записан.\n";
}

void outputResult(participant* sortedList, int listSize) {
    int choice;
    choice = 0;
    choice = inputNum(0, 1, "Если нужно вывести результат в консоль, введите 0. Если в файл, введите 1: ");
    if (choice == 0)
        outputList(sortedList, "Отсортированный список:\n", listSize);
    else {
        string foutPath;
        foutPath = checkFileOutputPath();
        writeResultIntoFile(sortedList, foutPath, listSize);
    }
}

int main() {
    SetConsoleCP(1251);
    SetConsoleOutputCP(1251);
    int listSize;
    participant* list;
    participant* sortedList;
    listSize = 0;
    writeCondition();
    list = inputList(listSize);
    outputList(list, "Введенный список:\n", listSize);
    sortedList = sortList(list, listSize);
    outputResult(sortedList, listSize);
    delete[] list;
    delete[] sortedList;
    return 0;
}
