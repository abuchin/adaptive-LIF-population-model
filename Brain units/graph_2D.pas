unit graph_2D;

interface
uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
     StdCtrls,TeEngine,
     Init;

procedure Palette(min,max,dmin,dmax :double);
PROCEDURE Initial_Picture_2D;
procedure GraphicsFor1Node(ie,i,j :integer);
PROCEDURE Draw_Lattice(ie,ni,nj,jview :integer; z :arr_3_X_Y);

implementation
uses MathMy,Unit1,Unit2,Unit3,Unit4,BP2Delphi,graph_0d;

function ix(x :double) :integer;
begin
  x:=x/xU;
  if x<-10 then x:=-10;  if x>10 then x:=10;
  ix:=trunc(x_shift+(x-x_pole)*x_sc);
end;

function jy(y :double) :integer;
begin
  y:=y/yU;
  if y<-10 then y:=-10;  if y>10 then y:=10;
  jy:=trunc(y_shift-(y-y_pole)*y_sc);
end;

procedure line_my(x1,y1,x2,y2 :double);
begin
  Form3.Canvas.MoveTo(ix(x1),jy(y1));
  Form3.Canvas.LineTo(ix(x2),jy(y2));
end;

procedure OutText2D(x1,y1 :integer; t1 :string);
begin
  Form3.Canvas.TextOut(x1,y1,t1);
end;

procedure Min_Max(ie :integer; z :arr_3_X_Y; var min,max,dmin,dmax :double);
var  i,j :integer;
begin
  min:= 1e10;
  max:=-1e10;
  for i:=1 to ni do begin
      for j:=1 to nj do begin
          if z[ie,i,j]>max then max:=z[ie,i,j];
          if z[ie,i,j]<min then min:=z[ie,i,j];
      end;
  end;
  { Discretization of steps for min and max}
  i:=trunc(dln(abs(min))/ln(10)*10);
  dmin:=step(10,i/10)*sgn(min);
  j:=trunc(dln(abs(max))/ln(10)*10)+1;
  dmax:=step(10,j/10)*sgn(max);
end;

procedure Palette(min,max,dmin,dmax :double);
var  i,x,y,n_null,x0 :integer;
     t1,t2           :string;
begin
  x0:=750;   { Origin point }
  setcolor(5);
  for i:=1 to 15 do begin
      x:=x0+i*10;
      y:=10;
      setcolor(1);
      SetMyBrushColor(15-i);
      Form3.Canvas.Rectangle(x,y,x+8,y-8);
{     Rectangle(x,y,x+8,y-8);}
  end;
  setcolor(15);
  str(min:8:3,t1);
  OutText2D(x0,15,t1);
  str(max:8:3,t1);
  OutText2D(x0+130,15,t1);
  { Null notch }
{  n_null:=15-Color_u(0,dmin,dmax);}  { number of null square }
{  x:=450+n_null*10;  y:=10;
  line_my(x+4,y-10,x+4,y+2);}
end;

PROCEDURE Initial_Picture_2D;
var
   nl,nle       : longint;
   t1,t2,t3,t4  : string;
BEGIN
                     { Amplitudes }
   xU:=ni/2;
   yU:=xU{nj/2};
   x_sc:=200;          y_sc:=x_sc{130*1.2};
   x_pole:=0;          y_pole:=0;
   x_shift:=50;        y_shift:=20+(nj+1)/yU*y_sc{350*1.2};
   { Palette }
   Palette(1,16,1,16);
   { GraphicsFor1Node }
   Form3.Chart1.BottomAxis.Maximum:=ni;
END;

procedure GraphicsFor1Node(ie,i,j :integer);
var
     tl,tl_,t_sc : double;
     ntl         : integer;
BEGIN
  Form3.Chart3.BottomAxis.Maximum:=MinIfNotZero(Form4.DDSpinEdit72.Value,t_end*1000)+1e-8;
  t_sc:=Form3.Chart3.BottomAxis.Maximum;
  tl:=t*1000{ms}-trunc(t*1000{ms}/t_sc)*t_sc;  tl_:=tl+dt;
  { rate }
  Form3.Series8.AddXY(tl, Wpn[1,i,j]);
  Form3.Series9.AddXY(tl, Wpn[2,i,j]);
  { dendrite potential }
  Form3.Series5.AddXY(tl, (Vm[1,i,j]-Vrest[1])*1000);
  Form3.Series6.AddXY(tl, (Vm[2,i,j]-Vrest[2])*1000);
END;

{*********************************************************************}
PROCEDURE Draw_Lattice(ie,ni,nj,jview :integer; z :arr_3_X_Y);
var
     i,j,col                    :integer;
     min,max,dmin,dmax,D        :double;
     t1,t2                      :string;

BEGIN
                  { Text }
   setcolor(1);
   str(t*1000:8:3,t1);
   t1:='t='+t1+' ';
   OutText2D(ix(0),jy(nj+1)-20,t1);
   str(nt:3,t1);
   t1:='nt='+t1;
   OutText2D(ix(0)+100,jy(nj+1)-20,t1);
   if Form3.CheckBox1.Checked then begin
      Min_Max(ie,z, min,max,dmin,dmax);
      dmin:=min;  dmax:=max;
      Palette(min,max,dmin,dmax);
                     { Lattice }
      for i:=1 to ni+1 do begin
          for j:=1 to nj+1 do begin
              D:=(z[ie,i-1,j-1]+z[ie,i,j]+z[ie,i-1,j]+z[ie,i,j-1])/4;
              col:=Color_u(D,dmin,dmax);
              SetMyBrushColor(col);
              Form3.Canvas.Pen.Color:=clBlack{Form3.Canvas.Brush.Color};
              Form3.Canvas.Rectangle(ix(i-1),jy(j-1),ix(i),jy(j));
                  { Numbers }
              {setcolor(4);
              str((z^[i,j]+z^[i-1,j-1])/2:5:2,t1);
              OutText2D(ix(i-1)-5,jy(j)+5,t1);}
          end;
      end;
                     { Distribution along line }
      setcolor(2);
      for i:=0 to ni do begin
          line_my(1.0*i, (z[ie,i,jview]  -dmin)/(dmax-dmin+1e-6)*(nj-1)+1,
                  i+1.0, (z[ie,i+1,jview]-dmin)/(dmax-dmin+1e-6)*(nj-1)+1);
      end;
   end;
   {Spatial distribution }
   Form3.Series1.Clear;
   Form3.Series2.Clear;
   Form3.Series3.Clear;
   Form3.Series4.Clear;
   for i:=0 to ni do begin
       { pulse rates }
       Form3.Series1.AddXY(i, Wpn[ 1,i,jview]);
       Form3.Series2.AddXY(i, Wpn[ 2,i,jview]);
       { potentials }
       Form3.Series3.AddXY(i, (Vm[ 1,i,  jview]-Vrest[1])*1000);
       Form3.Series4.AddXY(i, (Vm[ 2,i,  jview]-Vrest[2])*1000);
   end;
   Application.ProcessMessages;
END;

end.
