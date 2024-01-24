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
    Writeln('Данная программа формирует объединение двух множеств, и выделяет из него подмножество четных чисел, кратных 3.');
    Writeln('Даны множества:');
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
        Writeln('Если Вы хотите вывести результат в консоль, введите 0. Если в файл, введите 1.');
        Try
            Readln(Num);
        Except
            IsCorrect := False;
            Writeln('Введенные данные не соответствуют условию. Повторите попытку.');
        End;
        If IsCorrect And (Num <> 0) And (Num <> 1) Then
        Begin
            IsCorrect := False;
            Writeln('Введенные данные не соответствуют условию. Повторите попытку.');
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
        Writeln('Введите путь к файлу, в который нужно записать результат.');
        Readln(Path);
        If Not FileExists(Path) Then
        Begin
            Writeln('Введенного файла не существует. Повторите попытку.');
            IsCorrect := False;
        End
        Else If ExtractFileExt(Path) <> '.txt' Then
        Begin
            Writeln('Введенный Вами файл не является текстовым. Повторите попытку.');
            IsCorrect := False;
        End
        Else If FileIsReadOnly(Path) Then
        Begin
            Writeln('Введенный Вами файл доступен только для чтения. Повторите попытку.');
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
                WriteSetIntoFile(Y, 'Полученное объединение множеств: ', FOut);
                WriteSetIntoFile(Y1, 'Полученное подмножество: ', FOut);
            Finally
                CloseFile(FOut);
            End;
        Except
            Writeln('Произошла ошибка. Повторите попытку.');
            IsCorrect := False;
            Path := CheckFilePath();
        End;
    Until IsCorrect;
    Writeln('Результат записан.');
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
        OutputSet(Y, 'Полученное объединение множеств: ');
        OutputSet(Y1, 'Полученное подмножество: ');
    End
    Else
    Begin
        FOutPath := CheckFilePath();
        WriteResultIntoFile(Y, Y1, FOutPath);
    End;
    Readln;

End.
