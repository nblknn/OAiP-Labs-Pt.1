Program Lab11;

Uses
    System.SysUtils;

Var
    X, Y: Integer;
    IsCorrect: Boolean;

Begin
    Writeln('������ ��������� ����������, ����������� �� ����� ���������� ��������� D.');
    Writeln('������� �������������� ���������: X+Y<=1; 2*X-Y<=1; Y>=0.');
    Repeat
        IsCorrect := True;
        Writeln('������� ���������� �����: X � Y �������� ������ �������.');
        Try
            Readln(X, Y);
        Except
            Writeln('��������� ������ �� ������������� �������. ��������� �������.');
            IsCorrect := False;
        End;
    Until (IsCorrect);
    If (X + Y < 2) And (2 * X - Y < 2) And (Y > -1) Then
        Writeln('����� ����������� ��������� D.')
    Else
        Writeln('����� �� ����������� ��������� D.');

    Readln;

End.
