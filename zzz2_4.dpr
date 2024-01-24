Program zzz2_4;

Uses
    System.SysUtils;

Type
    TMatrix = Array Of Array Of Integer;
    TArrOI = Array Of Integer;

Const
    MINSIZE = 2;
    MAXSIZE = 10;
    MIN = -1000;
    MAX = 1000;

Function CheckInput(Const MINNUM, MAXNUM: Integer;
  OutputMessage: String): Integer;
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
            Writeln('��������� ������ �� ������������� �������. ��������� �������.');
        End;
        If IsCorrect And ((Num < MINNUM) Or (Num > MAXNUM)) Then
        Begin
            IsCorrect := False;
            Writeln('��������� ������ �� ������������� �������. ��������� �������.');
        End;
    Until (IsCorrect);
    CheckInput := Num;
End;

Function InputMatrix(Matrix: TMatrix): TMatrix;
Var
    I, J: Integer;
    IsCorrect: Boolean;
Begin
    Writeln('������� �������.');
    For I := 0 To High(Matrix) Do
        For J := 0 To High(Matrix[I]) Do
        Begin
            Write('������� ������� ', I + 1, ' ������, ', J + 1,
              ' ������� �������: ');
            Matrix[I][J] := CheckInput(MIN, MAX, '');
        End;
    Writeln;
    InputMatrix := Matrix;
End;

Function FillMatrixFromConsole(): TMatrix;
Var
    RowNum, ColNum: Integer;
    Matrix: TMatrix;
Begin
    Writeln('������� ������� ������� (�� 2 �� 10).');
    RowNum := CheckInput(MINSIZE, MAXSIZE,
      '������� ���������� ����� �������: ');
    ColNum := CheckInput(MINSIZE, MAXSIZE,
      '������� ���������� �������� �������: ');
    SetLength(Matrix, RowNum, ColNum);
    Matrix := InputMatrix(Matrix);
    FillMatrixFromConsole := Matrix;
End;

Function CheckFilePath(Path: String): Boolean;
Var
    IsCorrect: Boolean;
Begin
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
    CheckFilePath := IsCorrect;
End;

Function CheckFileInputPath(): String;
Var
    Path: String;
    IsCorrect: Boolean;
Begin
    Repeat
        IsCorrect := True;
        Writeln('������� ���� � �����, ����������� �������. ������ ������� ������ ���� ������� ������� (������ � �������, �� 2 �� 10).');
        Readln(Path);
        IsCorrect := CheckFilePath(Path);
    Until IsCorrect;
    CheckFileInputPath := Path;
End;

Function FillMatrixFromFile(Path: String; Matrix: TMatrix): TMatrix;
Var
    I, J, RowNum, ColNum: Integer;
    FIn: TextFile;
    IsCorrect: Boolean;
Begin
    AssignFile(FIn, Path);
    Repeat
        IsCorrect := True;
        Try
            Try
                Reset(FIn);
                Read(FIn, RowNum);
                Read(FIn, ColNum);
                If (IsCorrect And (RowNum < MINSIZE) Or (RowNum > MAXSIZE) Or
                  (ColNum < MINSIZE) Or (ColNum > MAXSIZE)) Then
                Begin
                    Writeln('������ � ��������� ����� �� ������������� �������. ��������� �������.');
                    IsCorrect := False;
                End;
                SetLength(Matrix, RowNum, ColNum);
                I := 0;
                While ((I < RowNum) And IsCorrect) Do
                Begin
                    J := 0;
                    While ((J < ColNum) And IsCorrect) Do
                    Begin
                        If Eof(FIn) Then
                        Begin
                            Writeln('������ ��������� ������� �� ������������� ���������. ��������� �������.');
                            IsCorrect := False;
                        End;
                        Read(FIn, Matrix[I][J]);
                        If (IsCorrect And ((Matrix[I][J] < MIN) Or
                          (Matrix[I][J] > MAX))) Then
                        Begin
                            Writeln('������ ���������� ����� �� ������������� �������. ��������� �������.');
                            IsCorrect := False;
                        End;
                        Inc(J);
                    End;
                    Inc(I);
                End;
                If (IsCorrect And (Not Eof(FIn))) Then
                Begin
                    Writeln('������ ��������� ������� �� ������������� ���������. ��������� �������.');
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
    Writeln;
    FillMatrixFromFile := Matrix;
