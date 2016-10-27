unit ph_Volt;

interface
uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
     StdCtrls,TeEngine,
     Init,ph_Dens;

procedure InitialPhaseDensityAndPotential(l :integer);
procedure MembranePotential_Phase;
procedure EqForDispersion_Phase;
procedure GapJunctions(xts :integer);

implementation
uses mathMy,Hodgkin,HH_canal,threshold,Unit2,Unit4,Unit9,graph_0d;

var tvd :double;

{function xThr2(l :integer) :integer;
var x           :integer;
    w,tThr      :double;
begin
  x:=trunc(dT_AP[i3_ie(l)]/dts);
  repeat
    x:=x+1;
  until  (x=Nts)or
         ((V0_ph[l,x]>=VT[l,x]+Vrest[l])and(V0_ph[l,x]>V0_ph[l,x-1]));
  xThr2:=x;
end;}

{function xThr(l :integer) :integer;
var x           :integer;
    w,tThr      :double;
begin
  if nt<=1 then begin xThr:=Nts; exit; end;
  x:=Nts;
  while (V0_ph[l,x]>VT[l,x]+Vrest[l])and(x>trunc(dT_AP[i3_ie(l)]/dts))
  do     x:=x-1;
  xThr:=imin(x+1,Nts);
end;}

function xThr(l :integer) :integer;
var x,i         :integer;
    maxH        :double;
begin
  x:=Nts;
  for i:=1 to Nts-1 do  if Hzrd[l,i]>Hzrd[l,x] then begin
      x:=i;
  end;
  xThr:=x;
end;

procedure Reset_at_AP_nn_yK_nA_lA_nM_wAHP(ie :integer);
var xThr_               :integer;
    tau_nM,tau_wAHP     :double;
begin
  nn_ph[ie,0]:=nn_AP[i3_ie(ie)];
  if HH_type[ie]='Lyle' then begin
     yK_ph[ie,0]:=yK_AP;
     nA_ph[ie,0]:=nA_AP;
     lA_ph[ie,0]:=lA_AP;
     { nM and wAHP }
     xThr_:=xThr(ie);
     nM_ph[ie,0]  :=nM_ph[ie,xThr_];
     wAHP_ph[ie,0]:=wAHP_ph[ie,xThr_];
     nM_ph[ie,0]  :=nM_ph[ie,0]   + 0.175 *(1-nM_ph[ie,0]);
     wAHP_ph[ie,0]:=wAHP_ph[ie,0] + 0.0177*(1-wAHP_ph[ie,0]);
     Form2.Series13.Clear;
     Form2.Series13.AddXY(xThr_*dts*1000,nM_ph[ie,xThr_]);
  end;
end;

//function Vreset(ie :integer) :double;
//begin
//  if HH_type[ie]='Lyle' then  Vreset:=-0.040{V}
//                        else  Vreset:=Vrest[ie];
//end;

procedure New_nn_yK_nA_lA_nM_wAHP(l,x :integer; q :double);
var
    tau_nn,nn_inf,Dnn,dnndts,
    tau_yK,yK_inf,DyK,dyKdts,
    tau_nA,nA_inf,DnA,dnAdts,
    tau_lA,lA_inf,DlA,dlAdts,
    tau_nM,nM_inf,DnM,dnMdts,
    tau_wAHP,wAHP_inf,DwAHP,dwAHPdts             :double;
