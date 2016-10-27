unit HH_Migli;

interface
function Na_current_Migli(ie :integer):double;
function K_current_Migli(ie :integer):double;
function KM_current_Migli(ie :integer):double;
procedure InitialCanalConductances_Migli(ie :integer);

implementation
uses Init,mathMy,HH_canal;

{--------------------------------------------------------------}
function Na_current_Migli(ie :integer):double;
var  v2,a,b,tau,m_inf,m_exp,m3,h_inf,h_exp,i_inf,i_exp,bi :double;
begin
  { *          vtrap(x,y) = x/( Exp(x/y)-1 )            * }
  v2:= V[ie]*1000;
  { Eq. for 'm' }
  a:= 0.4   * vtrap(-(v2+30), 7.2);
  b:= 0.124 * vtrap( (v2+30), 7.2);
  tau:= 0.5 / (a + b);
  if tau<0.02 then  tau:=0.02;
  m_inf:=   a / (a + b);
  m_exp:= 1 - dexp(-dt*1000/tau);
  mm[ie]:=mm[ie]+m_exp*(m_inf-mm[ie]);
  m3:=istep(mm[ie],3);
  { Eq. for 'h' }
  a:= 0.03 * vtrap(-(v2+45), 1.5);
  b:= 0.01 * vtrap( (v2+45), 1.5);
  tau:= 0.5 / (a + b);
  if tau<0.5 then  tau:=0.5;
  h_inf:= 1 / (1 + dexp((v2+50)/4));
  h_exp:= 1 - dexp(-dt*1000/tau);
  hh[ie]:=hh[ie]+h_exp*(h_inf-hh[ie]);
  { Eq. for 'i' }
  bi:=0.8;
  a:= dexp(0.45*(v2+60));
  b:= dexp(0.09*(v2+60));
  tau:= 3000*b / (1 + a);
  if tau<10 then  tau:=10;
  i_inf:= (1 + bi * dexp((v2+58)/2))/(1 + dexp((v2+58)/2));
  i_exp:= 1 - dexp(-dt*1000/tau);
  ii[ie]:=ii[ie]+i_exp*(i_inf-ii[ie]);
  Na_current_Migli:=gNa[ie]*m3*hh[ie]*ii[ie]*(V[ie]-VNa);      { Current }
end;

function K_current_Migli(ie :integer):double;
var  v2,a,b,tau,n_inf,n_exp,n4 :double;
begin
  v2:= V[ie]*1000;
  { Eq. for 'n' }
  a:= dexp(-0.11*(v2-13));
  b:= dexp(-0.08*(v2-13));
  tau:= 50*b / (1 + a);
  if tau<2 then  tau:=2;
  n_inf:= 1 / (1 + a);
  n_exp:= 1 - dexp(-dt*1000/tau);
  nn[ie]:=nn[ie]+n_exp*(n_inf-nn[ie]);
  n4:=istep(nn[ie],4);
  K_current_Migli :=gK[i3_ie(ie)]*nn[ie]*(V[ie]-VK[i3_ie(ie)]);              { Current }
end;

function KM_current_Migli(ie :integer):double;
var  v2,a,b,tau,n_inf,n_exp,l_inf,l_exp :double;
begin
  v2:= V[ie]*1000;
  { Eq. for 'n' }
  a:=dexp( -0.038*( 1.5  +1/(1+dexp(v2+40)/5) )*(v2-11) );
  b:=dexp( -0.038*( 0.825+1/(1+dexp(v2+40)/5) )*(v2-11) );
  tau:= 4*b / (1 + a);
  if tau<0.1 then  tau:=0.1;
  n_inf:= 1 / (1 + a);
  n_exp:= 1 - dexp(-dt*1000/tau);
  nM[ie]:=nM[ie]+n_exp*(n_inf-nM[ie]);
  { Eq. for 'l' }
  a:= dexp(0.11*(v2+56));
  tau:= 0.26 * (v2+50);
  if tau<2 then  tau:=2;
  l_inf:= 1 / (1 + a);
  l_exp:= 1 - dexp(-dt*1000/tau);
  lM[ie]:=lM[ie]+l_exp*(l_inf-lM[ie]);
  KM_current_Migli :=gKM[i3_ie(ie)]*nM[ie]*lM[ie]*(V[ie]-VK[i3_ie(ie)]);              { Current }
end;

{*********************************************************************}

procedure InitialCanalConductances_Migli(ie :integer);
var  v2,a,b,ICaH,m2,bi :double;
begin
      v2:= V[ie]*1000;
      { mm - for Na }
      a:= 0.4   * vtrap(-(v2+30), 7.2);
      b:= 0.124 * vtrap( (v2+30), 7.2);
      mm[ie]:= a / (a + b);
      { hh - for Na }
      a:= 0.03 * vtrap(-(v2+45), 1.5);
      b:= 0.01 * vtrap( (v2+45), 1.5);
      hh[ie]:= 1 / (1 + dexp((v2+50)/4));
      { ii - for Na }
      bi:=0.8;
      a:= dexp(0.45*(v2+60));
      b:= dexp(0.09*(v2+60));
      ii[ie]:= (1 + bi * dexp((v2+58)/2))/(1 + dexp((v2+58)/2));
      { nn - for K }
      a:= dexp(-0.11*(v2-13));
      b:= dexp(-0.08*(v2-13));
      nn[ie]:= 1 / (1 + a);
      { Other conductances ---------------- }
      { nM - for KM }
      a:=dexp( -0.038*( 1.5  +1/(1+dexp(v2+40)/5) )*(v2-11) );
      b:=dexp( -0.038*( 0.825+1/(1+dexp(v2+40)/5) )*(v2-11) );
      nM[ie]:= 1 / (1 + a);
      { lM - for KM }
      a:= dexp(0.11*(v2+56));
      lM[ie]:= 1 / (1 + a);
end;

end.
