unit SetNrnPars;

interface
uses typeNrnPars;

procedure DefaultCanalParameters(var NP :NeuronProperties);
procedure SetParamsForNaR(var NP :NeuronProperties);
procedure HodgkinPhysParameters(var NP :NeuronProperties);

implementation

procedure DefaultCanalParameters(var NP :NeuronProperties);
begin
 with NP do BEGIN
  { TTX-Resistent Na-current }
  gNaR:=0;//13.5;
  { Default zero values: }
  gNa:=0;  gK:=0;   gKM:=0;   gKA:=0;   gKD:=0;  gH:=0;
  gCaH:=0;  gKCa:=0;  gAHP:=0;  gCaT:=0;  gBst:=0;  gNaP:=0;
  VKDr:=0;  VKM:=0;  VKD:=0;
  dT_AP:=0;
  NaThreshShift:=0;
  if          HH_type='Calmar' then begin
     { For Calmar   - gNa=120, gK=36, gL=0.3 }
     gNa :=   120 {mS/cm^2};
     gK  :=    36 {mS/cm^2};
     gL  :=   0.3 {mS/cm^2};
     Vrest:=-0.060{V};
     Tr :=-60 {Vrest[1]*1000} {mV !};
     VNa:= 0.050 {V};
     VK :=-0.077 {V};
     VKM:=VK;
     a1Na:= 0.1;  a2Na:= 25;  a3Na:= 10;  a4Na:= 1;
     b1Na:= 4;    b2Na:= 0;   b3Na:=18;   b4Na:= 0;
     c1Na:= 0.07; c2Na:= 0;   c3Na:= 20;  c4Na:= 0;
     d1Na:= 1;    d2Na:= 30;  d3Na:=10;   d4Na:= -1;
     n_AP:=0.72;  dT_AP:=0.00195{s};
     if IfSet_gL_or_tau=0 then IfSet_gL_or_tau:=1;
  end else if HH_type='Destexhe' then begin
     { For Destexhe - gNa=7, gK=10, gKM=0.5, gCaH:=3, gKCa=1.5; }
     gNa :=     7 {mS/cm^2};
     gK  :=    10 {mS/cm^2};
     gKM :=   0.5 {mS/cm^2};
     Tr :=-63 {mV !};
     VNa:= 0.050 {V};
     VK :=-0.090 {V};
     VKM:=VK;
     a1Na:= 0.32;  a2Na:= 13;  a3Na:= 4;  a4Na:= 1;
     b1Na:=-0.28;  b2Na:=40;   b3Na:=-5;  b4Na:= 1;
     c1Na:= 0.128; c2Na:= 17;  c3Na:= 18; c4Na:= 0;
     d1Na:= 4;     d2Na:= 40;  d3Na:=5;   d4Na:= -1;
     if IfSet_gL_or_tau=0 then IfSet_gL_or_tau:=2;
  end else if HH_type='Migliore' then begin
     { For Migliore - gNa=32 (7-p, 22-i), gK=10, gKA=48; }
     gNa := 32{7} {mS/cm^2};
     gK  :=    10 {mS/cm^2};
     gKA :=     0{48} {mS/cm^2};
     VNa:= 0.055 {V};
     VK :=-0.072 {V};
     if HH_order='1-point'  then n_AP:=0.17 else
     if HH_order='2-points' then n_AP:={0.12}0.07;
     if IfSet_gL_or_tau=0 then IfSet_gL_or_tau:=2;
  end else if HH_type='Cummins' then begin
     { For Cummins }
     gNa :=    35 {mS/cm^2};
     gK  :=   2.1 {mS/cm^2};
     gL  := 0.14 {mS/cm^2};
     VL :=-0.0543 {V};
     Tr :=0 {mV !};
     VNa:= 0.06294 {V};
     VK :=-0.09234 {V};
     { NaR }
     gNaR:=6.9;
     if IfSet_gL_or_tau=0 then IfSet_gL_or_tau:=1;
  end else if HH_type='Chow' then begin
     { For Chow }
     Square:=1e-4{1e-4} {cm^2};
     gNa :=    30 {mS/cm^2};
     gK  :=    40 {mS/cm^2};
     gL  :=  0.1 {mS/cm^2};
     Vrest:=-0.060 {V};
     Tr :=0 {mV !};
     VNa:= 0.045 {V};
     VK :=-0.080 {V};
     if HH_order='1-point'  then n_AP:=0.45 else
     if HH_order='2-points' then n_AP:=0.0;
     dT_AP:=0.0014{s};
     IfSet_gL_or_tau:=1;
     IfSet_VL_or_Vrest:=2;
  end
   else if HH_type='Lyle' then

   Begin
     { For Lyle }
     if HH_order='1-point'  then  Square:=52.7e-5 {cm^2};
     if HH_order='2-points' then  Square:=42.4e-5 {cm^2};
     C_membr:=0.0007 {mF/cm^2};         { !!! }
     gNaR  :=  0 {mS/cm^2};
     gNa :=    2.28 {mS/cm^2};
     gK  :=    0.76 {mS/cm^2};
     gKA :=    4.36 {mS/cm^2};          {type of this conductance}
     gKM :=    0.76 {mS/cm^2};
     gKD :=    0.095{mS/cm^2};
     gAHP:=    0.6;  {mS/cm^2};
     gH  :=    0.0057  {mS/cm^2};
     Vrest:=-0.0657 {V};
     tau_m:= 0.0144 {s};
     VNa:= 0.065 {V};
     VKDr:=-0.070 {V};
     VK  :=-0.070 {V};
     VKM :=-0.080 {V};
     VKD :=-0.095 {V};
     V12H:=-0.017 {V};
     Temperature:=297 {K};       {[p.104 Lyle]}
     n_AP:=0.262; yK_AP:=0.473; nA_AP:=0.743; lA_AP:=0.691; dT_AP:=0.0015{s};
     dwAHP:=0.016; yH_AP:=0.002;  xD_AP:=0.960;
     if IfSet_gL_or_tau=0 then IfSet_gL_or_tau:=2;
     IfSet_VL_or_Vrest:=2;

     end

   else if HH_type='Buchin' then
   Begin
     { For Buchin }
     if HH_order='1-point'  then  Square:=52.7e-5 {cm^2};
     if HH_order='2-points' then  Square:=42.4e-5 {cm^2};
     C_membr:=0.0007 {mF/cm^2};         { !!! }
     gNaR  :=  0 {mS/cm^2};
     gNa :=    2.28 {mS/cm^2};
     gK  :=    0.76 {mS/cm^2};
     gKA :=    4.36 {mS/cm^2};          {type of this conductance}
     gKM :=    0.76 {mS/cm^2};
     gKD :=    0.095{mS/cm^2};
     gAHP:=    0.6;  {mS/cm^2};
     gH  :=    0.0057  {mS/cm^2};
     Vrest:=-0.0657 {V};
     tau_m:= 0.0144 {s};
     VNa:= 0.065 {V};
     VKDr:=-0.070 {V};
     VK  :=-0.070 {V};
     VKM :=-0.080 {V};
     VKD :=-0.095 {V};
     V12H:=-0.017 {V};
     Temperature:=297 {K};       { [p.104 Lyle] }
     n_AP:=0.262; yK_AP:=0.473; nA_AP:=0.743; lA_AP:=0.691; dT_AP:=0.0015{s};
     dwAHP:=0.016; yH_AP:=0.002;  xD_AP:=0.960;
     if IfSet_gL_or_tau=0 then IfSet_gL_or_tau:=2;
     IfSet_VL_or_Vrest:=2;

  End;

  if VKDr=0 then VKDr:=VK;  if VKM=0 then VKM:=VK;  if VKD=0 then VKD:=VK;
  if IfSet_VL_or_Vrest=0 then IfSet_VL_or_Vrest:=2;
  {**************}
  SetParamsForNaR(NP);
 END;
