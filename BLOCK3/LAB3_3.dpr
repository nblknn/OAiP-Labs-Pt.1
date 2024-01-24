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
    Writeln('Äàííàÿ ïðîãðàììà óïîðÿäî÷èâàåò ñïèñîê ó÷àñòíèêîâ ñ èõ áàëëàìè íà ñîðåâíîâàíèè.');
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
            Writeln('Ââåäåííîå çíà÷åíèå äîëæíî áûòü öåëûì ÷èñëîì! Ïîâòîðèòå ïîïûòêó.');
        End;
        IsCorrect := IsNumRangeCorrect(MIN, MAX, Num,
          'Äèàïàçîí ââåäåííîãî ÷èñëà íå ñîîòâåòñòâóåò óñëîâèþ! Ïîâòîðèòå ïîïûòêó.',
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
        Write('Ââåäèòå ôàìèëèþ ', I + 1, ' ó÷àñòíèêà: ');
        Readln(Surname);
        If (Surname = '') Or (Length(Surname) > MAXSURNAMELENGTH) Then
        Begin
            Writeln('Ôàìèëèÿ äîëæíà ñîäåðæàòü îò 1 äî 30 ñèìâîëîâ! Ïîâòîðèòå ïîïûòêó.');
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
    Writeln('Óñëîâèÿ ââîäà: ôàìèëèÿ ó÷àñòíèêà äîëæíà áûòü íå äëèííåå 30 ñèìâîëîâ, êîëè÷åñòâî áàëëîâ - öåëîå ÷èñëî îò 0 äî 100.');
    For I := 0 To High(List) Do
    Begin
        List[I].Surname := InputSurname(I);
        List[I].Points := InputNum(MINPOINT, MAXPOINT,
          'Ââåäèòå êîëè÷åñòâî áàëëîâ ó÷àñòíèêà: ');
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
    Writeln;
    Repeat
        Writeln('Óñëîâèÿ: â ïåðâîé ñòðîêå äîëæíî áûòü çàïèñàíî êîëè÷åñòâî ó÷àñòíèêîâ (îò 3 äî 20).');
        Writeln('Â ñòðîêàõ ñ ó÷àñòíèêàìè ñíà÷àëà çàïèñûâàåòñÿ ôàìèëèÿ (äî 30 ñèìâîëîâ), çàòåì êîëè÷åñòâî íàáðàííûõ áàëëîâ (öåëîå ÷èñëî îò 0 äî 100).');
        Writeln('Ââåäèòå ïóòü ê ôàéëó, ñîäåðæàùåìó ñïèñîê ó÷àñòíèêîâ.');
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
            Writeln('Ôàìèëèè, çàïèñàííûå â ôàéëå, íå ñîîòâåòñòâóþò äèàïàçîíó. Ïîâòîðèòå ïîïûòêó.');
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
                  'Ðàçìåð, çàïèñàííûé â ôàéëå, íå ñîîòâåòñòâóåò äèàïàçîíó. Ïîâòîðèòå ïîïûòêó.',
                  IsCorrect);
                SetLength(List, ListSize);
                I := 0;
                While IsCorrect And (I < (High(List) + 1)) Do
                Begin
                    If Eof(FIn) Then
                    Begin
                        Writeln('Êîëè÷åñòâî ó÷àñòíèêîâ íå ñîâïàäàåò ñ çàïèñàííûì â ôàéëå ðàçìåðîì. Ïîâòîðèòå ïîïûòêó.');
                        IsCorrect := False;
                    End;
                    List[I].Surname := ReadSurnameFromFile(IsCorrect, FIn);
                    Readln(FIn, List[I].Points);
                    IsCorrect := IsNumRangeCorrect(MINPOINT, MAXPOINT,
                      List[I].Points,
                      'Áàëëû, çàïèñàííûå â ôàéëå, íå ñîîòâåòñòóþò äèàïàçîíó. Ïîâòîðèòå ïîïûòêó.',
                      IsCorrect);
                    Inc(I);
                End;
                If IsCorrect And Not Eof(FIn) Then
                Begin
                    Writeln('Êîëè÷åñòâî ó÷àñòíèêîâ íå ñîâïàäàåò ñ çàïèñàííûì â ôàéëå ðàçìåðîì. Ïîâòîðèòå ïîïûòêó.');
                    IsCorrect := False;
                End;
            Finally
                CloseFile(FIn);
            End;
        Except
            Writeln('Äàííûå âûáðàííîãî ôàéëà íå ñîîòâåòñòâóþò óñëîâèþ. Ïîâòîðèòå ïîïûòêó.');
            IsCorrect := False;
        End;
        If Not IsCorrect Then
            Path := CheckFileInputPath();
    Until IsCorrect;
    Writeln('Äàííûå èç ôàéëà óñïåøíî ñ÷èòàíû.');
    GetListFromFile := List;
End;

Function InputList(): TList;
Var
    Choice, ListSize: Integer;
    List: TList;
    FInPath: String;
Begin
    Choice := InputNum(0, 1,
      'Åñëè Âû õîòèòå ââîäèòü äàííûå â êîíñîëü, ââåäèòå 0. Åñëè èñïîëüçîâàòü ôàéë, ââåäèòå 1: ');
    If Choice = 0 Then
    Begin
        ListSize := InputNum(MINSIZE, MAXSIZE,
          'Ââåäèòå êîëè÷åñòâî ó÷àñòíèêîâ (îò 3 äî 20): ');
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
            Writeln('Ïðîèçîøëà îøèáêà. Ïîâòîðèòå ïîïûòêó.');
            IsCorrect := False;
            Path := CheckFileOutputPath();
        End;
    Until IsCorrect;
    Writeln('Ðåçóëüòàò çàïèñàí.');
End;

Procedure OutputResult(SortedList: TList);
Var
    Choice: Integer;
    FOutPath: String;
Begin
    Choice := InputNum(0, 1,
      'Åñëè íóæíî âûâåñòè ðåçóëüòàò â êîíñîëü, ââåäèòå 0. Åñëè â ôàéë, ââåäèòå 1: ');
    If Choice = 0 Then
        OutputList(SortedList, 'Îòñîðòèðîâàííûé ñïèñîê:')
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
    OutputList(List, 'Ââåäåííûé ñïèñîê:');
    SortedList := SortList(List);
    OutputResult(SortedList);
    Readln

End.
