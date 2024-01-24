Program LAB3_1;

Uses
    System.SysUtils;

Const
    NUMBERS = ['0' .. '9'];
    LETTERS = ['A' .. 'Z', 'a' .. 'z', 'À' .. 'ß', 'à' .. 'ÿ', '¨', '¸'];
    OPENBRACE = '(';
    CLOSEBRACE = ')';

Procedure WriteCondition();
Begin
    Writeln('Äàííàÿ ïðîãðàììà â êàæäîì ÷åòíîì ñëîâå òåêñòà çàìåíÿåò âñå áóêâû íà ïðîïèñíûå,',
      #10, 'à êàæäîå íå÷åòíîå ñëîâî çàêëþ÷àåò â êðóãëûå ñêîáêè.');
End;

Function CheckChoiceInput(OutputMessage: String): Integer;
Var
    Num: Integer;
    IsCorrect: Boolean;
Begin
    Repeat
        IsCorrect := True;
        Writeln(OutputMessage);
        Try
            Readln(Num);
        Except
            IsCorrect := False;
            Writeln('Ââåäåííûå äàííûå íå ñîîòâåòñòâóþò óñëîâèþ. Ïîâòîðèòå ïîïûòêó.');
        End;
        If IsCorrect And ((Num <> 0) And (Num <> 1)) Then
        Begin
            IsCorrect := False;
            Writeln('Ââåäåííûå äàííûå íå ñîîòâåòñòâóþò óñëîâèþ. Ïîâòîðèòå ïîïûòêó.');
        End;
    Until (IsCorrect);
    Writeln;
    CheckChoiceInput := Num;
End;

Function IsTextCorrect(Text: AnsiString): Boolean;
Var
    I: Integer;
    IsCorrect: Boolean;
Begin
    IsCorrect := False;
    If Text = '' Then
        Writeln('Â òåêñòå íåò ñèìâîëîâ. Ïîâòîðèòå ïîïûòêó.')
    Else
    Begin
        I := 1;
        While Not IsCorrect And (I < (Length(Text) + 1)) Do
        Begin
            If Text[I] In LETTERS Then
                IsCorrect := True;
            Inc(I);
        End;
        If Not IsCorrect Then
            Writeln('Â òåêñòå íåò áóêâ. Ïîâòîðèòå ïîïûòêó.');
    End;
    IsTextCorrect := IsCorrect;
End;

Function InputTextFromConsole(): AnsiString;
Var
    Text: AnsiString;
Begin
    Repeat
        Writeln('Ââåäèòå òåêñò.');
        Readln(Text);
    Until IsTextCorrect(Text);
    Writeln;
    InputTextFromConsole := Text;
End;

Function IsFilePathCorrect(Path: String): Boolean;
Var
    IsCorrect: Boolean;
Begin
    IsCorrect := True;
    If Not FileExists(Path) Then
    Begin
        Writeln('Ââåäåííîãî ôàéëà íå ñóùåñòâóåò. Ïîâòîðèòå ïîïûòêó.');
        IsCorrect := False;
    End
    Else If ExtractFileExt(Path) <> '.txt' Then
    Begin
        Writeln('Ââåäåííûé Âàìè ôàéë íå ÿâëÿåòñÿ òåêñòîâûì. Ïîâòîðèòå ïîïûòêó.');
        IsCorrect := False;
    End;
    IsFilePathCorrect := IsCorrect;
End;

Function CheckFileInputPath(): String;
Var
    Path: String;
Begin
    Repeat
        Writeln('Ââåäèòå ïóòü ê ôàéëó, ñîäåðæàùåìó òåêñò.');
        Readln(Path);
    Until IsFilePathCorrect(Path);
    CheckFileInputPath := Path;
End;

Function GetTextFromFile(Path: String): AnsiString;
Var
    I: Integer;
    Text, Line: AnsiString;
    IsCorrect: Boolean;
    FIn: TextFile;
Begin
    Repeat
        IsCorrect := True;
        Try
            Try
                AssignFile(FIn, Path);
                Reset(FIn);
                While Not Eof(FIn) Do
                Begin
                    Readln(FIn, Line);
                    Text := Text + Line + #10;
                End;
                IsCorrect := IsTextCorrect(Text);
            Finally
                CloseFile(FIn);
            End;
        Except
            Writeln('Ïðîèçîøëà îøèáêà. Ïîâòîðèòå ïîïûòêó.');
            IsCorrect := False;
        End;
        If Not IsCorrect Then
        Begin
            Path := CheckFileInputPath();
            Text := '';
        End;
    Until IsCorrect;
    Writeln('Äàííûå èç ôàéëà óñïåøíî ñ÷èòàíû.');
    Writeln;
    GetTextFromFile := Text;
End;

Function InputText(): AnsiString;
Var
    Choice: Integer;
    Text: AnsiString;
    FInPath: String;
Begin
    Choice := CheckChoiceInput
      ('Åñëè Âû õîòèòå ââîäèòü äàííûå â êîíñîëü, ââåäèòå 0. Åñëè èñïîëüçîâàòü ôàéë, ââåäèòå 1.');
    If Choice = 0 Then
        Text := InputTextFromConsole()
    Else
    Begin
        FInPath := CheckFileInputPath();
        Text := GetTextFromFile(FInPath);
        Writeln('Ââåäåííûé òåêñò:', #10, Text);
    End;
    InputText := Text;
End;

Function FormatWord(Count: Integer; Word, ResultText: AnsiString): AnsiString;
Begin
    If Odd(Count) Then
        ResultText := ResultText + OPENBRACE + Word + CLOSEBRACE
    Else
        ResultText := ResultText + AnsiUpperCase(Word);
    FormatWord := ResultText;
End;

Function FormatText(Text: AnsiString): AnsiString;
Var
    I, Count: Integer;
    Word, ResultText: AnsiString;
Begin
    Word := '';
    ResultText := '';
    Count := 1;
    For I := 1 To Length(Text) Do
        If (Text[I] In LETTERS) Or (Text[I] In NUMBERS) Then
            Word := Word + Text[I]
        Else If Word <> '' Then
        Begin
            ResultText := FormatWord(Count, Word, ResultText) + Text[I];
            Word := '';
            Inc(Count);
        End
        Else
            ResultText := ResultText + Text[I];
    If Word <> '' Then
        ResultText := FormatWord(Count, Word, ResultText);
    FormatText := ResultText;
End;

Function CheckFileOutputPath(): String;
Var
    Path: String;
    IsCorrect: Boolean;
Begin
    Repeat
        IsCorrect := True;
        Writeln('Ââåäèòå ïóòü ê ôàéëó, â êîòîðûé íóæíî çàïèñàòü ðåçóëüòàò.');
        Readln(Path);
        IsCorrect := IsFilePathCorrect(Path);
        If IsCorrect And FileIsReadOnly(Path) Then
        Begin
            Writeln('Ââåäåííûé Âàìè ôàéë äîñòóïåí òîëüêî äëÿ ÷òåíèÿ. Ïîâòîðèòå ïîïûòêó.');
            IsCorrect := False;
        End;
    Until IsCorrect;
    CheckFileOutputPath := Path;
End;

Procedure WriteResultIntoFile(ResultText: AnsiString; Path: String);
Var
    FOut: TextFile;
    IsCorrect: Boolean;
Begin
    Repeat
        IsCorrect := True;
        Try
            Try
                AssignFile(FOut, Path);
                Rewrite(FOut);
                Writeln(FOut, ResultText);
            Finally
                CloseFile(FOut);
            End;
        Except
            Writeln('Ïðîèçîøëà îøèáêà. Ïîâòîðèòå ïîïûòêó.');
            IsCorrect := False;
            Path := CheckFileOutputPath();
        End;
    Until IsCorrect;
    Writeln('Ðåçóëüòàò çàïèñàí.');
End;

Procedure OutputText(ResultText: AnsiString);
Var
    Choice: Integer;
    FOutPath: String;
Begin
    Choice := CheckChoiceInput
      ('Åñëè Âû õîòèòå âûâåñòè ðåçóëüòàò â êîíñîëü, ââåäèòå 0. Åñëè â ôàéë, ââåäèòå 1.');
    If Choice = 0 Then
        Writeln('Ðåçóëüòàò:', #10, ResultText)
    Else
    Begin
        FOutPath := CheckFileOutputPath();
        WriteResultIntoFile(ResultText, FOutPath);
    End;
End;

Var
    Text, ResultText: AnsiString;

Begin
    WriteCondition();
    Text := InputText();
    ResultText := FormatText(Text);
    OutputText(ResultText);
    Readln;

End.
