Program LAB3_3;

Uses
    System.SysUtils;

Const
    MINSIZE = 3;
    MAXSIZE = 20;
    MINPOINT = 0;
    MAXPOINT = 100;
    MAXSURNAMELENGTH = 30;

Type
    TParticipant = Record
        Surname: String[30];
        Points: 0 .. 100;
    End;

    TList = Array Of TParticipant;

Procedure WriteCondition();
Begin
    Writeln('������ ��������� ������������� ������ ���������� � �� ������� �� ������������.');
End;

Function IsNumRangeCorrect(Const MIN, MAX: Integer; Num: Integer;
  ErrorMessage: String; Var IsCorrect: Boolean): Boolean;
Begin
    If IsCorrect And (Num > MAX) Or (Num < MIN) Then
    Begin
        IsCorrect := False;
        Writeln(ErrorMessage);
    End;
    IsNumRangeCorrect := IsCorrect;
End;

Function InputNum(Const MIN, MAX: Integer; OutputMessage: String): Integer;
Var
    Num: Integer;
    IsCorrect: Boolean;
Begin
    Repeat
        IsCorrect := True;
        Write(OutputMessage);
        Try
            Readln(Num);
        Except
            IsCorrect := False;
            Writeln('��������� �������� ������ ���� ����� ������! ��������� �������.');
        End;
        IsCorrect := IsNumRangeCorrect(MIN, MAX, Num,
          '�������� ���������� ����� �� ������������� �������! ��������� �������.',
          IsCorrect);
    Until (IsCorrect);
    InputNum := Num;
End;

Function InputSurname(I: Integer): String;
Var
    Surname: String;
    IsCorrect: Boolean;
Begin
    Repeat
        IsCorrect := True;
        Write('������� ������� ', I + 1, ' ���������: ');
        Readln(Surname);
        If (Surname = '') Or (Length(Surname) > MAXSURNAMELENGTH) Then
        Begin
            Writeln('������� ������ ��������� �� 1 �� 30 ��������! ��������� �������.');
            IsCorrect := False;
        End;
    Until IsCorrect;
    InputSurname := Surname;
End;

Function GetListFromConsole(ListSize: Integer): TList;
Var
    I, Check: Integer;
    PointsString: String;
    List: TList;
    IsCorrect: Boolean;
Begin
    SetLength(List, ListSize);
    Writeln('������� �����: ������� ��������� ������ ���� �� ������� 30 ��������, ���������� ������ - ����� ����� �� 0 �� 100.');
    For I := 0 To High(List) Do
    Begin
        List[I].Surname := InputSurname(I);
        List[I].Points := InputNum(MINPOINT, MAXPOINT,
          '������� ���������� ������ ���������: ');
    End;
    GetListFromConsole := List;
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
    Writeln;
    Repeat
        Writeln('�������: � ������ ������ ������ ���� �������� ���������� ���������� (�� 3 �� 20).');
        Writeln('� ������� � ����������� ������� ������������ ������� (�� 30 ��������), ����� ���������� ��������� ������ (����� ����� �� 0 �� 100).');
        Writeln('������� ���� � �����, ����������� ������ ����������.');
        Readln(Path);
    Until IsFilePathCorrect(Path);
    CheckFileInputPath := Path;
End;

Function ReadSurnameFromFile(Var IsCorrect: Boolean; Var FIn: TextFile): String;
Var
    Symbol: Char;
    Surname: String;
Begin
    Surname := '';
    If IsCorrect Then
    Begin
        Read(FIn, Symbol);
        Repeat
            Surname := Surname + Symbol;
            Read(FIn, Symbol);
        Until (Symbol = ' ') Or (Length(Surname) = MAXSURNAMELENGTH);
        If (Surname = '') Or (Symbol <> ' ') Then
        Begin
            Writeln('�������, ���������� � �����, �� ������������� ���������. ��������� �������.');
            IsCorrect := False;
        End;
    End;
    ReadSurnameFromFile := Surname;
End;

Function GetListFromFile(Path: String): TList;
Var
    I, ListSize: Integer;
    List: TList;
    IsCorrect: Boolean;
    FIn: TextFile;
