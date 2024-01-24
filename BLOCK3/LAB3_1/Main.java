import java.util.Scanner;
import java.util.HashSet;
import java.io.*;

public class Main {

    static final HashSet<Character> NUMBERS = new HashSet<Character>();
    static final HashSet<Character> LETTERS = new HashSet<Character>();
    static final char OPENBRACE = '(';
    static final char CLOSEBRACE = ')';

    private static HashSet<Character> fillNumbersSet() {
        for (char i = '1'; i < ('9' + 1); i++)
            NUMBERS.add(i);
        return NUMBERS;
    }

    private static HashSet<Character> fillLettersSet() {
        for (char i = 'A'; i < ('Z' + 1); i++)
            LETTERS.add(i);
        for (char i = 'a'; i < ('z' + 1); i++)
            LETTERS.add(i);
        for (char i = 'А'; i < ('Я' + 1); i++)
            LETTERS.add(i);
        for (char i = 'а'; i < ('я' + 1); i++)
            LETTERS.add(i);
        LETTERS.add('Ё');
        LETTERS.add('ё');
        return LETTERS;
    }

    private static void writeCondition() {
        System.out.println("Данная программа в каждом четном слове текста заменяет все буквы на прописные,\nа каждое нечетное слово заключает в круглые скобки.");
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
        System.out.println();
        return num;
    }

    private static boolean isTextIncorrect(String text) {
        boolean isIncorrect;
        isIncorrect = true;
        if (text.isEmpty())
            System.out.println("В тексте нет символов. Повторите попытку.");
        else {
            int i = 0;
            while (isIncorrect && (i < text.length())) {
                if (LETTERS.contains(text.charAt(i)))
                    isIncorrect = false;
                i++;
            }
            if (isIncorrect)
                System.out.println("В тексте нет букв. Повторите попытку.");
        }
        return isIncorrect;
    }

    private static String inputTextFromConsole(Scanner scan) {
        String text;
        do {
            System.out.println("Введите текст.");
            text = scan.nextLine();
        } while (isTextIncorrect(text));
        return text;
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
            System.out.println("Введите путь к файлу, содержащему текст.");
            path = scan.nextLine();
            file = new File(path);
        } while (isFilePathIncorrect(path, file));
        return path;
    }

    private static String getTextFromFile(String path, Scanner scan) {
        boolean isIncorrect;
        String line;
        String text;
        File file = new File(path);
        text = "";
        do {
            isIncorrect = false;
            try (Scanner scanFile = new Scanner(new FileReader(path))) {
                while (scanFile.hasNext()) {
                    line = scanFile.nextLine();
                    text += line;
                }
            } catch (Exception e){
                System.out.println("Данные выбранного файла не соответствуют условию. Повторите попытку.");
                isIncorrect = true;
            }
            if (!isIncorrect)
                isIncorrect = isTextIncorrect(text);
            if (isIncorrect) {
                path = checkFileInputPath(scan);
                text = "";
            }
        } while (isIncorrect);
        System.out.println("Данные из файла успешно считаны.");
        System.out.println();
        return text;
    }

    private static String inputText(Scanner scan) {
        int choice;
        String text;
        choice = 0;
        choice = checkChoiceInput("Если Вы хотите вводить данные в консоль, введите 0. Если использовать файл, введите 1.", scan);
        if (choice == 0)
            text = inputTextFromConsole(scan);
        else {
            String finPath = checkFileInputPath(scan);
            text = getTextFromFile(finPath, scan);
            System.out.println("Введенный текст:\n" + text);
        }
        return text;
    }
    private static String formatWord(int count, String word, String resultText) {
        if (count % 2 != 0)
            resultText += OPENBRACE + word + CLOSEBRACE;
        else {
            word = word.toUpperCase();
            resultText += word;
        }
        return resultText;
    }

    private static String formatText(String text) {
        int count;
        String word;
        String resultText;
        count = 1;
        word = "";
        resultText = "";
        for (int i = 0; i < text.length(); i++)
            if (LETTERS.contains(text.charAt(i)) || NUMBERS.contains(text.charAt(i)))
                word += text.charAt(i);
            else
            if (word != "") {
                resultText = formatWord(count, word, resultText) + text.charAt(i);
                word = "";
                count++;
            }
            else
                resultText += text.charAt(i);
        if (word != "")
            resultText = formatWord(count, word, resultText);
        return resultText;
    }

    private static String checkFileOutputPath(Scanner scan) {
        String path;
        boolean isIncorrect;
        do {
            isIncorrect = false;
            System.out.println("Введите путь к файлу, в который нужно записать результат.");
            path = String.format(scan.nextLine());
            File file = new File(path);
            isIncorrect = isFilePathIncorrect(path, file);
            if (!isIncorrect & !file.canWrite()) {
                System.out.println("Введенный Вами файл доступен только для чтения. Повторите попытку.");
                isIncorrect = true;
            }
        } while (isIncorrect);
        System.out.println();
        return path;
    }

    private static void writeResultIntoFile(String resultText, String path, Scanner scan) {
        boolean isIncorrect;
        do {
            isIncorrect = false;
            try (FileWriter fw = new FileWriter(new File(path))) {
                fw.write(resultText);
            } catch (Exception e) {
                System.out.println("Произошла ошибка. Повторите попытку.");
                isIncorrect = true;
            }
            if (isIncorrect)
                path = checkFileOutputPath(scan);
        } while (isIncorrect);
        System.out.println("Результат записан.");
    }

    private static void outputText(String resultText, Scanner scan) {
        int choice;
        choice = 0;
        choice = checkChoiceInput("\nЕсли Вы хотите вывести результат в консоль, введите 0. Если в файл, введите 1.", scan);
        if (choice == 0)
            System.out.println("Результат:\n" + resultText);
        else {
            String foutPath = checkFileOutputPath(scan);
            writeResultIntoFile(resultText, foutPath, scan);
        }
    }

    public static void main(String[] args) {
        Scanner scan = new Scanner(System.in);
        String text;
        String resultText;
        fillNumbersSet();
        fillLettersSet();
        writeCondition();
        text = inputText(scan);
        resultText = formatText(text);
        outputText(resultText, scan);
        scan.close();
    }
}