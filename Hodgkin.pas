unit Hodgkin;

interface
procedure gSyn_From_i3;
procedure DefaultCanalParameters(ie :integer);
procedure HodgkinPhysParameters;
function Current_Iind(ie :integer) :double;
procedure CorrectPassiveParameters(ie :integer);
procedure InitialConditionsHodgkin;
procedure MembranePotential;


implementation
uses Init,HH_canal,HH_migli,Unit4;

{----------------------------------------------------------------------}
procedure SynapticParameters;
var  ie :integer;
begin
  { Transmitter }
  Transm:=0.001 {M};
  dt_T:=0.001 {s};
  { Density of synapses on exitatory and inhibitory cells }
  gAMP3[1]:=0.8 {mS/cm^2};      gAMP3[2]:=1 {mS/cm^2};
  gGAB3[1]:=0   {mS/cm^2};      gGAB3[2]:=0 {mS/cm^2};
  gAMPA[1]:=0   {mS/cm^2};      gAMPA[2]:=6 {mS/cm^2};
  gGABA[1]:=7   {mS/cm^2};      gGABA[2]:=0 {mS/cm^2};
  gGABB[1]:=0   {mS/cm^2};      gGABB[2]:=0 {mS/cm^2};
  gNMD3[1]:=0   {mS/cm^2};      gNMD3[2]:=0 {mS/cm^2};
  gNMDA[1]:=0   {mS/cm^2};      gNMDA[2]:=0 {mS/cm^2};
  gGJ_E[1]:=0;                  gGJ_E[2]:=0;
  gGJ_I[1]:=0;                  gGJ_I[2]:=0;
  gSyn_From_i3;
  for ie:=1 to 2 do begin
      { Constants for receptors }
      alAMPA[ie]:=185 {1/s};
      alGABA[ie]:=120 {1/s};
      alGABB[ie]:=  8 {1/s};
      alNMDA[ie]:= {50}36 {1/s};
      beAMPA[ie]:=185 {1/s};
      beGABA[ie]:=5200 {1/s};
      beGABB[ie]:=  8 {1/s};
      beNMDA[ie]:=1/0.003 {1/s};
      alAMP3[ie]:=alAMPA[ie];
      alGAB3[ie]:=alGABA[ie];
      beAMP3[ie]:=beAMPA[ie];
      beGAB3[ie]:=beGABA[ie];
  end;
  VAMPA:=(  5)/1000 {V};
  VGABA:=(-80)/1000 {V};
  VGABB:=(-93)/1000 {V};
  VNMDA:=( 10)/1000 {V};
  { Other }
  Mg:=2 {mM};
end;

procedure gSyn_From_i3;
begin
  gAMP3[3]:=gAMP3[i3];
  gGAB3[3]:=gGAB3[i3];
  gAMPA[3]:=gAMPA[i3];
  gGABA[3]:=gGABA[i3];
  gGABB[3]:=gGABB[i3];
  gNMD3[3]:=gNMD3[i3];
  gNMDA[3]:=gNMDA[i3];
end;

