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
    Writeln('������ ��������� ��������� "����������" ������ �� ����������.');
    Repeat
        IsCorrect := True;
        Writeln('������� ���������� ��������� ������� �� 3 �� 10.');
        Try
            Readln(Size);
        Except
            Writeln('��������� ������ �� ������������� �������. ��������� �������.');
            IsCorrect := False;
        End;
        If IsCorrect And ((Size < MIN) Or (Size > MAX)) Then
        Begin
            Writeln('��������� ������ �� ������������� �������. ��������� �������.');
            IsCorrect := False;
        End;
    Until (IsCorrect);

    SetLength(Arr, Size);
    SetLength(ArrSgl, Size);
    Writeln('������� �������� ������� (����� �����).');

    For I := 1 To Size Do
        Repeat
            IsCorrect := True;
            Write('������� ', I, ' ������� �������: ');
            Try
                Readln(Arr[I - 1]);
            Except
                Writeln('��������� ������ �� ������������� �������. ��������� �������.');
                IsCorrect := False;
            End;
        Until (IsCorrect);

    ArrSgl[0] := Arr[0];
    ArrSgl[Size - 1] := Arr[Size - 1];

    For I := 1 To (Size - 2) Do
        ArrSgl[I] := (Arr[I - 1] + Arr[I] + Arr[I + 1]) / 3;
    Write('����� ����������� �������: ');

    For I := 0 To Size - 1 Do
        Write(ArrSgl[I]:5:2, ' ');

    Readln;

End.
