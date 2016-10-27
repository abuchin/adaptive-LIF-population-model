unit HH_canal;

interface
function i3_ie(ie:integer) :integer;
function vtrap(x,y :double):double;
function Na_current_CalmDest(ie :integer):double;
function K_current_CalmDest(ie :integer):double;
function Bst_current(ie :integer; V,nu :double):double;
function NaP_current(ie :integer; V :double):double;
{** for all approximations **}
procedure InitialCanalConductances(ie :integer);
procedure InitialCanalExtraConductances(ie :integer);
procedure CalculateActiveConductance(ie :integer);
function Na_current(ie :integer):double;
procedure tau_inf_K(ie:integer; V:double; var tau_n,n_inf,tau_yK,yK_inf:double);
function K_cond(ie :integer; x,y :double):double;
function K_current(ie :integer):double;
procedure tau_inf_KA(ie:integer; V:double; var tau_n,n_inf,tau_l,l_inf:double);
function KA_cond(ie :integer; x,y :double):double;
function KA_current(ie :integer):double;
procedure tau_inf_KM(ie:integer; V:double; var tau_n,n_inf:double);
function KM_cond(ie :integer; V,nu :double):double;
function KM_current(ie :integer; V,nu :double):double;
procedure tau_inf_AHP(ie:integer; V:double; var tau_n,n_inf:double);
function AHP_cond(ie :integer; V,nu :double):double;
function AHP_current(ie :integer; V,nu :double):double;

implementation
uses Init,MathMy,HH_migli,HH_Chow,HH_Lyle;

function i3_ie(ie:integer) :integer;
begin
  if ie=3 then i3_ie:=i3
          else i3_ie:=ie;
end;

function vtrap(x,y :double):double;
begin
  if (abs(x/y) < 1e-6) then
    vtrap:= y*(1 - x/y/2)
  else
    vtrap:= x/(Exp(x/y)-1);
end;

{--------------------------------------------------------------}
function Na_current_CalmDest(ie :integer):double;
var  v2,a,b,tau_m,m_inf,m_exp,m3,tau_h,h_inf,h_exp :double;
begin
  v2:= V[ie]*1000 - Tr;
  { Eq. 3.8 for 'm' }
  if          HH_type[ie]='Destexhe' then begin
      a:= 0.32 * vtrap(13-v2, 4);
      b:= 0.28 * vtrap(v2-40, 5);
  end else if HH_type[ie]='Calmar' then begin
     a:= 0.1 * vtrap(25-v2, 10);
     b:= 4 * dexp(-v2/18);
  end;
  tau_m:= 1 / (a + b);
  m_inf:= a / (a + b);
  m_exp:= 1 - dexp(-dt*1000/tau_m);
  mm[ie]:=mm[ie]+m_exp*(m_inf-mm[ie]);
  m3:=istep(mm[ie],3);
  { Eq. 3.9 for 'h' }
  if          HH_type[ie]='Destexhe' then begin
      a:= 0.128 * dexp((17-v2)/18);
      b:= 4 / ( 1 + dexp((40-v2)/5) );
  end else if HH_type[ie]='Calmar' then begin
     a:= 0.07 * dexp(-v2/20);
     b:= 1 / ( 1 + dexp((30-v2)/10) );
  end;
  tau_h:= 1 / (a + b);
  h_inf:= a / (a + b);
  h_exp:= 1 - dexp(-dt*1000/tau_h);
  hh[ie]:=hh[ie]+h_exp*(h_inf-hh[ie]);
  Na_current_CalmDest:=gNa[i3_ie(ie)]*m3*hh[ie]*(V[ie]-VNa);      { Current }
end;

function K_current_CalmDest(ie :integer):double;
var  v2,a,b,tau_n,n_inf,n_exp,n4 :double;
begin
  v2:= V[ie]*1000 - Tr;
  { Eq. 3.4 for 'n' }
  if          HH_type[ie]='Destexhe' then begin
      a:= 0.032 * vtrap(15-v2, 5);
      b:= 0.5 * dexp((10-v2)/40);
  end else if HH_type[ie]='Calmar' then begin
     a:= 0.01 * vtrap(10-v2, 10);
     b:= 0.125 * dexp(-v2/80);
  end;
  tau_n:= 1 / (a + b);
  n_inf:= a / (a + b);
  n_exp:= 1 - dexp(-dt*1000/tau_n);
  nn[ie]:=nn[ie]+n_exp*(n_inf-nn[ie]);
  n4:=istep(nn[ie],4);
  K_current_CalmDest :=gK[i3_ie(ie)]*n4*(V[ie]-VK[i3_ie(ie)]);              { Current }
