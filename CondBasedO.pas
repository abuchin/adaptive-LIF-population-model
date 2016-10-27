unit CondBasedO;

interface
uses
  typeNrnPars,MathMyO,NeuronO,ChannelO{,ControlNrn};

type
{==================================================================}
  TCondBasedNrn = class(TNeuron)
  private
  public
    chNa :TChannel;
    chK  :TChannel;
    chKA :TChannel;
    chKM :TChannel;
    chKD :TChannel;
    chH  :TChannel;
    chNaR:TChannel;
    chAHP:TChannel;
    chCaH:TChannel;
    chCaT:TChannel;
    chKCa:TChannel;
    chNaP:TChannel;
    chBst:TChannel;

    procedure Ca_concentration(ICa:double);
    function VCa(Ca :double) :double;
    procedure CalculateActiveConductance;
    procedure InitialCanalConductances;
    procedure InitialCanalExtraConductances;
    procedure CorrectPassiveParameters;
    procedure Calc_RHP_and_Cond_if_given_V(var RHP,g :double);
    procedure InitialConditionsHodgkin;

    procedure InitialConditions; override;
    procedure IntegrateMembranePotential(uu,ss,tt,Iind,Vhold :double);
    procedure MembranePotential(uu,ss,tt,Iind,Vhold :double); override;

    constructor Create(NP :NeuronProperties);
  end;

implementation

constructor TCondBasedNrn.Create(NP :NeuronProperties);
begin
  inherited Create(NP);
end;

{*********************************************************************}

function TCondBasedNrn.VCa(Ca :double) :double;
var x :double;
begin
  Ca:=max(Ca,NP.Ca8);
  x:=NP.Rgas*NP.Temperature/2/NP.Faraday*ln(NP.Ca0/Ca);
  VCa:=x{0.120} {V};
end;

procedure TCondBasedNrn.Ca_concentration(ICa:double);
begin
  NV.Ca:=NV.Ca + dt*(-ICa/2/NP.Faraday/NP.d_Ca*1e6
                 - (NV.Ca-NP.Ca8)/NP.tauCa); {mM=mmol/m^3}
end;

{*********************************************************************}

procedure TCondBasedNrn.CalculateActiveConductance;
var  gNaR_,gNa_,gK_,gKM_,gKA_,gKD_,gH_,
     gCaH_,gKCa_,gAHP_,gCaT_,gBst_,gNaP_        :double;
begin
  gNa_ :=NP.gNa *chNa. Conductance(NV.mm,  NV.hh,    0);
  gK_  :=NP.gK  *chK.  Conductance(NV.nn,  NV.yK,    0);
  gKA_ :=NP.gKA *chKA. Conductance(NV.nA,  NV.lA,    0);
  gKM_ :=NP.gKM *chKM. Conductance(NV.nM,  0,        0);
  gKD_ :=NP.gKD *chKD. Conductance(NV.xD,  NV.yD,    0);
  gH_  :=NP.gH  *chH.  Conductance(NV.yH,  0,        0);
  gNaR_:=NP.gNaR*chNaR.Conductance(NV.mmR, NV.hhR,   0);
  gAHP_:=NP.gAHP*chAHP.Conductance(NV.wAHP,0,        0);
  gCaH_:=NP.gCaH*chCaH.Conductance(NV.mCaH,NV.hCaH, NV.kCaH);
  gCaT_:=NP.gCaT*chCaT.Conductance(NV.mCaT,NV.hCaT,  0);
  gKCa_:=NP.gKCa*chKCa.Conductance(NV.nKCa,0,     0);
  gNaP_:=NP.gNaP*chNaP.Conductance(NV.mNaP,0,     0);
  gBst_:=NP.gBst*chBst.Conductance(NV.mBst,0,     0);
  NV.Conductance:= gNaR_ +gNa_ {+ss[ie]} +gK_ +gKM_ +gKA_ +gKD_
                    +gCaH_ +gKCa_ + gAHP_ + gCaT_ + gBst_ +gNaP_;  {mS/cm^2}
end;


