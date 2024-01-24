import java.util.Scanner;

public class lab22 {
    static final int MIN = 0;
    static final int MAX = 9;
    static final int MINNUM = 1;
    static final int MAXNUM = 1000000;

    private static void writeCondition() {
        System.out.println("Данная программа складывает два числа столбиком.");
        System.out.println("Условие ввода чисел: числа целые, от 1 до 1000000.");
    }

    private static int inputNum(int number, Scanner scan) {
        int num = 0;
        boolean isIncorrect;
        do {
            isIncorrect = false;
            System.out.print("Введите " + number + " число: ");
            try {
                num = Integer.parseInt(scan.nextLine());
            }
            catch (NumberFormatException e) {
                System.out.println("Введенные данные не соответствуют условию. Повторите попытку.");
                        isIncorrect = true;
            }
            if (!isIncorrect & ((num < MINNUM) | (num > MAXNUM))) {
                isIncorrect = true;
                System.out.println("Введенные данные не соответствуют условию. Повторите попытку.");
            }
        } while (isIncorrect);
        return num;
    }

    private static int findNumSize(int num) {
        int size = 0;
        while (num > MIN) {
            size++;
            num /= 10;
        }
        return size;
    }

    private static int[] convertToArray(int num, int size) {
        int ten = 10;
        int[] numArr = new int[size];
        for (int i = size - 1; i > -1; i--) {
            numArr[i] = ((num % ten) / (ten / 10));
            ten *= 10;
        }
        return numArr;
    }

    private static int findSumSize(int fstSize, int secSize) {
        int sumSize = 0;
        if (fstSize > secSize)
            return fstSize;
        else
            return secSize;
    }

    private static int[] findSum(int biggerSize, int smallerSize, int sumSize,
                                 int[] biggerNum, int[] smallerNum) {
        int[] sum = new int[sumSize];
        for (int i = (sumSize - 1); i > -1; i--)
            if (i > (biggerSize - smallerSize - 1))
                sum[i] = biggerNum[i] + smallerNum[i - (biggerSize - smallerSize)];
            else
                sum[i] = biggerNum[i];
        return sum;
    }

    private static int[] findSumCondition(int fstSize, int secSize, int sumSize,
                                          int[] fstNumArr, int[] secNumArr) {
        if (fstSize > secSize)
            return findSum(fstSize, secSize, sumSize, fstNumArr, secNumArr);
        else
            return findSum(secSize, fstSize, sumSize, secNumArr, fstNumArr);
    }

    private static int[] addOnes(int sumSize, int[] sum) {
        int one = 0;
        for (int i = (sumSize - 1); i > 0; i--) {
            sum[i] += one;
            if (sum[i] > MAX) {
                one = 1;
                sum[i] -= 10;
            }
            else
                one = 0;
        }
        sum[0] += one;
        return sum;
    }

    private static int[] addPosition(int sumSize, int[] sum) {
        if (sum[0] > MAX) {
            int[] sumNew = new int[sumSize];
            for (int i = (sumSize - 2); i > -1; i--)
                sumNew[i + 1] = sum[i];
            sumNew[1] = sum[0] - 10;
            sumNew[0] = 1;
            return sumNew;
        }
        else return sum;
    }

    private static void outputArray(int numSize, int sumSize, int[] arr) {
        for (int i = 0; i < (sumSize - numSize + 1); i++)
            System.out.print(" ");
        for (int i = 0; i < numSize; i++)
            System.out.print(arr[i]);
        System.out.println();
    }

    private static void outputSum(int fstSize, int secSize, int sumSize,
                                  int[] fstNumArr, int[] secNumArr, int[] sum) {
        System.out.println("Результат: ");
        outputArray(fstSize, sumSize, fstNumArr);
        System.out.println("+");
        outputArray(secSize, sumSize, secNumArr);
        System.out.println("-------");
        outputArray(sumSize, sumSize, sum);
    }

    public static void main(String[] args) {
        final Scanner scan = new Scanner(System.in);
        int fstNum = 0;
        int secNum = 0;
        int fstSize = 0;
        int secSize = 0;
        int sumSize = 0;
        writeCondition();
        fstNum = inputNum(1, scan);
        secNum = inputNum(2, scan);
        scan.close();
        fstSize = findNumSize(fstNum);
        secSize = findNumSize(secNum);
        int[] fstNumArr = convertToArray(fstNum, fstSize);
        int[] secNumArr = convertToArray(secNum, secSize);
        sumSize = findSumSize(fstSize, secSize);
        int[] sum = findSumCondition(fstSize, secSize, sumSize, fstNumArr,
                secNumArr);
        sum = addOnes(sumSize, sum);
        if (sum[0] > MAX)
            sumSize++;
        sum = addPosition(sumSize, sum);
        outputSum(fstSize, secSize, sumSize, fstNumArr, secNumArr, sum);
    }
}