End;

Procedure OutputMatrix(Matrix: TMatrix);
Var
    I, J: Integer;
Begin
    Writeln('��������� �������:');
    For I := 0 To High(Matrix) Do
    Begin
        For J := 0 To High(Matrix[0]) Do
            Write(Matrix[I][J], ' ');
        Writeln;
    End;
    Writeln;
End;

Function FindZeroAmountOfEachRow(Matrix: TMatrix): TArrOI;
Var
    I, J: Integer;
    ZeroAmount: TArrOI;
Begin
    SetLength(ZeroAmount, High(Matrix) + 1);
    For I := 0 To High(Matrix) Do
    Begin
        ZeroAmount[I] := 0;
        For J := 0 To High(Matrix[I]) Do
            If Matrix[I][J] = 0 Then
                Inc(ZeroAmount[I]);
    End;
    FindZeroAmountOfEachRow := ZeroAmount;
End;

Function FindMaxZeroAmount(ZeroAmount: TArrOI): Integer;
Var
    I, MaxZeroAmount: Integer;
Begin
    MaxZeroAmount := ZeroAmount[0];
    For I := 1 To High(ZeroAmount) Do
        If ZeroAmount[I] > MaxZeroAmount Then
            MaxZeroAmount := ZeroAmount[I];
    FindMaxZeroAmount := MaxZeroAmount;
End;

Function FindNumOfMaxZeroRows(MaxZeroAmount: Integer;
  ZeroAmount: TArrOI): Integer;
Var
    I, MaxZeroRows: Integer;
Begin
    MaxZeroRows := 0;
    For I := 0 To High(ZeroAmount) Do
        If ZeroAmount[I] = MaxZeroAmount Then
            Inc(MaxZeroRows);
    FindNumOfMaxZeroRows := MaxZeroRows;
End;

Function FindMaxZeroRowIndex(MaxZeroRows, MaxZeroAmount: Integer;
  ZeroAmount: TArrOI): Integer;
Var
    I, Index: Integer;
Begin
    For I := 0 To High(ZeroAmount) Do
        If ZeroAmount[I] = MaxZeroAmount Then
            Index := I;
    FindMaxZeroRowIndex := Index;
End;

Function FindMaxZeroRowIndexArray(MaxZeroRows, MaxZeroAmount: Integer;
  ZeroAmount: TArrOI): TArrOI;
Var
    I, J: Integer;
    IndexArray: TArrOI;
Begin
    SetLength(IndexArray, MaxZeroRows);
    J := 0;
    For I := 0 To High(ZeroAmount) Do
        If ZeroAmount[I] = MaxZeroAmount Then
        Begin
            IndexArray[J] := I;
            Inc(J);
        End;
    FindMaxZeroRowIndexArray := IndexArray;
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
        IsCorrect := CheckFilePath(Path);
        If IsCorrect And FileIsReadOnly(Path) Then
        Begin
            Writeln('��������� ���� ���� �������� ������ ��� ������. ��������� �������.');
            IsCorrect := False;
        End;
    Until IsCorrect;
    CheckFileOutputPath := Path;
End;

Procedure WriteResultIntoFile(MaxZeroAmount, MaxZeroRows, Index: Integer;
  IndexArray: TArrOI; Matrix: TMatrix; Path: String);
Var
    I, J: Integer;
    IsCorrect: Boolean;
    FOut: TextFile;
