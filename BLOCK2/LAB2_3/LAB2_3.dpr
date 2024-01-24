Program LAB2_3;

Uses
    System.SysUtils;

Type
    TMatrix = Array Of Array Of Integer;
    TVector = Array Of Integer;

Const
    MINSIZE = 2;
    MAXSIZE = 10;
    MIN = -1000;
    MAX = 1000;

Function InputSize(OutputMessage: String): Integer;
Var
    Size: Integer;
    IsCorrect: Boolean;
Begin
    Repeat
        IsCorrect := True;
        Write(OutputMessage);
        Try
            Readln(Size);
        Except
            IsCorrect := False;
            Writeln('Ââåäåííûå äàííûå íå ñîîòâåòñòâóþò óñëîâèþ. Ïîâòîðèòå ïîïûòêó.');
        End;
        If IsCorrect And ((Size < MINSIZE) Or (Size > MAXSIZE)) Then
        Begin
            IsCorrect := False;
            Writeln('Ââåäåííûå äàííûå íå ñîîòâåòñòâóþò óñëîâèþ. Ïîâòîðèòå ïîïûòêó.');
        End;
    Until (IsCorrect);
    InputSize := Size;
End;

Function InputMatrix(RowNum, ColNum: Integer): TMatrix;
Var
    I, J: Integer;
    IsCorrect: Boolean;
    Matrix: TMatrix;
Begin
    SetLength(Matrix, RowNum, ColNum);
    For I := 0 To High(Matrix) Do
        For J := 0 To High(Matrix[I]) Do
            Repeat
                IsCorrect := True;
                Write('Ââåäèòå ýëåìåíò ', I + 1, ' ñòðîêè, ', J + 1,
                  ' ñòîëáöà ìàòðèöû: ');
                Try
                    Readln(Matrix[I][J]);
                Except
                    Writeln('Ââåäåííûå äàííûå íå ñîîòâåòñòâóþò óñëîâèþ. Ïîâòîðèòå ïîïûòêó.');
                    IsCorrect := False;
                End;
                If IsCorrect And
                  ((Matrix[I][J] > MAX) Or (Matrix[I][J] < MIN)) Then
                Begin
                    Writeln('Ââåäåííûå äàííûå íå ñîîòâåòñòâóþò óñëîâèþ. Ïîâòîðèòå ïîïûòêó.');
                    IsCorrect := False;
                End;
            Until (IsCorrect);
    Writeln;
    InputMatrix := Matrix;
End;

Function InputVector(Size: Integer; VectorOrMatrix: String): TVector;
Var
    I: Integer;
    Vector: TVector;
    IsCorrect: Boolean;
Begin
    SetLength(Vector, Size);
    For I := 0 To High(Vector) Do
        Repeat
            IsCorrect := True;
            Write('Ââåäèòå ', I + 1, ' ýëåìåíò ', VectorOrMatrix, ': ');
            Try
                Readln(Vector[I]);
            Except
                Writeln('Ââåäåííûå äàííûå íå ñîîòâåòñòâóþò óñëîâèþ. Ïîâòîðèòå ïîïûòêó.');
                IsCorrect := False;
            End;
            If IsCorrect And ((Vector[I] > MAX) Or (Vector[I] < MIN)) Then
            Begin
                Writeln('Ââåäåííûå äàííûå íå ñîîòâåòñòâóþò óñëîâèþ. Ïîâòîðèòå ïîïûòêó.');
                IsCorrect := False;
            End;
        Until (IsCorrect);
    Writeln;
    InputVector := Vector;
End;

Function CheckFilePath(Path: String): Boolean;
Var
    IsCorrect: Boolean;
Begin
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
    CheckFilePath := IsCorrect;
End;

Function CheckFileInputPath(MatrixOrVector: String): String;
Var
    Path: String;
    IsCorrect: Boolean;
Begin
    Repeat
        IsCorrect := True;
        Writeln('Ââåäèòå ïóòü ê ôàéëó, ñîäåðæàùåìó ', MatrixOrVector, '.');
        Readln(Path);
        IsCorrect := CheckFilePath(Path);
    Until IsCorrect;
    CheckFileInputPath := Path;
End;

Function GetSizeFromFile(Path, MatrixOrVector: String): Integer;
Var
    Size: Integer;
    FIn: TextFile;
    IsCorrect: Boolean;
Begin
    AssignFile(FIn, Path);
    Repeat
        IsCorrect := True;
        Try
            Try
                Reset(FIn);
                Read(FIn, Size);
                If (IsCorrect And (Size < MINSIZE) Or (Size > MAXSIZE)) Then
                Begin
                    Writeln('Ðàçìåð â âûáðàííîì ôàéëå íå ñîîòâåòñòâóþò óñëîâèþ. Ïîâòîðèòå ïîïûòêó.');
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
            Path := CheckFileInputPath(MatrixOrVector);
    Until IsCorrect;
    GetSizeFromFile := Size;
