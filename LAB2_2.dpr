Program LAB2_2;

Uses
    System.SysUtils;

Const
    MIN = 0;
    MAX = 9;
    MINNUM = 1;
    MAXNUM = 1000000;

Type
    TArrOI = Array Of Integer;

Procedure WriteCondition();
Begin
    Writeln('������ ��������� ���������� ��� ����� ���������.');
    Writeln('������� ����� �����: ����� �����, �� 1 �� 1000000.');
End;

Function InputNum(Number: Integer): Integer;
Var
    Num: Integer;
    IsCorrect: Boolean;
Begin
    Repeat
        IsCorrect := True;
        Write('������� ', Number, ' �����: ');
        Try
            Read(Num);
        Except
            Writeln('��������� ������ �� ������������� �������. ��������� �������.');
            IsCorrect := False;
        End;
        If IsCorrect And ((Num < MINNUM) Or (Num > MAXNUM)) Then
        Begin
            Writeln('��������� ������ �� ������������� �������. ��������� �������.');
            IsCorrect := False;
        End;
    Until IsCorrect;
    InputNum := Num;
End;

Function FindNumSize(Num, Size: Integer): Integer;
Begin
    Size := 0;
    While Num > MIN Do
    Begin
        Inc(Size);
        Num := Num Div 10;
    End;
    FindNumSize := Size;
End;

Function ConvertToArray(Num, Size: Integer): TArrOI;
Var
    NumArr: TArrOI;
    I, Ten: Integer;
Begin
    SetLength(NumArr, Size);
    Ten := 10;
    For I := High(NumArr) DownTo 0 Do
    Begin
        NumArr[I] := (Num Mod Ten) Div (Ten Div 10);
        Ten := Ten * 10;
    End;
    ConvertToArray := NumArr;
End;

Function FindSum(BiggerSize, SmallerSize: Integer;
  BiggerNum, SmallerNum: TArrOI): TArrOI;
Var
    Sum: TArrOI;
    I: Integer;
Begin
    SetLength(Sum, BiggerSize);
    For I := High(Sum) DownTo 0 Do
        If (I > (BiggerSize - SmallerSize - 1)) Then
            Sum[I] := BiggerNum[I] + SmallerNum[I - (BiggerSize - SmallerSize)]
        Else
            Sum[I] := BiggerNum[I];
    FindSum := Sum;
End;

Function FindSumCondition(FstSize, SecSize: Integer;
  FstNumArr, SecNumArr: TArrOI): TArrOI;
Var
    Sum: TArrOI;
Begin
    If (FstSize > SecSize) Then
        Sum := FindSum(FstSize, SecSize, FstNumArr, SecNumArr)
    Else
        Sum := FindSum(SecSize, FstSize, SecNumArr, FstNumArr);
    FindSumCondition := Sum;
End;

Procedure AddOnes(Var Sum: TArrOI);
Var
    I, One: Integer;
Begin
    One := 0;
    For I := High(Sum) DownTo 1 Do
    Begin
        Sum[I] := Sum[I] + One;
        If Sum[I] > MAX Then
        Begin
            One := 1;
            Sum[I] := Sum[I] - 10;
        End
        Else
            One := 0;
    End;
    Sum[0] := Sum[0] + One;
End;

Procedure AddPosition(Var Sum: TArrOI);
Var
    I: Integer;
Begin
    If Sum[0] > MAX Then
    Begin
        SetLength(Sum, (High(Sum) + 2));
        For I := (High(Sum) - 1) Downto 0 Do
            Sum[I + 1] := Sum[I];
        Sum[1] := Sum[0] - 10;
        Sum[0] := 1;
    End;
End;

Procedure OutputArray(Arr, Sum: TArrOI);
Var
    I: Integer;
Begin
    For I := Low(Arr) To (5 - High(Arr)) Do
        Write(' ');
    For I := Low(Arr) To High(Arr) Do
        Write(Arr[I]);
    Writeln;
End;

Procedure OutputSum(FstNumArr, SecNumArr, Sum: TArrOI);
Var
    I: Integer;
Begin
    Writeln('���������:');
    OutputArray(FstNumArr, Sum);
    Writeln('+');
    OutputArray(SecNumArr, Sum);
    Writeln('-------');
    OutputArray(Sum, Sum);
End;

Var
    FstNum, SecNum, FstSize, SecSize: Integer;
    FstNumArr, SecNumArr, Sum: TArrOI;

Begin
    WriteCondition();
    FstNum := InputNum(1);
    SecNum := InputNum(2);
    FstSize := FindNumSize(FstNum, FstSize);
    SecSize := FindNumSize(SecNum, SecSize);
    FstNumArr := ConvertToArray(FstNum, FstSize);
    SecNumArr := ConvertToArray(SecNum, SecSize);
    Sum := FindSumCondition(FstSize, SecSize, FstNumArr, SecNumArr);
    AddOnes(Sum);
    AddPosition(Sum);
    OutputSum(FstNumArr, SecNumArr, Sum);
    Readln(FstSize);

End.
