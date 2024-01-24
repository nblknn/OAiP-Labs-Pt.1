import java.util.Scanner;
import java.io.*;

public class Main {

    static final int MINSIZE = 3;
    static final int MAXSIZE = 20;
    static final int MINPOINT = 0;
    static final int MAXPOINT = 100;
    static final int MAXSURNAMELENGTH = 30;

    record participant (String surname, int points) {};

    private static void writeCondition() {
        System.out.println("Данная программа упорядочивает список участников с их баллами на соревновании.");
    }

    private static boolean isNumRangeIncorrect(final int MIN, final int MAX, int num, String errorMessage) {
        boolean isIncorrect;
        isIncorrect = false;
        if ((num < MIN) || (num > MAX)) {
            System.out.println(errorMessage);
            isIncorrect = true;
        }
        return isIncorrect;
    }

    private static int inputNum(final int MIN, final int MAX, String outputMessage, Scanner scan) {
        int num;
        num = 0;
        boolean isIncorrect;
        do {
            isIncorrect = false;
            System.out.print(outputMessage);
            try {
                num = Integer.parseInt(scan.nextLine());
            }
            catch (NumberFormatException e){
                System.out.println("Введенное значение должно быть целым числом! Повторите попытку.");
                isIncorrect = true;
            }
            if (!isIncorrect)
                isIncorrect = isNumRangeIncorrect(MIN, MAX, num, "Диапазон введенного числа не соответствует условию! Повторите попытку.");
        } while (isIncorrect);
        return num;
    }

    private static boolean isSurnameIncorrect(String surname) {
        boolean isIncorrect;
        isIncorrect = false;
        if (surname.isEmpty() || (surname.length() > MAXSURNAMELENGTH)) {
            isIncorrect = true;
            System.out.println("Фамилия должна содержать от 1 до 30 символов! Повторите попытку.");
        }
        return isIncorrect;
    }

    private static String inputSurname(int i, Scanner scan) {
        String surname;
        do {
            System.out.print("Введите фамилию " + i + 1 + " участника: ");
            surname = scan.nextLine();
        } while (isSurnameIncorrect(surname));
        return surname;
    }

    private static participant[] getListFromConsole(int listSize, Scanner scan) {
        participant[] list = new participant[listSize];
        String surname;
        int points;
        points = 0;
        System.out.println("Условия ввода: фамилия участника должна быть не длиннее 30 символов, количество баллов - целое число от 0 до 100.");
        for (int i = 0; i < listSize; i++) {
            surname = inputSurname(i, scan);
            points = inputNum(MINPOINT, MAXPOINT, "Введите количество баллов участника: ", scan);
            list[i] = new participant(surname, points);
        }
        return list;
    }

    private static boolean isFilePathIncorrect(String path, File file) {
        boolean isIncorrect;
        isIncorrect = false;
        if (!file.exists()) {
            System.out.println("Введенного файла не существует. Повторите попытку.");
            isIncorrect = true;
        }
        else
        if (!path.endsWith(".txt")) {
            System.out.println("Введенный Вами файл не является текстовым. Повторите попытку.");
            isIncorrect = true;
        }
        return isIncorrect;
    }

    private static String checkFileInputPath(Scanner scan) {
        String path;
        File file;
        do {
            System.out.println("\nУсловия: в первой строке должно быть записано количество участников (от 3 до 20).");
            System.out.println("В строках с участниками сначала записывается фамилия (до 30 символов), затем количество набранных баллов (целое число от 0 до 100).");
            System.out.println("Введите путь к файлу, содержащему список участников.");
            path = scan.nextLine();
            file = new File(path);
        } while (isFilePathIncorrect(path, file));
        return path;
    }

