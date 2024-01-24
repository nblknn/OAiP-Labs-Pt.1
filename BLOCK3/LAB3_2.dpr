Program LAB3_2;

Uses
    System.SysUtils;

Type
    TSet = Set Of Byte;

Const
    X1 = [1, 2, 3, 4, 5, 6];
    X2 = [1, 3, 4, 5, 6];
    BYTEMAX = 255;

Procedure OutputSet(SetOfNum: TSet; SetName: String);
Var
    I: Byte;
Begin
    Write(SetName, '{ ');
    For I := 0 To BYTEMAX Do
        If (I In SetOfNum) Then
            Write(I, ' ');
    Writeln('}');
End;

Function FindSumOfSets(): TSet;
Var
    Y: TSet;
Begin
    Y := X1 + X2;
    FindSumOfSets := Y;
End;

Function FindSubSet(Y: TSet): TSet;
Var
    I: Byte;
    Y1: TSet;
Begin
    Y1 := [];
    For I := 0 To BYTEMAX Do
        If (I In Y) And (Not Odd(I)) And (I Mod 3 = 0) Then
            Y1 := Y1 + [I];
    FindSubSet := Y1;
End;

Procedure WriteCondition();
Begin
    Writeln('Äàííàÿ ïðîãðàììà ôîðìèðóåò îáúåäèíåíèå äâóõ ìíîæåñòâ, è âûäåëÿåò èç íåãî ïîäìíîæåñòâî ÷åòíûõ ÷èñåë, êðàòíûõ 3.');
    Writeln('Äàíû ìíîæåñòâà:');
    OutputSet(X1, 'X1: ');
    OutputSet(X2, 'X2: ');
End;

Function CheckChoiceInput(): Integer;
Var
    Num: Integer;
    IsCorrect: Boolean;
Begin
    Repeat
        IsCorrect := True;
        Writeln('Åñëè Âû õîòèòå âûâåñòè ðåçóëüòàò â êîíñîëü, ââåäèòå 0. Åñëè â ôàéë, ââåäèòå 1.');
        Try
            Readln(Num);
        Except
            IsCorrect := False;
            Writeln('Ââåäåííûå äàííûå íå ñîîòâåòñòâóþò óñëîâèþ. Ïîâòîðèòå ïîïûòêó.');
        End;
        If IsCorrect And (Num <> 0) And (Num <> 1) Then
        Begin
            IsCorrect := False;
            Writeln('Ââåäåííûå äàííûå íå ñîîòâåòñòâóþò óñëîâèþ. Ïîâòîðèòå ïîïûòêó.');
        End;
    Until (IsCorrect);
    CheckChoiceInput := Num;
End;

Function CheckFilePath(): String;
Var
    Path: String;
    IsCorrect: Boolean;
Begin
    Repeat
        IsCorrect := True;
        Writeln('Ââåäèòå ïóòü ê ôàéëó, â êîòîðûé íóæíî çàïèñàòü ðåçóëüòàò.');
        Readln(Path);
        If Not FileExists(Path) Then
        Begin
            Writeln('Ââåäåííîãî ôàéëà íå ñóùåñòâóåò. Ïîâòîðèòå ïîïûòêó.');
            IsCorrect := False;
        End
        Else If ExtractFileExt(Path) <> '.txt' Then
        Begin
            Writeln('Ââåäåííûé Âàìè ôàéë íå ÿâëÿåòñÿ òåêñòîâûì. Ïîâòîðèòå ïîïûòêó.');
            IsCorrect := False;
        End
        Else If FileIsReadOnly(Path) Then
        Begin
            Writeln('Ââåäåííûé Âàìè ôàéë äîñòóïåí òîëüêî äëÿ ÷òåíèÿ. Ïîâòîðèòå ïîïûòêó.');
            IsCorrect := False;
        End;
    Until IsCorrect;
    CheckFilePath := Path;
End;

Procedure WriteSetIntoFile(SetOfNum: TSet; SetName: String; Var FOut: TextFile);
Var
    I: Byte;
Begin
    Write(FOut, SetName, '{ ');
    For I := 0 To BYTEMAX Do
        If (I In SetOfNum) Then
            Write(FOut, I, ' ');
    Writeln(FOut, '}');
End;

Procedure WriteResultIntoFile(Y, Y1: TSet; Path: String);
Var
    I: Byte;
    IsCorrect: Boolean;
    FOut: TextFile;
Begin
    Repeat
        IsCorrect := True;
        Assign(FOut, Path);
        Try
            Try
                Rewrite(FOut);
                WriteSetIntoFile(Y, 'Ïîëó÷åííîå îáúåäèíåíèå ìíîæåñòâ: ', FOut);
                WriteSetIntoFile(Y1, 'Ïîëó÷åííîå ïîäìíîæåñòâî: ', FOut);
            Finally
                CloseFile(FOut);
            End;
        Except
            Writeln('Ïðîèçîøëà îøèáêà. Ïîâòîðèòå ïîïûòêó.');
            IsCorrect := False;
            Path := CheckFilePath();
        End;
    Until IsCorrect;
    Writeln('Ðåçóëüòàò çàïèñàí.');
End;

Var
    Choice: Integer;
    FOutPath: String;
    Y, Y1: TSet;

Begin
    WriteCondition();
    Y := FindSumOfSets();
    Y1 := FindSubSet(Y);
    Choice := CheckChoiceInput();
    If Choice = 0 Then
    Begin
        OutputSet(Y, 'Ïîëó÷åííîå îáúåäèíåíèå ìíîæåñòâ: ');
        OutputSet(Y1, 'Ïîëó÷åííîå ïîäìíîæåñòâî: ');
    End
    Else
    Begin
        FOutPath := CheckFilePath();
        WriteResultIntoFile(Y, Y1, FOutPath);
    End;
    Readln;

End.
