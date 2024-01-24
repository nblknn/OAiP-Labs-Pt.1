import java.util.Scanner;

public class lab12{

    public static void main(String[] args){

        Scanner scan=new Scanner(System.in);
        final int LIMIT = 12;
        int n = 0, m = 0, placements = 0;
        boolean isIncorrect;

        System.out.println ("Данная программа вычисляет число размещений из N по M.");
        do {
            isIncorrect = false;
            System.out.println("Условия ввода: N и M натуральные числа, N больше M, N и M меньше 12.");
            try {
                System.out.print("Введите N: ");
                n = Integer.parseInt(scan.nextLine());
                System.out.print("Введите M: ");
                m = Integer.parseInt(scan.nextLine());
            }
            catch (NumberFormatException e) {
                System.out.println("Введенные данные не соответствуют условию. Повторите попытку.");
                isIncorrect = true;
            }
            if (!isIncorrect && ((n < m + 1) || (n < 1) || (m < 1) || (n > LIMIT) || (m > LIMIT))) {
                System.out.println("Введенные данные не соответствуют условию. Повторите попытку.");
                isIncorrect = true;
            }
            } while (isIncorrect);
        scan.close();
        placements = n;
        int temp = n - m;

        for (int i = n - 1; i >temp; i--)
        {
            n--;
            placements = placements * n;
        }
        System.out.println ("Число размещений равно " + placements);
    }
}