begin
        tau_inf_K  (l,V0_ph[l,x], tau_nn,nn_inf,tau_yK,yK_inf);
        tau_inf_KA (l,V0_ph[l,x], tau_nA,nA_inf,tau_lA,lA_inf);
        tau_inf_KM (l,V0_ph[l,x], tau_nM,nM_inf);
        tau_inf_AHP(l,V0_ph[l,x], tau_wAHP,wAHP_inf);
        { -------- }
        Dnn:=E_exp(dt,tau_nn)*(nn_inf-nn_ph[l,x])*q;
        DyK:=E_exp(dt,tau_yK)*(yK_inf-yK_ph[l,x])*q;
        DnA:=E_exp(dt,tau_nA)*(nA_inf-nA_ph[l,x])*q;
        DlA:=E_exp(dt,tau_lA)*(lA_inf-lA_ph[l,x])*q;
        DnM:=E_exp(dt,tau_nM)*(nM_inf-nM_ph[l,x])*q;
        DwAHP:=E_exp(dt,tau_wAHP)*(wAHP_inf-wAHP_ph[l,x])*q;
        dnndts:=(nn_ph[l,x] - nn_ph[l,x-1])/dts;
        dyKdts:=(yK_ph[l,x] - yK_ph[l,x-1])/dts;
        dnAdts:=(nA_ph[l,x] - nA_ph[l,x-1])/dts;
        dlAdts:=(lA_ph[l,x] - lA_ph[l,x-1])/dts;
        dnMdts:=(nM_ph[l,x] - nM_ph[l,x-1])/dts;
        dwAHPdts:=(wAHP_ph[l,x] - wAHP_ph[l,x-1])/dts;
        if x=Nts then begin
           dnndts:=0; dyKdts:=0; dnAdts:=0; dlAdts:=0; dnMdts:=0; dwAHPdts:=0;
        end;
        nn_ph[l,x]:=nn_ph[l,x] - dt*dnndts + Dnn;
        yK_ph[l,x]:=yK_ph[l,x] - dt*dyKdts + DyK;
        nA_ph[l,x]:=nA_ph[l,x] - dt*dnAdts + DnA;
        lA_ph[l,x]:=lA_ph[l,x] - dt*dlAdts + DlA;
        nM_ph[l,x]:=nM_ph[l,x] - dt*dnMdts + DnM;
        wAHP_ph[l,x]:=wAHP_ph[l,x] - dt*dwAHPdts + DwAHP;
        {***** Second order TVD-scheme *****}
        if (IfSecondOrder=1)and(x<>Nts) then begin
           nn_ph[l,x]:=nn_ph[l,x]-tvd*(L_nn[l,x]-L_nn[l,x-1]);
           yK_ph[l,x]:=yK_ph[l,x]-tvd*(L_yK[l,x]-L_yK[l,x-1]);
           nA_ph[l,x]:=nA_ph[l,x]-tvd*(L_nA[l,x]-L_nA[l,x-1]);
           lA_ph[l,x]:=lA_ph[l,x]-tvd*(L_lA[l,x]-L_lA[l,x-1]);
           nM_ph[l,x]:=nM_ph[l,x]-tvd*(L_nM[l,x]-L_nM[l,x-1]);
           wAHP_ph[l,x]:=wAHP_ph[l,x]-tvd*(L_wAHP[l,x]-L_wAHP[l,x-1]);
        end;
end;

{*********************************************************************}
procedure InitialPhaseDensityAndPotential(l :integer);
var x,k                                         :integer;
    a,b,v2,gK_,gKA_,gKM_,gAHP_,IK,IKA,IKM,IAHP,Im,q,V_0,V_E,gs,gdE,
    DV0Dt,DVEDt,
    tau_nn,nn_inf,Dnn,
    tau_yK,yK_inf,DyK,
    tau_nA,nA_inf,DnA,
    tau_lA,lA_inf,DlA,
    tau_nM,nM_inf,DnM,
    tau_wAHP,wAHP_inf,DwAHP,sigma_V
                                                :double;
