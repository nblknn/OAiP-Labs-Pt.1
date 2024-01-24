Program Lab12;

Uses
    System.SysUtils;

Const
    LIMIT = 12;

Var
    N, M, Placements, I: Integer;
    IsCorrect: Boolean;

Begin
    Writeln('Äàííàÿ ïðîãðàììà âû÷èñëÿåò ÷èñëî ðàçìåùåíèé èç N ïî M.');
    Repeat
        IsCorrect := True;
        Writeln('Óñëîâèÿ ââîäà: N è M íàòóðàëüíûå ÷èñëà, N áîëüøå M, N è M ìåíüøå 12.');
        Try
            Write('Ââåäèòå N: ');
            Readln(N);
            Write('Ââåäèòå M: ');
            Readln(M);
        Except
            Writeln('Ââåäåííûå äàííûå íå ñîîòâåòñòâóþò óñëîâèþ. Ïîâòîðèòå ïîïûòêó.');
            IsCorrect := False;
        End;
        If IsCorrect And ((N < M + 1) Or (N < 1) Or (M < 1) Or (N > LIMIT) Or
          (M > LIMIT)) Then
        Begin
            Writeln('Ââåäåííûå äàííûå íå ñîîòâåòñòâóþò óñëîâèþ. Ïîâòîðèòå ïîïûòêó.');
            IsCorrect := False;
        End;
    Until (IsCorrect);
    Placements := N;
    For I := (N - 1) DownTo (N - M + 1) Do
    Begin
        Dec(N);
        Placements := Placements * N;
    End;
    Writeln('×èñëî ðàçìåùåíèé ðàâíî ', Placements);

    Readln;

End.
