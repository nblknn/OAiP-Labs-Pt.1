Program Lab2_1;

Uses
    System.SysUtils;

Const
    MINMARK = 0;
    MAXMARK = 10;
    MIN = 5;
    MAX = 15;
    MINSUCCESS = 4;

Var
    Num, I: Integer;
    IsCorrect, IsSuccessful: Boolean;
    Marks: Array Of Integer;

Begin
    Writeln('Данная программа определяет, является ли студент неуспевающим.');
    Writeln('Неуспевающим считается студент, имеющий оценки ниже 4.');
    Repeat
        IsCorrect := True;
        Writeln('Введите количество оценок студента (от 5 до 15).');
        Try
            Readln(Num);
        Except
            Writeln('Введенные данные не соответствуют условию. Повторите попытку.');
            IsCorrect := False;
        End;
        If IsCorrect And ((Num < MIN) Or (Num > MAX)) Then
        Begin
            Writeln('Введенные данные не соответствуют условию. Повторите попытку.');
            IsCorrect := False;
        End;
    Until (IsCorrect);
    SetLength(Marks, Num);
    Writeln('Введите оценки студента (от 0 до 10).');
    For I := Low(Marks) To High(Marks) Do
        Repeat
            IsCorrect := True;
            Write('Введите ', (I + 1), ' оценку студента: ');
            Try
                Readln(Marks[I]);
            Except
                Writeln('Введенные данные не соответствуют условию. Повторите попытку.');
                IsCorrect := False;
            End;
            If IsCorrect And ((Marks[I] < MINMARK) Or (Marks[I] > MAXMARK)) Then
            Begin
                Writeln('Введенные данные не соответствуют условию. Повторите попытку.');
                IsCorrect := False;
            End;
        Until (IsCorrect);
    IsSuccessful := True;
    I := 0;
    While IsSuccessful And (I < Num) Do
    Begin
        IsSuccessful := Marks[I] > (MINSUCCESS - 1);
        Inc(I);
    End;
    If IsSuccessful Then
        Writeln('Студент является успевающим.')
    Else
        Writeln('Студент является неуспевающим.');
    Readln;

End.
