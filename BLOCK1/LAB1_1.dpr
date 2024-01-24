Program Lab11;

Uses
    System.SysUtils;

Var
    X, Y: Integer;
    IsCorrect: Boolean;

Begin
    Writeln('Данная программа определяет, принадлежит ли точка замкнутому множеству D.');
    Writeln('Условия принадлежности множеству: X+Y<=1; 2*X-Y<=1; Y>=0.');
    Repeat
        IsCorrect := True;
        Writeln('Введите координаты точки: X и Y являются целыми числами.');
        Try
            Readln(X, Y);
        Except
            Writeln('Введенные данные не соответствуют условию. Повторите попытку.');
            IsCorrect := False;
        End;
    Until (IsCorrect);
    If (X + Y < 2) And (2 * X - Y < 2) And (Y > -1) Then
        Writeln('Точка принадлежит множеству D.')
    Else
        Writeln('Точка не принадлежит множеству D.');

    Readln;

End.
