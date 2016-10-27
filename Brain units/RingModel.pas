unit RingModel;

interface
procedure SimplestRing;

implementation
uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
     StdCtrls, ComCtrls, ExtCtrls,
     Init,mathMy,Wright,slice,other,other_2D,Hodgkin,HH_canal,
     graph_0d, graph_2D,wave,Unit1,Unit2,Unit8,
     ph_Dens,ph_Volt,Correspond,V1_liason;

var
    aE,aI,InpE,InpI :array[-180..180] of double;


procedure PrintTime(t:double);
var t1 :string;
begin
   str(t:7:2,t1);
   t1:='t='+t1+' ms';
   Form8.Label8.Caption:=t1;
end;

function Knife(x :double):double;
begin
  if x>0 then Knife:=x else Knife:=0;
end;

procedure SimplestRing;
{*************************************************************************}
{  d/dt aE = -aE + Knife(InpE),
   d/dt aI = -aI + Knife(InpI),
   InpE(x) = 1/2/pi*Int_(-pi)^(pi) J1*cos(x-y)*aE(y)+J0*aI(y) dy
           + I0+I1*cos(x-x0),
   InpI(x) = 1/2/pi*Int_(-pi)^(pi) aE(y) dy.
   Trivial model is when  aI(x)=aE(x).
   Parameters are : I0 (Qns), I1 (Iext), J1 (gAMPA[1]), J0-J1 (gGABA[1]).
   See LesHouches book p.319 [Hansel,Sompolinsky]. }
{*************************************************************************}
var i,N,j,nt_ :integer;
    dt,x,dx,I0,I1,J0,J1 :double;
begin
  N:=180;
  dx:=pi/N;
  I0:=Form8.DDSpinEdit9.Value;      {1}
  I1:=Form8.DDSpinEdit10.Value*I0;  {0.18}
  J0:=Form8.DDSpinEdit11.Value;     {-0.4}
  J1:=Form8.DDSpinEdit12.Value;     {4}
  dt:=Form8.DDSpinEdit13.Value;
  { Initial conditions }
  for i:=-N to N do begin aE[i]:=0; aI[i]:=0; end;
  nt_:=-1;
  repeat nt_:=nt_+1;
    Form8.Series2.Clear;
    Form8.Series3.Clear;
    Form8.Series7.Clear;
    Form8.Series4.Clear;
    { Synaptic Input }
    for i:=-N to N do begin
        x:=i*dx;
        InpE[i]:=I0+I1*cos(x-X_stim);    { External }
        InpI[i]:=0;
        for j:=-N to N do begin
            InpE[i]:=InpE[i]+dx/2/pi*(J1*(cos(dx*(i-j))+1)*aE[j]+(J0-J1)*aI[j]);
            InpI[i]:=InpI[i]+dx/2/pi*aE[j];
        end;
    end;
    { Egs. for Rate }
    for i:=-N to N-1 do begin
        x:=i*dx;
        {***************************************************}
        aE[i]:=aE[i]+dt*(-aE[i]+Knife(InpE[i]));
        //aI[i]:=aI[i]+dt*(-aI[i]+Knife(InpI[i]));
        aI[i]:=Knife(InpI[i]);
        {***************************************************}
        Form8.Series2.AddXY(i/N*180, InpE[i]);             { pn[1], black}
        Form8.Series3.AddXY(i/N*180, aE[i]);               {  Q[1], red}
        Form8.Series7.AddXY(i/N*180, aI[i]);
        Form8.Series4.AddXY(i/N*180, I0+I1*cos(x-X_stim)); {Stimul, yellow}
    end;
    { Boundary condition }
    aE[N]:=aE[-N];
    aI[N]:=aI[-N];
    PrintTime(nt_*dt);
    Application.ProcessMessages;
  until nt_*dt>=Form8.DDSpinEdit8.Value;
end;

end.
