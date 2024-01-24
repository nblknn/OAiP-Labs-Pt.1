import java.util.Scanner;

public class Main {
    public static void main(String[] args) {

        final int MIN = 5;
        final int MAX = 15;
        final int MINMARK = 0;
        final int MAXMARK = 10;
        final int MINSUCCESS = 3;

        Scanner scan=new Scanner(System.in);
        int num = 0;
        boolean isIncorrect;
        boolean isSuccessful;
        System.out.println ("Данная программа определяет, является ли студент неуспевающим.");
        System.out.println ("Неуспевающим считается студент, имеющий оценки ниже 4.");
        do {
            isIncorrect = false;
            try {
                System.out.println("Введите количество оценок студента (от 5 до 15).");
                num = Integer.parseInt(scan.nextLine());
            }
            catch (NumberFormatException e){
                System.out.println("Введенные данные не соответствуют условию. Повторите попытку.");
                isIncorrect = true;
            }
            if (!isIncorrect & ((num > MAX) | (num < MIN))) {
                System.out.println("Введенные данные не соответствуют условию. Повторите попытку.");
                isIncorrect = true;
            }
        }while (isIncorrect);
        System.out.println ("Введите оценки студента (от 0 до 10).");
        int marks[] = new int[num];
        for (int i=0; i<num; i++) {
            do {
                isIncorrect = false;
                try {
                    System.out.print ("Введите " + (i + 1) + " оценку студента: ");
                    marks[i] = Integer.parseInt(scan.nextLine());
                }
                catch (NumberFormatException e){
                    System.out.println("Введенные данные не соответствуют условию. Повторите попытку.");
                    isIncorrect = true;
                }
                if (!isIncorrect & ((marks[i] > MAXMARK) | (marks[i] < MINMARK))){
                    System.out.println("Введенные данные не соответствуют условию. Повторите попытку.");
                    isIncorrect = true;
                }
            }while (isIncorrect);
        }
        scan.close();
        isSuccessful = true;
        int i = 0;
        while (isSuccessful & (i < num)) {
            isSuccessful = (marks[i] > MINSUCCESS);
            i++;
        }
        if (isSuccessful)
            System.out.println("Студент является успевающим.");
        else
            System.out.println("Студент является неуспевающим.");
    }
}
