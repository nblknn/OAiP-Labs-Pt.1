import java.util.Scanner;

public class lab14{

    public static void main(String[] args){

        final int MIN = 3;
        final int MAX = 10;

        Scanner scan=new Scanner(System.in);
        int size = 0;
        boolean isIncorrect;
        System.out.println ("Данная программа формирует 'сглаженный' массив из введенного.");
        do {
            isIncorrect = false;
            try {
                System.out.println("Введите количество элементов массива от 3 до 10.");
                size = Integer.parseInt(scan.nextLine());
            }
            catch (NumberFormatException e){
                System.out.println("Введенные данные не соответствуют условию. Повторите попытку.");
                isIncorrect = true;
            }
            if (!isIncorrect & ((size > MAX) | (size < MIN))) {
                System.out.println("Введенные данные не соответствуют условию. Повторите попытку.");
                isIncorrect = true;
            }
        }while (isIncorrect);
        System.out.println ("Введите элементы массива (целые числа).");
        int arr[] = new int[size];
        float arrSgl[] = new float[size];
        for (int i=1; i<size+1; i++) {
            do {
                isIncorrect = false;
                try {
                    System.out.print ("Введите " + i + " элемент массива: ");
                    arr[i-1] = Integer.parseInt(scan.nextLine());
                }
                catch (NumberFormatException e){
                    System.out.println("Введенные данные не соответствуют условию. Повторите попытку.");
                    isIncorrect = true;
                }
            }while (isIncorrect);
        }
        scan.close();
        arrSgl[0] = arr[0];
        arrSgl[size-1] = arr[size-1];
        for (int i=1; i<(size-1); i++)
            arrSgl[i]  = (float) ((arr[i - 1] + arr[i] + arr[i + 1]) / 3.0);
        System.out.print ("Вывод сглаженного массива: ");
        for (int i = 0; i < size; i++)
            System.out.printf("%.2f ", arrSgl[i]);
    }
}