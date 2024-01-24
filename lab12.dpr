Program Lab12;

Uses
    System.SysUtils;

Const
    LIMIT = 12;

Var
    N, M, Placements, I: Integer;
    IsCorrect: Boolean;

Begin
    Writeln('������ ��������� ��������� ����� ���������� �� N �� M.');
    Repeat
        IsCorrect := True;
        Writeln('������� �����: N � M ����������� �����, N ������ M, N � M ������ 12.');
        Try
            Write('������� N: ');
            Readln(N);
            Write('������� M: ');
            Readln(M);
        Except
            Writeln('��������� ������ �� ������������� �������. ��������� �������.');
            IsCorrect := False;
        End;
        If IsCorrect And ((N < M + 1) Or (N < 1) Or (M < 1) Or (N > LIMIT) Or
          (M > LIMIT)) Then
        Begin
            Writeln('��������� ������ �� ������������� �������. ��������� �������.');
            IsCorrect := False;
        End;
    Until (IsCorrect);
    Placements := N;
    For I := (N - 1) DownTo (N - M + 1) Do
    Begin
        Dec(N);
        Placements := Placements * N;
    End;
    Writeln('����� ���������� ����� ', Placements);

    Readln;

End.