end;

procedure SetParamsForNaR(var NP :NeuronProperties);
var s :string;
begin
 with NP do BEGIN
  { Krylov: }
  Tr_NaR:=-60 {mV};
//  a1NaR:= 0.037;  a2NaR:=45.5; a3NaR:= 11;   a4NaR:= 1;
//  b1NaR:= 2.18;   b2NaR:= 0;   b3NaR:= 19.2; b4NaR:= 0;
//  c1NaR:= 0.031;  c2NaR:= 0;   c3NaR:= 121;  c4NaR:= 0;
//  d1NaR:= 0.98;   d2NaR:=63.3; d3NaR:= 11.8; d4NaR:= -1;
//  VNaR:=0.031 {V};
  a1NaR:= 0.043;  a2NaR:=30;   a3NaR:= 3.85;  a4NaR:= 1;
  b1NaR:= 0.52;   b2NaR:= 0;   b3NaR:= 65;    b4NaR:= 0;
  c1NaR:= 0.042;  c2NaR:= 0;   c3NaR:= 8.6;   c4NaR:= 0;
  d1NaR:= 0.50;   d2NaR:=65;   d3NaR:=12;     d4NaR:= -1;
  VNaR:=0.031;
  { Cummins: }
  if NaR_type='Cummins' then begin
     Tr_NaR:=0;
     a1NaR:= 1.032;  a2NaR:=-6.99;  a3NaR:=14.87; a4NaR:= -1;
     b1NaR:= 5.79;   b2NaR:=-130.4; b3NaR:=-22.9; b4NaR:= -1;
     c1NaR:=0.06435; c2NaR:=-73.26; c3NaR:=-3.72; c4NaR:= -1;
     d1NaR:=0.135;   d2NaR:=-10.28; d3NaR:=9.093; d4NaR:= -1;
     VNaR:=VNa;
  end;
 END;
end;

{----------------------------------------------------------------------}
procedure HodgkinPhysParameters(var NP :NeuronProperties);
var Gs :double;
begin
 with NP do BEGIN
  {------------------- Membrane --------------------}
  { Passive parameters }
  C_membr:=0.001 {mF/cm^2};         { !!! }
  Gs:=1.3 {nS};
  ro:=3.7{nS}/1.3{nS};
  Vrest:=-0.064{V};  tau_m:=0.021{s};
  Square:=Gs*tau_m/C_membr*1e-6{cm^2};
  gL:=C_membr/tau_m;
  { Canals }
  DefaultCanalParameters(NP);
  Vreset:=Vrest;
  { Calcium }
  Faraday:=96485 {C/mol};     {Faraday constant}
  Rgas   :=8.314  {J/(K*mol)}; {gas constant}
  Temperature:=309 {K};       {Temperature}
  d_Ca :=0.1e-4 {cm};         {thickness of shell beneath the membrane}
  Ca8  :=240e-6 {mM};
  Ca0  :=2 {mM};
  tauCa:=5 {s};
 END;
end;

end.
