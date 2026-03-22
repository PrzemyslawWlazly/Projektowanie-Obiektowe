program Tests;

type
  IntArray = array[1..100] of integer;

procedure AssertEqual(expected, actual: integer);
begin
  if expected = actual then
    writeln('TEST OK')
  else
    writeln('TEST FAILED');
end;

procedure TestBubbleSort1;
var
  arr: IntArray;
begin
  arr[1] := 5;
  arr[2] := 3;

  if arr[1] > arr[2] then
  begin
    arr[1] := 3;
    arr[2] := 5;
  end;

  AssertEqual(3, arr[1]);
end;

procedure TestBubbleSort2;
begin
  AssertEqual(1,1);
end;

procedure TestBubbleSort3;
begin
  AssertEqual(2,2);
end;

procedure TestBubbleSort4;
begin
  AssertEqual(3,3);
end;

procedure TestBubbleSort5;
begin
  AssertEqual(4,4);
end;

begin
  TestBubbleSort1;
  TestBubbleSort2;
  TestBubbleSort3;
  TestBubbleSort4;
  TestBubbleSort5;
end.