end;

{*** KM ***}

function KM_cond_CalmDest(ie :integer; v2,nu :double):double;
var  a,b,tau_n,n_inf,n_exp :double;
begin
  a:= 0.1 * vtrap(-v2-30, 9);
  b:= 0.1 * vtrap( v2+30, 9);
  tau_n:= 1 / (a + b);
  n_inf:= a / (a + b);
  n_exp:= 1 - dexp(-dt*1000/tau_n);
  nM[ie]:=nM[ie] + dt*0.155*nu + n_exp*(n_inf-nM[ie]);
  KM_cond_CalmDest :=gKM[i3_ie(ie)]*nM[ie];
end;

function KM_current_CalmDest(ie :integer; V,nu :double):double;
begin
  KM_current_CalmDest :=KM_cond_CalmDest(ie, V*1000,nu)*(V-VKM);
end;

{*** AHP ***}

function AHP_cond_CalmDest(ie :integer; v2,nu :double):double;
var  tau_w,w_inf,w_exp,w_inf_rest :double;
begin
  tau_w:= 400/(3.3*dexp((v2+35)/20)+dexp(-(v2+35)/20));
  w_inf:=      1 / (1+dexp(-(v2            +35)/10));
  w_inf_rest:= 1 / (1+dexp(-(Vrest[ie]*1000+35)/10));
  w_exp:= 1 - dexp(-dt*1000/tau_w);
  wAHP[ie]:=wAHP[ie] + dt*0.028*nu + w_exp*(w_inf-wAHP[ie]);
  AHP_cond_CalmDest:=gAHP[i3_ie(ie)]*(wAHP[ie]-w_inf_rest);
end;

function AHP_current_CalmDest(ie :integer; V,nu :double):double;
begin
  AHP_current_CalmDest :=AHP_cond_CalmDest(ie, V*1000,nu)*(V-VAHP);
end;

{*** Bst ***}

function Bst_current1(ie :integer; V,nu :double):double;
{ slow spike-dependent current for bursts }
var  al,tau2,m_inf,m_exp,sigm :double;
begin
  if tau_Bst=0 then  tau_Bst:= 200 {ms}; { activation time }
  al:=1000/tau_Bst;
  sigm:=nu;//2*Sigmoid(nu,10)-1;
  New_m (al,al,dt,sigm, mBst[ie],UBst[ie],WBst[ie]);
  Bst_current1 :=gBst[i3_ie(ie)]*mBst[ie]*(V-VK[i3_ie(ie)]);
end;

function Bst_current(ie :integer; V,nu :double):double;
{ slow spike-dependent current for bursts }
var  tau1,tau2,m_inf,Vh,VT :double;
begin
  {[Izhikevich 2004]}
  if tau_Bst=0 then  tau_Bst:= 20{ms}; { activation time }
  if mBst[ie]=0 then  mBst[ie]:=1;
  tau2:=100{ms};
  Vh:=-0.060;
  VT:= 0.120;
  if V>Vh then begin
     New_m1 (0,1000/tau_Bst, dt,1.0, mBst[ie],UBst[ie],WBst[ie]);
     m_inf:=1;
  end else begin
     New_m1 (1000/tau2,   0, dt,1.0, mBst[ie],UBst[ie],WBst[ie]);
     m_inf:=0;
  end;
  Bst_current :=gBst[ie]*m_inf*mBst[ie]*(V-VT);
end;

function NaP_current(ie :integer; V :double):double;
var  v2 :double;
begin
  v2:= V*1000;
  mNaP[ie]:=1 / (1+dexp(-(v2+57.7)/7.7));
  NaP_current :=gNaP[i3_ie(ie)]*istep(mNaP[ie],3)*(V-VNa);
end;

procedure InitialCanalConductances_CalmDest(ie :integer);
var
     v2,a,b,ICaH,m2     :double;
     s                  :string;
