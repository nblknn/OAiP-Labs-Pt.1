Program LAB3_1;

Uses
    System.SysUtils;

Const
    NUMBERS = ['0' .. '9'];
    LETTERS = ['A' .. 'Z', 'a' .. 'z', '�' .. '�', '�' .. '�', '�', '�'];
    OPENBRACE = '(';
    CLOSEBRACE = ')';

Procedure WriteCondition();
Begin
    Writeln('������ ��������� � ������ ������ ����� ������ �������� ��� ����� �� ���������,',
      #10, '� ������ �������� ����� ��������� � ������� ������.');
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
            Writeln('��������� ������ �� ������������� �������. ��������� �������.');
        End;
        If IsCorrect And ((Num <> 0) And (Num <> 1)) Then
        Begin
            IsCorrect := False;
            Writeln('��������� ������ �� ������������� �������. ��������� �������.');
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
        Writeln('� ������ ��� ��������. ��������� �������.')
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
            Writeln('� ������ ��� ����. ��������� �������.');
    End;
    IsTextCorrect := IsCorrect;
End;

Function InputTextFromConsole(): AnsiString;
Var
    Text: AnsiString;
Begin
    Repeat
        Writeln('������� �����.');
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
        Writeln('���������� ����� �� ����������. ��������� �������.');
        IsCorrect := False;
    End
    Else If ExtractFileExt(Path) <> '.txt' Then
    Begin
        Writeln('��������� ���� ���� �� �������� ���������. ��������� �������.');
        IsCorrect := False;
    End;
    IsFilePathCorrect := IsCorrect;
End;

Function CheckFileInputPath(): String;
Var
    Path: String;
Begin
    Repeat
        Writeln('������� ���� � �����, ����������� �����.');
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
            Writeln('��������� ������. ��������� �������.');
            IsCorrect := False;
        End;
        If Not IsCorrect Then
        Begin
            Path := CheckFileInputPath();
            Text := '';
        End;
    Until IsCorrect;
    Writeln('������ �� ����� ������� �������.');
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
      ('���� �� ������ ������� ������ � �������, ������� 0. ���� ������������ ����, ������� 1.');
    If Choice = 0 Then
        Text := InputTextFromConsole()
    Else
    Begin
        FInPath := CheckFileInputPath();
        Text := GetTextFromFile(FInPath);
        Writeln('��������� �����:', #10, Text);
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
        Writeln('������� ���� � �����, � ������� ����� �������� ���������.');
        Readln(Path);
        IsCorrect := IsFilePathCorrect(Path);
        If IsCorrect And FileIsReadOnly(Path) Then
        Begin
            Writeln('��������� ���� ���� �������� ������ ��� ������. ��������� �������.');
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
            Writeln('��������� ������. ��������� �������.');
            IsCorrect := False;
            Path := CheckFileOutputPath();
        End;
    Until IsCorrect;
    Writeln('��������� �������.');
End;

Procedure OutputText(ResultText: AnsiString);
Var
    Choice: Integer;
    FOutPath: String;
Begin
    Choice := CheckChoiceInput
      ('���� �� ������ ������� ��������� � �������, ������� 0. ���� � ����, ������� 1.');
    If Choice = 0 Then
        Writeln('���������:', #10, ResultText)
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
