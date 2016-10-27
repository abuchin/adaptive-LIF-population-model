unit HH_Chow;

interface
function Na_current_Chow(ie :integer):double;
function K_current_Chow(ie :integer):double;
{ Initial conductances for Na and K }
procedure InitialCanalConductances_Chow(ie :integer);

implementation
uses Init,MathMy,HH_canal;

{--------------------------------------------------------------}
function Na_current_Chow(ie :integer):double;
var  v2,a,b,tau_m,m_inf,m_exp,m3,
            tau_h,h_inf,h_exp :double;
begin
  v2:= V[ie]*1000;
  tau_h:= 0.6/(1+dexp(-0.12*(v2+67)));
  m_inf:=   1/(1+dexp(-0.08*(v2+26)));
  h_inf:=   1/(1+dexp( 0.13*(v2+38)));
  h_exp:= 1 - dexp(-dt*1000/tau_h);
  mm[ie]:=m_inf;
  hh[ie]:=hh[ie]+h_exp*(h_inf-hh[ie]);
  m3:=istep(mm[ie],3);
  Na_current_Chow:=gNa[i3_ie(ie)]*m3*hh[ie]*(V[ie]-VNa);
end;

function K_current_Chow(ie :integer):double;
var  v2,tau_n,n_inf,n_exp,n4 :double;
begin
  v2:= V[ie]*1000;
  tau_n:= (0.5 + 2.0/(1+dexp(0.045*(v2-50))));   // !!!!Znak-OK!
  n_inf:= 1/(1+dexp(-0.045*(v2+10)));
  n_exp:= 1 - dexp(-dt*1000/tau_n);
  nn[ie]:=nn[ie]+n_exp*(n_inf-nn[ie]);
  n4:=istep(nn[ie],4);
  K_current_Chow :=gK[i3_ie(ie)]*n4*(V[ie]-VK[i3_ie(ie)])*(1-IfBlockK);
end;

{*********************************************************************}

procedure InitialCanalConductances_Chow(ie :integer);
var
     v2 :double;
begin
      v2:= V[ie]*1000;
      { mm,hh - for Na }
      mm[ie]:=  1/(1+dexp(-0.08*(v2+26)));
      hh[ie]:=  1/(1+dexp( 0.13*(v2+38)));
      { nn - for K }
      nn[ie]:= 1/(1+dexp(-0.045*(v2+10)));
end;

{*********************************************************************}

end.
