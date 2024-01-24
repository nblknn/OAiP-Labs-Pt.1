import java.util.Scanner;

public class lab13{

    public static void main(String[] args){

        Scanner scan=new Scanner(System.in);
        int fstNum = 0;
        int secNum = 0;
        int fstDen = 0;
        int secDen = 0;
        int sumNum = 0;
        int sumDen = 0;
        int fstNod = 0;
        int secNod = 0;
        int nod = 0;
        boolean isIncorrect;
        System.out.println ("Данная программа вычисляет сумму двух рациональных дробей.");
        do {
            isIncorrect = false;
            System.out.println("Условие ввода: числители и знаменатели дробей являются натуральными числами.");
            try {
                System.out.print("Введите первую дробь: ");
                fstNum = Integer.parseInt(scan.nextLine());
                fstDen = Integer.parseInt(scan.nextLine());
                System.out.print("Введите вторую дробь: ");
                secNum = Integer.parseInt(scan.nextLine());
                secDen = Integer.parseInt(scan.nextLine());
            }
            catch (NumberFormatException e) {
                System.out.println("Введенные данные не соответствуют условию. Повторите попытку.");
                isIncorrect = true;
            }
            if (!isIncorrect & ((fstDen < 1) | (secDen < 1) | (fstNum < 1) | (secNum < 1))) {
                System.out.println("Введенные данные не соответствуют условию. Повторите попытку.");
                isIncorrect = true;
            }
        } while (isIncorrect);
        scan.close();
        System.out.print (fstNum + "/" + fstDen + " + " + secNum + "/" + secDen + " = ");
        fstNum *= secDen;
        secNum *= fstDen;
        sumNum = fstNum + secNum;
        sumDen = fstDen * secDen;
        fstNod = sumDen;
        secNod = sumNum;
        while ((fstNod != 0) & (secNod != 0)) {
            if (fstNod > secNod)
                fstNod %= secNod;
            else
                secNod %= fstNod;
        }
        nod = fstNod + secNod;
        System.out.println(sumNum + "/" + sumDen);
        sumNum /= nod;
        sumDen /= nod;
        System.out.println("Полученный результат: " + sumNum + "/" + sumDen);
    }
}