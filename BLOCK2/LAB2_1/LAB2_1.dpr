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
    Writeln('Äàííàÿ ïðîãðàììà îïðåäåëÿåò, ÿâëÿåòñÿ ëè ñòóäåíò íåóñïåâàþùèì.');
    Writeln('Íåóñïåâàþùèì ñ÷èòàåòñÿ ñòóäåíò, èìåþùèé îöåíêè íèæå 4.');
    Repeat
        IsCorrect := True;
        Writeln('Ââåäèòå êîëè÷åñòâî îöåíîê ñòóäåíòà (îò 5 äî 15).');
        Try
            Readln(Num);
        Except
            Writeln('Ââåäåííûå äàííûå íå ñîîòâåòñòâóþò óñëîâèþ. Ïîâòîðèòå ïîïûòêó.');
            IsCorrect := False;
        End;
        If IsCorrect And ((Num < MIN) Or (Num > MAX)) Then
        Begin
            Writeln('Ââåäåííûå äàííûå íå ñîîòâåòñòâóþò óñëîâèþ. Ïîâòîðèòå ïîïûòêó.');
            IsCorrect := False;
        End;
    Until (IsCorrect);
    SetLength(Marks, Num);
    Writeln('Ââåäèòå îöåíêè ñòóäåíòà (îò 0 äî 10).');
    For I := Low(Marks) To High(Marks) Do
        Repeat
            IsCorrect := True;
            Write('Ââåäèòå ', (I + 1), ' îöåíêó ñòóäåíòà: ');
            Try
                Readln(Marks[I]);
            Except
                Writeln('Ââåäåííûå äàííûå íå ñîîòâåòñòâóþò óñëîâèþ. Ïîâòîðèòå ïîïûòêó.');
                IsCorrect := False;
            End;
            If IsCorrect And ((Marks[I] < MINMARK) Or (Marks[I] > MAXMARK)) Then
            Begin
                Writeln('Ââåäåííûå äàííûå íå ñîîòâåòñòâóþò óñëîâèþ. Ïîâòîðèòå ïîïûòêó.');
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
        Writeln('Ñòóäåíò ÿâëÿåòñÿ óñïåâàþùèì.')
    Else
        Writeln('Ñòóäåíò ÿâëÿåòñÿ íåóñïåâàþùèì.');
    Readln;

End.