{********************************************************************}
procedure TCondBasedNrn.InitialCanalConductances ;
var
     v2,a,b,ICaH,m2     :double;
     s                  :string;
begin
  chNa. Init;
  chK.  Init;
  chKA. Init;
  chKM. Init;
  chKD. Init;
  chH.  Init;
  chNaR.Init;
  chAHP.Init;
  chCaH.Init;
  chCaT.Init;
  chKCa.Init;
  chNaP.Init;
  chBst.Init;
end;

procedure TCondBasedNrn.InitialCanalExtraConductances ;
var
     v2,a,b,ICaH,tau_w :double;
begin
      NV.Ca:=NP.Ca8;
      { Other conductances ---------------- }
      chCaH.Init;
      ICaH:=chCaH.Current;
      { Ca-concentration }
      NV.Ca:=NP.Ca8 - NP.tauCa*ICaH/2/NP.Faraday/NP.d_Ca*1e6; {mM=mmol/m^3}
end;

procedure TCondBasedNrn.Calc_RHP_and_Cond_if_given_V(var RHP,g :double);
var  INaR,INa,IK,IKM,IKA,IKD,ICaH,IKCa,IAHP,ICaT,IBst,INaP,IH :double;
begin
      INa :=chNa. Current;
      IK  :=chK.  Current;
      IKA :=chKA. Current;
      IKM :=chKM. Current;
      IKD :=chKD. Current;
      IH  :=chH.  Current;
      INaR:=chNaR.Current;
      IAHP:=chAHP.Current;
      ICaH:=chCaH.Current;
      ICaT:=chCaT.Current;
      Ca_concentration(ICaT+ICaH);
      IKCa:=chKCa.Current;
      INaP:=chNaP.Current;
      IBst:=chBst.Current;
      RHP:= -INaR -INa -IK -IKM -IKA -IKD -ICaH -IKCa -IH
            -IAHP -ICaT -IBst -INaP;
      CalculateActiveConductance;
      g:=NV.Conductance;
end;

procedure TCondBasedNrn.CorrectPassiveParameters;
{ see p.148 }
var  RHP,g      :double;
     i          :integer;
begin
  Calc_RHP_and_Cond_if_given_V(RHP,g);
  {-------------------------------}
  if NP.IfSet_gL_or_tau  =2 then begin
     NP.gL   :=NP.C_membr/NP.tau_m - g;
  end else begin
     NP.tau_m:=NP.C_membr/(g+NP.gL)
  end;
  {-------------------------------}
  if NP.IfSet_VL_or_Vrest=2 then begin
     NP.VL:=NP.Vrest - RHP/NP.gL
  end else begin
     i:=0;
     repeat i:=i+1;
       NV.V:=NP.Vrest;
       InitialCanalExtraConductances;
       InitialCanalConductances;
       Calc_RHP_and_Cond_if_given_V(RHP,g);
       NP.Vrest:=NP.Vrest + dt/NP.C_membr*(RHP-NP.gL*(NP.Vrest-NP.VL));
       if NP.IfSet_gL_or_tau  =2 then  NP.gL   :=NP.C_membr/NP.tau_m - g
                                 else  NP.tau_m:=NP.C_membr/(g+NP.gL);
     until ((abs(NV.V-NP.Vrest)<0.0000001)and(i>1000)) or (i=10000);
     NV.V:=NP.Vrest;
  end;
end;

procedure TCondBasedNrn.InitialConditionsHodgkin;
begin
  NP.FRT:=NP.Faraday/NP.Rgas/NP.Temperature/1000;
  { Blockage of Na-channels & K-cannels}
 {
  if NP.IfThrModel=1 then  begin
                            NP.IfBlockNa:=1;
                            NP.IfBlockK:=1;
                           end

                     else begin
                            NP.IfBlockNa:=0;
                            NP.IfBlockK:=0;
                          end;
}
  { Voltage-gated canals and passive parameters ---------------}
  InitialCanalExtraConductances;
  InitialCanalConductances;
  CorrectPassiveParameters;   {! depend on ss}
end;

