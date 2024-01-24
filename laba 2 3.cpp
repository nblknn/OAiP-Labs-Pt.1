#include <iostream>
#include <fstream>
using namespace std;

const int MINSIZE = 2;
const int MAXSIZE = 10;
const int MIN = -1000;
const int MAX = 1000;

int inputSize(string outputMessage) {
    int size = 0;
    bool isIncorrect;
    do {
        isIncorrect = false;
        cout << outputMessage;
        cin >> size;
        if (cin.get() != '\n') {
            cin.clear();
            while (cin.get() != '\n');
            isIncorrect = true;
            cout << "Введенные данные не соответствуют условию. Повторите попытку."
                << endl;
        }
        if (!isIncorrect && ((size < MINSIZE) || (size > MAXSIZE))) {
            isIncorrect = true;
            cout << "Введенные данные не соответствуют условию. Повторите попытку."
                << endl;
        }
    } while (isIncorrect);
    return size;
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
        for (int j = 0; j < colNum; j++)
            do {
                isIncorrect = false;
                cout << "Введите элемент " << i + 1 << " строки, " << j + 1 << " столбца матрицы : ";
                cin >> matrix[i][j];
                if (!isIncorrect && cin.get() != '\n') {
                    cin.clear();
                    while (cin.get() != '\n');
                    isIncorrect = true;
                    cout << "Введенные данные не соответствуют условию. Повторите попытку." << endl;
                }
                if (!isIncorrect && (matrix[i][j] < MIN || matrix[i][j] > MAX)) {
                    isIncorrect = true;
                    cout << "Введенные данные не соответствуют условию. Повторите попытку." << endl;
                }
            } while (isIncorrect);
    cout << endl;
    return matrix;
}

int* inputVector(int size, string vectorOrMatrix) {
    bool isIncorrect;
    int* vector = new int[size];
    for (int i = 0; i < size; i++)
        do {
            isIncorrect = false;
            cout << "Введите " << i + 1 << " элемент " << vectorOrMatrix << ": ";
            cin >> vector[i];
            if (!isIncorrect && cin.get() != '\n') {
                cin.clear();
                while (cin.get() != '\n');
                isIncorrect = true;
                cout << "Введенные данные не соответствуют условию. Повторите попытку." << endl;
            }
            if (!isIncorrect && (vector[i] < MIN || vector[i] > MAX)) {
                isIncorrect = true;
                cout << "Введенные данные не соответствуют условию. Повторите попытку." << endl;
            }
        } while (isIncorrect);
    cout << endl;
    return vector;
}

bool checkFileExtension(string path) {
    bool isIncorrect = true;
    if (path.substr(path.size() - 4) == ".txt")
        isIncorrect = false;
    else
        cout << "Введенный Вами файл не является текстовым. Повторите попытку." << endl;
    return isIncorrect;
}