begin
  k:=i3_ie(l);
  minDVDt:=Form4.DDSpinEdit82.Value;
  if Nts=0    then  Nts:=imin(80,MaxPh);
  if ts_end=0 then  ts_end:=0.050;
  dts:=ts_end/Nts;
  for x:=0 to Nts-1 do ro[l,x]:=0;
  ro[l,Nts]:=1/dts;
  { Conditions at rest. }
  V0_ph[l,Nts]:=Vrest[l];
  VE_ph[l,Nts]:=Vrest[l];  VatE[l]:=VE_ph[l,Nts];
  IsynE_ph[l,Nts]:=0;      IsynI_ph[l,Nts]:=0;
  tau_inf_K  (l,V0_ph[l,Nts], tau_nn,nn_ph[l,Nts],tau_yK,yK_ph[l,Nts]);
  tau_inf_KA (l,V0_ph[l,Nts], tau_nA,nA_ph[l,Nts],tau_lA,lA_ph[l,Nts]);
  tau_inf_KM (l,V0_ph[l,Nts], tau_nM,nM_ph[l,Nts]);
  tau_inf_AHP(l,V0_ph[l,Nts], tau_wAHP,wAHP_ph[l,Nts]);
  DuDt_ph[l,Nts]:=0;  DuDt[l]:=DuDt_ph[l,Nts];
  { Conditions at spike }
  V0_ph[l,0]:=Vreset[k];
  VE_ph[l,0]:=Vrest[l];  IsynE_ph[l,0]:=0;  IsynI_ph[l,0]:=0;
  Reset_at_AP_nn_yK_nA_lA_nM_wAHP(l);
  { Passive parameters }
  gK_ :=gK[k] * K_cond(l,nn_ph[l,Nts],yK_ph[l,Nts])*(1-IfBlockK);
  gKA_:=gKA[k]*KA_cond(l,nA_ph[l,Nts],lA_ph[l,Nts])*(1-IfBlockK);
  gKM_:=gKM[k]*      sqr(nM_ph[l,Nts])             *(1-IfBlockK);
  gAHP_:=gAHP[k]*      wAHP_ph[l,Nts];
  IK  :=gK_  *(V0_ph[l,Nts]-VK[k]);
  IKA :=gKA_ *(V0_ph[l,Nts]-VKA);
  IKM :=gKM_ *(V0_ph[l,Nts]-VKM);
  IAHP:=gAHP_*(V0_ph[l,Nts]-VAHP);
  g_ph[l,Nts]:=C_membr[k]/tau_m[k];
  gL[l]:=C_membr[k]/tau_m[k] - (gK_+gKA_+gKM_+gAHP_);
  VL[l]:=Vrest[l]+(IK+IKA+IKM+IAHP)/gL[l];
  //  wAHP[l]:=0;  mBst[l]:=0;
  { Integrate by t* }
  for x:=1 to Nts-1 do begin
      { Fast conductances }
      if x*dts<=dT_AP[k] then q:=0 else q:=1;
      tau_inf_K  (l,V0_ph[l,x-1], tau_nn,nn_inf,tau_yK,yK_inf);
      tau_inf_KA (l,V0_ph[l,x-1], tau_nA,nA_inf,tau_lA,lA_inf);
      tau_inf_KM (l,V0_ph[l,x-1], tau_nM,nM_inf);
      tau_inf_AHP(l,V0_ph[l,x-1], tau_wAHP,wAHP_inf);
      { -------- }
      Dnn:=E_exp(dts,tau_nn)*(nn_inf-nn_ph[l,x-1])*q;
      DyK:=E_exp(dts,tau_yK)*(yK_inf-yK_ph[l,x-1])*q;
      DnA:=E_exp(dts,tau_nA)*(nA_inf-nA_ph[l,x-1])*q;
      DlA:=E_exp(dts,tau_lA)*(lA_inf-lA_ph[l,x-1])*q;
      DnM:=E_exp(dts,tau_nM)*(nM_inf-nM_ph[l,x-1])*q;
      DwAHP:=E_exp(dt,tau_wAHP)*(wAHP_inf-wAHP_ph[l,x-1])*q;
      nn_ph[l,x]:=nn_ph[l,x-1] + Dnn;
      yK_ph[l,x]:=yK_ph[l,x-1] + DyK;
      nA_ph[l,x]:=nA_ph[l,x-1] + DnA;
      lA_ph[l,x]:=lA_ph[l,x-1] + DlA;
      nM_ph[l,x]:=nM_ph[l,x-1] + DnM;
      wAHP_ph[l,x]:=wAHP_ph[l,x-1] + DwAHP;
      { Membrane current }
      IK :=gK[k] * K_cond(l,nn_ph[l,x],yK_ph[l,x]) *(V0_ph[l,x-1]-VK[k]);
      IKA:=gKA[k]*KA_cond(l,nA_ph[l,x],lA_ph[l,x]) *(V0_ph[l,x-1]-VKA);
      IKM:=gKM[k]*sqr(nM_ph[l,x])                  *(V0_ph[l,x-1]-VKM);
      IAHP:=gAHP[k]*wAHP_ph[l,x]                   *(V0_ph[l,x-1]-VAHP);
      g_ph[l,x]:=gK[k] * K_cond(l,nn_ph[l,x],yK_ph[l,x])
                +gKA[k]*KA_cond(l,nA_ph[l,x],lA_ph[l,x])
                +gKM[k]*sqr(nM_ph[l,x])+gAHP[k]*wAHP_ph[l,x]+gL[l];
      Im :=-gL[l]*(V0_ph[l,x-1]-VL[l]) - (IK+IKA+IKM)*(1-IfBlockK) - IAHP;
      { Voltage }
      if          HH_order[l]='1-point'  then begin
          DuDt_ph[l,x]:= Im/C_membr[k]*q;
          V0_ph[l,x]:=V0_ph[l,x-1] + dts*DuDt_ph[l,x];
      end else if HH_order[l]='2-points' then begin
          IsynE_ph[l,x]:=0;  IsynI_ph[l,x]:=0;
          V_0:=V0_ph[l,x-1];
          V_E:=VE_ph[l,x-1];
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
  { Threshold }
  for x:=0 to Nts do begin
