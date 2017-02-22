unit PowerMath;

interface

function a(k, n: integer): real;
function c(k, n: integer): real;
function digit(n: real): word;
function pow(a, n: real): real;
function fact(n: byte): real;
function fib(n: word): real;
function gold(): real;
function is_digit(input: char): boolean;
function normal_shot(a: real): string;
function nsd(a, b: real): real;
function nsk(a, b: integer): integer;
function tobin(n: real; d: integer): string;
function todec(n: string; d: byte): integer;
function trim(a: integer; n: byte): integer;
function trim_end(a: integer; n: byte): integer;

implementation

function a(k, n: integer): real;
begin
  Result := fact(n) / fact(n - k);
end;

function c(k, n: integer): real;
begin
  Result := a(k, n) * (1 / fact(k));
end;

function digit(n: real): word;
var
  x: word;
begin
  n := abs(n); 
  x := 0; 
  repeat
    inc(x); 
    n /= 10;
  until (n = 0);
  Result := x;
end;


function pow(a, n: real): real;
begin
  Result := power(a, n)
end;

function fact(n: byte): real;
begin
  if (n <= 1) then fact := 1 else 
    Result := n * fact(n - 1);
end;

function fib(n: word): real;
var
  f0, f1: real;
begin
  f0 := 0;
  f1 := 1;
  case (n) of
    0: fib := f0;
    1: fib := f1;
  else 
    repeat
      f1 := f0 + f1;
      f0 := f1 - f0;
      n := n - 1;
    until (n <= 1);
    Result := f1;
  end;
end;

function gold(): real;
begin
  Result := (sqrt(5) + 1) / 2;
end;

function is_digit(input: char): boolean;
begin
  Result := ((input >= '0') and 
             (input <= '9')) ? true : false;
end;

function normal_shot(a: real): string;
const
  epsilon = 8 * 2;// size of real * 2
var
  d, n: real;
begin
  Result := '';
  if (a < 0) then begin a := abs(a);Result += '-'; end;
  if (a.ToString.Contains('E')) then 
    Result += a.ToString else
  begin
    repeat
      d += 1;
      n := a * d;
      if (n.ToString.Length = epsilon) then
        n := Real.Parse(n.ToString.Remove(epsilon - 1, 1));
    until (not n.ToString.Contains(','));
    if (d = 1) then
      Result += n.ToString else
      Result += n.ToString + '/' + d.ToString;
  end;
end;

function nsd(a, b: real): real;
begin
  if (a = 0) then Result := b else
  begin
    while (b <> 0) do
    begin
      if (a > b) then 
        a -= b else
        b -= a;
    end;
    Result := a;
  end;
end;

function nsk(a, b: integer): integer;
begin
  Result := Trunc(a / nsd(a, b) * b);
end;

function tobin(n: real; d: integer): string;
var
  chars := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  s: string;
  n2: integer;
begin
  n2 := round(int(n));
  s := '';
  repeat
    s := ((chars[n2 mod d + 1]) + s);
    n2 := n2 div d;
  until (n2 = 0);
  Result := s;
end;

function todec(n: string; d: byte): integer;
var
  chars := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  i, j, sum: integer;
begin
  sum := 0;
  j := n.Length;
  for i := 1 to j do
  begin
    Dec(j);
    sum := sum + Round((pos(n[i], chars) - 1) * Exp(Ln(d) * j));
  end;
  Result := sum;
end;

function trim(a: integer; n: byte): integer;
begin
  Result := Trunc(a / Power(10, digit(a) - n));
end;

function trim_end(a: integer; n: byte): integer;
begin
  Result := Round(Frac(a / pow(10, n)) * pow(10, n));
end;
end.