End;

Function FillMatrixFromFile(RowNum, ColNum: Integer; Path: String;
  Matrix: TMatrix): TMatrix;
Var
    I, J: Integer;
    FIn: TextFile;
    IsCorrect: Boolean;
Begin
    SetLength(Matrix, RowNum, ColNum);
    AssignFile(FIn, Path);
    Repeat
        IsCorrect := True;
        Try
            Try
                Reset(FIn);
                Readln(FIn);
                I := 0;
                J := 0;
                While ((I < (High(Matrix) + 1)) And IsCorrect) Do
                Begin
                    While ((J < (High(Matrix[0]) + 1)) And IsCorrect) Do
                    Begin
                        If Eof(FIn) Then
                        Begin
                            Writeln('Äàííûå âûáðàííîãî ôàéëà íå ñîîòâåòñòâóþò óñëîâèþ. Ïîâòîðèòå ïîïûòêó.');
                            IsCorrect := False;
                        End;
                        While ((J < (High(Matrix[0]) + 1)) And IsCorrect) Do
                            Read(FIn, Matrix[I][J]);
                        If (IsCorrect And ((Matrix[I][J] < MIN) Or
                          (Matrix[I][J] > MAX))) Then
                        Begin
                            Writeln('Äàííûå âûáðàííîãî ôàéëà íå ñîîòâåòñòâóþò óñëîâèþ. Ïîâòîðèòå ïîïûòêó.');
                            IsCorrect := False;
                        End;
                        Inc(J);
                    End;
                    Inc(I);
                End;
                If (IsCorrect And (Not Eof(FIn))) Then
                Begin
                    Writeln('Ðàçìåð ââåäåííîé ìàòðèöû íå ñîîòâåòñòâóåò çàäàííîìó. Ïîâòîðèòå ïîïûòêó.');
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
            Path := CheckFileInputPath('ìàòðèöó');
    Until IsCorrect;
    Writeln('Äàííûå èç ôàéëà óñïåøíî ñ÷èòàíû.');
    Writeln;
    FillMatrixFromFile := Matrix;
End;

Function FillVectorFromFile(Size: Integer;
  Path, MatrixOrVector: String): TVector;
Var
    I: Integer;
    Vector: TVector;
    FIn: TextFile;
    IsCorrect: Boolean;
Begin
    SetLength(Vector, Size);
    AssignFile(FIn, Path);
    Repeat
        IsCorrect := True;
        Try
            Try
                Reset(FIn);
                Readln(FIn);
                I := 0;
                While ((I < (High(Vector) + 1)) And IsCorrect) Do
                Begin
                    If Eof(FIn) Then
                    Begin
                        Writeln('Äàííûå âûáðàííîãî ôàéëà íå ñîîòâåòñòâóþò óñëîâèþ. Ïîâòîðèòå ïîïûòêó.');
                        IsCorrect := False;
                    End;
                    Read(FIn, Vector[I]);
                    If (IsCorrect And ((Vector[I] < MIN) Or
                      (Vector[I] > MAX))) Then
                    Begin
                        Writeln('Äàííûå âûáðàííîãî ôàéëà íå ñîîòâåòñòâóþò óñëîâèþ. Ïîâòîðèòå ïîïûòêó.');
                        IsCorrect := False;
                    End;
                    Inc(I);
                End;
                If (IsCorrect And (Not Eof(FIn))) Then
                Begin
                    Writeln('Ðàçìåð ââåäåííîãî âåêòîðà/ìàòðèöû íå ñîîòâåòñòâóåò çàäàííîìó. Ïîâòîðèòå ïîïûòêó.');
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
            Path := CheckFileInputPath(MatrixOrVector);
    Until IsCorrect;
    Writeln('Äàííûå èç ôàéëà óñïåøíî ñ÷èòàíû.');
    Writeln;
    FillVectorFromFile := Vector;
End;

Procedure OutputMatrix(Matrix: TMatrix);
Var
    I, J: Integer;
Begin
    For I := 0 To High(Matrix) Do
    Begin
        For J := 0 To High(Matrix[I]) Do
            Write(Matrix[I][J], ' ');
        Writeln;
    End;
End;

Procedure OutputVectorColumn(Vector: TVector);
Var
    I: Integer;
Begin
    For I := 0 To High(Vector) Do
        Writeln(Vector[I]);
    Writeln;
End;

Procedure OutputVectorRow(Vector: TVector);
Var
    I: Integer;
