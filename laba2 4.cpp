#include <iostream>
#include <fstream>
using namespace std;

const int MINSIZE = 2;
const int MAXSIZE = 10;
const int MIN = -1000;
const int MAX = 1000;

int checkInput(const int MINNUM, const int MAXNUM, string outputMessage) {
    int num = 0;
    bool isIncorrect;
    do {
        isIncorrect = false;
        cout << outputMessage;
        cin >> num;
        if (cin.get() != '\n') {
            cin.clear();
            while (cin.get() != '\n');
            isIncorrect = true;
            cout << "Введенные данные не соответствуют условию. Повторите попытку."
                << endl;
        }
        if (!isIncorrect && ((num < MINNUM) || (num > MAXNUM))) {
            isIncorrect = true;
            cout << "Введенные данные не соответствуют условию. Повторите попытку."
                << endl;
        }
    } while (isIncorrect);
    return num;
}

int** createMatrix(int rowNum, int colNum) {
    int** matrix = new int* [rowNum];
    for (int i = 0; i < rowNum; i++)
        matrix[i] = new int[colNum];
    return matrix;
}

int** inputMatrix(int rowNum, int colNum) {
    bool isIncorrect;
    int** matrix = createMatrix(rowNum, colNum);
    for (int i = 0; i < rowNum; i++)
        for (int j = 0; j < colNum; j++) {
            cout << "Введите элемент " << i + 1 << " строки, " << j + 1 << " столбца матрицы: ";
            matrix[i][j] = checkInput(MIN, MAX, "");
        }
            cout << endl;
            return matrix;
}

int** fillMatrixFromConsole(int& rowNum, int& colNum) {
    cout << "Введите размеры матрицы (от 2 до 10)." << endl;
    rowNum = checkInput(MINSIZE, MAXSIZE, "Введите количество строк матрицы : ");
    colNum = checkInput(MINSIZE, MAXSIZE, "Введите количество столбцов матрицы : ");
    int** matrix = inputMatrix(rowNum, colNum);
    return matrix;
}

bool checkFileExtension(string path) {
    bool isIncorrect = true;
    if (path.substr(path.size() - 4) == ".txt")
        isIncorrect = false;
    else
        cout << "Введенный Вами файл не является текстовым. Повторите попытку." << endl;
    return isIncorrect;
}

string checkFileInputPath() {
    string path;
    bool isIncorrect;
    do {
        isIncorrect = false;
        cout << "Введите путь к файлу, содержащему матрицу. Первой строкой должны быть введены размеры (строки и столбцы, от 2 до 10)." << endl;
        cin >> path;
        ifstream fin(path);
        fin.open(path);
        if (!fin.is_open()) {
            cout << "Введенного файла не существует. Повторите попытку." << endl;
            isIncorrect = true;
        }
        if (!isIncorrect)
            isIncorrect = checkFileExtension(path);
        fin.close();
    } while (isIncorrect);
    return path;
}

int** fillMatrixFromFile(string path, int& rowNum, int& colNum) {
    bool isIncorrect;
    int** matrix = 0;
    do {
        isIncorrect = false;
        ifstream fin(path);
        try {
            fin >> rowNum;
            fin >> colNum;
            if (!isIncorrect && (rowNum < MIN || rowNum > MAX || colNum < MIN || colNum > MAX))
            {
                cout << "Размер в выбранном файле не соответствуют условию. Повторите попытку." << endl;
                isIncorrect = true;
            }
            matrix = createMatrix(rowNum, colNum);
            for (int i = 0; i < rowNum; i++)
                for (int j = 0; j < colNum; j++) {
                    fin >> matrix[i][j];
                    if (!isIncorrect && ((matrix[i][j] < MIN) || (matrix[i][j] > MAX))) {
                        cout << "Данные выбранного файла не соответствуют условию. Повторите попытку." << endl;
                        isIncorrect = true;
                    }
                }
            if (!isIncorrect && !fin.eof()) {
                cout << "Размер введенной матрицы не соответствует заданному. Повторите попытку." << endl;
                isIncorrect = true;
            }
        }
        catch (string errorMessage)
        {
            cout << "Данные выбранного файла не соответствуют условию. Повторите попытку." << endl;
            isIncorrect = true;
        }
        fin.close();
        if (isIncorrect)
            path = checkFileInputPath();
    } while (isIncorrect);
    cout << "Данные из файла успешно считаны." << endl;
    cout << endl;
    return matrix;
}

