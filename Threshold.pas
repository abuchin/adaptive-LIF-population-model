unit Threshold;

interface
procedure IfSpikeOccurs(V_:double; var Vprev_,tAP_:double; var indic_:integer);
procedure FrequencyAmplitude(var Vprev :double; var indicat :integer);
procedure FindThreshold;
procedure PlotForControlParameters;
procedure Plot_nu_Iind;
procedure Plot_Adaptaion;

var
    dIind,Iind_max,
    Th,DVDt_Th,Th1,DVDt_Th1,Th_Curv,DVDt_Curv,tAP_Curv    :double;

implementation
uses Forms,Math,
     MyTypes,Init,t_dtO,MathMy,Graph,Clamp,ReducedEq,Hodgkin,
     Unit1,Unit3,Unit5,Unit6,Unit9,Unit7,
     Thread_u_s,Other,FiringClamp,function_Z,Noise,FC_control,
     NeuronO,CreateNrnO;

var
        n_av,n_Iav                              :integer;
        Vpeak                                   :double;


function TimeFromThePeak(V0,V1,V2 :double) :double;
{ V0,V1,V2 are values corresponding to moments 0,-dt,-2*dt }
var  b,tp :double;
begin
  TimeFromThePeak:=0;
  if (V1>V0)and(V1>V2) then begin
      tp:=-dt/2*((V2-V0)-(V1-V0)*4)/((V2-V0)-(V1-V0)*2);
      b:= ((V2-V0)-(V1-V0)*4)/2/dt;
      Vpeak:=V0+b/2*tp;
      TimeFromThePeak:=tp;
  end;
end;

procedure IfSpikeOccurs(V_:double; var Vprev_,tAP_:double; var indic_:integer);
{Defines if a spike occurs for V_.
 'indic_' = 0 - after spike
            1 - on ascending way
            2 - at spike
 'Vprev_' - potential at previous time step}
var t_peak :double;
begin
  IF (NP.IfThrModel=1)or(NP.IfLIF=1) THEN BEGIN
     IfSpikeOccursInThrModel(V_,NP.Vrest+NV.Thr,NV.ddV,tAP_,indic_);
     exit;
  END;
  if (indic_=2)or(t<tAP_+0.001) then indic_:=0;  { after spike }
  if V_>Form9.DDSpinEdit12.Value/1e3{-30mV} then begin
     { Find local maximum }
     if V_>Vprev_ then begin
        indic_:=1;            { on ascending way }
     end else begin
         if indic_=1 then begin
            indic_:=2;        { at spike }
            t_peak:=t+TimeFromThePeak(V_,Vprev_,Vpprev);
            ISI[0]:=min(t_peak-tAP_,t_peak);
            tAP_:=t_peak;
         end;
     end;
  end;
  Vpprev:=Vprev_;
  Vprev_:=V_;
end;

procedure FrequencyAmplitude(var Vprev :double; var indicat :integer);
var is0,topV,Vprev_mem,dVdt,ooo :double;
begin
  if indicat=3 then indicat:=0;   { End of spike }
  freq:=freq*(nt-1)/nt;
  Vprev_mem:=Vprev;
  IfSpikeOccurs(NV.V,Vprev,NV.tAP,indicat);
  { if spike }
  if indicat=2 then begin
     freq:=(freq*t+1)/t;
     avVmax:=(avVmax*freq*t+Vprev)/(freq*t+1);
     Vmax:=Vpeak;//Vprev_mem;
     n_av:=0;  n_Iav:=0;
     if Vav<>0    then  Vav_prev   :=Vav;    Vav:=0;
     if Vweigh<>0 then  Vweigh_prev:=Vweigh; Vweigh:=NP.Vrest;
     if avPSC<>0  then  avPSC_prev :=avPSC;  avPSC:=0;
     if Vmin<>1e6 then  avVmin:=(avVmin*freq*t+Vmin)/(freq*t+1);
     Vmin_prev:=Vmin; Vmin:=1e6;
     Th:=ThrNeuron.V-NP.Vrest;
     IIspike:=IIspike+1;
   end;
  { Measurement Between Spikes }
  if (indicat<>2)and(t-NV.tAP>0) then begin
      { Average potential }
      dVdt:=(NV.V-Vprev_mem)/dt; {mV/ms}
      ooo:=Form9.DDSpinEdit5.Value/1e3;   {-15mV }
      if (NV.V<ooo)and(t-NV.tAP>0.002)and(abs(dVdt)<5) then begin
         n_av:=n_av+1;
         Vav  :=(  Vav*(n_av-1)+NV.V )/n_av;
      end;
      Vweigh:=Vweigh + dt/NP.tau_m*(NV.V-Vweigh);
      { Slope }
      ooo:=Form9.DDSpinEdit10.Value/1e3;  {-40mV}
      if (NV.V>ooo-0.001)and(NV.V<ooo)and(NV.PSC>0) then begin
         n_Iav:=n_Iav+1;
         is0:=NV.PSC/NP.Square/1e9/(NV.V-NP.Vrest)-NP.gL;
         avPSC:=(avPSC*(n_Iav-1)+is0)/n_Iav;
      end;
      { Minimum }
      Vmin:=min(Vmin,NV.V);
  end;
  { Width of AP }
  ooo:=Form9.DDSpinEdit11.Value/1e3;   {-20mV}
  if (indicat=1)and(NV.V>ooo)and(Vprev_mem<ooo) then begin
      tAP1:=t-dt;
      tAP1:=tAP1+(ooo-Vprev_mem)/(NV.V-Vprev_mem)*dt;
  end;
  if (indicat=0)and(NV.V<ooo)and(Vprev_mem>ooo) then begin
      tAP2:=t-dt;
      tAP2:=tAP2+(ooo-Vprev_mem)/(NV.V-Vprev_mem)*dt;
      WidthAP:=tAP2-tAP1;
      indicat:=3;    { End of spike }
  end;