Begin
    Repeat
        IsCorrect := True;
        Try
            Try
                Assign(FIn, Path);
                Reset(FIn);
                Readln(FIn, ListSize);
                IsCorrect := IsNumRangeCorrect(MINSIZE, MAXSIZE, ListSize,
                  '������, ���������� � �����, �� ������������� ���������. ��������� �������.',
                  IsCorrect);
                SetLength(List, ListSize);
                I := 0;
                While IsCorrect And (I < (High(List) + 1)) Do
                Begin
                    If Eof(FIn) Then
                    Begin
                        Writeln('���������� ���������� �� ��������� � ���������� � ����� ��������. ��������� �������.');
                        IsCorrect := False;
                    End;
                    List[I].Surname := ReadSurnameFromFile(IsCorrect, FIn);
                    Readln(FIn, List[I].Points);
                    IsCorrect := IsNumRangeCorrect(MINPOINT, MAXPOINT,
                      List[I].Points,
                      '�����, ���������� � �����, �� ������������ ���������. ��������� �������.',
                      IsCorrect);
                    Inc(I);
                End;
                If IsCorrect And Not Eof(FIn) Then
                Begin
                    Writeln('���������� ���������� �� ��������� � ���������� � ����� ��������. ��������� �������.');
                    IsCorrect := False;
                End;
            Finally
                CloseFile(FIn);
            End;
        Except
            Writeln('������ ���������� ����� �� ������������� �������. ��������� �������.');
            IsCorrect := False;
        End;
        If Not IsCorrect Then
            Path := CheckFileInputPath();
    Until IsCorrect;
    Writeln('������ �� ����� ������� �������.');
    GetListFromFile := List;
End;

Function InputList(): TList;
Var
    Choice, ListSize: Integer;
    List: TList;
    FInPath: String;
Begin
    Choice := InputNum(0, 1,
      '���� �� ������ ������� ������ � �������, ������� 0. ���� ������������ ����, ������� 1: ');
    If Choice = 0 Then
    Begin
        ListSize := InputNum(MINSIZE, MAXSIZE,
          '������� ���������� ���������� (�� 3 �� 20): ');
        List := GetListFromConsole(ListSize);
    End
    Else
    Begin
        FInPath := CheckFileInputPath();
        List := GetListFromFile(FInPath);
    End;
    InputList := List;
End;

Function SwapElements(List: TList; I: Integer): TList;
Var
    Temp: TParticipant;
Begin
    Temp := List[I];
    List[I] := List[I - 1];
    List[I - 1] := Temp;
    SwapElements := List;
End;

Function SortList(List: TList): TList;
Var
    I, J: Integer;
Begin
    For I := 1 To High(List) Do
        For J := 1 To High(List) Do
            If List[J].Points > List[J - 1].Points Then
                List := SwapElements(List, J)
            Else If (List[J].Points = List[J - 1].Points) And
              (AnsiUpperCase(List[J].Surname) <
              AnsiUpperCase(List[J - 1].Surname)) Then
                List := SwapElements(List, J);
    SortList := List;
End;

Procedure OutputList(List: TList; ListName: String);
Var
    I: Integer;
Begin
    Writeln;
    Writeln(ListName);
    For I := 0 To High(List) Do
        Writeln(List[I].Surname, ' ', List[I].Points);
    WriteLn;
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

Procedure WriteResultIntoFile(List: TList; Path: String);
Var
    I: Integer;
    FOut: TextFile;
    IsCorrect: Boolean;
Begin
    Repeat
        IsCorrect := True;
        Assign(FOut, Path);
        Try
            Try
                Rewrite(FOut);
                For I := 0 To High(List) Do
                    Writeln(FOut, List[I].Surname, ' ', List[I].Points);
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

Procedure OutputResult(SortedList: TList);
Var
    Choice: Integer;
    FOutPath: String;
Begin
    Choice := InputNum(0, 1,
      '���� ����� ������� ��������� � �������, ������� 0. ���� � ����, ������� 1: ');
    If Choice = 0 Then
        OutputList(SortedList, '��������������� ������:')
    Else
    Begin
        FOutPath := CheckFileOutputPath();
        WriteResultIntoFile(SortedList, FOutPath);
    End;
End;

Var
    List, SortedList: TList;

Begin
    WriteCondition();
    List := InputList();
    OutputList(List, '��������� ������:');
    SortedList := SortList(List);
    OutputResult(SortedList);
    Readln

End.
