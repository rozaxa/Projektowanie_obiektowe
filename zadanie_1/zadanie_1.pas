uses crt, sysutils;

{To specify a different range, please provide arguments when running the program:
First argument  -> Lower bound of the range
Second argument -> Upper bound of the range
Third argument  -> Number of numbers to generate }

const
  DefaultMin = 0;
  DefaultMax = 100;
  DefaultCount = 50;
  MaxSize = 100;

type
  Ar = array[1..MaxSize] of integer;

procedure GenerateNumbers(var arr: Ar; minVal, maxVal, count: integer);
var
  i: integer;
begin
  randomize;
  for i := 1 to count do
    arr[i] := minVal + random(maxVal - minVal + 1);
end;

procedure BubbleSort(var arr: Ar; count: integer);
var
  i, j, temp: integer;
begin
  for i := 1 to count - 1 do
    for j := 1 to count - i do
      if arr[j] > arr[j + 1] then
      begin
        temp := arr[j];
        arr[j] := arr[j + 1];
        arr[j + 1] := temp;
      end;
end;

procedure DisplayNumbers(arr: Ar; count: integer);
var
  i: integer;
begin
  for i := 1 to count do
    write(arr[i], ' ');
  writeln;
end;

var
  numbers: Ar;
  minVal, maxVal, count: integer;
begin
  clrscr;

  if ParamCount >= 1 then
    minVal := StrToIntDef(ParamStr(1), DefaultMin)
  else
    minVal := DefaultMin;

  if ParamCount >= 2 then
    maxVal := StrToIntDef(ParamStr(2), DefaultMax)
  else
    maxVal := DefaultMax;

  if ParamCount >= 3 then
    count := StrToIntDef(ParamStr(3), DefaultCount)
  else
    count := DefaultCount;

  if (count < 1) or (count > MaxSize) then count := DefaultCount;
  if minVal > maxVal then
  begin
    writeln('Invalid range, using defaults.');
    minVal := DefaultMin;
    maxVal := DefaultMax;
  end;

  GenerateNumbers(numbers, minVal, maxVal, count);
  writeln('Random numbers:');
  DisplayNumbers(numbers, count);

  BubbleSort(numbers, count);
  writeln('Sorted numbers:');
  DisplayNumbers(numbers, count);

end.
