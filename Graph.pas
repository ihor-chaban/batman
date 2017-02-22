{$mainresource hwres.aps}
program Graph;

uses
  GraphABC, DrawGraph, PowerMath;

var
  x, y, t, scale, down_limit, up_limit: real;
  size, offset_x, offset_y, x_temp, y_temp: integer;
  precision, width: word;
  numbering, calc_mode, temp: boolean;
  color: GraphABC.Color;
  settings: text;

function H_(x: real): real;
begin
  if (x < 0) then result := 0 else
  if (x = 0) then result := 1 / 2 else
  if (x > 0) then result := 1;
end;

function w(x: real): real;
begin
  result := 3 * sqrt(1 - power(x / 7, 2));
end;

function l(x: real): real;
begin
  result := (1 / 2) * (x + 3) - (3 / 7) * sqrt(10) * sqrt(4 - power(x + 1, 2)) + (6 / 7) * sqrt(10);
end;

function h(x: real): real;
begin
  result := (1 / 2) * (3 * (abs(x - 1 / 2) + abs(x + 1 / 2) + 6) - 11 * (abs(x - 3 / 4) + abs(x + 3 / 4)));
end;

function r(x: real): real;
begin
  result := (6 / 7) * sqrt(10) + (3 - x) / 2 - (3 / 7) * sqrt(10) * sqrt(4 - power((x - 1), 2));
end;

procedure paint();
begin
  ClearWindow;
  LockDrawing;
  draw_cs(size, scale, offset_x, offset_y, numbering);
  Pen.Color := color;
  Pen.Width := width;
  Redraw;
  UnlockDrawing;
  temp := true;
  if (calc_mode) then begin
    down_limit := (-(scale * (size / 60)) - scale * (offset_x));
    up_limit := ((scale * (size / 60)) - scale * (offset_x));
  end;
  var z: boolean;
  for var step := 1 to 5 do
  begin
    z := true;
    t := down_limit;
    while t <= up_limit do 
    begin
      {assignment of function}
      x := t;
      case (step) of
        1:
          begin
            if (abs(x) > 3) then
            begin
              Pen.Color := color;
              y := 3 * sqrt(1 - power(x, 2) / 49);
            end
            else Pen.Color := clTransparent;
          end;
        2:
          begin
            if (abs(x) > 4) then
            begin
              Pen.Color := color;
              y := -3 * sqrt(1 - power(x, 2) / 49);
            end
            else Pen.Color := clTransparent;
          end;
        3: 
          begin
            if (abs(x) > 1) then
            begin
              Pen.Color := color;
              y := 1.5 - 0.5 * abs(x) - (3 / 7) * sqrt(10) * (-2 + sqrt(3 - power(x, 2) + 2 * abs(x)));
            end
            else Pen.Color := clTransparent;
          end;
        4: y := (h(x) - l(x)) * H_(x + 1) + (r(x) - h(x)) * H_(x - 1) + (l(x) - w(x)) * H_(x + 3) + (w(x) - r(x)) * H_(x - 3) + w(x);
        5: y := (1 / 2) * (3 * sqrt(1 - power((x / 7), 2)) + sqrt(1 - power((abs(abs(x) - 2) - 1), 2)) + abs(x / 2) - ((3 * sqrt(33) - 7) / 112) * power(x, 2) - 3) *      ((x + 4) / abs(x + 4) - (x - 4) / abs(x - 4)) - 3 * sqrt(1 - power((x / 7), 2));
      end;
      {/assignment of function}
      if (z) then
      begin
        (move_cur(x, y, offset_x, offset_y, size, scale));
        z := false;
      end;
      
      if (temp) then begin
        if (move_cur(x, y, offset_x, offset_y, size, scale)) then
          temp := false;
        t += (scale * pow(1 / 10, precision));
      end else begin
        if (not draw_xy(x, y, offset_x, offset_y, size, scale)) then
          temp := true;
        t += (scale * pow(1 / 10, precision));
      end;
    end;
  end;
end;

