Program Lab13;

Uses
    System.SysUtils;

Var
    FstNum, SecNum, FstDen, SecDen, SumNum, SumDen, FstNod, SecNod,
      Nod: Integer;
    IsCorrect: Boolean;

Begin
    Writeln('Äàííàÿ ïðîãðàììà âû÷èñëÿåò ñóììó äâóõ ðàöèîíàëüíûõ äðîáåé.');
    Repeat
        IsCorrect := True;
        Writeln('Óñëîâèå ââîäà: ÷èñëèòåëè è çíàìåíàòåëè äðîáåé ÿâëÿþòñÿ íàòóðàëüíûìè ÷èñëàìè.');
        Try
            Write('Ââåäèòå ïåðâóþ äðîáü: ');
            Readln(FstNum, FstDen);
            Write('Ââåäèòå âòîðóþ äðîáü: ');
            Readln(SecNum, SecDen);
        Except
            Writeln('Ââåäåííûå äàííûå íå ñîîòâåòñòâóþò óñëîâèþ. Ïîâòîðèòå ïîïûòêó.');
            IsCorrect := False;
        End;
        If IsCorrect And ((FstDen < 0) Or (SecDen < 0) Or (FstNum < 0) Or
          (SecNum < 0)) Then
        Begin
            Writeln('Ââåäåííûå äàííûå íå ñîîòâåòñòâóþò óñëîâèþ. Ïîâòîðèòå ïîïûòêó.');
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
    Writeln('Ïîëó÷åííûé ðåçóëüòàò: ', SumNum, '/', SumDen);

    Readln;

End.
