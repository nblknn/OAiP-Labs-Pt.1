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
    Writeln('Äàííàÿ ïðîãðàììà ôîðìèðóåò "ñãëàæåííûé" ìàññèâ èç ââåäåííîãî.');
    Repeat
        IsCorrect := True;
        Writeln('Ââåäèòå êîëè÷åñòâî ýëåìåíòîâ ìàññèâà îò 3 äî 10.');
        Try
            Readln(Size);
        Except
            Writeln('Ââåäåííûå äàííûå íå ñîîòâåòñòâóþò óñëîâèþ. Ïîâòîðèòå ïîïûòêó.');
            IsCorrect := False;
        End;
        If IsCorrect And ((Size < MIN) Or (Size > MAX)) Then
        Begin
            Writeln('Ââåäåííûå äàííûå íå ñîîòâåòñòâóþò óñëîâèþ. Ïîâòîðèòå ïîïûòêó.');
            IsCorrect := False;
        End;
    Until (IsCorrect);

    SetLength(Arr, Size);
    SetLength(ArrSgl, Size);
    Writeln('Ââåäèòå ýëåìåíòû ìàññèâà (öåëûå ÷èñëà).');

    For I := 1 To Size Do
        Repeat
            IsCorrect := True;
            Write('Ââåäèòå ', I, ' ýëåìåíò ìàññèâà: ');
            Try
                Readln(Arr[I - 1]);
            Except
                Writeln('Ââåäåííûå äàííûå íå ñîîòâåòñòâóþò óñëîâèþ. Ïîâòîðèòå ïîïûòêó.');
                IsCorrect := False;
            End;
        Until (IsCorrect);

    ArrSgl[0] := Arr[0];
    ArrSgl[Size - 1] := Arr[Size - 1];

    For I := 1 To (Size - 2) Do
        ArrSgl[I] := (Arr[I - 1] + Arr[I] + Arr[I + 1]) / 3;
    Write('Âûâîä ñãëàæåííîãî ìàññèâà: ');

    For I := 0 To Size - 1 Do
        Write(ArrSgl[I]:5:2, ' ');

    Readln;

End.
