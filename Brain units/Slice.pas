unit Slice;

interface
uses Init,PopulationO;

procedure CommonParameters;
procedure DefaultParameters;
procedure InitiateCalculation_1D;
procedure PhysParameters;
procedure OtherParameters;
procedure ParametersFromFile;
procedure ParametersFromFile2;
procedure ParametersFromFile3;
procedure ParametersFromFile4;
procedure ParametersFromFile5;
procedure ParametersFromFile6;
procedure ParametersFromFile7;
procedure ParametersFromFile8;
procedure ParametersFromFile9;
procedure ParametersFromFile10;
procedure ParametersFromFile11;
procedure ParametersFromFile12;
procedure ParametersFromFile13;
procedure ParametersFromFile14;
procedure ParametersFromFile15;
procedure ParametersFromFile16;
procedure ParametersFromFile17;
procedure ParametersFromFile18;
procedure ParametersFromFile19;
procedure CalcParameters;
function Calc_Functional(dimF :integer; var VFunc :vect) :double;

implementation
uses  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls,
  mathMy,Hodgkin,other,graph_0d,Wright,run,ph_Dens,
  Unit1,Unit2,Unit4,Unit13, Correspond,Statistics;

{***********Theta***************************************}
{I Theta_Miles.id }
{***********Noise***************************************}
{I Noise1.id }
{I Noise2.id }
{I Noise3.id }
{***********CA3*****************************************}
{I CA3_E_AMPA.id }          {1'}
{I CA3_E_GABA.id }          {2'}
{I CA3_oscill.id }
{I 40Hz_CA3_1.id }       {17.03.2005}
{I 20Hz_CA3_Lyle.id }    {19.10.2005}
{*******************************************************}
{I E_EPSC&P.id } {- incompartible PSC and PSP }
{I 40Hz.id }
{I resonance_Pike.id }
{I Lacaille.id }
{I burst.id }
{I 2D_PSP.id }
{I Wang.id }
{I Miles_Marder.id }
{I GaussCond.id }
{I MilesNoise.id }
{I Pouille.id }
{I Pouille_PSÑ_PSP.id }
{I PSP_1A_Karnup.id }          {14}
{I Mlinar.id }          {13}
{I I_v(t)_Ali.id }      {12}
{I I_Japon_Net.id }        {1.12.2005}
{I I_v(t)_Japon.id }       {2.09.2005, 06.02.2006}
{$I E_v(t)_Lyle.id }      {14.03.2005, 27.04.2005, 22.08.2005, 01.02.2006, 24.12.2006, 27.02.2007, 10.09.2007}
{I E_v(t)_Lyle_2D.id }  {18.01.2007, 6.03.2007}
{I V1.id }           {11.03.2007, 31.03.2007, 31.05.2007, 30.06.2007}
{I EXAMPLE.ID }     {8.07.2007, 18.08.2007, 30.09.2007}
{I decayTime.id }    {27.03.2007}
{I BarrelCtx.id }    {13.04.2007, 18.05.2007, 06.06.2007}
{I Noise_Mainen.id } {11.10.2006}
{I E_v(t)_Ali.id }      {11}
{I I_v(t).id }          {10}
{I I_IPSC.id }          {9}
{I E_IPSC.id }          {8}
{I E_fastIPSC.id }
{I E_pass.id }          {1}
{I I_AMPA+NMDA.id }     {7}
{I I_NMDA.id }          {6}
{I I_AMPA.id }          {5}
{I E_AMPA+NMDA.id }     {4}
{I E_NMDA.id }          {3}
{I E_AMPA.id }          {2}
{I variat.id }
{I 2D.id }
{I standart.id }
{I rest.id}
{I pass_47.id}
{I pass_woo.id}
{I DV_3A.id}
{I PSC&P_2.id}       {!}
{I IPSC_2D.id}
{I IPSP_2D.id}
{I IPSP_2B.id}
{I EPSP600w.id}
{I EPSP_Woo.id}
{I NMDA_all.id}
{I EPSC_4C.id}
{I EPSC_2C.id}
{I EPSP_4A.id}
{I EPSP_2B.id}
{I EPSP_1B.id}
{I AP_5Bin.id}
{I IPSPi_5B.id}
{I EPSPi_12.id}
{I AHPi_6B.id}
{I Ali_P_10.id}
{I Ali_P_04.id}
{I Ali_Pi02.id}

procedure DefaultParameters;
{ Executed at initiation of Form. }
begin
  Nts:=imin(200,MaxPh);   ts_end:=0.100;
  WriteOrNot:=0;   YesToClean:=1;
  HH_type[1]:='Lyle';           HH_order[1]:='2-points';
  HH_type[2]:='Chow';           HH_order[2]:='1-point';
  IfSecondOrder:=1;   { 0-for Godunov, 1-for TVD }
  IfPhase:=1;
  IfInSyn_al_EQ_beta:=1;
  IfAMPAGABAinp_NE_local:=0;
  IfSigmoidForPresynRate:=0;
  Smpl:=1;
  MainDir:='';
  SmplFile[Smpl]:='';
  IfDataStartsFromZero:=1;
  KeepParams:=0;
{  CommonParameters;}
  InitiateCalculation_1D;
  CorrespondParametersToTheForm;
end;

procedure InitiateCalculation_1D;
begin
  iHist:=0;
  if KeepParams=0 then  PhysParameters;
  CalcParameters;
  {*****************}
  CommonParameters;
  ParametersFromFile;
  {*****************}
  OtherParameters;
  //ReadFrequencyFunction;
  InitHistory;
end;

procedure PhysParameters;
begin
    { Unstable AP generation - bursting }
    sgm_V[1]:=0.002{V};    sgm_V[2]:=0.002{V};
    VThr0[1]:=0.011{V};    VThr0[2]:=0.015{V};
    ThrCorrection[1]:=0;   ThrCorrection[2]:=0;
    { Axon }
    gam[1]:=1.39{m/s}/1.5{mm}*1000;    gam[2]:=1{m/s}/0.5{mm}*1000;
    { External signals }
    pext_Iext:=4 {Hz/muA};
    factorE:=1;  factorI:=1;
    Qns:=0;
    I_ind:=0;   nu_ind:=0 {Hz};
    t0s:=0.00042+0.0005{s};  tSt:=0.001{80e-6}{s};  dtSt:=0;  nStimuli:=1;
    Iext:=120{mkA};
    t_Exp:=0.0;
    { Intracellular recordings }
    IfBlockAMPA:=0; IfBlockGABA:=0; IfBlockGABB:=0; IfBlockNMDA:=0; IfBlockK:=0;
    { Neuron parameters }
    HodgkinPhysParameters;
end;

procedure OtherParameters;
var  ie :integer;
begin
  case If_I_V_or_p of
  1: VI_sc:=I_sc;
  2: VI_sc:=V_sc;
  3: VI_sc:=p_sc;
  4: Vi_sc:=V_sc;
  5: Vi_sc:=V_sc;
  end;
  nt_end:=imin(trunc(t_end/dt), mMaxExp);
  if IfAMPAGABAinp_NE_local=0 then begin
     for ie:=1 to 2 do begin
         alAMP3[ie]:=alAMPA[ie];  beAMP3[ie]:=beAMPA[ie];
         alGAB3[ie]:=alGABA[ie];  beGAB3[ie]:=beGABA[ie];
     end;
  end;
  if not(Form4.CheckBox11.Checked) then gSyn_From_i3;
  Randomize;
end;

procedure CalcParameters;
begin
  IfReadHistory:=0;
  IfChangeVrest:=1; { Current or Voltage (1/0) }
  If_I_V_or_p:=2;
  IfUndimensionate:=0;    DrawOrNot:=1;   IfSimplex:=1;
  { Samples - experimental curves }
  NSmpls:=4;
  scx_Smpl:=0.001 {s};  scy_Smpl:=0.001{V} {-1}{pA};  shift_Smp:=0 {ms};
  sc_Simplex:=1;
  { Initiating of graphics }
  n_show:=10;  n_DrawPhase:=20;  n_Write:=3;
  p_sc:=1 {Hz};  V_sc:=1000 {for mV in Axis};  I_sc:=1 {for pA in Axis};
  t_end:=0.00182;
  dt:=0.000008;
  t_Exp:=0.0 {s};  { time when V=Vexp }
  t_ind:=0 {s};     { time when I_ind is on }
end;

function StatisticsForWhom :double;
begin
  case Form13.RadioGroup1.ItemIndex of
  0: if Form4.CheckBox8.Checked then
        StatisticsForWhom:=Iadd[1]*Square[1]*1e9
     else
        StatisticsForWhom:=pext;
  1: StatisticsForWhom:=Q[1];
  end;
end;

{-----------------------------------------------------------------------}

function Calc_Functional(dimF :integer; var VFunc :vect) :double;
{
  Simulation by Wright's model, comparison with sample 'Vexp',
  calculation of residual in 'dimF'-th different intervals.
}
var
      Func                          : double;
      i,iFunc,ntP,nl                : integer;
begin
      if KeepParams=0 then  CommonParameters;
      case Smpl of
      0: ;
      1: ParametersFromFile;
      2: ParametersFromFile2;
      3: ParametersFromFile3;
      4: ParametersFromFile4;
      5: ParametersFromFile5;
      6: ParametersFromFile6;
      7: ParametersFromFile7;
      8: ParametersFromFile8;
      9: ParametersFromFile9;
      10: ParametersFromFile10;
      11: ParametersFromFile11;
      12: ParametersFromFile12;
      13: ParametersFromFile13;
      14: ParametersFromFile14;
      15: ParametersFromFile15;
      16: ParametersFromFile16;
      17: ParametersFromFile17;
      18: ParametersFromFile18;
      19: ParametersFromFile19;
      else
         ParametersFromFile;
      end;
      OtherParameters;
      CorrespondParametersToTheForm;
      ReadExpData;
      { RestPotentials & SetStateSolution }
      InitialConditions;
      InitialConditionsHodgkin;
      Initiate_NP_ForPopulation_O(HH_type[1],HH_order[1],ThrCorrection[1],NPE);
      Initiate_NP_ForPopulation_O(HH_type[2],HH_order[2],ThrCorrection[2],NPI);
      CreatePopulationBy_NP_O(Nts,dt,ts_end,sgm_V[1],NPE,APopE);
      CreatePopulationBy_NP_O(Nts,dt,ts_end,sgm_V[2],NPI,APopI);
      APopE.InitialConditions;
      APopI.InitialConditions;
      if DrawOrNot =1 then  Initial_Picture;
      if WriteOrNot=1 then  InitiateWriting;
      { Interval [0,nt_end] will be devided on 'dimF' pieces }
      ntP:=Trunc(nt_end/dimF);
      for i:=1 to dimF do  VFunc[i]:=0;
      Func:=0;
      REPEAT
        { ----- Step ----- }
        t:=t+dt;   nt:=nt+1;
        WrightSystem;
        if (t>0.0)and(t<t_Exp) then  V[1]:=Vrest[1]+Vexp[nt,Smpl];
        { Measurement }
        case If_I_V_or_p of
        1: Vr:=PSC[3];
        2: Vr:=V[3];//-Vrest[3];
        3: Vr:=Q[3];
        4: Vr:=VatE[3]-Vrest[3];
        5: Vr:=VatE[3]-Vrest[3];
        end;
        Renamination;
        { Residuals }
        iFunc:=trunc((nt-1)/ntP)+1;  { number of current component }
        nl:=nt-(iFunc-1)*ntP;    { local step of current piece }
        VFunc[iFunc]:=sqrt(sqr(VFunc[iFunc])*(nl-1)/nl+sqr(Vexp[nt,Smpl]-Vr)/nl);
        Func        :=sqrt(sqr( Func       )*(nt-1)/nt+sqr(Vexp[nt,Smpl]-Vr)/nt);
        {**************************************}
        Vmod[nt]:=Vr;
        {**************************************}
        { Drawing }
        if (DrawOrNot=1) and (trunc(nFunk/10)=nFunk/10)
            and ((trunc(nt/n_show)=nt/n_show)or(nt=1)) then begin
            Evolution;
            ApopE.Draw;
        end;
        if (trunc(nt/n_DrawPhase)=nt/n_DrawPhase)and(trunc(nFunk/10)=nFunk/10)
            and(Form2.Visible)                         then DrawPhaseSpace;
        if (WriteOrNot=1) and (trunc(nt/n_Write)=nt/n_Write) then Writing;
        if Form1.CheckBox1.Checked then ViewSpikes;
        if Form1.CheckBox3.Checked then AnalyseStatistics(StatisticsForWhom);//{Q[1]}pext{Iadd[1]*Square[1]*1e9});
        { Treat Key }
        if Form1.Thread1.Checked then begin
           MyThread1.MySynchronize;
           MyThread1.Treat_Key;
        end;
        Application.ProcessMessages;
        Pause;
      UNTIL nt>=nt_end;
//      if WriteOrNot=1 then  close(ccc);
      Calc_Functional:=Func;
      APopE.Free;
      APopI.Free;
end;

{---------- E N D -------------------------------------------------------------}
end.
