Program Lab12;

Uses
    System.SysUtils;

Const
    LIMIT = 12;

Var
    N, M, Placements, I: Integer;
    IsCorrect: Boolean;

Begin
    Writeln('Данная программа вычисляет число размещений из N по M.');
    Repeat
        IsCorrect := True;
        Writeln('Условия ввода: N и M натуральные числа, N больше M, N и M меньше 12.');
        Try
            Write('Введите N: ');
            Readln(N);
            Write('Введите M: ');
            Readln(M);
        Except
            Writeln('Введенные данные не соответствуют условию. Повторите попытку.');
            IsCorrect := False;
        End;
        If IsCorrect And ((N < M + 1) Or (N < 1) Or (M < 1) Or (N > LIMIT) Or
          (M > LIMIT)) Then
        Begin
            Writeln('Введенные данные не соответствуют условию. Повторите попытку.');
            IsCorrect := False;
        End;
    Until (IsCorrect);
    Placements := N;
    For I := (N - 1) DownTo (N - M + 1) Do
    Begin
        Dec(N);
        Placements := Placements * N;
    End;
    Writeln('Число размещений равно ', Placements);

    Readln;

End.
