unit HH_Lyle;

interface
procedure tau_inf_K_Lyle(v2 :double; var tau_n,n_inf,tau_yK,yK_inf :double);
function K_cond_Lyle(x,y :double):double;
function K_current_Lyle(ie :integer):double;
procedure tau_inf_KA_Lyle(v2 :double; var tau_n,n_inf,tau_l,l_inf :double);
function KA_cond_Lyle(x,y :double):double;
function KA_current_Lyle(ie :integer):double;
procedure tau_inf_KM_Lyle(v2 :double; var tau_n,n_inf :double);
function KM_cond_Lyle(ie :integer; v2,nu :double):double;
function KM_current_Lyle(ie :integer; V,nu :double):double;
procedure tau_inf_AHP_Lyle(v2 :double; var tau_w,w_inf :double);
function AHP_cond_Lyle(ie :integer; v2,nu :double):double;
function AHP_current_Lyle(ie :integer; V,nu :double):double;
procedure InitialCanalConductances_Lyle(ie :integer);

implementation
uses Init,MathMy,HH_canal;

type arr4x4=array[1..4,1..4] of double;
     arr4x2=array[1..4,1..2] of double;
var
    XNa :arr4x2;


{---------------- K - DR -----------------}
procedure tau_inf_K_Lyle(v2 :double; var tau_n,n_inf,tau_yK,yK_inf :double);
var a,b :double;
begin
  { Eq. for 'n' }
  a:=0.17*dexp( (v2+5)*0.8*3*FRT);
  b:=0.17*dexp(-(v2+5)*0.2*3*FRT);
  tau_n:= 1 / (a + b) + 0.8;
  n_inf:= a / (a + b);
  { Eq. for 'yK' }
  tau_yK:= 300;
  yK_inf:= 1 / (1 + dexp(-(v2+68)*(-1)*FRT));
end;

function K_cond_Lyle(x,y :double):double;
begin
  K_cond_Lyle :=x*y*(1-IfBlockK);
end;

function K_current_Lyle(ie :integer):double;
var  v2,tau_n,n_inf,tau_yK,yK_inf :double;
begin
  tau_inf_K_Lyle(V[ie]*1000, tau_n,n_inf,tau_yK,yK_inf);
  nn[ie]:=nn[ie]+E_exp(dt,tau_n )*( n_inf-nn[ie]);
  yK[ie]:=yK[ie]+E_exp(dt,tau_yK)*(yK_inf-yK[ie]);
  K_current_Lyle :=gK[i3_ie(ie)]*K_cond_Lyle(nn[ie],yK[ie])*(V[ie]-VK[i3_ie(ie)]);
end;

{---------------- KA -----------------}
procedure tau_inf_KA_Lyle(v2 :double; var tau_n,n_inf,tau_l,l_inf :double);
var a,b :double;
begin
  { Eq. for 'nA' }
  a:=0.08*dexp( (v2+41)*0.85*2.8*FRT);
  b:=0.08*dexp(-(v2+41)*0.15*2.8*FRT);
  tau_n:= 1 / (a + b) + 1.0;
  n_inf:= a / (a + b);
  { Eq. for 'lA' }
  a:=0.04*dexp( (v2+49)*1*(-3)*FRT);
  b:=0.04;
  tau_l:= 1 / (a + b) + 2.0;
  l_inf:= a / (a + b);
end;

function KA_cond_Lyle(x,y :double):double;
begin
  KA_cond_Lyle :=istep(x,4)*istep(y,3);
end;

function KA_current_Lyle(ie :integer):double;
var  tau_n,n_inf,tau_l,l_inf :double;
begin
  tau_inf_KA_Lyle(V[ie]*1000, tau_n,n_inf,tau_l,l_inf);
  nA[ie]:=nA[ie]+E_exp(dt,tau_n)*(n_inf-nA[ie]);
  lA[ie]:=lA[ie]+E_exp(dt,tau_l)*(l_inf-lA[ie]);
  KA_current_Lyle :=gKA[i3_ie(ie)]*KA_cond_Lyle(nA[ie],lA[ie])*(V[ie]-VKA);              { Current }
end;

{---------------- KM -----------------}
procedure tau_inf_KM_Lyle(v2 :double; var tau_n,n_inf :double);
var a,b :double;
begin
  { Eq. for 'nM' }
  a:=0.003*dexp( (v2+45)*0.6*6*FRT);
  b:=0.003*dexp(-(v2+45)*0.4*6*FRT);
  tau_n:= 1 / (a + b) + 8;
  n_inf:= a / (a + b);
end;

function KM_cond_Lyle(ie :integer; v2,nu :double):double;
var  tau_n,n_inf :double;
begin
  tau_inf_KM_Lyle(v2, tau_n,n_inf);
  nM[ie]:=nM[ie] + dt*0.155*nu*(1-nM[ie])
                 + E_exp(dt,tau_n)*(n_inf-nM[ie]);
  KM_cond_Lyle :=gKM[i3_ie(ie)]*sqr(nM[ie]);
end;

function KM_current_Lyle(ie :integer; V,nu :double):double;
begin
  KM_current_Lyle :=KM_cond_Lyle(ie,V*1000,nu)*(V-VKM);              { Current }
end;

  { *** AHP  ***}

procedure tau_inf_AHP_Lyle(v2 :double; var tau_w,w_inf :double);
begin
  tau_w:= 400*5/(3.3*dexp((v2+35)/20)+dexp(-(v2+35)/20));
  w_inf:=      1 / (1+dexp(-(v2            +35)/10));
end;

function AHP_cond_Lyle(ie :integer; v2,nu :double):double;
var  tau_w,w_inf,w_exp,w_inf_rest :double;
begin
  tau_inf_AHP_Lyle(v2,tau_w,w_inf);
  wAHP[ie]:=wAHP[ie] + dt*0.016{0.028}*nu*(1-wAHP[ie])
                     + dt*1000/tau_w*(w_inf-wAHP[ie]);
  AHP_cond_Lyle :=gAHP[i3_ie(ie)]*wAHP[ie];
end;

function AHP_current_Lyle(ie :integer; V,nu :double):double;
var  v2,a,b,tau_w,w_inf,w_exp :double;
begin
  AHP_current_Lyle:=AHP_cond_Lyle(ie,V*1000,nu)*(V-VAHP);     { Current }
end;

{*********************************************************************}

procedure InitialCanalConductances_Lyle(ie :integer);
var
     tau_m,tau_h, tau_n,tau_yK,dum :double;
begin
      { nn - for K }
      tau_inf_K_Lyle  (V[ie]*1000, tau_n,nn[ie],tau_yK,yK[ie]);
      tau_inf_KA_Lyle (V[ie]*1000, tau_n,nA[ie],tau_yK,lA[ie]);
      tau_inf_KM_Lyle (V[ie]*1000, tau_n,nM[ie]);
      tau_inf_AHP_Lyle(V[ie]*1000, tau_n,wAHP[ie]);
end;

{*********************************************************************}

end.