procedure DefaultCanalParameters(ie :integer);
begin
  { Default zero values: }
  gNa[ie]:=0;  gK[ie]:=0;  gKA[ie]:=0;  gKM[ie]:=0;  gAHP[ie]:=0;  gNaP[ie]:=0;
  gBst[ie]:=0;  UBst[ie]:=0;  WBst[ie]:=0;
  VAHP:=-0.070 {V};    Vreset[ie]:=0;
  dT_AP[ie]:=0;
  IfSet_gL_or_tau[ie]:=2;
  if          HH_type[ie]='Calmar' then begin
     { For Calmar   - gNa=120, gK=36, gL=0.3 }
     gNa[ie]:=120 {mS/cm^2};
     gK[ie]:=  36 {mS/cm^2};
     gL[ie]:= 0.3 {mS/cm^2};
     Vrest[ie]:=-0.060{V};
     Tr :=-60 {Vrest[1]*1000} {mV !};
     VNa   := 0.050 {V};
     VK[ie]:=-0.077 {V};
     VKM:=VK[ie];
  end else if HH_type[ie]='Destexhe' then begin
     { For Destexhe - gNa=7, gK=10, gKM=0.5, gCaH:=3, gKCa=1.5; }
     gNa[ie]:=  7 {mS/cm^2};
     gK[ie] := 10 {mS/cm^2};
     gKM[ie]:=0.5 {mS/cm^2};
     Tr :=-63 {mV !};
     VNa   := 0.050 {V};
     VK[ie]:=-0.090 {V};
     nn_AP[ie]:=0.5;
  end else if HH_type[ie]='Migliore' then begin
     { For Migliore - gNa=32 (7-p, 22-i), gK=10, gKA=48; }
     gNa[ie]:= 32{7} {mS/cm^2};
     if HH_order[ie]='1-point'  then begin  gK[1]:=10; gK[2]:=10; end;
     if HH_order[ie]='2-points' then begin  gK[1]:=20; gK[2]:=15; end;
     gKM[ie]:=  0{48} {mS/cm^2};
     VNa   := 0.055 {V};
     VK[ie]:=-0.072 {V};
     if HH_order[ie]='1-point'  then  nn_AP[ie]:=0.17;
     if HH_order[ie]='2-points' then  nn_AP[ie]:=0.05;
  end else if HH_type[ie]='Chow' then begin
     { For Chow }
     gNa[ie]:= 30 {mS/cm^2};
     gK[ie]:=  40 {mS/cm^2}; //20 {mS/cm^2};
     gL[ie]:= 0.1 {mS/cm^2};
     Vrest[ie]:=-0.060 {V};
     Tr :=0 {mV !};
     VNa   := 0.045 {V};
     VK[ie]:=-0.080 {V};
     nn_AP[ie]:=0.45;
     dT_AP[ie]:=0.0014{s};
     Vreset[ie]:=-0.040{V};
     IfSet_gL_or_tau[ie]:=1;
  end else if HH_type[ie]='Lyle' then begin
     { For Lyle }
     if HH_order[ie]='1-point'  then  Square[ie] :=52.7e-5 {cm^2};
     if HH_order[ie]='2-points' then  Square[ie] :=42.4e-5 {cm^2};
     C_membr[ie]:=0.0007 {mF/cm^2};         { !!! }
     gK[ie]  :=    0.76 {mS/cm^2};
     gKA[ie] :=    4.36 {mS/cm^2};
     gKM[ie] :=    0.76 {mS/cm^2};
     gAHP[ie]:=    0.6  {mS/cm^2};
     Vrest[ie]:=-0.0657 {V};
     tau_m[ie]:= 0.0144 {s};
     VK[ie]:=-0.070 {V};
     VKA   :=-0.070 {V};
     VKM   :=-0.080 {V};
     VAHP  :=-0.070 {V};
     nn_AP[ie]:=0.262; yK_AP:=0.473; nA_AP:=0.743; lA_AP:=0.691;
     dT_AP[ie]:=0.0015{s};     dwAHP:=0.016;
     Vreset[ie]:=-0.040{V};
     IfSet_gL_or_tau[ie]:=2;
  end else if HH_type[ie]='Passive' then begin
     gK[ie]  :=0;
     gKA[ie] :=0;
     gKM[ie] :=0;
     gAHP[ie]:=0;
     Vreset[1]:=-0.0751{V};
     Vreset[2]:=Vrest[2];
  end;
  Vus:=VK[1];
  if Vreset[ie]=0 then Vreset[ie]:=Vrest[ie];
end;

procedure HodgkinPhysParameters;
begin
  {------------------- Membrane --------------------}
  { Passive parameters }
  C_membr[1]:=0.001{07} {mF/cm^2};         { !!! }
  { In Pyramids:}
  Gs[1]:=1.3 {nS};
  roE{=Gd/Gs}:=3.7{nS}/Gs[1];   roI:=15{nS}/Gs[1];
  Vrest[1]:=-0.064{V};  tau_m[1]:=0.021{s};
  Square[1]:=Gs[1]*tau_m[1]/C_membr[1]*1e-6{cm^2};
  gL[1]:=C_membr[1]/tau_m[1];
  DefaultCanalParameters(1);
  { In Interneurones:}
  C_membr[2]:=0.001{07} {mF/cm^2};         { !!! }
  Vrest[2]:=-0.0704{V};  tau_m[2]:=0.016{s};
  gL[2]:=C_membr[2]/tau_m[2];
  Square[2]:=1e-4{cm^2};
  DefaultCanalParameters(2);
  { In Registered cell: }
  if i3=0 then i3:=1;        {'1'-excitatory }
  Vrest[3]:=Vrest[i3];
  gL[3]:=C_membr[i3]/tau_m[i3];
  {-------------------------- Synapses --------------------------}
  SynapticParameters;
end;

