unit phase;

interface
uses Init;

function PhaseDensity(ie :integer{; Qst :double}) :double;
procedure MembranePotential_Phase;
procedure EqForDispersion_Phase;
procedure GapJunctions;

var
     ro,V0_ph,VE_ph,DuDt_ph,nn_ph,yK_ph,nA_ph,lA_ph,nM_ph,
     VT,sgmV
                                :array[1..3,0..MaxPh] of double;
     L_ro                       :array[0..MaxPh] of double;
     dts,ts_end                                         :double;
     Nts,IfFsgmRead,NP                                  :integer;
     cP                         :array[0..10] of double;
     erf                        :array[0..1000,1..2] of double;
{****************************************************}

implementation
uses mathMy,Hodgkin,HH_canal,threshold,Unit2,Unit4,graph_0d;

procedure WriteDistrInPhase;
var aaa :text;
    x   :integer;
begin
  assign(aaa,'Ph_ro_V(x).dat'); rewrite(aaa);
  FOR x:=0 to Nts do begin {loop for phase}
      write  (aaa,dts*x*1000:8:3,' ',ro[1,x]:11,' ',V0_ph[1,x]*1000:9:4);
      writeln(aaa,' ',VE_ph[1,x]*1000:9:4);
  END; {loop for phase}
  close(aaa);
end;

function F_sigma(t :double) :double;
{ Approximation of
  the rate of firing probability:
  F*sigma=sqrt(2/pi)*exp(-t^2)/(1-erf(t))
}
var tt,ttt,z :double;
begin
  tt :=t*t;  ttt:=tt*t;
  z:=7.974594595893E-001       +8.931203868230E-001*t
    +2.207323627194E-001*tt    -4.385519667402E-002*ttt
    -5.283585580342E-003*tt*tt +3.862594834886E-003*tt*ttt
    -4.585162409359E-004*ttt*ttt;
  if      t <-2 then z:=0
  else if t > 4 then z:=t*sqrt(2);
  F_sigma:=z;
end;

{FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
function Erfic(x :double):double;
var  xb,dx    :double;
     aaa      :text;
     i        :integer;
  function ErfTail(x :double):double;
  begin
    if x>0 then  ErfTail:= 1-exp(-x*x)/x/sqrt(pi)
           else  ErfTail:=-1-exp(-x*x)/x/sqrt(pi);
  end;
begin
  { Read Table }
  if IfFsgmRead<>1 then begin
     IfFsgmRead:=1;
     assign(aaa,'erfic.dat'); reset(aaa);
     i:=-1;
     repeat i:=i+1;
       readln(aaa,erf[i,1],erf[i,2]);
     until (eof(aaa));
     close(aaa);
  end;
  xb:=erf[0,1]; dx:=erf[1,1]-erf[0,1];
  if abs(x)>2.8 then  Erfic:=ErfTail(x) else begin
     i:=trunc((x-xb)/dx);   if (xb+i*dx=x) then i:=i-1;
     Erfic:=erf[i,2]+(erf[i+1,2]-erf[i,2])/dx*(x-erf[i,1]);
  end;
end;

FUNCTION F_sigmaL(x,xL :double) :double;
{ Hazard function:
  F*sigma=sqrt(2/pi)*exp(-x^2)/(erf(xL)-erf(x)) }
BEGIN
  if x>xL-1e-6 then begin  F_sigmaL:=20;        exit;  end;
  if x>4       then begin  F_sigmaL:=x*sqrt(2); exit;  end;
  if x<-5      then begin  F_sigmaL:=0;         exit;  end;
  F_sigmaL:=sqrt(2/pi)*dexp(-x*x)/(Erfic(xL)-Erfic(x));
END;

FUNCTION F_tilde(x :double) :double;
{ Hazard function:
  F*sigma=sqrt(2/pi)*exp(-x^2)/(1-erf(x)) }
BEGIN
  if x>4       then begin  F_tilde:=x*sqrt(2); exit;  end;
  if x<-5      then begin  F_tilde:=0;         exit;  end;
  F_tilde:=sqrt(2/pi)*dexp(-x*x)/(1-Erfic(x));
END;

function fA_T(T :double) :double;
var i :integer;
    z :double;
begin
  if NP=0 then begin
     NP:=10;
     cP[ 0]:=  1.001055497606E+000;
     cP[ 1]:= -1.129983204604E+000;
     cP[ 2]:=  3.893667847693E-001;
     cP[ 3]:= -2.098434970547E-002;
     cP[ 4]:= -2.774989796891E-003;
     cP[ 5]:= -2.340612034447E-003;
     cP[ 6]:= -4.729497907511E-004;
     cP[ 7]:=  2.142725255194E-004;
     cP[ 8]:=  5.900123243314E-005;
     cP[ 9]:= -7.283552720865E-006;
     cP[10]:= -2.077520293817E-006;
  end;
  z:=0;
  if T<=2.5 then begin
     for i:=0 to NP do  z:=z+cP[i]*istep(T,i);
  end else  z:= exp(5.021314568377*(-T) + 6.286870461772);
  fA_T:=max(z,0);
end;

{FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}

procedure WriteF_sigma;
var aaa :text;
    i   :integer;
    V,V_,sigma,FV :double;
begin
  assign(aaa,'F_sigma(x).dat'); rewrite(aaa);
  sigma:=0.2;
  FOR i:=0 to 300 do begin
      V:=-3+i*0.02;
      V_:=V/sigma/sqrt(2);
      FV:=F_sigma(V_);
      writeln(aaa,V:9:4,' ',FV:9:4,' ');
  END;
  close(aaa);
end;

function xThr(l :integer) :integer;
var x           :integer;
    w,tThr      :double;
begin
  x:=trunc(dT_AP/dts);
  repeat
    x:=x+1;
  until  (x=Nts)or
         ((V0_ph[l,x]>=VT[l,x]+Vrest[l])and(V0_ph[l,x]>V0_ph[l,x-1]));
  xThr:=x;
end;

procedure Set_nn_reset(ie :integer);
begin
  if          HH_type[ie]='Destexhe' then begin
     nn_ph[ie,0]:=0.5;
  end else if HH_type[ie]='Chow' then begin
     nn_ph[ie,0]:=0.4;
  end else if HH_type[ie]='Lyle' then begin
     nn_ph[ie,0]:=nn_AP;
     yK_ph[ie,0]:=yK_AP;
     nA_ph[ie,0]:=nA_AP;
     lA_ph[ie,0]:=lA_AP;
     nM_ph[ie,0]:=nM_ph[ie,xThr(ie)] + 0.155;
  end else begin
     if HH_order[ie]='1-point'  then                      nn_ph[ie,0]:=0.17 else
     if HH_order[ie]='2-points' then  if i3_ie(ie)=2 then nn_ph[ie,0]:=0.07 else
                                                          nn_ph[ie,0]:=0.05;
  end;
end;

function Vreset(ie :integer) :double;
begin
  if HH_type[ie]='Lyle' then  Vreset:=-0.040{V}
                        else  Vreset:=Vrest[ie];
end;

procedure New_nn_yK_nA_lA_nM(l,x :integer; q :double);
var
    tau_nn,nn_inf,Dnn,dnndt,
    tau_yK,yK_inf,DyK,dyKdt,
    tau_nA,nA_inf,DnA,dnAdt,
    tau_lA,lA_inf,DlA,dlAdt,
    tau_nM,nM_inf,DnM,dnMdt             :double;
begin
        tau_inf_K (l,V0_ph[l,x], tau_nn,nn_inf,tau_yK,yK_inf);
        tau_inf_KA(l,V0_ph[l,x], tau_nA,nA_inf,tau_lA,lA_inf);
        tau_inf_KM(l,V0_ph[l,x], tau_nM,nM_inf);
        { -------- }
        Dnn:=E_exp(dt,tau_nn)*(nn_inf-nn_ph[l,x])*q;
        DyK:=E_exp(dt,tau_yK)*(yK_inf-yK_ph[l,x])*q;
        DnA:=E_exp(dt,tau_nA)*(nA_inf-nA_ph[l,x])*q;
        DlA:=E_exp(dt,tau_lA)*(lA_inf-lA_ph[l,x])*q;
        DnM:=E_exp(dt,tau_nM)*(nM_inf-nM_ph[l,x])*q;
        dnndt:=(nn_ph[l,x] - nn_ph[l,x-1])/dts;
        dyKdt:=(yK_ph[l,x] - yK_ph[l,x-1])/dts;
        dnAdt:=(nA_ph[l,x] - nA_ph[l,x-1])/dts;
        dlAdt:=(lA_ph[l,x] - lA_ph[l,x-1])/dts;
        dnMdt:=(nM_ph[l,x] - nM_ph[l,x-1])/dts;
        nn_ph[l,x]:=nn_ph[l,x] - dt*dnndt + Dnn;
        yK_ph[l,x]:=yK_ph[l,x] - dt*dyKdt + DyK;
        nA_ph[l,x]:=nA_ph[l,x] - dt*dnAdt + DnA;
        lA_ph[l,x]:=lA_ph[l,x] - dt*dlAdt + DlA;
        nM_ph[l,x]:=nM_ph[l,x] - dt*dnMdt + DnM;
end;

procedure InitialPhaseDensityAndPotential(l :integer);
var x,k                                         :integer;
    a,b,v2,gK_,gKA_,gKM_,IK,IKA,IKM,Im,q,V_0,V_E,gs,gdE,
    DV0Dt,DVEDt,
    tau_nn,nn_inf,Dnn,
    tau_yK,yK_inf,DyK,
    tau_nA,nA_inf,DnA,
    tau_lA,lA_inf,DlA,
    tau_nM,nM_inf,DnM
                                                :double;
begin
  k:=i3_ie(l);
  if Nts=0    then  Nts:=imin(80,MaxPh);
  if ts_end=0 then  ts_end:=0.050;
  dts:=ts_end/Nts;
  for x:=0 to Nts-1 do ro[l,x]:=0;
  ro[l,Nts]:=1/dts;
  { Conditions at spike }
  V0_ph[l,0]:=Vreset(l);
  VE_ph[l,0]:=Vrest[l];
  Set_nn_reset(l);
  { Conditions at rest. Passive parameters. Slow nu-dependent channels. }
  tau_inf_K (l,Vrest[l], tau_nn,nn_ph[l,x],tau_yK,yK_ph[l,x]);
  tau_inf_KA(l,Vrest[l], tau_nA,nA_ph[l,x],tau_lA,lA_ph[l,x]);
  tau_inf_KM(l,Vrest[l], tau_nM,nM_ph[l,x]);
  gK_ :=gK[k] * K_cond(l,nn_ph[l,x],yK_ph[l,x])*(1-IfBlockK);
  gKA_:=gKA[k]*KA_cond(l,nA_ph[l,x],lA_ph[l,x])*(1-IfBlockK);
  gKM_:=gKM[k]*sqr(nM_ph[l,x])*(1-IfBlockK);
  IK :=gK_ *(Vrest[l]-VK[k]);
  IKA:=gKA_*(Vrest[l]-VKA);
  IKM:=gKM_*(Vrest[l]-VKM);
  gL[l]:=C_membr[k]/tau_m[k] - (gK_+gKA_+gKM_);
  VL[l]:=Vrest[l]+(IK+IKA+IKM)/gL[l];
//  if ie=3 then begin gL[3]:=gL[i3]; VL[3]:=VL[i3]; end;
//  nM[l]  :=0;
  wAHP[l]:=0;
  mBst[l]:=0;
  { Integrate by t* }
  for x:=1 to Nts do begin
      { Fast conductances }
      if x*dts<=dT_AP then q:=0 else q:=1;
      tau_inf_K (l,V0_ph[l,x-1], tau_nn,nn_inf,tau_yK,yK_inf);
      tau_inf_KA(l,V0_ph[l,x-1], tau_nA,nA_inf,tau_lA,lA_inf);
      tau_inf_KM(l,V0_ph[l,x-1], tau_nM,nM_inf);
      { -------- }
      Dnn:=E_exp(dts,tau_nn)*(nn_inf-nn_ph[l,x-1])*q;
      DyK:=E_exp(dts,tau_yK)*(yK_inf-yK_ph[l,x-1])*q;
      DnA:=E_exp(dts,tau_nA)*(nA_inf-nA_ph[l,x-1])*q;
      DlA:=E_exp(dts,tau_lA)*(lA_inf-lA_ph[l,x-1])*q;
      DnM:=E_exp(dts,tau_nM)*(nM_inf-nM_ph[l,x-1])*q;
      nn_ph[l,x]:=nn_ph[l,x-1] + Dnn;
      yK_ph[l,x]:=yK_ph[l,x-1] + DyK;
      nA_ph[l,x]:=nA_ph[l,x-1] + DnA;
      lA_ph[l,x]:=lA_ph[l,x-1] + DlA;
      nM_ph[l,x]:=nM_ph[l,x-1] + DnM;
      { Membrane current }
      IK :=gK[k] * K_cond(l,nn_ph[l,x],yK_ph[l,x]) *(V0_ph[l,x-1]-VK[k]);
      IKA:=gKA[k]*KA_cond(l,nA_ph[l,x],lA_ph[l,x]) *(V0_ph[l,x-1]-VKA);
      IKM:=gKM[k]*sqr(nM_ph[l,x])                  *(V0_ph[l,x-1]-VKM);
      Im :=-gL[l]*(V0_ph[l,x-1]-VL[l]) - (IK+IKA+IKM)*(1-IfBlockK);
      { Voltage }
      if          HH_order[l]='1-point'  then begin
          DuDt_ph[l,x]:= Im/C_membr[k]*q;
          V0_ph[l,x]:=V0_ph[l,x-1] + dts*DuDt_ph[l,x];
      end else if HH_order[l]='2-points' then begin
          V_0:=V0_ph[l,x];
          V_E:=VE_ph[l,x];
          gs:=C_membr[k]/tau_m[k];    gdE:=gs*roE;
          {----------}
          DVEDt:= 1/tau_m[k]*(-(V_E-Vrest[l]) - (2+gdE/gs)*(V_E-V_0))*q;
          DV0Dt:= 1/tau_m[k]*( gdE/gs *(V_E -V_0) + Im/gs)*q;
          {----------}
          VE_ph[l,x]:=V_E + dts*DVEDt;
          V0_ph[l,x]:=V_0 + dts*DV0Dt;
          {----------}
          If (If_I_V_or_p=1)or(If_I_V_or_p=5) then  V0_ph[3,x]:=Vrest[3];
          DuDt_ph[l,x]:=DV0Dt;
      end;
  end;
  { Draw initial phase distribution }
  if l=3 then  DrawPhaseSpace;
end;

procedure Limiters(ie :integer);
{ TVD-scheme with VanLeer as a limiter }
var i :integer;
begin
  for i:=1 to Nts-1 do begin
      L_ro[i]:=VanLeer(ro[ie,i+1]-ro[ie,i], ro[ie,i]-ro[ie,i-1]);
  end;
  L_ro[0]:=0;    L_ro[Nts]:=0;
end;

{*********************************************************************}
function PhaseDensity(ie :integer) :double;
{ Solves the equation   dro/dt + dro/dts = - ro nu(ts),
  with boundary condition  ro[0]=int_0^inf (ro nu(ts)) dts
}
var ts,roi,S,dro, F,sigma_V,V_,dVdt,A,F_A         :double;
    i,k                                           :integer;
begin
  k:=i3_ie(ie);
  if nt=2 then WriteF_sigma;
  if Round(0.099/dt)=nt then WriteDistrInPhase;
  if nt<=1 then InitialPhaseDensityAndPotential(ie);
  IfSecondOrder:=1;    { 0-for Godunov, 1-for TVD }
  if IfSecondOrder=1 then  Limiters(ie);
  S:=0;
  FOR i:=Nts downto 1 do begin {loop for phase}
      ts:=dts*i;
      dVdt:=DuDt_ph[ie,i];
      VT[ie,i]:=VThreshold3(k,dVdt);
      if Form4.CheckBox10.Checked then
           sigma_V:= sgmV[ie,i] + 0.01*sgmAP[k]*0.010{V} //VT[ie,i]
      else sigma_V:=                   sgmAP[k]*0.010{V};//VT[ie,i];
      V_:=(V0_ph[ie,i]-Vrest[ie]-VT[ie,i])/sigma_V;
      { Derived from "frozen" Gauss }
      if (dVdt< 0)  then F:=0 else F:=F_tilde(V_)/sigma_V*dVdt;
      { From self-similar Fokker-Planck }
      if (ts<0.008) then A:=0 else A:=fA_T(-V_)/tau_m[k];
      { Spike half-duration }
      if i*dts<=dT_AP then begin F:=0; A:=0; end;
      //F_A:=max(0,F+A);
      {*** Transfer equation ***}
      if dt>=dts then Warning('Courant number>1');
      roi:=ro[ie,i];  if i=Nts then roi:=0;
      ro[ie,i]:=ro[ie,i] - dt*(roi-ro[ie,i-1])/dts;
      {***** Second order TVD-scheme *****}
      if IfSecondOrder=1 then begin
         ro[ie,i]:=ro[ie,i] - dt/dts*(1-dt/dts)/2*(L_ro[i]-L_ro[i-1]);
      end;
      {*** Source ***}
      dro:=dt*ro[ie,i]*(F+A);
      {**************************************************}
      ro[ie,i]:=ro[ie,i]                           - dro;
      {**************************************************}
      S:=S                                         + dro;
  END;
  ro[ie,0]:=ro[ie,0] - dt*ro[ie,0]/dts + S;
  PhaseDensity:=ro[ie,0];
  S:=0;  for i:=0 to Nts do S:=S+dts*ro[ie,i]; { Norm }
end;
{*********************************************************************}

function AverageV(l :integer) :double;
var x                   :integer;
    Amount,V_av         :double;
begin
  V_av:=0; Amount:=0;
  for x:=trunc(dT_AP/dts)+1 to Nts do begin
      V_av:=V_av+V0_ph[l,x]*ro[l,x]*dts;
      Amount:=Amount +      ro[l,x]*dts;
  end;
  AverageV:=V_av/Amount;
end;

function RateOfWorkingNeurons2(l :integer) :double;
var x :integer;
    S :double;
begin
  S:=0;
  x:=-1;
  repeat x:=x+1;
    S:=S + ro[l,x]*dts;
  until S>=0.5;
  RateOfWorkingNeurons2:=1/((x+1)*dts) {Hz};
end;

function RateOfWorkingNeurons(l :integer) :double;
var x           :integer;
    w,tThr      :double;
begin
  x:=trunc(dT_AP/dts);
  repeat
    x:=x+1;
  until  (x=Nts)or((V0_ph[l,x]>=VT[l,x]+Vrest[l])and(V0_ph[l,x]>V0_ph[l,x-1]));
  if x=Nts then begin
     RateOfWorkingNeurons:=0;//ro[l,0];
  end else begin
     if abs(V0_ph[l,x]-V0_ph[l,x-1])<1e-8 then w:=0
     else w:=(V0_ph[l,x]-VT[l,x]-Vrest[l])/(V0_ph[l,x]-V0_ph[l,x-1]);
     tThr:=dts*(x-w);
     RateOfWorkingNeurons:=1/tThr;
  end;
end;

{*********************************************************************}
{*********************************************************************}
procedure MembranePotential_Phase;
{*********************************************************************}
var  k,l,x,q                                    :integer;
     IatE,DIsynE,DV0Dt,DVEDt,dV0,dVE,
     tau_nn,nn_inf,Dnn,dnndt,
     tau_yK,yK_inf,DyK,dyKdt,
     tau_nA,nA_inf,DnA,dnAdt,
     tau_lA,lA_inf,DlA,dlAdt,
     tau_nM,nM_inf,DnM,dnMdt,
     V_av,V_E,V_0,gs,gdE,nu,rs                  :double;
     IK_ph,IKA_ph,IKM_ph,gKM_,IKM,gAHP_,IAHP,IBst,INaP
                                                :array[1..3] of double;
BEGIN
  {Conditions at spike}
  for l:=1 to 3 do begin
      V0_ph[l,0]:=Vreset(l);
      VE_ph[l,0]:=Vrest[l];
      Set_nn_reset(l);
  end;
  { AHP and Burst-currents, slow }
  for l:=1 to 2 do begin
      V_av:=AverageV(l);
      nu:={ro[l,0];///(1-rs*dts);//}RateOfWorkingNeurons(l);
//      gKM_[l] :=  KM_cond_nu(l, {Vrest[l]}V_av, nu);
      gAHP_[l]:= AHP_cond(l, {Vrest[l]}V_av, nu);
      IBst[l] := Bst_current(l, V_av, nu);
  end;
  { ---------------- Ohm's law  and transfer ---------------------------- }
  FOR x:=Nts downto 1 do begin {loop for phase}
    if x*dts<=dT_AP then q:=0 else q:=1;
    { K - current }
    for l:=1 to 3 do begin
        k:=i3_ie(l);
        New_nn_yK_nA_lA_nM(l,x,q);
        IK_ph[l] :=gK[k] * K_cond(l,nn_ph[l,x],yK_ph[l,x]) *(V0_ph[l,x]-VK[k]);
        IKA_ph[l]:=gKA[k]*KA_cond(l,nA_ph[l,x],lA_ph[l,x]) *(V0_ph[l,x]-VKA);
        IKM_ph[l]:=gKM[k]*sqr(nA_ph[l,x])                  *(V0_ph[l,x]-VKM);
    end;
    { NaP, AHP and additive current }
    for l:=1 to 3 do begin
//        IKM[l] := gKM_[i3_ie(l)]*(V0_ph[l,x]-VKM);
        IAHP[l]:=gAHP_[i3_ie(l)]*(V0_ph[l,x]-VAHP);
        INaP[l]:= NaP_current(i3_ie(l),V0_ph[l,x]);
        Iadd[l]:= Current_Iind(l);
    end;
    { ---------------- Currents ----------------------------------- }
    for l:=1 to 3 do begin
        k:=i3_ie(l);
        Im[l]:=-IAHP[k] -IBst[k] -INaP[l] -gL[l]*(V0_ph[l,x]-VL[l]) +Iadd[l]
               -(IK_ph[l] +IKA_ph[l] +IKM_ph[l])*(1-IfBlockK);
    end;
    { ---------------- Gap Junctions ------------------------------ }
    GapJunctions;
    { ---------------- Ohm's law ---------------------------------- }
    for l:=1 to 3 do begin
        k:=i3_ie(l);
        if          HH_order[l]='1-point'  then begin
          DuDt_ph[l,x]:= (Im[l]+IsynE[l]+IsynI[l])/C_membr[k]*q;
          if x=Nts then dV0:=0 else
          dV0:=(V0_ph[l,x] - V0_ph[l,x-1])/dts;
          V0_ph[l,x]:=V0_ph[l,x] - dt*dV0 + dt*DuDt_ph[l,x];
        end else if HH_order[l]='2-points' then begin
          DIsynE:=(IsynE[l]-IsynE_old[l])/dt;
          IatE:=1/2*tau_m[k]*DIsynE + 3/2*IsynE[l];
          V_0:=V0_ph[l,x];
          V_E:=VE_ph[l,x];
          gs:=C_membr[k]/tau_m[k];    gdE:=gs*roE;
          {----------}
          DVEDt:= 1/tau_m[k]*(-(V_E -Vrest[l])
                - (2+gdE/gs)*(V_E -V_0) + 2/gdE*IatE - 0*IsynI[l]/gs)*q;
          DV0Dt:= 1/tau_m[k]*(
                     gdE/gs *(V_E -V_0) + Im[l]/gs   + IsynI[l]/gs)*q;
          if x=Nts then begin
             dVE:=0;  dV0:=0;
          end else begin
             dVE:=(VE_ph[l,x] - VE_ph[l,x-1])/dts;
             dV0:=(V0_ph[l,x] - V0_ph[l,x-1])/dts;
          end;
          {----------}
          VE_ph[l,x]:=V_E - dt*dVE + dt*DVEDt;
          V0_ph[l,x]:=V_0 - dt*dV0 + dt*DV0Dt;
          {----------}
          If (If_I_V_or_p=1)or(If_I_V_or_p=5) then  V0_ph[3,x]:=Vrest[3];
          DuDt_ph[l,x]:=DV0Dt;
        end;
    end;
  END; {loop for phase}
  {Potentials in quiet neurones}
  for l:=1 to 3 do begin
      V[l]   :=V0_ph[l,Nts];
      VatE[l]:=VE_ph[l,Nts];
      DuDt[l]:=DuDt_ph[l,Nts];
  end;
END;
{*********************************************************************}
{*********************************************************************}

procedure GapJunctions;
var  ie,x,k             :integer;
     V_av_E,V_av_I      :double;
begin
  V_av_E:=0;  V_av_I:=0;
  for x:=1 to Nts do begin
      V_av_E:=V_av_E + V0_ph[1,x]*ro[1,x]*dts;
      V_av_I:=V_av_I + V0_ph[2,x]*ro[2,x]*dts;
  end;
  for ie:=1 to 3 do begin
      k:=i3_ie(ie);
      I_GJ[ie]:=gGJ_E[k]*(V_av_E-V[ie]) + gGJ_I[k]*(V_av_I-V[ie]);
      Im[ie]:=Im[ie]+I_GJ[ie];
  end;
end;

{*********************************************************************}
procedure EqForDispersion_Phase;
var
    k,l,i                                       :integer;
    mmE,mmI,gE,gI,gs,DsgmV,s                    :double;
begin
  for l:=1 to 3 do begin
      k:=i3_ie(l);
      s:=sgmAP[k];
      gs:=C_membr[k]/tau_m[k];
      mmE:=mAMPA[k] + mAMP3[k];
      mmI:=mGABA[k] + mGAB3[k];
      gE:= gAMPA[k]*mAMPA[k] + gAMP3[k]*mAMP3[k];
      gI:= gGABA[k]*mGABA[k] + gGAB3[k]*mGAB3[k];
      {Condition at spike}
      sgmV[l,0]:=0;
      FOR i:=Nts downto 1 do begin {loop for phase}
          DsgmV:=1/C_membr[k]*(
                - ( gs + gE*(1+s) + gI*(1+s) )*sgmV[l,i]
                - s*gE*(V[l]-VAMPA) + s*gI*(V[l]-VGABA) );
          sgmV[l,i]:=sgmV[l,i] - dt*(sgmV[l,i]-sgmV[l,i-1])/dts + dt*DsgmV;
      END;
  end;
end;

end.
