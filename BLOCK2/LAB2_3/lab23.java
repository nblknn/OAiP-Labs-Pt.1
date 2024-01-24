import java.util.Scanner;
import java.io.*;

public class lab23 {

    static final int MINSIZE = 2;
    static final int MAXSIZE = 10;
    static final int MIN = -1000;
    static final int MAX = 1000;


    private static int inputSize(String outputMessage, Scanner scan) {
        int size = 0;
        boolean isIncorrect;
        do {
            isIncorrect = false;
            System.out.print(outputMessage);
            try {
                size = Integer.parseInt(scan.nextLine());
            }
            catch (NumberFormatException e){
                System.out.println("Введенные данные не соответствуют условию. Повторите попытку.");
                isIncorrect = true;
            }
            if (!isIncorrect && ((size < MINSIZE) || (size > MAXSIZE))) {
                isIncorrect = true;
                System.out.println("Введенные данные не соответствуют условию. Повторите попытку.");
            }
        } while (isIncorrect);
        return size;
    }

    private static int[][] inputMatrix(int rowNum, int colNum, Scanner scan) {
        boolean isIncorrect;
        int[][] matrix = new int[rowNum][colNum];
        for (int i = 0; i < rowNum; i++)
            for (int j = 0; j < colNum; j++)
                do {
                    isIncorrect = false;
                    System.out.print("Введите элемент " + (i + 1) + " строки, " +
                            (j + 1) + " столбца матрицы : ");
                    try {
                        matrix[i][j] = Integer.parseInt(scan.nextLine());
                    }
                    catch (NumberFormatException e){
                        System.out.println("Введенные данные не соответствуют условию. Повторите попытку.");
                        isIncorrect = true;
                    }
                    if (!isIncorrect && (matrix[i][j] < MIN || matrix[i][j] > MAX)) {
                        isIncorrect = true;
                        System.out.println("Введенные данные не соответствуют условию. Повторите попытку.");
                    }
                } while (isIncorrect);
        System.out.println();
        return matrix;
    }