begin
      v2:= V[ie]*1000 - Tr;
      { mm - for Na }
      if          HH_type[ie]='Destexhe' then begin
         a:= 0.32 * vtrap(13-v2, 4);
         b:= 0.28 * vtrap(v2-40, 5);
      end else if HH_type[ie]='Calmar' then begin
         a:= 0.1 * vtrap(25-v2, 10);
         b:= 4 * dexp(-v2/18);
      end;
      mm[ie]:= a / (a + b);
      { hh - for Na }
      if          HH_type[ie]='Destexhe' then begin
         a:= 0.128 * dexp((17-v2)/18);
         b:= 4 / ( 1 + dexp((40-v2)/5) );
      end else if HH_type[ie]='Calmar' then begin
         a:= 0.07 * dexp(-v2/20);
         b:= 1 / ( 1 + dexp((30-v2)/10) );
      end;
      hh[ie]:= a / (a + b);
      { nn - for K }
      if          HH_type[ie]='Destexhe' then begin
         a:= 0.032 * vtrap(15-v2, 5);
         b:= 0.5 * dexp((10-v2)/40);
      end else if HH_type[ie]='Calmar' then begin
         a:= 0.01 * vtrap(10-v2, 10);
         b:= 0.125 * dexp(-v2/80);
      end;
      nn[ie]:= a / (a + b);
end;

{----------- for all approximations ---------------------------}

procedure InitialCanalConductances(ie :integer);
var
     v2,a,b,ICaH,m2     :double;
     s                  :string;
begin
  { Na & K }
  if (HH_type[ie]='Destexhe') or (HH_type[ie]='Calmar') then begin
              InitialCanalConductances_CalmDest(ie);
  end else if HH_type[ie]='Migliore' then begin
              InitialCanalConductances_Migli(ie);
  end else if HH_type[ie]='Chow'  then begin
              InitialCanalConductances_Chow(ie);
  end else if HH_type[ie]='Lyle'  then begin
              InitialCanalConductances_Lyle(ie);
  end;
end;

procedure InitialCanalExtraConductances(ie :integer);
var
     v2,a,b,ICaH :double;
begin
  { Other conductances ---------------- }
  v2:= V[ie]*1000;
  if HH_type[ie]<>'Chow'  then begin
     { nM - for KM }
     a:= 0.1 * vtrap(-v2-30, 9);
     b:= 0.1 * vtrap( v2+30, 9);
     nM[ie]:= a / (a + b);
     { wAHP - for KAHP }
     wAHP[ie]:= 1 / (1+dexp(-(v2+35)/10));
  end;
  { mBst for Bursts }
  mBst[ie]:=0;
end;

procedure CalculateActiveConductance(ie :integer);
var  m3,m2,gNa_,gK_,n4,gKA_,gKM_,gAHP_,gBst_        :double;
     k                                              :integer;
begin
  k:=i3_ie(ie);
  { Na & K }
  if          HH_type[ie]='Migliore' then begin
     m3:=istep(mm[ie],3);
     gNa_:=gNa[k]*m3*hh[ie]*ii[ie];
     gK_ :=gK[k]*nn[ie];
  end else if HH_type[ie]='Lyle'     then begin
     gK_ :=gK[k] * K_cond_Lyle(nn[ie],yK[ie]);
  end else begin
     m3:=istep(mm[ie],3);
     gNa_:=gNa[k]*m3*hh[ie];
     n4:=istep(nn[ie],4);
     gK_ :=gK[k]*n4;
  end;
  { KA }
  if HH_type[ie]='Lyle' then  gKA_:=gKA[k]*KA_cond_Lyle(nA[ie],lA[ie])
                        else  gKA_:=gKA[k]*nA[ie]*lA[ie];
  { KM }
  if HH_type[ie]='Lyle' then  gKM_:=gKM[k]*sqr(nM[ie])
                        else  gKM_:=gKM[k]*nM[ie];
  { AHP & Bst}
  gAHP_:=gAHP[k]*wAHP[k];
  gBst_:=gBst[k]*zBst(mBst[k]);
  ActiveConductance:= gNa_*(1-IfPhase) +gK_ +gKM_
  			      	+ gAHP_ + gBst_ ; {mS/cm^2}
end;

{ Na }
function Na_current(ie :integer):double;
begin
  if (HH_type[ie]='Calmar') or (HH_type[ie]='Destexhe') then begin
      Na_current:=Na_current_CalmDest(ie);
  end else if  HH_type[ie]='Migliore'  then begin
      Na_current:=Na_current_Migli(ie);
  end else if  HH_type[ie]='Chow'  then begin
      Na_current:=Na_current_Chow(ie);
  end;
