unit DrawGraph;

interface

uses
  GraphABC, PowerMath;

procedure draw_cs(size: integer; scale: real; 
                  dx, dy: integer; numbering: boolean);
function draw_xy(x, y: real; dx, dy: integer; size: integer; 
                  scale: real): boolean;
function move_cur(x, y: real; dx, dy: integer; size: integer; 
                  scale: real): boolean;

implementation

procedure draw_cs(size: integer; scale: real; 
                  dx, dy: integer; numbering: boolean);

const
  o: byte = 30;
  z: word = round(size * 0.5);
  number_of_points: byte = round(size / (2 * o));

var
  i, num, temp_num: integer;
  str: string;

begin
  Pen.Width := 1;
  {��������� ����������� ������}
  dx := dx * o;
  dy := dy * o;
  {/��������� ����������� ������}
  
  {����������� ����}
  window.SetSize(size, size);
  window.CenterOnScreen;
  window.Title := ('Graph');
  setWindowIsFixedSize(true);
  setCoordinateOrigin(z, z);
  setSmoothingOn;
  {/����������� ����}
  
  {��������� ����}
  setpenstyle(psdashdot);
  setpencolor(cllightgray);
  i := -z + o - dx;
  while i <= z + (-dx) do
  begin
    line(i + dx, z, i + dx, -z);
    i := i + o;
  end;
  i := -z + o - dy;
  while i <= z + (-dy) do 
  begin
    line(z, i + dy, -z, i + dy);
    i := i + o;
  end;
  line((3) + dx, (-1) + dy + z, (-3) + dx, (-1) + dy + z);
  {/��������� ����}
  
  {������ ���� ���� �� ������}
  setpencolor(clblack);
  setpenstyle(pssolid);
  {/������ ���� ���� �� ������}
  
  {��������� �� OX �� ������ �� ��}
  if (abs(dy / o) < o) then begin
    line(-z, dy - (dy mod o), z, dy - (dy mod o));
    line((-6) + z, (-5) + dy - (dy mod o), (-1) + z, dy - (dy mod o));
    line((-6) + z, (5) + dy - (dy mod o), (-1) + z, dy - (dy mod o));
    i := -z + o - dx;
    while i <= z - dx - o do 
    begin
      line(i + dx, (3) + dy - (dy mod o), i + dx, (-3) + dy - (dy mod o));
      i := i + o;
    end;
  end;
  {/��������� �� OX �� ������ �� ��}
  
  {��������� �� OY �� ������ �� ��}
  if (abs(dx / o) < o) then begin
    line(dx - (dx mod o), -z, dx - (dx mod o), z);
    line((-5) + dx - (dx mod o), (5) - z, dx - (dx mod o), -z);
    line((5) + dx - (dx mod o), (5) - z, dx - (dx mod o), -z);
    i := -z + o - dy;
    while i <= z - dy do 
    begin
      line((3) + dx + ((-dx) mod o), i + dy, (-3) + dx + ((-dx) mod o), i + dy);    
      i := i + o;
    end;
  end;
  {/��������� �� OY �� ������ �� ��}
  
  {��������� �� ����}
  if (numbering) then begin
    setFontSize(10);
    setFontName('Consolas');
    setFontColor(clgray);
    setFontStyle(fsBold);
    
    {������ �������� �� OY}
    if ((dx / o) > -number_of_points) then begin
      num := number_of_points + round(dy / o) - 1;
      i := -z + o - dy;
      while i < 0 do 
      begin
        str := Normal_Shot((num) * (scale));
        temp_num := length(str) - 1;
        textout((-13) + dx - (temp_num * 7), (-8) + i + dy, str);
        i := i + o;
        Dec(num);
      end;
    end;
    {/������ �������� �� OY}
    
    {��'��� �������� �� OY}
    if ((dx / o) < number_of_points) then begin
      num := -number_of_points + round(dy / o) + 1;
      i := z - o - dy;
      while i > 0 do 
      begin
        str := Normal_Shot((num) * (scale));
        temp_num := length(str) - 1;
        textout((7) + dx, (-8) + i + dy, str);  
        i := i - o;
        Inc(num);
      end;
    end;
    {/��'��� �������� �� OY}
    
    {������ �������� �� OX}
    if ((dy / o) > -number_of_points) then begin
      num := number_of_points - round(dx / o) - 1;
      i := z - o - dx;
      while i > 0 do 
      begin
        str := Normal_Shot((num) * (scale));
        temp_num := length(str) - 1;
        textout((-3) + i + dx - (temp_num * 5), (-20) + dy, str);
        i := i - o;
        Dec(num);
      end;
    end;
    {/������ �������� �� OX}
    
    {��'��� �������� �� OX}
    if ((dy / o) < number_of_points) then begin
      num := -number_of_points - round(dx / o) + 1;
      i := -z + o - dx;
      while i < 0 do 
      begin
        str := Normal_Shot((num) * (scale));
        temp_num := length(str) - 1;
        textout((-5) + i + dx - (temp_num * 5), (5) + dy, str);
        i := i + o;
        Inc(num);
      end;
    end;
    {/��'��� �������� �� OX}
  end;
  {/��������� �� ����}
end;

function draw_xy(x, y: real; dx, dy: integer; size: integer; 
                  scale: real): boolean;

const
  o: byte = 30;
  z: word = round(size * 0.5);
  number_of_points: byte = round(size / (2 * o));

begin
  {�������� ��������� ����� �� �� ������� ����� � ��� ����}
  if 
  not (real.IsNaN(y)) and
    not (real.IsNaN(x)) and
    (y <= (scale * number_of_points) + dy * scale) and
    (y >= -(scale * number_of_points) + dy * scale) and
    (x <= (scale * number_of_points) - dx * scale) and
    (x >= -(scale * number_of_points) - dx * scale) then 
    {/�������� ��������� ����� �� �� ������� ����� � ��� ����}
  begin
    {���������� �����}
    LineTo
    (Round((x) * (z / (scale * number_of_points)) + (dx * o) - (dx * o) mod o),
     Round((-y) * (z / (scale * number_of_points)) + (dy * o) - (dy * o) mod o));
    {/���������� �����}
    draw_xy := true;
  end;
end;

function move_cur(x, y: real; dx, dy: integer; size: integer; 
                  scale: real): boolean;

const
  o: byte = 30;
  z: word = round(size * 0.5);
  number_of_points: byte = round(size / (2 * o));

begin
  if 
  not (real.IsNaN(y)) and
    not (real.IsNaN(x)) and
    (y <= (scale * number_of_points) + dy * scale) and
    (y >= -(scale * number_of_points) + dy * scale) and
    (x <= (scale * number_of_points) - dx * scale) and
    (x >= -(scale * number_of_points) - dx * scale) then 
  begin
    MoveTo
          (Round((x) * (z / (scale * number_of_points)) + (dx * o) - (dx * o) mod o),
           Round((-y) * (z / (scale * number_of_points)) + (dy * o) - (dy * o) mod o));
    move_cur := true;
  end;
end;
end.