end;

{-----------------------------------------------------------------------}
procedure FindThreshold;
{ ********************************************************************
  Calculates Threshold 'VTh' and time of AP 'tAP'
  for different induced current 'Iind'.
  So, we will find the dependence 'VTh=VTh(tAP)'.
  VTh is for nonspiking model (Destexhe with INa=0)
  at the spike moments for complete model.
**********************************************************************}
var ni,nIind,indicat                            :integer;
    hhh                                         :text;
    Vprev,Iind_mem,u_mem,s_mem,sgm_V            :double;
    ANrnF,ANrnT                                 :TNeuron;
BEGIN
  assign(ddd,'VTh(tAP).dat'); rewrite(ddd);
  if WriteOrNot=1 then begin  assign(hhh,'V_Vlin(t).dat'); rewrite(hhh); end;
  { Parameters }
  Smpl:=0;
  Iind_mem:=Iind; Iind:=0;  u_mem:=uu; uu:=0;  s_mem:=ss;
  ss:=Form3.DDSpinEdit5.Value;
  Form1.FitPictureToExpData1.Checked:=false;
  dt:=0.000015;
  t_end:=0.40{s}; t_Iind:=2.000{s};
  Freq_Iind:=Form3.DDSpinEdit2.Value;
  sgm_V :=   Form3.DDSpinEdit3.Value/1000;
  nt_end:=imin(trunc(t_end/dt), MaxNT);
  { Initiate 2 neurons: full and threshold ones }
  InitialConditions;
  CreateNeuronByTypeO(NP,ANrnF);
  //NP.IfReduced:=0;
  NP.IfThrModel:=1;
  NP.ThrShift:=0.100{V};
  CreateNeuronByTypeO(NP,ANrnT);
  NP.IfThrModel:=0;
  { Loop for induced current }
  nIind:=Trunc(Form3.DDSpinEdit1.Value/Form3.DDSpinEdit4.Value);
  FOR ni:=1 to nIind DO BEGIN
    Iind:=Form3.DDSpinEdit4.Value*ni {pA};
    //InitialConditions;
    ANrnF.InitialConditions;
    ANrnT.InitialConditions;
    InitialPicture;
    Clear_Th_V;
    IIspike:=0;
    indicat:=0;
    Th:=0;  DVDt_Th:=0;  Th_Curv:=0;
    repeat
      nt:=0;
      REPEAT  nt:=nt+1;  t:=nt*dt; { time step }
        { Noise }
        uu:=sgm_V*(NP.C_membr/NP.tau_m)*sqrt(2*NP.tau_m/dt)*randG(0,1);
        //if NP.IfReduced=1 then ReducedEquations
        //                  else MembranePotential;
        ANrnF.MembranePotential(uu,ss,0,0,0,Current_Iind+du_Reset,Vhold(t));
        if Form3.CheckBox1.Checked then uu:=0; {if NoNoiseInT-neuron}
        ANrnT.MembranePotential(uu,ss,0,0,0,Current_Iind+du_Reset,Vhold(t));
        //NoSpikePotential(t-NV.tAP,ThrNeuron,NV.DVlinDt,NV.ddV);
        NV:=ANrnF.NV;
        FrequencyAmplitude(Vprev,indicat);
        { Threshold before spike }
        if (ANrnF.NV.DVlinDt>Form3.DDSpinEdit6.Value)and(Th_Curv=0) then begin
           Th_Curv  :=ANrnF.NV.V - ANrnT.NP.Vrest;
           DVDt_Curv:=ANrnT.NV.DVlinDt;
           tAP_Curv :=t;
        end;
        { Drawing }
