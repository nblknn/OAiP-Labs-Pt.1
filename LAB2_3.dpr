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
            Writeln('Введенные данные не соответствуют условию. Повторите попытку.');
        End;
        If IsCorrect And ((Size < MINSIZE) Or (Size > MAXSIZE)) Then
        Begin
            IsCorrect := False;
            Writeln('Введенные данные не соответствуют условию. Повторите попытку.');
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
                Write('Введите элемент ', I + 1, ' строки, ', J + 1,
                  ' столбца матрицы: ');
                Try
                    Readln(Matrix[I][J]);
                Except
                    Writeln('Введенные данные не соответствуют условию. Повторите попытку.');
                    IsCorrect := False;
                End;
                If IsCorrect And
                  ((Matrix[I][J] > MAX) Or (Matrix[I][J] < MIN)) Then
                Begin
                    Writeln('Введенные данные не соответствуют условию. Повторите попытку.');
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
            Write('Введите ', I + 1, ' элемент ', VectorOrMatrix, ': ');
            Try
                Readln(Vector[I]);
            Except
                Writeln('Введенные данные не соответствуют условию. Повторите попытку.');
                IsCorrect := False;
            End;
            If IsCorrect And ((Vector[I] > MAX) Or (Vector[I] < MIN)) Then
            Begin
                Writeln('Введенные данные не соответствуют условию. Повторите попытку.');
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
        Writeln('Введенного файла не существует. Повторите попытку.');
        IsCorrect := False;
    End
    Else If ExtractFileExt(Path) <> '.txt' Then
    Begin
        Writeln('Введенный Вами файл не является текстовым. Повторите попытку.');
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
        Writeln('Введите путь к файлу, содержащему ', MatrixOrVector, '.');
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
                    Writeln('Размер в выбранном файле не соответствуют условию. Повторите попытку.');
                    IsCorrect := False;
                End;
            Finally
                CloseFile(FIn);
            End;
        Except
            Writeln('Данные выбранного файла не соответствуют условию. Повторите попытку.');
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
                            Writeln('Данные выбранного файла не соответствуют условию. Повторите попытку.');
                            IsCorrect := False;
                        End;
                        While ((J < (High(Matrix[0]) + 1)) And IsCorrect) Do
                            Read(FIn, Matrix[I][J]);
                        If (IsCorrect And ((Matrix[I][J] < MIN) Or
                          (Matrix[I][J] > MAX))) Then
                        Begin
                            Writeln('Данные выбранного файла не соответствуют условию. Повторите попытку.');
                            IsCorrect := False;
                        End;
                        Inc(J);
                    End;
                    Inc(I);
                End;
                If (IsCorrect And (Not Eof(FIn))) Then
                Begin
                    Writeln('Размер введенной матрицы не соответствует заданному. Повторите попытку.');
                    IsCorrect := False;
                End;
            Finally
                CloseFile(FIn);
            End;
        Except
            Writeln('Данные выбранного файла не соответствуют условию. Повторите попытку.');
            IsCorrect := False;
        End;
        If Not IsCorrect Then
            Path := CheckFileInputPath('матрицу');
    Until IsCorrect;
    Writeln('Данные из файла успешно считаны.');
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
                        Writeln('Данные выбранного файла не соответствуют условию. Повторите попытку.');
                        IsCorrect := False;
                    End;
                    Read(FIn, Vector[I]);
                    If (IsCorrect And ((Vector[I] < MIN) Or
                      (Vector[I] > MAX))) Then
                    Begin
                        Writeln('Данные выбранного файла не соответствуют условию. Повторите попытку.');
                        IsCorrect := False;
                    End;
                    Inc(I);
                End;
                If (IsCorrect And (Not Eof(FIn))) Then
                Begin
                    Writeln('Размер введенного вектора/матрицы не соответствует заданному. Повторите попытку.');
                    IsCorrect := False;
                End;
            Finally
                CloseFile(FIn);
            End;
        Except
            Writeln('Данные выбранного файла не соответствуют условию. Повторите попытку.');
            IsCorrect := False;
        End;
        If Not IsCorrect Then
            Path := CheckFileInputPath(MatrixOrVector);
    Until IsCorrect;
    Writeln('Данные из файла успешно считаны.');
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
        Writeln('Введите путь к файлу, в который нужно записать результат.');
        Readln(Path);
        IsCorrect := CheckFilePath(Path);
        If IsCorrect And FileIsReadOnly(Path) Then
        Begin
            Writeln('Введенный Вами файл доступен только для чтения. Повторите попытку.');
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
            Writeln('Произошла ошибка. Повторите попытку.');
            IsCorrect := False;
            Path := CheckFileOutputPath();
        End;
    Until IsCorrect;
    Writeln('Результат записан.');
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
            Writeln('Произошла ошибка. Повторите попытку.');
            IsCorrect := False;
            Path := CheckFileOutputPath();
        End;
    Until IsCorrect;
    Writeln('Результат записан.');
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
    Writeln('Количество строк матрицы равно ', RowNum,
      '. В первой строке файла введите количество столбцов.');
    FInPathMatrix := CheckFileInputPath('матрицу');
    ColNum := GetSizeFromFile(FInPathMatrix, 'матрицу');
    Matrix := FillMatrixFromFile(RowNum, ColNum, FInPathMatrix, Matrix);
    GetMatrixFromFile := Matrix;
