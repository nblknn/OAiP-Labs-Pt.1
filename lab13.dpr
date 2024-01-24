Program Lab13;

Uses
    System.SysUtils;

Var
    FstNum, SecNum, FstDen, SecDen, SumNum, SumDen, FstNod, SecNod,
      Nod: Integer;
    IsCorrect: Boolean;

Begin
    Writeln('Данная программа вычисляет сумму двух рациональных дробей.');
    Repeat
        IsCorrect := True;
        Writeln('Условие ввода: числители и знаменатели дробей являются натуральными числами.');
        Try
            Write('Введите первую дробь: ');
            Readln(FstNum, FstDen);
            Write('Введите вторую дробь: ');
            Readln(SecNum, SecDen);
        Except
            Writeln('Введенные данные не соответствуют условию. Повторите попытку.');
            IsCorrect := False;
        End;
        If IsCorrect And ((FstDen < 0) Or (SecDen < 0) Or (FstNum < 0) Or
          (SecNum < 0)) Then
        Begin
            Writeln('Введенные данные не соответствуют условию. Повторите попытку.');
            IsCorrect := False;
        End;
    Until (IsCorrect);

    Write(FstNum, '/', FstDen, ' + ', SecNum, '/', SecDen, ' = ');
    FstNum := FstNum * SecDen;
    SecNum := SecNum * FstDen;
    SumNum := FstNum + SecNum;
    SumDen := FstDen * SecDen;
    FstNod := SumDen;
    SecNod := SumNum;

    While (FstNod <> 0) And (SecNod <> 0) Do
    Begin
        If FstNod > SecNod Then
            FstNod := FstNod Mod SecNod
        Else
            SecNod := SecNod Mod FstNod;
    End;
    Nod := FstNod + SecNod;

    Writeln(SumNum, '/', SumDen);
    SumNum := SumNum Div Nod;
    SumDen := SumDen Div Nod;
    Writeln('Полученный результат: ', SumNum, '/', SumDen);

    Readln;

End.