//        if (nt=1)or(trunc(nt/n_Draw)=nt/n_Draw)  then Evolution;
        if (nt=1)or(trunc(nt/10)=nt/10) then begin
           Form3.Series3.AddXY(t*1000,ANrnF.NV.V*1000);
           Form3.Series4.AddXY(t*1000,ANrnT.NV.V*1000);
        end;
        if (WriteOrNot=1) and (trunc(nt/2)=nt/2) then
            writeln(hhh,t*1000:8:3,' ',ANrnF.NV.V*1000:11,' ',ANrnT.NV.V*1000:12);
      UNTIL (nt=nt_end) or (indicat=2);
      Form3.Series2. AddXY(t*1000,ANrnT.NV.V*1000);
      Form3.Series10.AddXY(tAP_Curv*1000,(Th_Curv+ANrnT.NP.Vrest)*1000);
      if (IIspike=2)and(indicat=2) then begin
         Th :=ANrnT.NV.V - ANrnT.NP.Vrest;
         DVDt_Th :=ANrnT.NV.DVlinDt;
      end;
      if (IIspike=1)and(indicat=2) then begin
         ANrnT.NV.tAP:=0;
         Th1:=ANrnT.NV.V - ANrnT.NP.Vrest;
         DVDt_Th1:=ANrnT.NV.DVlinDt;
      end;
    until (nt=nt_end) or (IIspike=2);
    if (ANrnF.NV.V<-0.050{V}) or (nt=nt_end) then ANrnT.NV.V:=0;
    { Results }
    if NV.tAP>0 then  Plot_Th_tAP;
    write  (ddd,Th*1000:9:3,' ',ANrnF.NV.tAP*1000:9:5,' ',Iind:9:5);
    writeln(ddd,' ',DVDt_Th:9:5,' ',Th1*1000:9:5,' ',DVDt_Th1:9:5);
    Application.ProcessMessages;
  END;
  close(ddd);
  if WriteOrNot=1 then close(hhh);
  uu:=u_mem;  ss:=s_mem;  Iind:=Iind_mem;
END;

procedure PlotForControlParameters;
{ ********************************************************************
  Calculates plot for frequency etc. depending on control parameters.
**********************************************************************}
var ns,nu,indicat,nt_end_rem                    :integer;
    dum,{Vprev,} gE1,gI1,
    t_end_rem,Iind_mem,u_mem,s_mem              :double;
    IfNoise                                     :boolean;
BEGIN
  IfNoise:=(Form9.RadioGroup1.ItemIndex<>0);
  Iind_mem:=Iind; Iind:=0;  u_mem:=uu; uu:=0;  s_mem:=ss; ss:=0;
  tt:=Form9.DDSpinEdit15.Value; { Third control parameter }
  t_end_rem:=t_end;   nt_end_rem:=nt_end;
  t_end:=Form9.DDSpinEdit4.Value/1000;
  nt_end:=imin(trunc(t_end/dt), MaxNT);
  WriteOrNot:=0;  Form1.Writing1.Checked:=false;
  assign(ddd,'v(u_s).dat'); rewrite(ddd);
  writeln(ddd,'ZONE T="ZONE1"');
  writeln(ddd,'I=', nue+1:3,' ,J=',nse+1:3,' ,K=1,F=POINT');
  FOR ns:=0 to nse DO BEGIN
  FOR nu:=0 to nue DO BEGIN
    uu:=((u_max-u_min)/nue*nu + u_min)/1000;
    ss:= (s_max-s_min)/nse*ns + s_min;
    InitialConditions;
    CorrespondParametersToTheForm;
