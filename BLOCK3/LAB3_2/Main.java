import java.util.Scanner;
import java.util.HashSet;
import java.io.*;

public class Main {
    static final HashSet<Integer> X1 = new HashSet<Integer>();
    static final HashSet<Integer> X2 = new HashSet<Integer>();
    static final int SETMAXELEMENT = 7;

    private static HashSet<Integer> addX1Elements(){
        for (int i = 1; i < SETMAXELEMENT; i++)
            X1.add(i);
        return X1;
    }

    private static HashSet<Integer> addX2Elements(){
        X2.add(1);
        for (int i = 3; i < SETMAXELEMENT; i++)
            X2.add(i);
        return X2;
    }

    private static void outputSet(HashSet<Integer> set, String setName) {
        System.out.print(setName + "{ ");
        for (int i : set)
            System.out.print(i + " ");
        System.out.println("}");
    }

    private static HashSet<Integer> findSumOfSets() {
        HashSet<Integer> y = new HashSet<Integer>();
        for (int i = 1; i < SETMAXELEMENT; i++)
            if (X1.contains(i) || X2.contains(i))
                y.add(i);
        return y;
    }

    private static HashSet<Integer> findSubSet(HashSet<Integer> y) {
        HashSet<Integer> y1 = new HashSet<Integer>();
        for (int i : y)
            if ((i % 2 == 0) && (i % 3 == 0))
                y1.add(i);
        return y1;
    }

    private static void writeCondition() {
        System.out.println("Данная программа формирует объединение двух множеств, и выделяет из него подмножество четных чисел, кратных 3.");
        System.out.println("Даны множества:");
        outputSet(X1, "X1: ");
        outputSet(X2, "X2: ");
    }

    private static int checkChoiceInput(Scanner scan) {
        int num = 0;
        boolean isIncorrect;
        do {
            isIncorrect = false;
            System.out.println("Если Вы хотите вывести результат в консоль, введите 0. Если в файл, введите 1.");
            try {
                num = Integer.parseInt(scan.nextLine());
            }
            catch (NumberFormatException e) {
                System.out.println("Введенные данные не соответствуют условию. Повторите попытку.");
                isIncorrect = true;
            }
            if ((!isIncorrect) && (num != 0) && (num != 1)) {
                isIncorrect = true;
                System.out.println("Введенные данные не соответствуют условию. Повторите попытку.");
            }
        } while (isIncorrect);
        return num;
    }

    private static String checkFilePath(Scanner scan) {
        String path;
        boolean isIncorrect;
        do {
            isIncorrect = false;
            System.out.println("Введите путь к файлу, в который нужно записать результат.");
                    path = scan.nextLine();
            File file = new File(path);
            if (!file.exists()) {
                System.out.println("Введенного файла не существует. Повторите попытку.");
                isIncorrect = true;
            }
            else
            if (!path.endsWith(".txt")) {
                System.out.println("Введенный Вами файл не является текстовым. Повторите попытку.");
                isIncorrect = true;
            }
            else
            if (!isIncorrect & !file.canWrite()) {
                System.out.println("Введенный Вами файл доступен только для чтения. Повторите попытку.");
                isIncorrect = true;
            }
        } while (isIncorrect);
        return path;
    }

    private static void writeSetIntoFile(HashSet<Integer> set, String setName, FileWriter fw) throws IOException {
        fw.write(setName + "{ ");
        for (int i : set)
            fw.write(i + " ");
        fw.write("}" + "\n");
    }

    private static void writeResultIntoFile(HashSet<Integer> y, HashSet<Integer> y1, String path, Scanner scan) {
        boolean isIncorrect;
        do {
            isIncorrect = false;
            try (FileWriter fw = new FileWriter(new File(path))) {
                writeSetIntoFile(y, "Полученное объединение множеств: ", fw);
                writeSetIntoFile(y1, "Полученное подмножество: ", fw);
            } catch (Exception e) {
                System.out.println("Произошла ошибка. Повторите попытку.");
                isIncorrect = true;
            }
            if (isIncorrect)
                path = checkFilePath(scan);
        } while (isIncorrect);
        System.out.println("Результат записан.");
    }

    public static void main(String[] args) {
        Scanner scan = new Scanner(System.in);
        int choice = 0;
        String foutPath;
        HashSet<Integer> y = new HashSet<Integer>();
        HashSet<Integer> y1 = new HashSet<Integer>();
        addX1Elements();
        addX2Elements();
        writeCondition();
        y = findSumOfSets();
        y1 = findSubSet(y);
        choice = checkChoiceInput(scan);
        if (choice == 0) {
            outputSet(y, "Полученное объединение множеств: ");
            outputSet(y1, "Полученное подмножество: ");
        }
        else {
            foutPath = checkFilePath(scan);
            writeResultIntoFile(y, y1, foutPath, scan);
        }
        scan.close();
    }
}