//      VT[l,x]:=VThreshold3(k,DuDt_ph[l,x]);
//      sigma_V:= sgm_V[k];
//      V_T_sgm[l,x]:=(V0_ph[l,x]-Vrest[l]-VT[l,x])/sigma_V/sqrt(2);
  end;
  { Draw initial phase distribution }
  if l=3 then  DrawPhaseSpace;
end;
{*********************************************************************}

function AverageV(l :integer) :double;
var x                   :integer;
    Amount,V_av         :double;
begin
  V_av:=0; Amount:=0;
  for x:=trunc(dT_AP[i3_ie(l)]/dts)+1 to Nts do begin
      V_av:=V_av+V0_ph[l,x]*ro[l,x]*dts;
      Amount:=Amount +      ro[l,x]*dts;
  end;
  if Amount=0 then AverageV:=V0_ph[l,0] else
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
  x:=trunc(dT_AP[i3_ie(l)]/dts);
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

procedure Limiters_V;
{ TVD-scheme with VanLeer as a limiter }
var i,ie :integer;
begin
  tvd:=dt/dts*(1-dt/dts)/2;
  for ie:=1 to 3 do begin
    for i:=1 to Nts-1 do begin
      L_V0[ie,i]:=VanLeer(V0_ph[ie,i+1]-V0_ph[ie,i], V0_ph[ie,i]-V0_ph[ie,i-1]);
      L_VE[ie,i]:=VanLeer(VE_ph[ie,i+1]-VE_ph[ie,i], VE_ph[ie,i]-VE_ph[ie,i-1]);
      L_nn[ie,i]:=VanLeer(nn_ph[ie,i+1]-nn_ph[ie,i], nn_ph[ie,i]-nn_ph[ie,i-1]);
      L_yK[ie,i]:=VanLeer(yK_ph[ie,i+1]-yK_ph[ie,i], yK_ph[ie,i]-yK_ph[ie,i-1]);
      L_nA[ie,i]:=VanLeer(nA_ph[ie,i+1]-nA_ph[ie,i], nA_ph[ie,i]-nA_ph[ie,i-1]);
      L_lA[ie,i]:=VanLeer(lA_ph[ie,i+1]-lA_ph[ie,i], lA_ph[ie,i]-lA_ph[ie,i-1]);
      L_nM[ie,i]:=VanLeer(nM_ph[ie,i+1]-nM_ph[ie,i], nM_ph[ie,i]-nM_ph[ie,i-1]);
      L_wAHP[ie,i]:=VanLeer(wAHP_ph[ie,i+1]-wAHP_ph[ie,i], wAHP_ph[ie,i]-wAHP_ph[ie,i-1]);
    end;
    L_V0[ie,0]:=0;    L_V0[ie,Nts]:=0;
    L_VE[ie,0]:=0;    L_VE[ie,Nts]:=0;
    L_nn[ie,0]:=0;    L_nn[ie,Nts]:=0;
    L_yK[ie,0]:=0;    L_yK[ie,Nts]:=0;
    L_nA[ie,0]:=0;    L_nA[ie,Nts]:=0;
    L_lA[ie,0]:=0;    L_lA[ie,Nts]:=0;
    L_nM[ie,0]:=0;    L_nM[ie,Nts]:=0;
    L_wAHP[ie,0]:=0;  L_wAHP[ie,Nts]:=0;
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
     V_av,V_E,V_0,gs,gdE,nu,rs,
     Isyn,IsynE_old,IsynI_old,DssE,DuuE
                                                :double;
     IK_ph,IKA_ph,IKM_ph,IAHP_ph,
     gK_,  gKA_,  gKM_,  gAHP_, gNaP_,
     IKM,IAHP,IBst,INaP
                                                :array[1..3] of double;