function Current_Iind(ie :integer) :double;
var  MeanCurr,tp,I_ind_per_cm2 :double;
begin
  I_ind_per_cm2:=I_ind/(Square[i3_ie(ie)]*1e9);
  if ((t>0)and(t<=t_ind)) or ((t>dtSt)and(t<dtSt+t_ind)) then begin
     if nu_ind=0 then begin                   {constant}
        MeanCurr:=I_ind_per_cm2
     end else if nu_ind<0 then begin          {sinus with increasing freq.}
        MeanCurr:=I_ind_per_cm2*sin(2*pi*(abs(nu_ind)*t/10)*t)
     end else begin                           {sinus}
        MeanCurr:=I_ind_per_cm2*sin(2*pi* nu_ind *t)
     end;
  end else begin
     MeanCurr:=0;
  end;
  { Pulse train }
  if (nu_ind>0)and(t_ind<0.005) then begin
     tp:=trunc(t*nu_ind)/nu_ind;
     if (t>tp)and(t<tp+t_ind)and(trunc(t*nu_ind)<=10)
     then  MeanCurr:=I_ind_per_cm2
     else  MeanCurr:=0;
  end;
  { If turn off additive current for E or I-cells }
  if i3_ie(ie)=Form4.ComboBox1.ItemIndex then Current_Iind:=0 else
  { If turn on Noise }
  if not(Form4.CheckBox8.Checked) then begin
     Current_Iind:=MeanCurr;
  end else begin
     Current_Iind:=MeanCurr + I_ind_per_cm2*NoiseToSgn*r_Noise[i3_ie(ie)];
  end;
end;

procedure CorrectPassiveParameters(ie :integer);
{ see p.148 }
var  RHP,INa,IK,IKM,IAHP,IBst   :double;
     k                          :integer;
begin
  k:=i3_ie(ie);
  if (HH_type[ie]='Passive') or (ie=3) then begin
     ActiveConductance:= 0;
     RHP:=0;
     gL[ie]:=C_membr[k]/tau_m[k];
     VL[ie]:=Vrest[ie];
  end else begin
     INa := Na_current(k);
     IK  :=  K_current(k);
     IKM := KM_current(k,Vrest[ie],pn[k]);
     IAHP:=AHP_current(k,Vrest[ie],pn[k]);
     IBst:=Bst_current(k,Vrest[ie],pn[k]);
     RHP:= -INa*(1-IfPhase) - IK - IKM - IAHP - IBst;
     CalculateActiveConductance(ie);
     if IfSet_gL_or_tau[k]=2 then begin
        gL[ie]:=C_membr[k]/tau_m[k] - ActiveConductance;
     end else begin
        tau_m[ie]:=C_membr[k]/(ActiveConductance+gL[ie]);
     end;
     VL[ie]:=Vrest[ie]-RHP/gL[ie];
  end;
end;

procedure InitialConditionsHodgkin;
var  i,ie           :integer;
     v2,a,b,ICaH,m2 :double;
begin
  { Synaptic conductanses ----------------------}
  for i:=1 to 2 do begin
    mAMP3[i]:=0;
    mAMPA[i]:=0;   eAMP[i]:=0;    UeAMP[i]:=0;   WeAMP[i]:=0;
    mGABB[i]:=0;
    mGABA[i]:=0;   eGAB[i]:=0;    UeGAB[i]:=0;   WeGAB[i]:=0;
    mGAB3[i]:=0;
    mNMD3[i]:=0;
    mNMDA[i]:=0;
    UAMP3[i]:=mAMP3[i]/alAMPA[i];  WAMP3[i]:=mAMP3[i]/beAMPA[i];
    UGAB3[i]:=mGAB3[i]/alGABA[i];  WGAB3[i]:=mGAB3[i]/beGABA[i];
    UAMPA[i]:=mAMPA[i]/alAMPA[i];  WAMPA[i]:=mAMPA[i]/beAMPA[i];
    UGABA[i]:=mGABA[i]/alGABA[i];  WGABA[i]:=mGABA[i]/beGABA[i];
    UGABB[i]:=mGABB[i]/alGABB[i];  WGABB[i]:=mGABB[i]/beGABB[i];
    UNMD3[i]:=mNMD3[i]/alNMDA[i];  WNMD3[i]:=mNMD3[i]/beNMDA[i];
    UNMDA[i]:=mNMDA[i]/alNMDA[i];  WNMDA[i]:=mNMDA[i]/beNMDA[i];
    if abs(alAMPA[i]-beAMPA[i])<0.001 then UAMP3[i]:=mAMP3[i];
    if abs(alGABA[i]-beGABA[i])<0.001 then UGAB3[i]:=mGAB3[i];
    if abs(alAMPA[i]-beAMPA[i])<0.001 then UAMPA[i]:=mAMPA[i];
    if abs(alGABA[i]-beGABA[i])<0.001 then UGABA[i]:=mGABA[i];
    if abs(alGABB[i]-beGABB[i])<0.001 then UGABB[i]:=mGABB[i];
    if abs(alNMDA[i]-beNMDA[i])<0.001 then UNMD3[i]:=mNMD3[i];
    if abs(alNMDA[i]-beNMDA[i])<0.001 then UNMDA[i]:=mNMDA[i];
  end;
  for ie:=1 to 2 do begin
      ss[ie]:=0;       { Inhibition }
      uu[ie]:=0 {mV};  { Exitation }
      uuE[ie]:=0; uuI[ie]:=0; ssE[ie]:=0; ssI[ie]:=0;
  end;
  { -----------------------------------------------------------}
  { Voltage-gated canals and passive parameters ---------------}
  HH_type[3]:=HH_type[i3];           HH_order[3]:=HH_order[i3];
  FRT:=96485 {C/mol}/8.314  {J/(K*mol)}/309 {K}/1000;
  InitialCanalExtraConductances(1);
  InitialCanalExtraConductances(2);
  InitialCanalConductances(1);
  InitialCanalConductances(2);
  CorrectPassiveParameters(1);   {! depend on ss[ie]}
  CorrectPassiveParameters(2);
  CorrectPassiveParameters(3);
