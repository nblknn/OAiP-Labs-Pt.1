import java.util.Scanner;
import java.io.*;

public class main {

    static final int MINSIZE = 2;
    static final int MAXSIZE = 10;
    static final int MIN = -1000;
    static final int MAX = 1000;


    private static int checkInput(final int MINNUM, final int MAXNUM, String outputMessage, Scanner scan) {
        int num = 0;
        boolean isIncorrect;
        do {
            isIncorrect = false;
            System.out.print(outputMessage);
            try {
                num = Integer.parseInt(scan.nextLine());
            }
            catch (NumberFormatException e){
                System.out.println("Введенные данные не соответствуют условию. Повторите попытку.");
                isIncorrect = true;
            }
            if (!isIncorrect && ((num < MINNUM) || (num > MAXNUM))) {
                isIncorrect = true;
                System.out.println("Введенные данные не соответствуют условию. Повторите попытку.");
            }
        } while (isIncorrect);
        return num;
    }

    private static int[][] inputMatrix(int rowNum, int colNum, Scanner scan) {
        boolean isIncorrect;
        int[][] matrix = new int[rowNum][colNum];
        for (int i = 0; i < rowNum; i++)
            for (int j = 0; j < colNum; j++) {
                System.out.print("Введите элемент " + (i + 1) + " строки, " + (j + 1) + " столбца матрицы : ");
                matrix[i][j] = checkInput(MIN, MAX, "", scan);
            }
        System.out.println();
        return matrix;
    }

    private static int[][] fillMatrixFromConsole(Scanner scan) {
        int rowNum = 0;
        int colNum = 0;
        System.out.println("Введите размеры матрицы (от 2 до 10).");
        rowNum = checkInput(MINSIZE, MAXSIZE, "Введите количество строк матрицы: ", scan);
        colNum = checkInput(MINSIZE, MAXSIZE, "Введите количество столбцов матрицы: ", scan);
        int[][] matrix = inputMatrix(rowNum, colNum, scan);
        return matrix;
    }
    private static boolean checkFilePath(String path, File file) {
        boolean isIncorrect = false;
        if (!file.exists()) {
            System.out.println("Введенного файла не существует. Повторите попытку.");
            isIncorrect = true;
        }
        else if (!path.endsWith(".txt")) {
            System.out.println("Введенный Вами файл не является текстовым. Повторите попытку.");
            isIncorrect = true;
        }
        return isIncorrect;
    }

    private static String checkFileInputPath(Scanner scan) {
        String path;
        boolean isIncorrect;
        do {
            isIncorrect = false;
            System.out.println("Введите путь к файлу, содержащему матрицу. Первой строкой должны быть введены размеры (строки и столбцы, от 2 до 10).");
            path = scan.nextLine();
            File file = new File(path);
            isIncorrect = checkFilePath(path, file);
        } while (isIncorrect);
        return path;
    }

    private static int[][] fillMatrixFromFile(String path, Scanner scan) {
        int rowNum = 0;
        int colNum = 0;
        boolean isIncorrect;
        int[][] matrix = new int[rowNum][colNum];
        do {
            isIncorrect = false;
            try (Scanner scanFile = new Scanner(new FileReader(path))) {
             //   Scanner scanFile = new Scanner(br);
                rowNum = scanFile.nextInt();
                colNum = scanFile.nextInt();
                if (!isIncorrect && (rowNum < MIN || rowNum > MAX || colNum < MIN || colNum > MAX))
                {
                    System.out.println("Размер в выбранном файле не соответствуют условию. Повторите попытку.");
                    isIncorrect = true;
                }
                matrix = new int[rowNum][colNum];
                for (int i = 0; i < rowNum; i++)
                    for (int j = 0; j < colNum; j++) {
                        matrix[i][j] = scanFile.nextInt();
                        if (!isIncorrect && ((matrix[i][j] < MIN) || (matrix[i][j] > MAX))) {
                            System.out.println("Данные выбранного файла не соответствуют условию. Повторите попытку.");
                            isIncorrect = true;
                        }
                    }
                if (!isIncorrect && scanFile.hasNext()) {
                    System.out.println("Размер введенной матрицы не соответствует заданному. Повторите попытку.");
                    isIncorrect = true;
                }
                //scanFile.close();
            } catch (Exception e) {
                System.out.println("Данные выбранного файла не соответствуют условию. Повторите попытку.");
                isIncorrect = true;
            }
            if (isIncorrect)
                path = checkFileInputPath(scan);
        } while (isIncorrect);
        System.out.println("Данные из файла успешно считаны.");
        System.out.println();
        return matrix;
    }