    private static int[] inputVector(int size, String vectorOrMatrix, Scanner scan) {
        boolean isIncorrect;
        int[] vector = new int[size];
        for (int i = 0; i < size; i++)
            do {
                isIncorrect = false;
                System.out.print("Введите " + (i + 1) + " элемент " +
                        vectorOrMatrix + ": ");
                try {
                    vector[i] = Integer.parseInt(scan.nextLine());
                }
                catch (NumberFormatException e){
                    System.out.println("Введенные данные не соответствуют условию. Повторите попытку.");
                    isIncorrect = true;
                }
                if (!isIncorrect && (vector[i] < MIN || vector[i] > MAX)) {
                    isIncorrect = true;
                    System.out.println("Введенные данные не соответствуют условию. Повторите попытку.");
                }
            } while (isIncorrect);
        System.out.println();
        return vector;
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

    private static String checkFileInputPath(String matrixOrVector, Scanner scan) {
        String path;
        boolean isIncorrect;
        do {
            isIncorrect = false;
            System.out.println("Введите путь к файлу, содержащему " +
                    matrixOrVector + ".");
            path = String.format(scan.nextLine());
            File file = new File(path);
            isIncorrect = checkFilePath(path, file);
        } while (isIncorrect);
        return path;
    }

    private static int getSizeFromFile(String path, String matrixOrVector,
                                       Scanner scan) {
        int size = 0;
        boolean isIncorrect;
        do {
            isIncorrect = false;
            try (BufferedReader br = new BufferedReader(new FileReader(path))) {
                Scanner scanFile = new Scanner(br);
                size = scanFile.nextInt();
                scanFile.close();
            } catch (Exception e) {
                System.out.println("Данные выбранного файла не соответствуют условию. Повторите попытку.");
                isIncorrect = true;
            }
            if (!isIncorrect && (size < MINSIZE || size > MAXSIZE)) {
                System.out.println("Размер в выбранном файле не соответствуют условию. Повторите попытку.");
                isIncorrect = true;
            }
            if (isIncorrect)
                path = checkFileInputPath(matrixOrVector, scan);
        } while (isIncorrect);
        return size;
    }

    private static int[][] fillMatrixFromFile(String path, int rowNum, int colNum,
                                              Scanner scan) {
        boolean isIncorrect;
        int[][] matrix = new int[rowNum][colNum];
        do {
            isIncorrect = false;
            try (BufferedReader br = new BufferedReader(new FileReader(path))) {
                Scanner scanFile = new Scanner(br);
                scanFile.nextInt();
                for (int i = 0; i < rowNum; i++)
                    for (int j = 0; j < colNum; j++) {
                        matrix[i][j] = scanFile.nextInt();
                        if (!isIncorrect && ((matrix[i][j] < MIN) ||
                                (matrix[i][j] > MAX))) {
                            System.out.println("Данные выбранного файла не соответствуют условию. Повторите попытку.");
                            isIncorrect = true;
                        }
                    }
                if (!isIncorrect & scanFile.hasNext()) {
                    System.out.println("Размер введенной матрицы не соответствует заданному. Повторите попытку.");
                            isIncorrect = true;
                }
                scanFile.close();
            } catch (Exception e) {
                System.out.println("Данные выбранного файла не соответствуют условию. Повторите попытку.");
                        isIncorrect = true;
            }
            if (isIncorrect)
                path = checkFileInputPath("матрицу", scan);
        } while (isIncorrect);
        System.out.println("Данные из файла успешно считаны.");
        System.out.println();
        return matrix;
    }

    private static int[] fillVectorFromFile(int size, String path, String
            matrixOrVector, Scanner scan) {
        boolean isIncorrect;
        int[] vector = new int[size];
        do {
            isIncorrect = false;
            try (BufferedReader br = new BufferedReader(new FileReader(path))) {
                Scanner scanFile = new Scanner(br);
                scanFile.nextInt();
                for (int i = 0; i < size; i++) {
                    vector[i] = scanFile.nextInt();
                    if (!isIncorrect && ((vector[i] < MIN) || (vector[i] > MAX))) {
                        System.out.println("Данные выбранного файла не соответствуют условию. Повторите попытку.");
                                isIncorrect = true;
                    }
                }
                if (!isIncorrect & scanFile.hasNext()) {
                    System.out.println("Размер введенного вектора/матрицы не соответствует заданному. Повторите попытку.");
                            isIncorrect = true;
                }
                scanFile.close();
            } catch (Exception e) {
                System.out.println("Данные выбранного файла не соответствуют условию. Повторите попытку.");
                        isIncorrect = true;
            }
            if (isIncorrect)
                path = checkFileInputPath(matrixOrVector, scan);
        } while (isIncorrect);
        System.out.println("Данные из файла успешно считаны.");
        System.out.println();
        return vector;
    }

    private static void outputMatrix(int rowNum, int colNum, int[][] matrix) {
        for (int i = 0; i < rowNum; i++) {
            for (int j = 0; j < colNum; j++)
                System.out.print(matrix[i][j] + " ");
            System.out.println();
        }
    }

    private static void outputVectorColumn(int size, int[] vector) {
        for (int i = 0; i < size; i++)
            System.out.println(vector[i]);
        System.out.println();
    }

    private static void outputVectorRow(int size, int[] vector) {
        for (int i = 0; i < size; i++)
            System.out.print(vector[i] + " ");
        System.out.println();
        System.out.println();
    }

    private static int[] findProductVector(int rowNum, int colNum, int[] vector,
                                           int[][] matrix) {
        int[] productVector = new int[colNum];
        for (int i = 0; i < colNum; i++) {
            productVector[i] = 0;
            for (int j = 0; j < rowNum; j++)
                productVector[i] = productVector[i] + (matrix[j][i] * vector[j]);
        }
        return productVector;
    }

    private static int[][] findProductMatrix(int rowNum, int colNum, int[] vector,
                                             int[] matrix) {
        int[][] productMatrix = new int[rowNum][colNum];
        for (int i = 0; i < rowNum; i++)
            for (int j = 0; j < colNum; j++)
                productMatrix[i][j] = matrix[j] * vector[i];
        return productMatrix;
    }

    private static String checkFileOutputPath(Scanner scan) {
        String path;
        boolean isIncorrect;
        System.out.println();
        do {
            isIncorrect = false;
            System.out.println("Введите путь к файлу, в который нужно записать результат.");
                    path = String.format(scan.nextLine());
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

    private static void writeVectorIntoFile(String path, int size,
                                            int[] productVector, Scanner scan) {
        boolean isIncorrect;
        do {
            isIncorrect = false;
            try (FileWriter fw = new FileWriter(new File(path))) {
                for (int i = 0; i < size; i++)
                    fw.write(productVector[i] + "\n");
            } catch (Exception e) {
                System.out.println("Произошла ошибка. Повторите попытку.");
                isIncorrect = true;
            }
            if (isIncorrect)
                path = checkFileOutputPath(scan);
        } while (isIncorrect);
        System.out.println("Результат записан.");
    }

    private static void writeMatrixIntoFile(String path, int rowNum, int colNum,
                                            int[][] productMatrix, Scanner scan) {
        boolean isIncorrect;
        do {
            isIncorrect = false;
            try (FileWriter fw = new FileWriter(new File(path))) {
                for (int i = 0; i < rowNum; i++) {
                    for (int j = 0; j < colNum; j++)
                        fw.write(productMatrix[i][j] + " ");
                    fw.write("\n");
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

    private static void outputVectors(int rowNum, int colNum, int[] vectorColumn,
                                      int[] vectorRow) {
        System.out.println("Введенный вектор:");
        outputVectorColumn(rowNum, vectorColumn);
        System.out.println("Введенная матрица:");
        outputVectorRow(colNum, vectorRow);
    }

    private static void outputVectorAndMatrix(int rowNum, int colNum,
                                              int[] vectorRow, int[][] matrix) {
        System.out.println("Введенный вектор:");
        outputVectorRow(rowNum, vectorRow);
        System.out.println("Введенная матрица:");
        outputMatrix(rowNum, colNum, matrix);
    }

    private static void inputFromConsole(int vectorType, Scanner scan) {
        int rowNum = 0;
        int colNum = 0;
        rowNum = inputSize("Введите размер вектора (от 2 до 10): ", scan);
        int[] vector = inputVector(rowNum, "вектора", scan);
        colNum = inputSize("Введите количество столбцов матрицы (от 2 до 10): ",
                scan);
        if (vectorType == 0) {
            int[] vectorRow = inputVector(colNum, "матрицы", scan);
            outputVectors(rowNum, colNum, vector, vectorRow);
            int[][] productMatrix = findProductMatrix(rowNum, colNum, vector,
                    vectorRow);
            System.out.println("Результат произведения вектора и матрицы:");
            outputMatrix(rowNum, colNum, productMatrix);
        }
        else {
            System.out.println("Количество строк матрицы равно " + rowNum + ".");
            int[][] matrix = inputMatrix(rowNum, colNum, scan);
            outputVectorAndMatrix(rowNum, colNum, vector, matrix);
            int[] productVector = findProductVector(rowNum, colNum, vector, matrix);
            System.out.println("Результат произведения вектора и матрицы:");
            outputVectorRow(colNum, productVector);
        }
    }

    private static void inputFromFile(int vectorType, Scanner scan) {
        int rowNum = 0;
        int colNum = 0;
        String finPathVector;
        String finPathMatrix;
        String foutPath;
        System.out.println("В первой строке файла должны быть записаны размеры (от 2 до 10).");
        finPathVector = checkFileInputPath("вектор", scan);
        rowNum = getSizeFromFile(finPathVector, "вектор", scan);
        int[] vector = fillVectorFromFile(rowNum, finPathVector, "вектор", scan);
        if (vectorType == 1)
            System.out.println("Количество строк матрицы равно " + rowNum + ". В первой строке файла введите количество столбцов.");
                    finPathMatrix = checkFileInputPath("матрицу", scan);
        colNum = getSizeFromFile(finPathMatrix, "матрицу", scan);
        if (vectorType == 0) {
            int[] vectorRow = fillVectorFromFile(colNum, finPathMatrix, "матрицу (вектор-строку)", scan);
            outputVectors(rowNum, colNum, vector, vectorRow);
            int[][] productMatrix = findProductMatrix(rowNum, colNum, vector,
                    vectorRow);
            foutPath = checkFileOutputPath(scan);
            writeMatrixIntoFile(foutPath, rowNum, colNum, productMatrix, scan);
        }
        else {
            int[][] matrix = fillMatrixFromFile(finPathMatrix, rowNum, colNum, scan);
            outputVectorAndMatrix(rowNum, colNum, vector, matrix);
            int[] productVector = findProductVector(rowNum, colNum, vector, matrix);
            foutPath = checkFileOutputPath(scan);
            writeVectorIntoFile(foutPath, colNum, productVector, scan);
        }
    }

    private static int checkChoiceInput(Scanner scan) {
        int num = 0;
        boolean isIncorrect;
        do {
            isIncorrect = false;
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

    private static int chooseVectorType(Scanner scan) {
        int vectorType = 0;
        System.out.println("Введите 0, если требуется умножить вектор-столбец на матрицу, и 1, если вектор-строку.");
                vectorType = checkChoiceInput(scan);
        if (vectorType == 0)
            System.out.println("Для умножения вектора-столбца на матрицу, матрица должна состоять из 1 строки.");
        else
            System.out.println("Для умножения вектора-строки на матрицу, число столбцов вектора должно совпадать с числом строк матрицы.");
        System.out.println();
        return vectorType;
    }

    private static void writeCondition() {
        System.out.println("Данная программа находит произведение вектора на матрицу.");
                System.out.println("Элементы вектора и матрицы - целые числа от -1000 до 1000.");
    }

    public static void main(String[] args) {
        final Scanner scan = new Scanner(System.in);
        int choice = 0;
        int vectorType = 0;
        writeCondition();
        System.out.println("Если Вы хотите вводить данные в консоль, введите 0. Если использовать файл, введите 1.");
        choice = checkChoiceInput(scan);
        vectorType = chooseVectorType(scan);
        if (choice == 0)
            inputFromConsole(vectorType, scan);
        else
            inputFromFile(vectorType, scan);
        scan.close();
    }
}