end;

{-----------------------------------------------------------------------}

procedure MembranePotential;
var  i,k,l                                              :integer;
     INa,IK,IKM,IKCa,VL_,
     IatE,IatI,DIsynE,DIsynI,Isyn,IsynE_old,IsynI_old,
     V_E,V_I,V_0,gs,gdE,gdI                             :double;
BEGIN
  { ---------------- Currents ----------------------------------- }
  for i:=1 to 2 do begin
      INa:=0;  IK:=0;  IKM:=0;
      if          HH_type[i]='Passive' then begin
         VL_:=Vrest[i];
//         ActiveConductance:= ss[i];
      end else begin
         INa:=Na_current(i);
         IK := K_current(i);
         IKM:=KM_current(i,V[i],0);
         VL_:=VL[i];
      end;
      Im[i]:= -INa -IK -IKM -gL[i]*(V[i]-VL_);
{      Isyn[i]:= -(ss[i]*(V[i]-VK)-uu[i]);}
  end;
  Im[3] :=   -gL[3] *(V[3] -Vrest[3]) + Current_Iind(3);
{      Isyn[3] := -(ss[1] *(V[3] -VK)-uu[1]);}
  { ---------------- Ohm's law ---------------------------------- }
  for l:=1 to 3 do begin
      k:=l;  if l=3 then  k:=i3;
      if          HH_order[l]='1-point'  then begin
          Isyn:= -(ssE[l]+ssI[l])*(V[l]-Vus) + uuE[l] + uuI[l];
          V[l]:=V[l] + dt*(Im[l]+Isyn)/C_membr[k];
          DuDt[l]:=       (Im[l]+Isyn)/C_membr[k];
      end else if HH_order[l]='2-points' then begin
          V_0:=V[l];  V_E:=VatE[l];  V_I:=VatI[l];
          IsynE_old:=IsynE[l];   IsynI_old:=IsynI[l];
          IsynE[l]:=-ssE[l]*(V_E-Vus) + uuE[l];
          IsynI[l]:=-ssI[l]*(V_I-Vus) + uuI[l];
          DIsynE:=(IsynE[l]-IsynE_old)/dt;
          DIsynI:=(IsynI[l]-IsynI_old)/dt;
          IatE:=1/2*tau_m[l]*DIsynE + 3/2*IsynE[l];
          IatI:=1/2*tau_m[l]*DIsynI + 3/2*IsynI[l];
          gs:=C_membr[k]/tau_m[l];
          gdE:=gs*roE;  gdI:=gs*roI;
          {----------}
          VatE[l]:=V_E + dt/tau_m[l]*(-(V_E  -Vrest[l])
                  - (2+gdE/gs)*(V_E -V_0)
                 {-    gdI/gs *(V_I -V_0)} +2/gdE*IatE -IsynI[l]/gs);
          {----------}
          VatI[l]:=V_I + dt/tau_m[l]*(-(V_I  -Vrest[l])
                   - (2+gdI/gs)*(V_I -V_0)
                   -    gdE/gs *(V_E -V_0) +2/gdI*IatI);
          {----------}
          V[l]   :=V_0 + dt/tau_m[l]*({-(V_0  -Vrest[l])}
                  +    gdE/gs *(V_E -V_0)
                 {+    gdI/gs *(V_I -V_0)} +Im[l]/gs+IsynI[l]/gs);
          DuDt[l]:=(V[l]-V_0)/dt;
      end;
  end;
  If (If_I_V_or_p=1)or(If_I_V_or_p=5) then  V[3]:=Vrest[3];
END;

end.