end;

{ K }
procedure tau_inf_K(ie:integer; V:double; var tau_n,n_inf,tau_yK,yK_inf:double);
var v2,a,b :double;
begin
  tau_yK:=1;  yK_inf:=0;
  if          HH_type[ie]='Destexhe' then begin
     { Destexhe }
     v2:= V*1000 - Tr;
     a:= 0.032 * vtrap(15-v2, 5);
     b:= 0.5 * dexp((10-v2)/40);
     tau_n:= 1 / (a + b);
     n_inf:= a / (a + b);
  end else if HH_type[ie]='Chow' then begin
     { Chow }
     v2:= V*1000;
     tau_n:= (0.5 + 2.0/(1+dexp(0.045*(v2-50))));
     n_inf:= 1/(1+dexp(-0.045*(v2+10)));
  end else if HH_type[ie]='Lyle' then begin
     { Lyle }
     tau_inf_K_Lyle(V*1000, tau_n,n_inf,tau_yK,yK_inf);
  end else begin
     { Migliore }
     v2:= V*1000;
     a:= dexp(-0.11*(v2-13));
     b:= dexp(-0.08*(v2-13));
     tau_n:= 50*b / (1 + a);
     if tau_n<2 then  tau_n:=2;
     n_inf:= 1 / (1 + a);
  end;
end;

function K_cond(ie :integer; x,y :double):double;
begin
  if  HH_type[ie]='Migliore'  then begin
      K_cond:=x
  end else if  HH_type[ie]='Lyle'  then begin
      K_cond:=K_cond_Lyle(x,y);
  end else begin
      K_cond:=istep(x,4);
  end;
end;

function K_current(ie :integer):double;
begin
  if (HH_type[ie]='Calmar') or (HH_type[ie]='Destexhe') then begin
      K_current:=K_current_CalmDest(ie);
  end else if  HH_type[ie]='Migliore'  then begin
      K_current:=K_current_Migli(ie);
  end else if  HH_type[ie]='Chow'  then begin
      K_current:=K_current_Chow(ie);
  end else if  HH_type[ie]='Lyle'  then begin
      K_current:=K_current_Lyle(ie);
  end;
end;

{ KA }
procedure tau_inf_KA(ie:integer; V:double; var tau_n,n_inf,tau_l,l_inf:double);
begin
  tau_inf_KA_Lyle(V*1000, tau_n,n_inf,tau_l,l_inf);
end;

function KA_cond(ie :integer; x,y :double):double;
begin
  KA_cond:=KA_cond_Lyle(x,y);
end;

function KA_current(ie :integer):double;
begin
  KA_current:=KA_current_Lyle(ie);
end;

{ KM }
procedure tau_inf_KM(ie:integer; V:double; var tau_n,n_inf:double);
begin
  tau_inf_KM_Lyle(V*1000, tau_n,n_inf);
end;

function KM_cond(ie :integer; V,nu :double):double;
begin
  if          HH_type[ie]='Lyle'    then begin
      KM_cond:=KM_cond_Lyle(ie, V*1000,nu)
  end else begin
      KM_cond:=KM_cond_CalmDest(ie, V*1000,nu);
  end;
end;

function KM_current(ie :integer; V,nu :double):double;
begin
  if          HH_type[ie]='Lyle'    then begin
      KM_current:=KM_current_Lyle(ie, V,nu)
  end else begin
      KM_current:=KM_current_CalmDest(ie, V,nu);
  end;
end;

{ AHP }
procedure tau_inf_AHP(ie:integer; V:double; var tau_n,n_inf:double);
begin
  tau_inf_AHP_Lyle(V*1000, tau_n,n_inf);
end;

function AHP_cond(ie :integer; V,nu :double):double;
begin
  if          HH_type[ie]='Lyle'    then begin
      AHP_cond:=AHP_cond_Lyle(ie, V*1000,nu)
  end else begin
      AHP_cond:=AHP_cond_CalmDest(ie, V*1000,nu);
  end;
end;

function AHP_current(ie :integer; V,nu :double):double;
begin
  if          HH_type[ie]='Lyle'    then begin
      AHP_current:=AHP_current_Lyle(ie, V,nu)
  end else begin
      AHP_current:=AHP_current_CalmDest(ie, V,nu);
  end;
end;

end.