void outputMatrix(int rowNum, int colNum, int** matrix) {
    cout << "Введенная матрица:" << endl;
    for (int i = 0; i < rowNum; i++) {
        for (int j = 0; j < colNum; j++)
            cout << matrix[i][j] << " ";
        cout << endl;
    }
    cout << endl;
}

int* findZeroAmountOfEachRow(int rowNum, int colNum, int** matrix) {
    int* zeroAmount = new int[rowNum];
    for (int i = 0; i < rowNum; i++) {
        zeroAmount[i] = 0;
        for (int j = 0; j < colNum; j++)
            if (matrix[i][j] == 0)
                zeroAmount[i]++;
    }
    return zeroAmount;
}

int findMaxZeroAmount(int rowNum, int* zeroAmount) {
    int maxZeroAmount = zeroAmount[0];
    for (int i = 1; i < rowNum; i++)
        if (zeroAmount[i] > maxZeroAmount)
            maxZeroAmount = zeroAmount[i];
    return maxZeroAmount;
}

int findNumOfMaxZeroRows(int rowNum, int maxZeroAmount, int* zeroAmount) {
    int maxZeroRows = 0;
    for (int i = 0; i < rowNum; i++)
        if (zeroAmount[i] == maxZeroAmount)
            maxZeroRows++;
    return maxZeroRows;
}

int findMaxZeroRowIndex(int rowNum, int maxZeroRows, int maxZeroAmount, int* zeroAmount) {
    int index = 0;
    for (int i = 0; i < rowNum; i++)
        if (zeroAmount[i] == maxZeroAmount)
            index = i;
    return index;
}

int* findMaxZeroRowIndexArray(int rowNum, int maxZeroRows, int maxZeroAmount, int* zeroAmount) {
    int* indexArray = new int[maxZeroRows];
    int j = 0;
    for (int i = 0; i < rowNum; i++)
        if (zeroAmount[i] == maxZeroAmount) {
            indexArray[j] = i;
            j++;
        }
    return indexArray;
}

string checkFileOutputPath() {
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
        if (!isIncorrect)
            isIncorrect = checkFileExtension(path);
        fout.close();
    } while (isIncorrect);
    cout << endl;
    return path;
}

void writeResultIntoFile(int rowNum, int colNum, int maxZeroAmount, int maxZeroRows, int index, int* indexArray, int** matrix, string path) {
    bool isIncorrect;
    do {
        isIncorrect = false;
        ofstream fout(path);
        try {
            if (maxZeroAmount == 0)
                fout << "В матрице нет строк с нулевыми элементами.";
            else if (maxZeroRows == 1) {
                fout << "Строка с максимальным количеством нулевых элементов: ";
                for (int j = 0; j < colNum; j++)
                    fout << matrix[index][j] << " ";
            }
            else if ((maxZeroRows == rowNum) && (maxZeroAmount == colNum))
                fout << "Все элементы матрицы - нулевые элементы.";
            else {
                fout << "Строки с максимальным количеством нулевых элементов: " << endl;
                for (int i = 0; i < maxZeroRows; i++) {
                    for (int j = 0; j < colNum; j++)
                        fout << matrix[indexArray[i]][j] << " ";
                    fout << endl;
                }
            }
        }
        catch (string errorMessage)
        {
            cout << "Произошла ошибка. Повторите попытку." << endl;
            isIncorrect = true;
        }
        fout.close();
        if (isIncorrect)
            path = checkFileOutputPath();
    } while (isIncorrect);
    cout << "Результат записан.";
}