    private static participant[] getListFromFile(String path, Scanner scan) {
        int listSize;
        listSize = 0;
        int points;
        points = 0;
        String surname;
        participant[] list = new participant[0];
        boolean isIncorrect;
        do {
            isIncorrect = false;
            try (Scanner scanFile = new Scanner(new FileReader(path))) {
                listSize = scanFile.nextInt();
                isIncorrect = isNumRangeIncorrect(MINSIZE, MAXSIZE, listSize, "Размер, записанный в файле, не соответствует диапазону. Повторите попытку.");
                list = new participant[listSize];
                int i = 0;
                while ((!isIncorrect) && (i < (listSize))) {
                    surname = scanFile.next();
                    isIncorrect = isSurnameIncorrect(surname);
                    if (!isIncorrect) {
                        points = scanFile.nextInt();
                        isIncorrect = isNumRangeIncorrect(MINPOINT, MAXPOINT, points, "Баллы, записанные в файле, не соответстуют диапазону. Повторите попытку.");
                    }
                    list[i] = new participant(surname, points);
                    i++;
                }
                if (!isIncorrect && scanFile.hasNext()) {
                    System.out.println("Количество участников не совпадает с записанным в файле размером. Повторите попытку.");
                    isIncorrect = true;
                }
            } catch (Exception e){
                System.out.println("Данные выбранного файла не соответствуют условию. Повторите попытку.");
                isIncorrect = true;
            }
            if (isIncorrect)
                path = checkFileInputPath(scan);
        } while (isIncorrect);
        System.out.println("Данные из файла успешно считаны.");
        return list;
    }

    private static participant[] inputList(Scanner scan) {
        int choice;
        int listSize;
        choice = 0;
        listSize = 0;
        participant[] list;
        choice = inputNum(0, 1, "Если Вы хотите вводить данные в консоль, введите 0. Если использовать файл, введите 1: ", scan);
        if (choice == 0) {
            listSize = inputNum(MINSIZE, MAXSIZE, "Введите количество участников (от 3 до 20): ", scan);
            list = getListFromConsole(listSize, scan);
        }
        else {
            String finPath;
            finPath = checkFileInputPath(scan);
            list = getListFromFile(finPath, scan);
        }
        return list;
    }

    private static participant[] swapElements(participant[] list, int i) {
        participant temp;
        temp = list[i];
        list[i] = list[i - 1];
        list[i - 1] = temp;
        return list;
    }

    private static participant[] sortList(participant[] list) {
        for (int i = 1; i < list.length; i++)
            for (int j = 1; j < list.length; j++)
                if (list[j].points > list[j - 1].points)
                    list = swapElements(list, j);
                else if (list[j].points == list[j - 1].points) {
                    int compare;
                    compare = list[j].surname.compareToIgnoreCase(list[j - 1].surname);
                    if (compare < 0)
                        list = swapElements(list, j);
                }
        return list;
    }

    private static void outputList(participant[] list, String listName) {
        System.out.println("\n" + listName);
        for (int i = 0; i < list.length; i++)
            System.out.println(list[i].surname + " " + list[i].points);
        System.out.println();
    }

    private static String checkFileOutputPath(Scanner scan) {
        String path;
        boolean isIncorrect;
        do {
            isIncorrect = false;
            System.out.println("Введите путь к файлу, в который нужно записать результат.");
            path = scan.nextLine();
            File file = new File(path);
            isIncorrect = isFilePathIncorrect(path, file);
            if (!isIncorrect & !file.canWrite()) {
                System.out.println("Введенный Вами файл доступен только для чтения. Повторите попытку.");
                isIncorrect = true;
            }
        } while (isIncorrect);
        return path;
    }

    private static void writeResultIntoFile(participant[] list, String path, Scanner scan) {
        boolean isIncorrect;
        do {
            isIncorrect = false;
            try (FileWriter fw = new FileWriter(new File(path))) {
                for (int i = 0; i < list.length; i++)
                    fw.write(list[i].surname + " " + list[i].points + "\n");
            } catch (Exception e) {
                System.out.println("Произошла ошибка. Повторите попытку.");
                isIncorrect = true;
            }
            if (isIncorrect)
                path = checkFileOutputPath(scan);
        } while (isIncorrect);
        System.out.println("Результат записан.");
    }

    private static void outputResult(participant[] sortedList, Scanner scan) {
        int choice;
        choice = 0;
        choice = inputNum(0, 1, "Если нужно вывести результат в консоль, введите 0. Если в файл, введите 1: ", scan);
        if (choice == 0)
            outputList(sortedList, "Отсортированный список:");
        else {
            String foutPath;
            foutPath = checkFileOutputPath(scan);
            writeResultIntoFile(sortedList, foutPath, scan);
        }
    }

    public static void main(String[] args) {
        Scanner scan = new Scanner(System.in);
        participant[] list;
        participant[] sortedList;
        writeCondition();
        list = inputList(scan);
        outputList(list, "Введенный список:");
        sortedList = sortList(list);
        outputResult(sortedList, scan);
        scan.close();
    }
}