string checkFileInputPath(string matrixOrVector) {
    string path;
    bool isIncorrect;
    do {
        isIncorrect = false;
        cout << "Введите путь к файлу, содержащему " << matrixOrVector << "." << endl;
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

int getSizeFromFile(string path, string matrixOrVector) {
    int size = 0;
    bool isIncorrect;
    do {
        isIncorrect = false;
        ifstream fin(path);
        try {
            fin >> size;
        }
        catch (string errorMessage)
        {
            cout << "Данные выбранного файла не соответствуют условию. Повторите попытку." << endl;
            isIncorrect = true;
        }
        if (!isIncorrect && (size < MINSIZE || size > MAXSIZE))
        {
            cout << "Размер в выбранном файле не соответствуют условию. Повторите попытку." << endl;
            isIncorrect = true;
        }
        fin.close();
        if (isIncorrect)
            path = checkFileInputPath(matrixOrVector);
    } while (isIncorrect);
    return size;
}

int** fillMatrixFromFile(string path, int rowNum, int colNum) {
    bool isIncorrect;
    int** matrix = createMatrix(rowNum, colNum);
    do {
        isIncorrect = false;
        ifstream fin(path);
        fin >> colNum;
        try {
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
            path = checkFileInputPath("матрицу");
    } while (isIncorrect);
    cout << "Данные из файла успешно считаны." << endl;
    cout << endl;
    return matrix;
}

int* fillVectorFromFile(int size, string path, string matrixOrVector) {
    bool isIncorrect;
    int* vector = new int[size];
    do {
        isIncorrect = false;
        ifstream fin(path);
        fin >> size;
        try {
            for (int i = 0; i < size; i++) {
                fin >> vector[i];
                if (!isIncorrect && ((vector[i] < MIN) || (vector[i] > MAX))) {
                    cout << "Данные выбранного файла не соответствуют условию. Повторите попытку." << endl;
                    isIncorrect = true;
                }
            }
            if (!isIncorrect && !fin.eof()) {
                cout << "Размер введенного вектора/матрицы не соответствует заданному. Повторите попытку." << endl;
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
            path = checkFileInputPath(matrixOrVector);
    } while (isIncorrect);
    cout << "Данные из файла успешно считаны." << endl;
    cout << endl;
    return vector;
}

void outputMatrix(int rowNum, int colNum, int** matrix) {
    for (int i = 0; i < rowNum; i++) {
        for (int j = 0; j < colNum; j++)
            cout << matrix[i][j] << " ";
        cout << endl;
    }
}

void outputVectorColumn(int size, int* vector) {
    for (int i = 0; i < size; i++)
            cout << vector[i] << endl;
    cout << endl;
}

void outputVectorRow(int size, int* vector) {
    for (int i = 0; i < size; i++)
        cout << vector[i] << " ";
    cout << endl;
    cout << endl;
}

int* findProductVector(int rowNum, int colNum, int* vector, int** matrix) {
    int* productVector = new int[colNum];
    for (int i = 0; i < colNum; i++) {
        productVector[i] = 0;
        for (int j = 0; j < rowNum; j++)
            productVector[i] = productVector[i] + (matrix[j][i] * vector[j]);
    }
    return productVector;
}

int** findProductMatrix(int rowNum, int colNum, int* vector, int* matrix) {
    int** productMatrix = createMatrix(rowNum, colNum);
    for (int i = 0; i < rowNum; i++)
        for (int j = 0; j < colNum; j++)
            productMatrix[i][j] = matrix[j] * vector[i];
    return productMatrix;
}

string checkFileOutputPath() {
    string path;
    bool isIncorrect;
    cout << endl;
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

void writeVectorIntoFile(string path, int size, int* productVector) {
    bool isIncorrect;
    do {
        isIncorrect = false;
        ofstream fout(path);
        try {
            for (int i = 0; i < size; i++)
                fout << productVector[i] << endl;
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

void writeMatrixIntoFile(string path, int rowNum, int colNum, int** productMatrix) {
    bool isIncorrect;
    do {
        isIncorrect = false;
        ofstream fout(path);
        try {
            for (int i = 0; i < rowNum; i++) {
                for (int j = 0; j < colNum; j++)
                    fout << productMatrix[i][j] << " ";
                fout << endl;
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

void outputVectors(int rowNum, int colNum, int* vectorColumn, int* vectorRow) {
    cout << "Введенный вектор:" << endl;
    outputVectorColumn(rowNum, vectorColumn);
    cout << "Введенная матрица:" << endl;
    outputVectorRow(colNum, vectorRow);
}

void outputVectorAndMatrix(int rowNum, int colNum, int* vectorRow, int** matrix) {
    cout << "Введенный вектор:" << endl;
    outputVectorRow(rowNum, vectorRow);
    cout << "Введенная матрица:" << endl;
    outputMatrix(rowNum, colNum, matrix);
}

void inputFromConsole(int vectorType) {
    int rowNum = 0;
    int colNum = 0;
    rowNum = inputSize("Введите размер вектора (от 2 до 10): ");
    int* vector = inputVector(rowNum, "вектора");
    colNum = inputSize("Введите количество столбцов матрицы (от 2 до 10): ");
    if (vectorType == 0) {
        int* vectorRow = inputVector(colNum, "матрицы");
        outputVectors(rowNum, colNum, vector, vectorRow);
        int** productMatrix = findProductMatrix(rowNum, colNum, vector, vectorRow);
        cout << "Результат произведения вектора и матрицы:" << endl;
        outputMatrix(rowNum, colNum, productMatrix);
        delete[] vectorRow;
        delete[] productMatrix;
    }
    else {
        cout << "Количество строк матрицы равно " << rowNum << "." << endl;
        int** matrix = inputMatrix(rowNum, colNum);
        outputVectorAndMatrix(rowNum, colNum, vector, matrix);
        int* productVector = findProductVector(rowNum, colNum, vector, matrix);
        cout << "Результат произведения вектора и матрицы:" << endl;
        outputVectorRow(colNum, productVector);
        delete[] matrix;
        delete[] productVector;
    }
    delete[] vector;
}

void inputFromFile(int vectorType) {
    int rowNum = 0;
    int colNum = 0;
    string finPathVector;
    string finPathMatrix;
    string foutPath;
    cout << "В первой строке файла должны быть записаны размеры (от 2 до 10)." << endl;
    finPathVector = checkFileInputPath("вектор");
    rowNum = getSizeFromFile(finPathVector, "вектор");
    int* vector = fillVectorFromFile(rowNum, finPathVector, "вектор");
    if (vectorType == 1)
        cout << "Количество строк матрицы равно " << rowNum << ". В первой строке файла введите количество столбцов." << endl;
    finPathMatrix = checkFileInputPath("матрицу");
    colNum = getSizeFromFile(finPathMatrix, "матрицу");
    if (vectorType == 0) {
        int* vectorRow = fillVectorFromFile(colNum, finPathMatrix, "матрицу (вектор-строку)");
        outputVectors(rowNum, colNum, vector, vectorRow);
        int** productMatrix = findProductMatrix(rowNum, colNum, vector, vectorRow);
        foutPath = checkFileOutputPath();
        writeMatrixIntoFile(foutPath, rowNum, colNum, productMatrix);
        delete[] vectorRow;
        delete[] productMatrix;
    }
    else {
        int** matrix = fillMatrixFromFile(finPathMatrix, rowNum, colNum);
        outputVectorAndMatrix(rowNum, colNum, vector, matrix);
        int* productVector = findProductVector(rowNum, colNum, vector, matrix);
        foutPath = checkFileOutputPath();
        writeVectorIntoFile(foutPath, colNum, productVector);
        delete[] matrix;
        delete[] productVector;
    }
    delete[] vector;
}

int checkChoiceInput() {
    int num = 0;
    bool isIncorrect;
    do {
        isIncorrect = false;
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
    return num;
}

int chooseVectorType() {
    int vectorType = 0;
    cout << "Введите 0, если требуется умножить вектор-столбец на матрицу, и 1, если вектор-строку." << endl;
    vectorType = checkChoiceInput();
    if (vectorType == 0)
        cout << "Для умножения вектора-столбца на матрицу, матрица должна состоять из 1 строки." << endl;
    else
        cout << "Для умножения вектора-строки на матрицу, число столбцов вектора должно совпадать с числом строк матрицы." << endl;
    cout << endl;
    return vectorType;
}

void writeCondition() {
    cout << "Данная программа находит произведение вектора на матрицу." << endl;
    cout << "Элементы вектора и матрицы - целые числа от -1000 до 1000." << endl;
}

int main()
{
    setlocale(LC_ALL, "Russian");
    int choice = 0;
    int vectorType = 0;
    writeCondition();
    cout << "Если Вы хотите вводить данные в консоль, введите 0. Если использовать файл, введите 1." << endl;
    choice = checkChoiceInput();
    vectorType = chooseVectorType();
    if (choice == 0)
        inputFromConsole(vectorType);
    else
        inputFromFile(vectorType);
    return 0;
}