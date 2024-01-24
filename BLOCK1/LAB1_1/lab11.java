import java.util.Scanner;

public class lab11 {

    public static void main(String[] args){

        Scanner scan=new Scanner(System.in);
        int x = 0, y = 0;
        boolean isIncorrect;
        System.out.println("Данная программа определяет, принадлежит ли точка замкнутому множеству D.");
        System.out.println("Условия принадлежности множеству: X+Y<=1; 2*X-Y<=1; Y>=0.");
        do {
            isIncorrect = false;
            System.out.println("Введите координаты точки: X и Y являются целыми числами.");
            try {
                x = Integer.parseInt(scan.nextLine());
                y = Integer.parseInt(scan.nextLine());
            }
            catch (NumberFormatException e) {
                System.out.println("Введенные данные не соответствуют условию. Повторите попытку.");
                isIncorrect = true;
            }
        } while (isIncorrect);
        scan.close();
        if ((x + y < 2)
                && (2 * x - y < 2)
                && (y > -1))
            System.out.println("Точка принадлежит множеству D.");
        else
            System.out.println("Точка не принадлежит множеству D.");
    }
}