void outputMaxZeroRow(int colNum, int index, int** matrix) {
    cout << "Строка с максимальным количеством нулевых элементов: ";
    for (int j = 0; j < colNum; j++)
        cout << matrix[index][j] << " ";
}

void outputMaxZeroRows(int colNum, int maxZeroRows, int* indexArray, int** matrix) {
    cout << "Строки с максимальным количеством нулевых элементов: " << endl;
    for (int i = 0; i < maxZeroRows; i++) {
        for (int j = 0; j < colNum; j++)
            cout << matrix[indexArray[i]][j] << " ";
        cout << endl;
    }
}

void outputResult(int rowNum, int colNum, int maxZeroAmount, int maxZeroRows, int index, int* indexArray, int** matrix) {
    if (maxZeroAmount == 0)
        cout << "В матрице нет строк с нулевыми элементами.";
    else if (maxZeroRows == 1)
        outputMaxZeroRow(colNum, index, matrix);
    else if ((maxZeroRows == rowNum) && (maxZeroAmount == colNum))
        cout << "Все элементы матрицы - нулевые элементы.";
    else
        outputMaxZeroRows(colNum, maxZeroRows, indexArray, matrix);
}

int checkChoiceInput(string outputMessage) {
    int num = 0;
    bool isIncorrect;
    do {
        isIncorrect = false;
        cout << outputMessage << endl;
        cin >> num;
        if (cin.get() != '\n') {
            cin.clear();
            while (cin.get() != '\n');
            isIncorrect = true;
            cout << "Введенные данные не соответствуют условию. Повторите попытку."
                << endl;
        }
        if (!isIncorrect && (num != 0) && (num != 1)) {
            isIncorrect = true;
            cout << "Введенные данные не соответствуют условию. Повторите попытку."
                << endl;
        }
    } while (isIncorrect);
    cout << endl;
    return num;
}

void writeCondition() {
    cout << "Данная программа находит строку матрицы, в которой больше всего нулевых элементов." << endl;
    cout << "Элементы матрицы - целые числа от -1000 до 1000." << endl;
}

int main()
{
    setlocale(LC_ALL, "Russian");
    int choice = 0;
    int rowNum = 0;
    int colNum = 0;
    int maxZeroAmount = 0;
    int maxZeroRows = 0;
    int index = 0;
    int* indexArray = new int;
    int** matrix;
    writeCondition();
    choice = checkChoiceInput("Если Вы хотите вводить данные в консоль, введите 0. Если использовать файл, введите 1.");
    if (choice == 0)
        matrix = fillMatrixFromConsole(rowNum, colNum);
    else {
        string finPath = checkFileInputPath();
        matrix = fillMatrixFromFile(finPath, rowNum, colNum);
    }
    outputMatrix(rowNum, colNum, matrix);
    int* zeroAmount = findZeroAmountOfEachRow(rowNum, colNum, matrix);
    maxZeroAmount = findMaxZeroAmount(rowNum, zeroAmount);
    maxZeroRows = findNumOfMaxZeroRows(rowNum, maxZeroAmount, zeroAmount);
    if (maxZeroRows == 1)
        index = findMaxZeroRowIndex(rowNum, maxZeroRows, maxZeroAmount, zeroAmount);
    else
        indexArray = findMaxZeroRowIndexArray(rowNum, maxZeroRows, maxZeroAmount, zeroAmount);
    choice = checkChoiceInput("Если Вы хотите вывести результат в консоль, введите 0. Если в файл, введите 1.");
    if (choice == 0)
        outputResult(rowNum, colNum, maxZeroAmount, maxZeroRows, index, indexArray, matrix);
    else {
        string foutPath = checkFileOutputPath();
        writeResultIntoFile(rowNum, colNum, maxZeroAmount, maxZeroRows, index, indexArray, matrix, foutPath);
    }
    delete[] indexArray;
    delete[] matrix;
    delete[] zeroAmount;
    return 0;
}