BEGIN
  {Conditions at spike}
  for l:=1 to 3 do begin
      k:=i3_ie(l);
      V0_ph[l,0]:=Vreset[k];
      VE_ph[l,0]:=Vrest[l];
      Reset_at_AP_nn_yK_nA_lA_nM_wAHP(l);
  end;
  { Burst-current, slow }
  if (gBst[1]>0)or(gBst[2]>0) then begin
      for l:=1 to 2 do begin
          V_av:=AverageV(l);
          nu:=RateOfWorkingNeurons(l);
          IBst[l] := Bst_current(l, V_av, nu);
      end;
  end else begin IBst[1]:=0; IBst[2]:=0; end;
  if IfSecondOrder=1 then  Limiters_V;
  { ---------------- Ohm's law  and transfer ---------------------------- }
  FOR x:=Nts downto 1 do begin {loop for phase}
    { K - currents }
    for l:=1 to 3 do begin
        k:=i3_ie(l);
        if x*dts<=dT_AP[k] then begin
                                      q:=0;
                           end else   q:=1;
        {******* Conductances ********}
        New_nn_yK_nA_lA_nM_wAHP(l,x,q);
        {-----------------------------}
        gK_[l]  :=gK[k]  * K_cond(l,nn_ph[l,x],yK_ph[l,x]);
        gKA_[l] :=gKA[k] *KA_cond(l,nA_ph[l,x],lA_ph[l,x]);
        gKM_[l] :=gKM[k] *sqr(nM_ph[l,x]);
        gAHP_[l]:=gAHP[k]*wAHP_ph[l,x] ;
        {******* Currents ************}
        IK_ph[l]  :=gK_[l]  *(V0_ph[l,x]-VK[k]);
        IKA_ph[l] :=gKA_[l] *(V0_ph[l,x]-VKA);
        IKM_ph[l] :=gKM_[l] *(V0_ph[l,x]-VKM);
        IAHP_ph[l]:=gAHP_[l]*(V0_ph[l,x]-VAHP);
    end;
    { NaP and additive current }
    for l:=1 to 3 do begin
        gNaP_[l]:=gNaP[i3_ie(l)]*istep(mNaP[i3_ie(l)],3);
        INaP[l]:= NaP_current(i3_ie(l),V0_ph[l,x]);
        Iadd[l]:= Current_Iind(l);
    end;
    { ---------------- Total Current and Conductance -------------- }
    for l:=1 to 3 do begin
        k:=i3_ie(l);
        g_ph[l,x]:=gNaP_[l]+gK_[l]+gKA_[l]+gKM_[l]+gAHP_[l]+gL[l];
        Im[l]:=-IAHP_ph[k] -IBst[k] -INaP[l] -gL[l]*(V0_ph[l,x]-VL[l]) +Iadd[l]
               -(IK_ph[l] +IKA_ph[l] +IKM_ph[l])*(1-IfBlockK);
    end;
    { ---------------- Gap Junctions ------------------------------ }
    GapJunctions(x);
    { ---------------- Ohm's law ---------------------------------- }
    for l:=1 to 3 do begin
        k:=i3_ie(l);
        if          HH_order[l]='1-point'  then begin
          Isyn:= -(ssE[l]+ssI[l])*(V0_ph[l,x]-Vus) + uuE[l]+uuI[l] + I_GJ[l];
          DuDt_ph[l,x]:= (Im[l]+Isyn)/C_membr[k]*q;
          if x=Nts then dV0:=0 else
          dV0:=(V0_ph[l,x] - V0_ph[l,x-1])/dts;
          {----------}
          V0_ph[l,x]:=V0_ph[l,x] - dt*dV0 + dt*DuDt_ph[l,x];
          {***** Second order TVD-scheme *****}
          if (IfSecondOrder=1)and(x<>Nts) then begin
             V0_ph[l,x]:=V0_ph[l,x]-tvd*(L_V0[l,x]-L_V0[l,x-1]);
          end;
          {----------}
        end else if HH_order[l]='2-points' then begin
          IsynE_old:=IsynE_ph[l,x];   IsynI_old:=IsynI_ph[l,x];
          IsynE_ph[l,x]:=-ssE[l]*(V0_ph[l,x]-Vus) + uuE[l];
          IsynI_ph[l,x]:=-ssI[l]*(V0_ph[l,x]-Vus) + uuI[l];
          DIsynE:=(IsynE_ph[l,x]-IsynE_old)/dt;
          IatE:=1/2*tau_m[k]*DIsynE + 3/2*IsynE_ph[l,x] + I_GJ[l];
          V_0:=V0_ph[l,x];
          V_E:=VE_ph[l,x];
          gs:=C_membr[k]/tau_m[k];    gdE:=gs*roE;
          {----------}
          DVEDt:= 1/tau_m[k]*(-(V_E -Vrest[l])
                - (2+gdE/gs)*(V_E -V_0)            + 2*IatE/gdE )*q;
          DV0Dt:= 1/tau_m[k]*(
                     gdE/gs *(V_E -V_0) + Im[l]/gs + IsynI_ph[l,x]/gs)*q;
          { Version with substitution of DV0Dt in IatE }
{          IsynE_ph[l,x]:=-ssE[l]*(V0_ph[l,x]-Vus) + uuE[l];
          IsynI_ph[l,x]:=-ssI[l]*(V0_ph[l,x]-Vus) + uuI[l];
          DssE:=(ssE[l]-ssE_old[l])/dt;
          DuuE:=(uuE[l]-uuE_old[l])/dt;
          V_0:=V0_ph[l,x];
          V_E:=VE_ph[l,x];
          gs:=C_membr[k]/tau_m[k];    gdE:=gs*roE;
          DV0Dt:= 1/tau_m[k]*(
                     gdE/gs *(V_E -V_0) + Im[l]/gs + IsynI_ph[l,x]/gs)*q;
          IatE:=1/2*tau_m[k]*(-DssE*(VE_ph[l,x]-Vus)+DuuE-ssE[l]*DV0Dt)
               +3/2*IsynE_ph[l,x] + I_GJ[l];
          DVEDt:= 1/tau_m[k]*(-(V_E -Vrest[l])
                - (2+gdE/gs)*(V_E -V_0)            + 2*IatE/gdE )*q;}
          if x=Nts then begin
             dVE:=0;  dV0:=0;
          end else begin
             dVE:=(VE_ph[l,x] - VE_ph[l,x-1])/dts;
             dV0:=(V0_ph[l,x] - V0_ph[l,x-1])/dts;
          end;
          {----------}
          VE_ph[l,x]:=V_E - dt*dVE + dt*DVEDt;
          V0_ph[l,x]:=V_0 - dt*dV0 + dt*DV0Dt;
          {***** Second order TVD-scheme *****}
          if (IfSecondOrder=1)and(x<>Nts) then begin
             V0_ph[l,x]:=V0_ph[l,x]-tvd*(L_V0[l,x]-L_V0[l,x-1]);
             VE_ph[l,x]:=VE_ph[l,x]-tvd*(L_VE[l,x]-L_VE[l,x-1]);
          end;
          {----------}
          DuDt_ph[l,x]:=DV0Dt;
        end;
        If (If_I_V_or_p=1)or(If_I_V_or_p=5) then  V0_ph[3,x]:=Vrest[3];
    end;
  END; {loop for phase}
  {Potentials in quiet neurones}
  for l:=1 to 3 do begin
      V[l]   :=V0_ph[l,Nts];
      VatE[l]:=VE_ph[l,Nts];
      DuDt[l]:=DuDt_ph[l,Nts];
      if HH_order[l]='2-points' then
      PSC[l]:=(IsynE_ph[l,Nts]+IsynI_ph[l,Nts]+Current_Iind(l))*Square[i3_ie(l)]*1e9;{pA}
  end;
END;
{*********************************************************************}
{*********************************************************************}
var  V_av_E,V_av_I :double;

procedure GapJunctions(xts :integer);
var  ie,x,k               :integer;
     VE_,VI_,VPeak        :double;
begin
  { Exception }
  if (gGJ_E[1]=0)and(gGJ_I[1]=0)and(gGJ_E[2]=0)and(gGJ_I[2]=0) then begin
     for ie:=1 to 3 do I_GJ[ie]:=0;
     exit;
  end;
  VPeak:=0;
  if xts=Nts then begin
     { Mean voltage of spiking cells }
     V_av_E:=0;  V_av_I:=0;
     for x:=0 to Nts do begin
         VE_:=V0_ph[1,x];
         VI_:=V0_ph[2,x];
         { Reconstruction of the spike }
         if x*dts<=dT_AP[1] then VE_:=VPeak + (Vreset[1]-VPeak)/dT_AP[1]*x*dts;
         if x*dts<=dT_AP[2] then VI_:=VPeak + (Vreset[2]-VPeak)/dT_AP[2]*x*dts;
         V_av_E:=V_av_E + VE_*ro[1,x]*dts;
         V_av_I:=V_av_I + VI_*ro[2,x]*dts;
     end;
  end;
  { Current going through GJ }
  for ie:=1 to 3 do begin
      k:=i3_ie(ie);
      if HH_order[ie]<>'2-points' then begin
         I_GJ[ie]:=gGJ_E[k]*(V_av_E-V0_ph[ie,xts])
                 + gGJ_I[k]*(V_av_I-V0_ph[ie,xts]);
      end else begin
         I_GJ[ie]:=gGJ_E[k]*(V_av_E-VE_ph[ie,xts])
                 + gGJ_I[k]*(V_av_I-VE_ph[ie,xts]);
      end;
      {Im[ie]:=Im[ie]+I_GJ[ie];}
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
      s:=sgm_V[k]/0.010{mV};   {nondim. dispersion of syn. conductances}
      gs:=C_membr[k]/tau_m[k];
      mmE:=mAMPA[k] + mAMP3[k];
      mmI:=mGABA[k] + mGAB3[k];
      gE:= gAMPA[l]*mAMPA[k] + gAMP3[l]*mAMP3[k];
      gI:= gGABA[l]*mGABA[k] + gGAB3[l]*mGAB3[k];
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