Begin
    Repeat
        IsCorrect := True;
        Assign(FOut, Path);
        Try
            Try
                Rewrite(FOut);
                If MaxZeroAmount = 0 Then
                    Writeln(FOut, '� ������� ��� ����� � �������� ����������.')
                Else If MaxZeroRows = 1 Then
                Begin
                    Write(FOut,
                      '������ � ������������ ����������� ������� ���������: ');
                    For J := 0 To High(Matrix[0]) Do
                        Write(FOut, Matrix[Index][J], ' ');
                End
                Else If (MaxZeroRows = (High(Matrix) + 1)) And
                  (MaxZeroAmount = (High(Matrix[0]) + 1)) Then
                    Writeln(FOut, '��� �������� ������� - ������� ��������.')
                Else
                Begin
                    Writeln(FOut,
                      '������ � ������������ ����������� ������� ���������: ');
                    For I := 0 To High(IndexArray) Do
                    Begin
                        For J := 0 To High(Matrix[0]) Do
                            Write(FOut, Matrix[IndexArray[I]][J], ' ');
                        Writeln(FOut);
                    End;
                End;
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

Procedure OutputMaxZeroRow(Index: Integer; Matrix: TMatrix);
Var
    J: Integer;
Begin
    Write('������ � ������������ ����������� ������� ���������: ');
    For J := 0 To High(Matrix[0]) Do
        Write(Matrix[Index][J], ' ');
End;

Procedure OutputMaxZeroRows(IndexArray: TArrOI; Matrix: TMatrix);
Var
    I, J: Integer;
Begin
    Writeln('������ � ������������ ����������� ������� ���������: ');
    For I := 0 To High(IndexArray) Do
    Begin
        For J := 0 To High(Matrix[0]) Do
            Write(Matrix[IndexArray[I]][J], ' ');
        Writeln;
    End;
End;

Procedure OutputResult(MaxZeroAmount, MaxZeroRows, Index: Integer;
  IndexArray: TArrOI; Matrix: TMatrix);
Begin
    If MaxZeroAmount = 0 Then
        Writeln('� ������� ��� ����� � �������� ����������.')
    Else If MaxZeroRows = 1 Then
        OutputMaxZeroRow(Index, Matrix)
    Else If (MaxZeroRows = (High(Matrix) + 1)) And
      (MaxZeroAmount = (High(Matrix[0]) + 1)) Then
        Writeln('��� �������� ������� - ������� ��������.')
    Else
        OutputMaxZeroRows(IndexArray, Matrix);
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

Procedure WriteCondition();
Begin
    Writeln('������ ��������� ������� ������ �������, � ������� ������ ����� ������� ���������.');
    Writeln('�������� ������� - ����� ����� �� -1000 �� 1000.');
End;

Var
    MaxZeroAmount, MaxZeroRows, Index, Choice: Integer;
    ZeroAmount, IndexArray: TArrOI;
    Matrix, MaxZero: TMatrix;
    FInPath, FOutPath: String;

Begin
    WriteCondition();
    Choice := CheckChoiceInput
      ('���� �� ������ ������� ������ � �������, ������� 0. ���� ������������ ����, ������� 1.');
    If Choice = 0 Then
        Matrix := FillMatrixFromConsole()
    Else
    Begin
        FInPath := CheckFileInputPath();
        Matrix := FillMatrixFromFile(FInPath, Matrix);
    End;
    OutputMatrix(Matrix);
    ZeroAmount := FindZeroAmountOfEachRow(Matrix);
    MaxZeroAmount := FindMaxZeroAmount(ZeroAmount);
    MaxZeroRows := FindNumOfMaxZeroRows(MaxZeroAmount, ZeroAmount);
    If MaxZeroRows = 1 Then
        Index := FindMaxZeroRowIndex(MaxZeroRows, MaxZeroAmount, ZeroAmount)
    Else
        IndexArray := FindMaxZeroRowIndexArray(MaxZeroRows, MaxZeroAmount,
          ZeroAmount);
    Choice := CheckChoiceInput
      ('���� �� ������ ������� ��������� � �������, ������� 0. ���� � ����, ������� 1.');
    If Choice = 0 Then
        OutputResult(MaxZeroAmount, MaxZeroRows, Index, IndexArray, Matrix)
    Else
    Begin
        FOutPath := CheckFileOutputPath();
        WriteResultIntoFile(MaxZeroAmount, MaxZeroRows, Index, IndexArray,
          Matrix, FOutPath);
    End;
    Readln;

End.