procedure TCondBasedNrn.InitialConditions;
begin
  NV.V:=NP.Vrest;  NV.VatE:=NP.Vrest; NV.DVlinDt:=0;
  NV.IsynE:=0; NV.Ca:=NP.Ca8;
  NV.indic:=0;
  NV.tAP:=-888; NV.Thr:=100;
  InitialConditionsHodgkin;
//  Read_Threshold_from_File;
end;

{-----------------------------------------------------------------------}

procedure TCondBasedNrn.IntegrateMembranePotential(uu,ss,tt,Iind,Vhold :double);
var
     indic_                       :integer;
     Ipass,Isyn,DVlinDt_old,
     IatE,DIsynE,V_E,V_0,gs,gdE,
     INaR,INa,IK,IKM,IKA,IKD,IH,ICaH,IKCa,IAHP,ICaT,IBst,INaP     :double;
BEGIN
  NV.Vold:=NV.V;
  DVlinDt_old:=NV.DVlinDt;
  { ---------------- Currents ----------------------------------- }
      INa:=0;  IK:=0;  IKM:=0;  IKA:=0;  IKD:=0;  IH:=0;
      ICaH:=0;  IKCa:=0; IAHP:=0; ICaT:=0; IBst:=0; INaP:=0;
         INaR:=chNaR.Current;
         INa :=chNa.Current;
         IK  :=chK.Current;
         IKM :=chKM.Current;
         IKA :=chKA.Current;
         IKD :=chKD.Current;
         ICaH:=chCaH.Current;
         ICaT:=chCaT.Current;
         Ca_concentration(ICaT+ICaH);
         IKCa:=chKCa.Current;
         IH  :=chH.Current;
         IAHP:=chAHP.Current;
         IBst:=chBst.Current;
         INaP:=chNaP.Current;
      Ipass:=NP.gL*(NV.V-NP.VL)*(1-NP.IfBlockPass);
      NV.Im:= -INaR -INa -IK -IKM -IKA -IKD -IH
              -ICaH -IKCa -IAHP -ICaT -IBst -INaP -Ipass +Iind;
      Isyn:= -ss*(NV.V-NP.VK) + uu - tt*sqr(NV.V-NP.Vrest);
  { ---------------- Ohm's law ---------------------------------- }
  if          NP.HH_order='1-point'  then begin
      NV.DVlinDt:=1/NP.C_membr*(NV.Im+Isyn);
      NV.V:=NV.V + dt*NV.DVlinDt;
  end else if NP.HH_order='2-points' then begin
      NV.IsynE_old:=NV.IsynE;
      NV.IsynE:=Isyn;  NV.IsynI:=0;
      DIsynE:=(NV.IsynE-NV.IsynE_old)/dt;
      IatE:=1/2*NP.tau_m*DIsynE + 3/2*NV.IsynE;
      V_0:=NV.V;  V_E:=NV.VatE;
      gs:=NP.C_membr/NP.tau_m;
      gdE:=gs*NP.ro;//3.7{nS}/1.3{nS};
      {----------}
      NV.VatE:=V_E + dt/NP.tau_m*(-(V_E  -NP.Vrest)
                   - (2+gdE/gs)*(V_E -V_0)
                   + 2/gdE*IatE -NV.IsynI/gs);
      {----------}
      NV.V   :=NV.V   + dt/NP.tau_m*(
                   +    gdE/gs *(V_E -V_0)
                   +  NV.Im/gs+NV.IsynI/gs);

  end;
   dt:= 0.0001;
  NV.DVlinDt:=(NV.V-NV.Vold)/dt;

  NV.ddV:=(NV.DVlinDt-DVlinDt_old)/dt;
  If (NP.If_I_V_or_g=1)or(NP.If_I_V_or_g=3) then  NV.V:=Vhold;
  NV.PSC:=(Isyn + NV.Im) *NP.Square*1e9; {pA}
  CalculateActiveConductance;
END;

procedure TCondBasedNrn.MembranePotential(uu,ss,tt,Iind,Vhold :double);
BEGIN
  IntegrateMembranePotential(uu,ss,tt,Iind,Vhold);
END;

end.