//    InitialPicture;
    if IfNoise then begin  { Noise }
       Ampl_u:=uu;  Ampl_s:=ss;
       U_S_to_gE_gI(Ampl_u,Ampl_s, 0,0, Ampl_gE,Ampl_gI);
       mean_gE:=Ampl_gE; mean_gI:=Ampl_gI;
       gE     :=Ampl_gE;      gI:=Ampl_gI;
    end;
    IIspike:=0;  V_Conv:=0;  VxZ:=0;  IxZ:=0;
    nt:=0;
    REPEAT  nt:=nt+1;  t:=nt*dt; { time step }
//      PrintTime;
      case Form9.RadioGroup1.ItemIndex of     { Noise }
      1: SynCurrentOnNewStep(Ampl_u,Ampl_u, uu);
      2: begin SynConductancesOnNewStep; gE_gI_to_U_S(gE,gI, 0,0, uu,ss); end;
      end;
      {****************}
      MembranePotential;
      NoSpikePotential(t-NV.tAP,ThrNeuron,NV.DVlinDt,NV.ddV);
      {****************}
      FrequencyAmplitude(Vprev,indicat);
      ResetVoltageOnDescendingWayOfSpike(indicat, NV.V);
      if (indicat=2)and not(IfNoise) then freq:=LimRev(ISI[0],1e-6);
      { Convolution }
      RememberInCircularArray(NV.V,Isyn,0);
      if indicat=2 then CalculateConvolutions;
      { Drawing }
//      if (nt=1)or(trunc(nt/n_Draw)=nt/n_Draw)  then Evolution;
      if (NV.V>0.100)or(NV.V<-0.150)or((IIspike=0)and(t>0.1)) then begin
          nt:=nt_end; freq:=0;
      end;
    UNTIL (nt>=imin(trunc(Form9.DDSpinEdit4.Value/1000/dt), MaxNT))or
          ((IIspike=Form9.DDSpinEdit6.Value)and(indicat=3));
    if IfNoise then begin  uu:=Ampl_u;  ss:=Ampl_s;  end;
    if freq>10 then NV.V:=0;
    Plot_for_u_s_In_Thread.Synchronize;
    if freq< 5 then begin  Vav_prev:=0; avPSC_prev:=0; VxZ:=0; IxZ:=0;
                           Vmin_prev:=0; Vmax:=0; Vweigh_prev:=0; V_Conv:=0;
                           VT_1ms:=0; end;
    Draw_nu_u_s(freq,Vav_prev,avPSC_prev, nu,ns, nue,nse);
    U_S_to_gE_gI(uu,ss, 0,0, gE1,gI1);
    {           1                  2                                 }
    write  (ddd,uu*1000:7:3,' ',ss:9:5,' ');
    {           3                           4                        }
    write  (ddd,LimRev(ISI[0],1e-6):9:5,' ',Vmax*1000:7:3,' ');
    {           5                        6                     7     }
    write  (ddd,Vweigh_prev*1000:7:3,' ',Vav_prev*1000:7:3,' ',avPSC_prev:9:5,' ');
    {           8           9           10                           }
    write  (ddd,gE1:9:5,' ',gI1:9:5,' ',Vmin_prev*1000:7:3,' ');
    {           11                  12               13              }
    write  (ddd,V_Conv*1000:7:3,' ',VxZ*1000:7:3,' ',IxZ:9:5,' ');
    {           14                          15                  16   }
    writeln(ddd,max(0,WidthAP)*1000:9:5,' ',VT_1ms*1000:7:3,' ',Th*1000:7:3);
  END;
  END;
  close(ddd);
  t_end:=t_end_rem;   nt_end:=nt_end_rem;
  uu:=u_mem;  ss:=s_mem;  Iind:=Iind_mem;
END;

procedure Plot_nu_Iind;
{ ********************************************************************
  Calculates plot for frequency etc. depending on Iind.
**********************************************************************}
var ni,nIind,indicat,If_I_V_or_g_o      :integer;
    dum,{Vprev,}Iind_o,t_Iind_o,sgm_V   :double;