procedure KeyDown(Key: integer);
begin
  case Key of
    VK_Left, VK_A: 
      begin
        if (scale < 1) then begin
          LockDrawing;
          clearwindow;
          offset_x += round(1 / scale);
          draw_cs(size, scale, offset_x, offset_y, numbering);
          Redraw;
        end
        else begin
          LockDrawing;
          clearwindow;
          offset_x += 1;
          draw_cs(size, scale, offset_x, offset_y, numbering);
          Redraw; 
        end;
        paint;
      end;
    
    VK_Right, VK_D:     
      begin
        if (scale < 1) then begin
          LockDrawing;
          clearwindow;
          offset_x -= round(1 / scale);
          draw_cs(size, scale, offset_x, offset_y, numbering);
          Redraw;
        end
        else begin
          LockDrawing;
          clearwindow;
          offset_x -= 1;
          draw_cs(size, scale, offset_x, offset_y, numbering);
          Redraw;
        end;
        paint; 
      end;
    
    VK_Up, VK_S:        
      begin
        if (scale < 1) then begin
          LockDrawing;
          clearwindow;
          offset_y += round(1 / scale);
          draw_cs(size, scale, offset_x, offset_y, numbering);
          Redraw;
        end
        else begin
          LockDrawing;
          clearwindow;
          offset_y += 1;
          draw_cs(size, scale, offset_x, offset_y, numbering);
          Redraw;
        end; 
        paint;
      end;
    
    
    VK_Down, VK_W:     
      begin
        if (scale < 1) then begin
          LockDrawing;
          clearwindow;
          offset_y -= round(1 / scale);
          draw_cs(size, scale, offset_x, offset_y, numbering);
          Redraw;
        end
        else begin
          LockDrawing;
          clearwindow;
          offset_y -= 1;
          draw_cs(size, scale, offset_x, offset_y, numbering);
          Redraw;
        end;
        paint;
      end;
    
    VK_PageDown:  
      begin
        if (scale < 1) then
          scale := scale * (2)
        else
          scale := scale + 1;
        paint;
      end;
    
    VK_PageUp:       
      begin
        if (scale <= 1) then
          scale := scale * (1 / 2)
        else
          scale := scale - 1;
        paint;
      end;
    
    VK_Tab:
      begin
        numbering := not numbering;
        paint;
      end;
    
    VK_Enter:
    Window.Save('Graph.png');
    
    VK_Escape:
    Window.Close;
    
    VK_ControlKey:
      begin
        offset_x := 0;
        offset_y := 0;
        scale := 1;
        paint;
      end;
    
    VK_F1:
      begin
        color := clRed;
        paint;
      end;
    
    VK_F2:
      begin
        color := clGreen;
        paint;
      end;
    
    VK_F3:
      begin
        color := clBlue;
        paint;
      end;
    
    VK_F4:
      begin
        color := clOrangeRed;
        paint;
      end;
    
    VK_F5:
      begin
        color := clSeaGreen;
        paint;
      end;
    
    VK_F6:
      begin
        color := clPurple;
        paint;
      end;
    
    VK_F7:
      begin
        color := clMagenta;
        paint;
      end;
    
    VK_F8:
      begin
        color := clDarkCyan;
        paint;
      end;
    
    VK_F9:
      begin
        color := clBrown;
        paint;
      end;
  end;
end;

procedure MouseDown(x, y, mb: integer);
begin
  x_temp := x;
  y_temp := y;
  LockDrawing;
end;

procedure MouseMove(x, y, mb: integer);
begin
  if (mb = 1) then
    if (abs(x - x_temp) >= 30) then begin
      offset_x += 1 * sign(x - x_temp);
      x_temp := x;
      ClearWindow;
      draw_cs(size, scale, offset_x, offset_y, numbering);
      Redraw;
    end else
    if (abs(y - y_temp) >= 30) then begin
      offset_y += 1 * sign(y - y_temp);
      y_temp := y;
      ClearWindow;
      draw_cs(size, scale, offset_x, offset_y, numbering);
      Redraw;
    end;
end;

procedure MouseUp(x, y, mb: integer);
begin
  offset_x := offset_x + round((x - x_temp) / 30);
  offset_y := offset_y + round((y - y_temp) / 30);
  paint;
end;

procedure Resize();
begin
  Redraw;
end;

begin
  assign(settings, 'settings.ini');
  reset(settings);
  readln(settings, size);
  readln(settings, width);
  readln(settings, precision);
  readln(settings, calc_mode);
  readln(settings, down_limit);
  readln(settings, up_limit);
  close(settings);
  
  scale := 1;
  numbering := true;
  color := clBlue;
  offset_x := 0;
  offset_y := 0;
  
  Window.SetSize(size, size);
  Window.CenterOnScreen;
  Window.Title := ('Graph');
  SetWindowIsFixedSize(true);
  SetCoordinateOrigin(round(size * 0.5), round(size * 0.5));
  SetSmoothingOn;
  
  paint;
  OnKeyDown := KeyDown;
  OnMouseDown := MouseDown;
  OnMouseUp := MouseUp;
  OnMouseMove := MouseMove;
  OnResize := Resize;
end.