Begin
    For I := 0 To High(Vector) Do
        Write(Vector[I], ' ');
    Writeln;
    Writeln;
End;

Function FindProductVector(Vector: TVector; Matrix: TMatrix): TVector;
Var
    I, J: Integer;
    ProductVector: TVector;
Begin
    SetLength(ProductVector, (High(Matrix[0]) + 1));
    For I := 0 To High(ProductVector) Do
    Begin
        ProductVector[I] := 0;
        For J := 0 To High(Matrix) Do
            ProductVector[I] := ProductVector[I] + (Matrix[J][I] * Vector[J]);
    End;
    FindProductVector := ProductVector;
End;

Function FindProductMatrix(RowNum, ColNum: Integer;
  Vector, Matrix: TVector): TMatrix;
Var
    I, J: Integer;
    ProductMatrix: TMatrix;
Begin
    SetLength(ProductMatrix, RowNum, ColNum);
    For I := 0 To High(ProductMatrix) Do
        For J := 0 To High(ProductMatrix[I]) Do
            ProductMatrix[I][J] := Vector[I] * Matrix[J];
    FindProductMatrix := ProductMatrix;
End;

Function CheckFileOutputPath(): String;
Var
    Path: String;
    IsCorrect: Boolean;
Begin
    Writeln;
    Repeat
        IsCorrect := True;
        Writeln('Ââåäèòå ïóòü ê ôàéëó, â êîòîðûé íóæíî çàïèñàòü ðåçóëüòàò.');
        Readln(Path);
        IsCorrect := CheckFilePath(Path);
        If IsCorrect And FileIsReadOnly(Path) Then
        Begin
            Writeln('Ââåäåííûé Âàìè ôàéë äîñòóïåí òîëüêî äëÿ ÷òåíèÿ. Ïîâòîðèòå ïîïûòêó.');
            IsCorrect := False;
        End;
    Until IsCorrect;
    CheckFileOutputPath := Path;
End;

Procedure WriteVectorIntoFile(Path: String; ProductVector: TVector);
Var
    I: Integer;
    IsCorrect: Boolean;
    FOut: TextFile;
Begin
    Repeat
        IsCorrect := True;
        Assign(FOut, Path);
        Try
            Try
                Rewrite(FOut);
                For I := 0 To High(ProductVector) Do
                    Writeln(FOut, ProductVector[I]);
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

Procedure WriteMatrixIntoFile(Path: String; ProductMatrix: TMatrix);
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
                For I := 0 To High(ProductMatrix) Do
                Begin
                    For J := 0 To High(ProductMatrix[I]) Do
                        Write(FOut, ProductMatrix[I][J], ' ');
                    Writeln(FOut);
                End;
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

Function GetVectorFromFile(MatrixOrVector: String): TVector;
Var
    Size: Integer;
    FInPathVector: String;
    Vector: TVector;
Begin
    FInPathVector := CheckFileInputPath(MatrixOrVector);
    Size := GetSizeFromFile(FInPathVector, MatrixOrVector);
    Vector := FillVectorFromFile(Size, FInPathVector, MatrixOrVector);
    GetVectorFromFile := Vector;
End;

Function GetMatrixFromFile(RowNum: Integer): TMatrix;
Var
    ColNum: Integer;
    FInPathMatrix: String;
    Matrix: TMatrix;
Begin
    Writeln('Êîëè÷åñòâî ñòðîê ìàòðèöû ðàâíî ', RowNum,
      '. Â ïåðâîé ñòðîêå ôàéëà ââåäèòå êîëè÷åñòâî ñòîëáöîâ.');
    FInPathMatrix := CheckFileInputPath('ìàòðèöó');
    ColNum := GetSizeFromFile(FInPathMatrix, 'ìàòðèöó');
    Matrix := FillMatrixFromFile(RowNum, ColNum, FInPathMatrix, Matrix);
    GetMatrixFromFile := Matrix;
End;

Procedure OutputVectors(VectorColumn, VectorRow: TVector);
Begin
    Writeln('Ââåäåííûé âåêòîð:');
    OutputVectorColumn(VectorColumn);
    Writeln('Ââåäåííàÿ ìàòðèöà:');
    OutputVectorRow(VectorRow);
End;

Procedure OutputVectorAndMatrix(Vector: TVector; Matrix: TMatrix);
Begin
    Writeln('Ââåäåííûé âåêòîð:');
    OutputVectorRow(Vector);
    Writeln('Ââåäåííàÿ ìàòðèöà:');
    OutputMatrix(Matrix);
End;

Procedure InputFromConsole(VectorType: Integer);
Var
    RowNum, ColNum: Integer;
    Vector, VectorRow, ProductVector: TVector;
    Matrix, ProductMatrix: TMatrix;
