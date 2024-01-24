#include <iostream>
using namespace std;

const int MIN = 0;
const int MAX = 9;
const int MINNUM = 1;
const int MAXNUM = 1000000;

void writeCondition()
{
	cout << "Данная программа складывает два числа столбиком." << endl;
    cout << "Условие ввода чисел: числа целые, от 1 до 1000000." << endl;
}

int inputNum(int number)
{
    int num = 0;
	bool isIncorrect;
    do {
        isIncorrect = false;
        cout << "Введите " << number << " число: ";
        cin >> num;
        if (cin.get() != '\n') {
            cin.clear();
            while (cin.get() != '\n');
            isIncorrect = true;
            cout << "Введенные данные не соответствуют условию. Повторите попытку." << endl;
        }
        if (!isIncorrect && ((num < MINNUM) || (num > MAXNUM))) {
            isIncorrect = true;
            cout << "Введенные данные не соответствуют условию. Повторите попытку." << endl;
        }
    } while (isIncorrect);
    return num;
}

int findNumSize(int num)
{
    int size = 0;
    while (num > MIN)
    {
        size++;
        num /= 10;
    }
    return size;
}

int* convertToArray(int num, int size)
{
    int ten = 10;
    int* numArr = new int[size];
    for (int i = size - 1; i > -1; i--)
    {
        numArr[i] = ((num % ten) / (ten / 10));
        ten *= 10;
    }
    return numArr;
}

int findSumSize(int fstSize, int secSize)
{
    int sumSize = 0;
    if (fstSize > secSize)
        return fstSize;
    else
        return secSize;
}


int* findSum(int biggerSize, int smallerSize, int sumSize, int* biggerNum, int* smallerNum)
{
    int* sum = new int[sumSize];
    for (int i = (sumSize - 1); i > -1; i--)
        if (i > (biggerSize - smallerSize - 1))
            sum[i] = biggerNum[i] + smallerNum[i - (biggerSize - smallerSize)];
        else
            sum[i] = biggerNum[i];
    return sum;
}

int* findSumCondition(int fstSize, int secSize, int sumSize, int* fstNumArr, int* secNumArr)
{
    if (fstSize > secSize)
        return findSum(fstSize, secSize, sumSize, fstNumArr, secNumArr);
    else
        return findSum(secSize, fstSize, sumSize, secNumArr, fstNumArr);
}

int* addOnes(int sumSize, int* sum)
{
    int one = 0;
    for (int i = (sumSize - 1); i > 0; i--)
    {
        sum[i] += one;
        if (sum[i] > MAX)
        {
            one = 1;
            sum[i] -= 10;
        }
        else
            one = 0;
    }
    sum[0] += one;
    return sum;
}

int* addPosition(int sumSize, int* sum)
{
    if (sum[0] > MAX)
    {
        int* sumNew = new int[sumSize];
        for (int i = (sumSize - 2); i > -1; i--)
            sumNew[i + 1] = sum[i];
        sumNew[1] = sum[0] - 10;
        sumNew[0] = 1;
        delete[] sum;
        return sumNew;
    }
    else return sum;
}

void outputArray(int numSize, int* arr)
{
    for (int i = 0; i < (7 - numSize); i++)
        cout << " ";
    for (int i = 0; i < numSize; i++)
        cout << arr[i];
    cout << endl;
    delete[] arr;
}

void outputSum(int fstSize, int secSize, int sumSize, int* fstNumArr, int* secNumArr, int* sum)
{
    cout << "Результат: " << endl;
    outputArray(fstSize, fstNumArr);
    cout << "+" << endl;
    outputArray(secSize, secNumArr);
    cout << "-------" << endl;
    outputArray(sumSize, sum);
}



int main()
{
    setlocale(LC_ALL, "Russian");
    int fstNum = 0;
    int secNum = 0;
    int fstSize = 0;
    int secSize = 0;
    int sumSize = 0;
    writeCondition();
    fstNum = inputNum(1);
    secNum = inputNum(2);
    fstSize = findNumSize(fstNum);
    secSize = findNumSize(secNum);
    int* fstNumArr = convertToArray(fstNum, fstSize);
    int* secNumArr = convertToArray(secNum, secSize);
    sumSize = findSumSize(fstSize, secSize);
    int* sum = findSumCondition(fstSize, secSize, sumSize, fstNumArr, secNumArr);
    sum = addOnes(sumSize, sum);
    if (sum[0] > MAX)
        sumSize++;
    sum = addPosition(sumSize, sum);
    outputSum(fstSize, secSize, sumSize, fstNumArr, secNumArr, sum);
    return 0;

}