    private static void outputMatrix(int[][] matrix) {
        System.out.println("Введенная матрица:");
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix[0].length; j++)
                System.out.print(matrix[i][j] + " ");
            System.out.println();
        }
        System.out.println();
    }

    private static int[] findZeroAmountOfEachRow(int[][] matrix) {
        int[] zeroAmount = new int[matrix.length];
        for (int i = 0; i < matrix.length; i++) {
            zeroAmount[i] = 0;
            for (int j = 0; j < matrix[0].length; j++)
                if (matrix[i][j] == 0)
                    zeroAmount[i]++;
        }
        return zeroAmount;
    }

    private static int findMaxZeroAmount(int[] zeroAmount) {
        int maxZeroAmount = zeroAmount[0];
        for (int i = 1; i < zeroAmount.length; i++)
            if (zeroAmount[i] > maxZeroAmount)
                maxZeroAmount = zeroAmount[i];
        return maxZeroAmount;
    }

    private static int findNumOfMaxZeroRows(int maxZeroAmount, int[] zeroAmount) {
        int maxZeroRows = 0;
        for (int i = 0; i < zeroAmount.length; i++)
            if (zeroAmount[i] == maxZeroAmount)
                maxZeroRows++;
        return maxZeroRows;
    }

    private static int findMaxZeroRowIndex(int maxZeroAmount, int[] zeroAmount) {
        int index = 0;
        for (int i = 0; i < zeroAmount.length; i++)
            if (zeroAmount[i] == maxZeroAmount)
                index = i;
        return index;
    }

    private static int[] findMaxZeroRowIndexArray(int maxZeroRows, int maxZeroAmount, int[] zeroAmount) {
        int[] indexArray = new int[maxZeroRows];
        int j = 0;
        for (int i = 0; i < zeroAmount.length; i++)
            if (zeroAmount[i] == maxZeroAmount) {
                indexArray[j] = i;
                j++;
            }
        return indexArray;
    }

    private static String checkFileOutputPath(Scanner scan) {
        String path;
        boolean isIncorrect;
        do {
            isIncorrect = false;
            System.out.println("Введите путь к файлу, в который нужно записать результат.");
            path = scan.nextLine();
            File file = new File(path);
            isIncorrect = checkFilePath(path, file);
            if (!isIncorrect & !file.canWrite()) {
                System.out.println("Введенный Вами файл доступен только для чтения. Повторите попытку.");
                isIncorrect = true;
            }
        } while (isIncorrect);
        System.out.println();
        return path;
    }

    private static void writeResultIntoFile(int maxZeroAmount, int maxZeroRows, int index, int[] indexArray, int[][] matrix, String path, Scanner scan) {
        boolean isIncorrect;
        do {
            isIncorrect = false;
            try (FileWriter fw = new FileWriter(new File(path))) {
                if (maxZeroAmount == 0)
                    fw.write("В матрице нет строк с нулевыми элементами.");
                else if (maxZeroRows == 1) {
                    fw.write("Строка с максимальным количеством нулевых элементов: ");
                    for (int j = 0; j < matrix.length; j++)
                        fw.write(matrix[index][j] + " ");
                }
                else if ((maxZeroRows == matrix.length) && (maxZeroAmount == matrix[0].length))
                    fw.write("Все элементы матрицы - нулевые элементы.");
                else {
                    fw.write("Строки с максимальным количеством нулевых элементов: \n");
                    for (int i = 0; i < maxZeroRows; i++) {
                        for (int j = 0; j < matrix[0].length; j++)
                            fw.write(matrix[indexArray[i]][j] + " ");
                        fw.write("\n");
                    }
                }
            } catch (Exception e) {
                System.out.println("Произошла ошибка. Повторите попытку.");
                isIncorrect = true;
            }
            if (isIncorrect)
                path = checkFileOutputPath(scan);
        } while (isIncorrect);
        System.out.println("Результат записан.");
    }

    private static void outputMaxZeroRow(int index, int[][] matrix) {
        System.out.print("Строка с максимальным количеством нулевых элементов: ");
        for (int j = 0; j < matrix[0].length; j++)
            System.out.print(matrix[index][j] + " ");
    }

    private static void outputMaxZeroRows(int maxZeroRows, int[] indexArray, int[][] matrix) {
        System.out.println("Строки с максимальным количеством нулевых элементов:");
        for (int i = 0; i < maxZeroRows; i++) {
            for (int j = 0; j < matrix[0].length; j++)
                System.out.print(matrix[indexArray[i]][j] + " ");
            System.out.println();
        }
    }

    private static void outputResult(int maxZeroAmount, int maxZeroRows, int index, int[] indexArray, int[][] matrix) {
        System.out.println();
        if (maxZeroAmount == 0)
            System.out.println("В матрице нет строк с нулевыми элементами.");
        else if (maxZeroRows == 1)
            outputMaxZeroRow(index, matrix);
        else if ((maxZeroRows == matrix.length) && (maxZeroAmount == matrix[0].length))
            System.out.println("Все элементы матрицы - нулевые элементы.");
        else
            outputMaxZeroRows(maxZeroRows, indexArray, matrix);
    }

    private static int checkChoiceInput(String outputMessage, Scanner scan) {
        int num = 0;
        boolean isIncorrect;
        do {
            isIncorrect = false;
            System.out.println(outputMessage);
            try {
                num = Integer.parseInt(scan.nextLine());
            }
            catch (NumberFormatException e){
                System.out.println("Введенные данные не соответствуют условию. Повторите попытку.");
                isIncorrect = true;
            }
            if (!isIncorrect && (num != 0) && (num != 1)) {
                isIncorrect = true;
                System.out.println("Введенные данные не соответствуют условию. Повторите попытку.");
            }
        } while (isIncorrect);
        return num;
    }

    private static void writeCondition() {
        System.out.println("Данная программа находит строку матрицы, в которой больше всего нулевых элементов.");
        System.out.println("Элементы матрицы - целые числа от -1000 до 1000.");
    }

    public static void main(String[] args) {
        final Scanner scan = new Scanner(System.in);
        int choice = 0;
        int maxZeroAmount = 0;
        int maxZeroRows = 0;
        int index = 0;
        int[] indexArray = new int[0];
        int[][] matrix;
        writeCondition();
        choice = checkChoiceInput("Если Вы хотите вводить данные в консоль, введите 0. Если использовать файл, введите 1.", scan);
        if (choice == 0)
            matrix = fillMatrixFromConsole(scan);
        else {
            String finPath = checkFileInputPath(scan);
            matrix = fillMatrixFromFile(finPath, scan);
        }
        outputMatrix(matrix);
        int[] zeroAmount = findZeroAmountOfEachRow(matrix);
        maxZeroAmount = findMaxZeroAmount(zeroAmount);
        maxZeroRows = findNumOfMaxZeroRows(maxZeroAmount, zeroAmount);
        if (maxZeroRows == 1)
            index = findMaxZeroRowIndex(maxZeroAmount, zeroAmount);
        else
            indexArray = findMaxZeroRowIndexArray(maxZeroRows, maxZeroAmount, zeroAmount);
        choice = checkChoiceInput("Если Вы хотите вывести результат в консоль, введите 0. Если в файл, введите 1.", scan);
        if (choice == 0)
            outputResult(maxZeroAmount, maxZeroRows, index, indexArray, matrix);
        else {
            String foutPath = checkFileOutputPath(scan);
            writeResultIntoFile(maxZeroAmount, maxZeroRows, index, indexArray, matrix, foutPath, scan);
        }
        scan.close();
    }
}
