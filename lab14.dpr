Program lab1_4;

Uses
    System.SysUtils;

Const
    MIN = 3;
    MAX = 10;

Var
    Size, I: Integer;
    Arr: Array Of Integer;
    ArrSgl: Array Of Real;
    IsCorrect: Boolean;

Begin
    Writeln('Данная программа формирует "сглаженный" массив из введенного.');
    Repeat
        IsCorrect := True;
        Writeln('Введите количество элементов массива от 3 до 10.');
        Try
            Readln(Size);
        Except
            Writeln('Введенные данные не соответствуют условию. Повторите попытку.');
            IsCorrect := False;
        End;
        If IsCorrect And ((Size < MIN) Or (Size > MAX)) Then
        Begin
            Writeln('Введенные данные не соответствуют условию. Повторите попытку.');
            IsCorrect := False;
        End;
    Until (IsCorrect);

    SetLength(Arr, Size);
    SetLength(ArrSgl, Size);
    Writeln('Введите элементы массива (целые числа).');

    For I := 1 To Size Do
        Repeat
            IsCorrect := True;
            Write('Введите ', I, ' элемент массива: ');
            Try
                Readln(Arr[I - 1]);
            Except
                Writeln('Введенные данные не соответствуют условию. Повторите попытку.');
                IsCorrect := False;
            End;
        Until (IsCorrect);

    ArrSgl[0] := Arr[0];
    ArrSgl[Size - 1] := Arr[Size - 1];

    For I := 1 To (Size - 2) Do
        ArrSgl[I] := (Arr[I - 1] + Arr[I] + Arr[I + 1]) / 3;
    Write('Вывод сглаженного массива: ');

    For I := 0 To Size - 1 Do
        Write(ArrSgl[I]:5:2, ' ');

    Readln;

End.
