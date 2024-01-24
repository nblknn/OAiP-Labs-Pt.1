#include <iostream>
#include <fstream>
#include <set>
#include <string>
#include <locale>
#include <Windows.h>
using namespace std;

const char OPENBRACE = '(';
const char CLOSEBRACE = ')';
const set<char> NUMBERS {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'};

set<char> fillLettersSet() {
    set<char> LETTERS;
    for (char i = 'A'; i < 'Z' + 1; i++)
        LETTERS.insert(i);
    for (char i = 'a'; i < 'z' + 1; i++)
        LETTERS.insert(i);
    for (char i = 'А'; i < 'Я' + 1; i++)
        LETTERS.insert(i);
    for (char i = 'а'; i < 'я' + 1; i++)
        LETTERS.insert(i);
    LETTERS.insert('Ё');
    LETTERS.insert('ё');
    return LETTERS;
}

void writeCondition() {
    cout << "Данная программа в каждом четном слове текста заменяет все буквы на прописные,\nа каждое нечетное слово заключает в круглые скобки.\n";
}

int checkChoiceInput(string outputMessage) {
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
            cout << "Введенные данные не соответствуют условию. Повторите попытку.\n";
        }
        if ((!isIncorrect) && (num != 0) && (num != 1)) {
            isIncorrect = true;
            cout << "Введенные данные не соответствуют условию. Повторите попытку.\n";
        }
    } while (isIncorrect);
    cout << "\n";
    return num;
}

bool isTextIncorrect(string text, const set<char> LETTERS) {
    bool isIncorrect; 
    isIncorrect = true;
    if (text == "")
        cout << "В тексте нет символов. Повторите попытку.\n";
    else {
        int i;
        i = 0;
        while (isIncorrect && (i < text.size() + 1)) {
            if (LETTERS.count(text[i]))
                isIncorrect = false;
            i++;
        }
        if (isIncorrect)
            cout << "В тексте нет букв. Повторите попытку.\n";
    }
    return isIncorrect;
}

string inputTextFromConsole(const set<char> LETTERS) {
    string text;
    do {
        cout << "Введите текст.\n";
        getline(cin, text, '\n');
    } while (isTextIncorrect(text, LETTERS));
    return text;
}

bool isFileExtIncorrect(string path) {
    bool isIncorrect;
    isIncorrect = true;
    if (path.substr(path.size() - 4) == ".txt")
        isIncorrect = false;
    else
        cout << "Введенный Вами файл не является текстовым. Повторите попытку.\n";
    return isIncorrect;
}

string checkFileInputPath() {
    string path;
    bool isIncorrect;
    do {
        isIncorrect = false;
        cout << "Введите путь к файлу, содержащему текст.\n";
            cin >> path;
        ifstream fin(path);
        fin.open(path);
        if (!fin.is_open()) {
            cout << "Введенного файла не существует. Повторите попытку.\n";
            isIncorrect = true;
        }
        if (!isIncorrect)
            isIncorrect = isFileExtIncorrect(path);
        fin.close();
    } while (isIncorrect);
    return path;
}

string getTextFromFile(string path, const set<char> LETTERS) {
    bool isIncorrect;
    string line;
    string text;
    do {
        isIncorrect = false;
        ifstream fin(path);
        try {
            while (!fin.eof()) {
                getline(fin, line);
                text += line;
            }
            isIncorrect = isTextIncorrect(text, LETTERS);
        }
        catch (string errorMessage) {
            cout << "Произошла ошибка. Повторите попытку.\n";
                isIncorrect = true;
        }
        fin.close();
        if (isIncorrect) {
            path = checkFileInputPath();
            text = "";
        }
    } while (isIncorrect);
    cout << "Данные из файла успешно считаны.\n\n";
    return text;
}

string inputText(const set<char> LETTERS) {
    int choice;
    string text;
    choice = 0;
    choice = checkChoiceInput("Если Вы хотите вводить данные в консоль, введите 0. Если использовать файл, введите 1.\n");
    if (choice == 0)
        text = inputTextFromConsole(LETTERS);
    else {
        string finPath = checkFileInputPath();
        text = getTextFromFile(finPath, LETTERS);
        cout << "Введенный текст:\n" << text << "\n";
    }
    return text;
}

string formatWord(int count, string word, string resultText) {
    locale locRus("Russian");
    if (count % 2 != 0)
        resultText += OPENBRACE + word + CLOSEBRACE;
    else {
        for (int j = 0; j < word.size() + 1; j++)
            word[j] = toupper(word[j], locRus);
        resultText += word;
    }
    return resultText;
}

string formatText(string text, const set<char> LETTERS) {
    int count;
    string word;
    string resultText;
    count = 1;
    word = "";
    resultText = "";
    for (int i = 0; i < text.size() + 1; i++)
        if ((LETTERS.count(text[i])) || (NUMBERS.count(text[i])))
            word += text[i];
        else
            if (word != "") {
                resultText = formatWord(count, word, resultText) + text[i];
                word = "";
                count++;
            }
            else
                resultText += text[i];
    if (word != "")
        resultText = formatWord(count, word, resultText);
    return resultText;
}

string checkFileOutputPath() {
    string path;
    bool isIncorrect;
    cout << endl;
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
        if (!isIncorrect)
            isIncorrect = isFileExtIncorrect(path);
        fout.close();
    } while (isIncorrect);
    cout << endl;
    return path;
}

void writeResultIntoFile(string resultText, string path) {
    bool isIncorrect;
    do {
        isIncorrect = false;
        ofstream fout(path);
        try {
            fout << resultText;
        }
        catch (string errorMessage) {
            cout << "Произошла ошибка. Повторите попытку.\n";
            isIncorrect = true;
        }
        fout.close();
        if (isIncorrect)
            path = checkFileOutputPath();
    } while (isIncorrect);
    cout << "Результат записан.";
}

void outputText(string resultText) {
    int choice;
    choice = 0;
    choice = checkChoiceInput("\nЕсли Вы хотите вывести результат в консоль, введите 0. Если в файл, введите 1.\n");
    if (choice == 0)
        cout << "Результат:\n" << resultText;
    else {
        string foutPath = checkFileOutputPath();
        writeResultIntoFile(resultText, foutPath);
    }
}

int main() {
    SetConsoleCP(1251);
    SetConsoleOutputCP(1251);
    string text;
    string resultText;
    const set<char> LETTERS = fillLettersSet();
    writeCondition();
    text = inputText(LETTERS);
    resultText = formatText(text, LETTERS);
    outputText(resultText);
    return 0;
}