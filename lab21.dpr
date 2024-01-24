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
    Writeln('������ ��������� ����������, �������� �� ������� ������������.');
    Writeln('������������ ��������� �������, ������� ������ ���� 4.');
    Repeat
        IsCorrect := True;
        Writeln('������� ���������� ������ �������� (�� 5 �� 15).');
        Try
            Readln(Num);
        Except
            Writeln('��������� ������ �� ������������� �������. ��������� �������.');
            IsCorrect := False;
        End;
        If IsCorrect And ((Num < MIN) Or (Num > MAX)) Then
        Begin
            Writeln('��������� ������ �� ������������� �������. ��������� �������.');
            IsCorrect := False;
        End;
    Until (IsCorrect);
    SetLength(Marks, Num);
    Writeln('������� ������ �������� (�� 0 �� 10).');
    For I := Low(Marks) To High(Marks) Do
        Repeat
            IsCorrect := True;
            Write('������� ', (I + 1), ' ������ ��������: ');
            Try
                Readln(Marks[I]);
            Except
                Writeln('��������� ������ �� ������������� �������. ��������� �������.');
                IsCorrect := False;
            End;
            If IsCorrect And ((Marks[I] < MINMARK) Or (Marks[I] > MAXMARK)) Then
            Begin
                Writeln('��������� ������ �� ������������� �������. ��������� �������.');
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
        Writeln('������� �������� ����������.')
    Else
        Writeln('������� �������� ������������.');
    Readln;

End.