End;

Procedure OutputVectors(VectorColumn, VectorRow: TVector);
Begin
    Writeln('Введенный вектор:');
    OutputVectorColumn(VectorColumn);
    Writeln('Введенная матрица:');
    OutputVectorRow(VectorRow);
End;

Procedure OutputVectorAndMatrix(Vector: TVector; Matrix: TMatrix);
Begin
    Writeln('Введенный вектор:');
    OutputVectorRow(Vector);
    Writeln('Введенная матрица:');
    OutputMatrix(Matrix);
End;

Procedure InputFromConsole(VectorType: Integer);
Var
    RowNum, ColNum: Integer;
    Vector, VectorRow, ProductVector: TVector;
    Matrix, ProductMatrix: TMatrix;
Begin
    RowNum := InputSize('Введите размер вектора (от 2 до 10): ');
    Vector := InputVector(RowNum, 'вектора');
    ColNum := InputSize('Введите количество столбцов матрицы (от 2 до 10): ');
    If VectorType = 0 Then
    Begin
        VectorRow := InputVector(ColNum, 'матрицы');
        OutputVectors(Vector, VectorRow);
        ProductMatrix := FindProductMatrix(High(Vector) + 1,
          High(VectorRow) + 1, Vector, VectorRow);
        Writeln('Результат произведения вектора и матрицы:');
        OutputMatrix(ProductMatrix);
    End
    Else
    Begin
        Writeln('Количество строк матрицы равно ', RowNum, '.');
        Matrix := InputMatrix(RowNum, ColNum);
        OutputVectorAndMatrix(VectorRow, Matrix);
        ProductVector := FindProductVector(VectorRow, Matrix);
        Writeln('Результат произведения вектора и матрицы:');
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
    Writeln('В первой строке файла должны быть записаны размеры (от 2 до 10).');
    Vector := GetVectorFromFile('вектор');
    If VectorType = 0 Then
    Begin
        VectorRow := GetVectorFromFile('матрицу (вектор-строку)');
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
            Writeln('Введенные данные не соответствуют условию. Повторите попытку.');
        End;
        If IsCorrect And ((Num <> 0) And (Num <> 1)) Then
        Begin
            IsCorrect := False;
            Writeln('Введенные данные не соответствуют условию. Повторите попытку.');
        End;
    Until (IsCorrect);
    CheckChoiceInput := Num;
End;

Function ChooseVectorType(): Integer;
Var
    VectorType: Integer;
Begin
    Writeln('Введите 0, если требуется умножить вектор-столбец на матрицу, и 1, если вектор-строку.');
    VectorType := CheckChoiceInput();
    If VectorType = 0 Then
        Writeln('Для умножения вектора-столбца на матрицу, матрица должна состоять из 1 строки.')
    Else
        Writeln('Для умножения вектора-строки на матрицу, число столбцов вектора должно совпадать с числом строк матрицы.');
    Writeln;
    ChooseVectorType := VectorType;
End;

Procedure WriteCondition();
Begin
    Writeln('Данная программа находит произведение вектора на матрицу.');
    Writeln('Элементы вектора и матрицы - целые числа от -1000 до 1000.');
End;

Var
    Choice, VectorType: Integer;

Begin
    WriteCondition();
    Writeln('Если Вы хотите вводить данные в консоль, введите 0. Если использовать файл, введите 1.');
    Choice := CheckChoiceInput();
    VectorType := ChooseVectorType();
    If Choice = 0 Then
        InputFromConsole(VectorType)
    Else
        InputFromFile(VectorType);

    Readln;

End.