BEGIN
  sgm_V :=      Form7.DDSpinEdit13.Value/1000;
  assign(ddd,'v(Iind).dat'); rewrite(ddd);
  { Memorize current values }
  Iind_o:=Iind;
  t_Iind_o:=t_Iind;
  t_Iind:=1e8;
  If_I_V_or_g_o:=NP.If_I_V_or_g;
  NP.If_I_V_or_g:=2;
  {---------------}
  nIind:=Trunc(Iind_max/dIind);
  FOR ni:=0 to nIind DO BEGIN
    Iind:=dIind*ni {pA};
    CorrespondParametersToTheForm;
    InitialConditions;
    CreateNeuronByTypeO(NP,ANrn);
    ANrn.InitialConditions;
    indicat:=0;
    nt:=0;
    REPEAT  nt:=nt+1;  t:=nt*dt; { time step }
      { Noise }
      if IfNoise then
         uu:={uu + }sgm_V*(NP.C_membr/NP.tau_m)*sqrt(2*NP.tau_m/dt)*randG(0,1);
      {****************}
//    MembranePotential;
      ANrn.MembranePotential(uu,ss,0,0,tt,Current_Iind+du_Reset,Vhold(t));
      NV:=ANrn.NV;
      FrequencyAmplitude(Vprev,indicat);
      { Drawing }
//      if (nt=1)or(trunc(nt/n_Draw)=nt/n_Draw)  then Evolution;
      if (NV.V>0.150) or (NV.V<-0.150) then begin nt:=nt_end; freq:=0; end;
    UNTIL nt=nt_end;
//    if freq>10 then V:=0;
    writeln(ddd,Iind:9:3,' ',freq:9:5);
    Form5.sp_XYLine1.AddXY(Iind,freq);
    ANrn.Free;
  END;
  { Remember current values }
  Iind:=Iind_o;
  t_Iind:=t_Iind_o;
  NP.If_I_V_or_g:=If_I_V_or_g_o;
  {---------------}
  close(ddd);
END;

procedure CatchAP_for_Adaptation(var Vprev :double; var indicat :integer);
var  i :integer;
begin
  freq:=freq*(nt-1)/nt;
  IfSpikeOccurs(NV.V,Vprev,NV.tAP,indicat);
  { if spike }
  if indicat=2 then begin
     IIspike:=IIspike+1;
     if IIspike<=10 then begin
        { Calculate ISI[IISpike] }
        ISI[IIspike]:=t;
        if IIspike>1 then
           for i:=1 to IIspike-1 do
               ISI[IIspike]:=ISI[IIspike]-ISI[i];
     end;
  end;
end;

procedure Plot_Adaptaion;
{ ********************************************************************
  Calculates plot for ISI of the first APs versus on Iind.
**********************************************************************}
var i,ni,nIind,indicat,If_I_V_or_g_o            :integer;
    dum,Vprev,Iind_o,t_Iind_o,tAPprev           :double;
BEGIN
  assign(ddd,'adaptation(I).dat'); rewrite(ddd);
  { Memorize current values }
  Iind_o:=Iind;
  t_Iind_o:=t_Iind;
  t_Iind:=1e8;
  If_I_V_or_g_o:=NP.If_I_V_or_g;
  NP.If_I_V_or_g:=2;
  {---------------}
  nIind:=Trunc(Iind_max_AD/dIind_AD);
  FOR ni:=0 to nIind DO BEGIN
    Iind:=dIind_AD*ni {pA};
    CorrespondParametersToTheForm;
    InitialConditions;
    indicat:=0;
    IIspike:=0;
    for i:=1 to 10 do  ISI[i]:=0;
    nt:=0;
    REPEAT  nt:=nt+1;  t:=nt*dt; { time step }
      MembranePotential;
      CatchAP_for_Adaptation(Vprev,indicat);
      if (NV.V>0.150) or (NV.V<-0.150) then nt:=nt_end;
    UNTIL nt=nt_end;
    for i:=1 to 10 do if ISI[i]<=0 then ISI[i]:=1e6;
    write  (ddd,Iind:9:3    ,' ',1/ISI[2]:9:5,' ',1/ISI[3]:9:5,' ');
    writeln(ddd,1/ISI[4]:9:5,' ',1/ISI[5]:9:5,' ',1/ISI[6]:9:5);
    Form6.Series5.AddXY(Iind,1/ISI[6]);
    Form6.Series4.AddXY(Iind,1/ISI[5]);
    Form6.Series3.AddXY(Iind,1/ISI[4]);
    Form6.Series2.AddXY(Iind,1/ISI[3]);
    Form6.Series1.AddXY(Iind,1/ISI[2]);
  END;
  { Remember current values }
  Iind:=Iind_o;
  t_Iind:=t_Iind_o;
  NP.If_I_V_or_g:=If_I_V_or_g_o;
  {---------------}
  close(ddd);
END;

end.
