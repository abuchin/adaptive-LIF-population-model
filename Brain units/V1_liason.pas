unit V1_liason;

interface
procedure Set_Ps_Ring(i,j :integer);
procedure PoissonEq(ie :integer);
procedure AnalytPoissonEq(ie :integer);
procedure SmearExcitatoryInputIntoInterneurons;

implementation
uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
     StdCtrls, ComCtrls, ExtCtrls,
     Init,mathMy,Wright,slice,other,other_2D,Hodgkin,HH_canal,
     graph_0d, graph_2D,wave,Unit1,Unit8,ph_Dens,ph_Volt,Correspond,V1;

procedure Set_Ps_Ring(i,j :integer);
var R_,Iext4 :double;
    iX_stim  :integer;
begin
  pext:=Qns;
  if (t>t0s) and (t<t0s+tSt) then  begin
    { distance from electrode center}
    iX_stim:=trunc((X_stim+pi)/2/pi*ni);
    R_:=sqrt(sqr(i-iX_stim)+sqr(j-nj_stim));
    Iext4:=Iext{mkA}*4{1/(mkA*s)};
    case Form8.ComboBox1.ItemIndex of
    0: if R_<=R_stim then pext:=pext + Iext4;                {'localised'}
    1: if R_<=R_stim then pext:=pext + Iext4                  {'R_stim/R'}
                     else pext:=pext + Iext4*R_stim/R_;
    2: begin              pext:=pext + Iext4*(1+cos(i/ni*2*pi-pi-X_stim));{'cos'}
         ni_stim:=round(ni/2);
       end;
    end;
  end;
end;

procedure PoissonEq(ie :integer);
{
  Solving of spatial propagation equation
  d^2 Wp /dx^2 = 1/r^2 (Wp-WQ),
  where  r is the length of connections in x-angle space.
  The explicit scheme
  Wpn[i+1]=(2+dx^2/r^2)*Wp[i] - Wp[i-1] - dx^2/r^2*WQ[i]
  Wpn[i]=(Wp[i+1] + Wp[i-1] + dx^2/r^2 *WQ[i])/(2 + dx^2/r^2)
}
var
    i,j               :integer;
    r_,o2,dx          :double;
begin
  j:=0;
  if ie=1 then  r_:=2*pi/Form8.DDSpinEdit2.Value  {radians}
          else  r_:=2*pi/Form8.DDSpinEdit6.Value; {radians}
  dx:=2*pi/ni;
  o2:=sqr(dx/r_);
  for i:=1 to ni do begin
      Wpn[ie,i,j]:=(Wp[ie,i+1,j] + Wp[ie,i-1,j] + o2*WQ[ie,i,j])/(2 + o2);
  end;
  { Boundary conditions }
  Wpn[ie,0,j]   :=Wpn[ie,ni,j];
  Wpn[ie,ni+1,j]:=Wpn[ie,1,j];
end;

procedure AnalytPoissonEq(ie :integer);
{
  Integrating input rate WQ with exponential weight.
}
var
    i,j,iz                      :integer;
    r_,dx,S,d_,coe,x,z,ooo,Norm :double;
begin
  j:=0;
  if ie=1 then  r_:=2*pi/Form8.DDSpinEdit2.Value  {radians}
          else  r_:=2*pi/Form8.DDSpinEdit6.Value; {radians}
  dx:=2*pi/ni;
  coe:=1/(2*r_*(1-dexp(-pi/r_)));
  for i:=1 to ni do begin
      S:=0;  Norm:=0;
      x:=i*dx;
      for iz:=1 to ni do begin
          z:=iz*dx;//(iz-1/2)*dx;
          ooo:=WQ[ie,iz,j];//(WQ[ie,iz,j]+WQ[ie,iz-1,j])/2;
          d_:=min(abs(z-x), min(abs(z-x+2*pi), abs(z-x-2*pi)) );
          S:=S  +  ooo*dexp(-d_/r_)*dx;
          Norm:=Norm + dexp(-d_/r_)*dx;
      end;
      Wpn[ie,i,j]:={coe*}S/Norm;
  end;
  { Boundary conditions }
  Wpn[ie,0,j]   :=Wpn[ie,ni,j];
  Wpn[ie,ni+1,j]:=Wpn[ie,1,j];
end;

procedure SmearExcitatoryInputIntoInterneurons;
var i :integer;
begin
  pn1_smeared:=0;
  for i:=1 to ni do begin
      pn1_smeared:=pn1_smeared+Wpn[1,i,0]/ni;
  end;
end;

end.