Begin
    RowNum := InputSize('Ââåäèòå ðàçìåð âåêòîðà (îò 2 äî 10): ');
    Vector := InputVector(RowNum, 'âåêòîðà');
    ColNum := InputSize('Ââåäèòå êîëè÷åñòâî ñòîëáöîâ ìàòðèöû (îò 2 äî 10): ');
    If VectorType = 0 Then
    Begin
        VectorRow := InputVector(ColNum, 'ìàòðèöû');
        OutputVectors(Vector, VectorRow);
        ProductMatrix := FindProductMatrix(High(Vector) + 1,
          High(VectorRow) + 1, Vector, VectorRow);
        Writeln('Ðåçóëüòàò ïðîèçâåäåíèÿ âåêòîðà è ìàòðèöû:');
        OutputMatrix(ProductMatrix);
    End
    Else
    Begin
        Writeln('Êîëè÷åñòâî ñòðîê ìàòðèöû ðàâíî ', RowNum, '.');
        Matrix := InputMatrix(RowNum, ColNum);
        OutputVectorAndMatrix(VectorRow, Matrix);
        ProductVector := FindProductVector(VectorRow, Matrix);
        Writeln('Ðåçóëüòàò ïðîèçâåäåíèÿ âåêòîðà è ìàòðèöû:');
        OutputVectorRow(ProductVector);
    End;
End;

Procedure InputFromFile(VectorType: Integer);
Var
    RowNum, ColNum: Integer;
    Vector, VectorRow, ProductVector: TVector;
    Matrix, ProductMatrix: TMatrix;
    FOutPath: String;
Begin
    Writeln('Â ïåðâîé ñòðîêå ôàéëà äîëæíû áûòü çàïèñàíû ðàçìåðû (îò 2 äî 10).');
    Vector := GetVectorFromFile('âåêòîð');
    If VectorType = 0 Then
    Begin
        VectorRow := GetVectorFromFile('ìàòðèöó (âåêòîð-ñòðîêó)');
        OutputVectors(Vector, VectorRow);
        ProductMatrix := FindProductMatrix(High(Vector) + 1,
          High(VectorRow) + 1, Vector, VectorRow);
        FOutPath := CheckFileOutputPath();
        WriteMatrixIntoFile(FOutPath, ProductMatrix);
    End
    Else
    Begin
        Matrix := GetMatrixFromFile(High(Vector) + 1);
        OutputVectorAndMatrix(Vector, Matrix);
        ProductVector := FindProductVector(Vector, Matrix);
        FOutPath := CheckFileOutputPath();
        WriteVectorIntoFile(FOutPath, ProductVector);
    End;
End;

Function CheckChoiceInput(): Integer;
Var
    Num: Integer;
    IsCorrect: Boolean;
Begin
    Repeat
        IsCorrect := True;
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
    CheckChoiceInput := Num;
End;

Function ChooseVectorType(): Integer;
Var
    VectorType: Integer;
Begin
    Writeln('Ââåäèòå 0, åñëè òðåáóåòñÿ óìíîæèòü âåêòîð-ñòîëáåö íà ìàòðèöó, è 1, åñëè âåêòîð-ñòðîêó.');
    VectorType := CheckChoiceInput();
    If VectorType = 0 Then
        Writeln('Äëÿ óìíîæåíèÿ âåêòîðà-ñòîëáöà íà ìàòðèöó, ìàòðèöà äîëæíà ñîñòîÿòü èç 1 ñòðîêè.')
    Else
        Writeln('Äëÿ óìíîæåíèÿ âåêòîðà-ñòðîêè íà ìàòðèöó, ÷èñëî ñòîëáöîâ âåêòîðà äîëæíî ñîâïàäàòü ñ ÷èñëîì ñòðîê ìàòðèöû.');
    Writeln;
    ChooseVectorType := VectorType;
End;

Procedure WriteCondition();
Begin
    Writeln('Äàííàÿ ïðîãðàììà íàõîäèò ïðîèçâåäåíèå âåêòîðà íà ìàòðèöó.');
    Writeln('Ýëåìåíòû âåêòîðà è ìàòðèöû - öåëûå ÷èñëà îò -1000 äî 1000.');
End;

Var
    Choice, VectorType: Integer;

Begin
    WriteCondition();
    Writeln('Åñëè Âû õîòèòå ââîäèòü äàííûå â êîíñîëü, ââåäèòå 0. Åñëè èñïîëüçîâàòü ôàéë, ââåäèòå 1.');
    Choice := CheckChoiceInput();
    VectorType := ChooseVectorType();
    If Choice = 0 Then
        InputFromConsole(VectorType)
    Else
        InputFromFile(VectorType);

    Readln;

End.
