unit Wright;

interface
function SigmNMDA(V :double) :double;
procedure SynapticCurrents;
procedure ReadFrequencyFunction;
function QfromU_S(u,s :double):double;
function QfromIs0(u,s :double; ie :integer):double;
procedure CheckFreqTable;
function BurstOfAPs(u,DuDt,VTh :double) :double;
procedure IntegrateNoise;
procedure Set_Ps;
procedure WrightSystem;

implementation
uses Math,Init,mathMy,Hodgkin,HH_canal,ph_Dens,ph_Volt,Unit4;

procedure AxonEquationRennie(ie :integer);
{
  Solving of axon equation
  [ 1/gam2 DD + 2/gam D + 1 - r_axon^2 Lapl ] p1 = Qe
  by Rennie-scheme.
}
var
   u,uo,un,wo,wn,w,ex_gam     : double;
begin
   ex_gam:=dexp(gam[ie]*dt);
  { Direct transform: }
  { u=p[1]*exp(gam*0), uo=p[1]*exp(-gam*dt) }
  { w=Qe*exp(gam*0),   wn=Qe*exp(gam*dt),   wo=Qe*exp(-gam*dt) }
  u:=p[ie];
  uo:=po[ie]/ex_gam;
  w:=Q[ie];// {Haken-Jirsa:}+dQdt[ie]/gam[ie];
  wo :=w/ex_gam;                         { ! must be w_old}
  wn :=w*ex_gam;                         { ! must be w_new}
  { ********************************************** }
  { Wave equation }
  {  DD u = gam2*w }
  un:=2*u - uo
     + sqr(dt*gam[ie])/12*(10*w+(wn+wo));     { source }
  { ********************************************** }
  { Inverse transform }
  pn[ie]:=un/ex_gam;
end;

function SigmNMDA(V :double) :double;
begin
  SigmNMDA:=1/(1+Mg/3.57*dexp(-62*V));
end;

{-----------------------------------------------------------------------}

procedure SynapticCurrents;
{
  Calculate the control variables 'uu'(V) and 'ss'(nondimensional).
}
var
     Sum,gtAMPA,gtGABA,gtGABB,gtNMDA,
     amp3,ampa,gaba,gab3,gabb,nmd3,nmda, quant  :double;
     ie,k,l                                     :integer;

  function S(x :double) :double;
  begin    S:=x {2/(1+dexp(-2*x)) - 1};  end;

begin
  { Intensity of transmitter emission  }
  quant:=dt_T;
  amp3:=S(pext *quant);
  gab3:=S(pext *quant);
  ampa:=S(pn[1]*quant);
  gaba:=S(pn[2]*quant);
  gabb:=S(pn[2]*quant);
  nmd3:=S(pext *quant);
  nmda:=S(pn[1]*quant);
  { Blockage }
  if IfBlockAMPA=1 then begin  amp3:=0; ampa:=0;  end;
  if IfBlockGABA=1 then begin  gab3:=0; gaba:=0;  end;
  if IfBlockGABB=1 then begin  gabb:=0;           end;
  if IfBlockNMDA=1 then begin  nmd3:=0; nmda:=0;  end;
  { Exclusions }
  if IfAMPAGABAinp_NE_local=0 then begin
     for ie:=1 to 2 do begin
         alAMP3[ie]:=alAMPA[ie];  beAMP3[ie]:=beAMPA[ie];
         alGAB3[ie]:=alGABA[ie];  beGAB3[ie]:=beGABA[ie];
     end;
  end;
  { Synaptic conductances }
  for l:=1 to 2 do begin
     ie:=l;
{    New_m(alAMP3[l],beAMP3[l],dt,amp3, mAMP3[l],UAMP3[l],WAMP3[l]);
    New_m(alGAB3[l],beGAB3[l],dt,gab3, mGAB3[l],UGAB3[l],WGAB3[l]);
    New_m(alAMPA[l],beAMPA[l],dt,ampa, mAMPA[l],UAMPA[l],WAMPA[l]);
    New_m(alGABA[l],beGABA[l],dt,gaba, mGABA[l],UGABA[l],WGABA[l]);
    New_m(alGABB[l],beGABB[l],dt,gabb, mGABB[l],UGABB[l],WGABB[l]);
    New_m(alNMDA[l],beNMDA[l],dt,nmd3, mNMD3[l],UNMD3[l],WNMD3[l]);
    New_m(alNMDA[l],beNMDA[l],dt,nmda, mNMDA[l],UNMDA[l],WNMDA[l]);}
  end;
  { ---------------- Remember old Currents ---------------------- }
  for l:=1 to 3 do begin
      IsynE_old[l]:=IsynE[l];
      IsynI_old[l]:=IsynI[l];
  end;
  { ---------------- Currents ----------------------------------- }
  for l:=1 to 3 do begin
    k:=l;  if l=3 then  k:=i3;
    gtAMPA:= gAMPA[k]*mAMPA[k] + gAMP3[k]*mAMP3[k];
    gtGABA:= gGABA[k]*mGABA[k] + gGAB3[k]*mGAB3[k];
    gtGABB:= gGABB[k]*mGABB[k];
    gtNMDA:=(gNMDA[k]*mNMDA[k] + gNMD3[k]*mNMD3[k])*SigmNMDA(V[l]);
    Sum:=        gtAMPA*(Vus-VAMPA)    + gtNMDA*(Vus-VNMDA)
               + gtGABA*(Vus-VGABA)    + gtGABB*(Vus-VGABB);
    { Control variables }
    uu[l]:=Current_Iind(l)-Sum;          {V}
    ss[l]:=gtAMPA + gtGABA + gtGABB + gtNMDA;
    IsynE[l]:= -gtAMPA*(V[l]-VAMPA) - gtNMDA*(V[l]-VNMDA);
    IsynI[l]:= -gtGABA*(V[l]-VGABA) - gtGABB*(V[l]-VGABB);
    PSC[l]:=(IsynE[l] + IsynI[l] + Current_Iind(l)) *Square[i3_ie(l)]*1e9; {pA}
  end;
end;

procedure SolveEqForVGABA;
var k,tau,max,min,m_thr,x0 :double;
begin
  k    :=Form4.DDSpinEdit76.Value;
  tau  :=Form4.DDSpinEdit75.Value/1000;
  max  :=Form4.DDSpinEdit77.Value/1000;
  min  :=Form4.DDSpinEdit78.Value/1000;
  m_thr:=Form4.DDSpinEdit79.Value;
  if mGABA[2]<m_thr then k:=0;
//  Form4.DDSpinEdit76.Value:=k;
  VGABA:=VGABA+dt/tau*(max-VGABA + k{*mGABA[2]}*(min-VGABA));
//  x0:=max; if mGABA[2]>m_thr then x0:=min;
  VGABA:=VGABA+dt/tau*(x0-VGABA);
  Form4.DDSpinEdit40.Value:=VGABA*1000;
end;

procedure ReadFrequencyFunction;
var i,j,ie,je    :integer;
    a            :char;
    u,s,v        :double;
begin
  assign(qqq,'V(u_s)15.dat');  reset(qqq);
  readln(qqq);
  readln(qqq,a,a,ie,a,a,a,a,je);
  { Read the last string and define 'du' and 'ds' }
  for i:=1 to ie do for j:=1 to je do  readln(qqq,u,s,v);
  du:=u/(ie-1);  ds:=s/(je-1);
  { Return to the start of values }
  reset(qqq);  readln(qqq);  readln(qqq);
  { Define available sizes of the array }
  ief:=imin(ie,mMax);  jef:=imin(je,mMax);
  { Fill in the array }
  for i:=1 to ie do begin
      for j:=1 to je do begin
          readln(qqq,u,s,v);
          if (i<=ief) and (j<=jef) then  FreqUS[i,j]:=v;
      end;
  end;
  close(qqq);
end;

function QfromU_S(u,s :double):double;
{
  It extracts frequencies (1/s) from array and interpolates them
  if control values of 'u'(V) and 's' are given.
}
var i,j :integer;
    x,y :double;
begin
  u:=u*1000;  { From Volts to mVolts }
  if (u>=du*(ief-1)) or (u<0) or (s>=ds*(jef-1)) or (s<0) then begin
      u:=0;  s:=0;
  end;
  i:=trunc(u/du)+1;
  j:=trunc(s/ds)+1;
  x:=u/du-(i-1);
  y:=s/ds-(j-1);
  QfromU_S:=FreqUS[i,j]*(1-x)*(1-y) + FreqUS[i+1,j]*x*(1-y)
           +FreqUS[i+1,j+1]*x*y     + FreqUS[i,j+1]*(1-x)*y;
end;

function QfromIs0(u,s :double; ie :integer):double;
{
  It extracts frequencies (1/s) from the approximated dependence of
  frequency on the complex of control values
  'i_s^0=(s*(Vrest[ie]-VK)-u)*gNa*Square' if 'u' and 's' are given.
  ^ freq., 1/s
  |                                       / | (x2,y2)
  |                                    /    |
  |                         (x1,y1) /       |
  |      i_s^0, pA                |         |
  |---------- >            _______|         |________
}
var
    x1,y1,x2,y2,x3,y3,is0,freq    :double;
    k                             :integer;
begin
  k:=ie; if ie=3 then k:=i3;
  is0:=-(s*(Vrest[ie]-Vus)-u)*Square[k]*1e9; {pA}
  if k=2 then begin
    {*** Interneuron ***}
//     x1:= 84 {pA};     {fitting to [Ali]}
//     y1:= 60 {1/s};
//     x2:=646 {pA};
//     y2:=240 {1/s};
     x1:= 25 {pA};       {Cope}
     y1:=  7 {1/s};
     x2:=150 {pA};
     y2:= 50 {1/s};
     if (is0<x1) then
       freq:=0
     else
       freq:=y1+(is0-x1)/(x2-x1)*(y2-y1);  {linear appr.}
  end else {if ie=1} begin
    {*** Pyramid ***}
     x1:= 27 {pA};     {fitting to [Ali]}
     y1:= {25}5 {1/s};
     x2:=182 {pA};
     y2:={145}90 {1/s};
     x3:=x2;
//     x1:=500 {pA};       {[Lanthorn]}
//     y1:= 5 {1/s};
//     x2:= 900 {pA};
//     y2:=30 {1/s};
//     x3:=2700 {pA};
//     y3:=60 {1/s};
     if (is0<x1)or(is0>x3) then
       freq:=0
     else if is0<x2 then
       freq:=y1+(is0-x1)/(x2-x1)*(y2-y1)   {linear appr.}
     else
       freq:=y2+(is0-x2)/(x3-x2)*(y3-y2);  {linear appr.}
  end;
  QfromIs0:=freq;
end;

procedure CheckFreqTable;
var  i,j :integer;
     u,s :double;
begin
  assign(ttt,'Table.dat');  rewrite(ttt);
  writeln(ttt,'ZONE T="ZONE1"');
  writeln(ttt,'I= 101 ,J= 101 ,K=1,F=POINT');
  for i:=0 to 100 do begin
      u:=du*(ief-1)/100*i;
      for j:=0 to 100 do begin
          s:=ds*(jef-1)/100*j;
          writeln(ttt,u:13,' ',s:13,' ',QfromU_S(u,s):13);
      end;
  end;
  close(ttt);
end;

function BurstOfAPs(u,DuDt,VTh :double) :double;
{ Defines frequency of APs in a burst, knowing
'u' - potential from rest level and 'DuDt' - rate of potential. }
var  tauAP, y,x,x2,x3,numax,sgm :double;
     k                          :integer;
begin
  tauAP:=0.001{s};
  if DuDt>1e-6 then begin
     x:=DuDt{/VTh}*tauAP/sgmAP[1];
     x2:=x*x; x3:=x*x*x;
     numax:=x/tauAP/(2.27765 + 0.179232*x + 2.79334e-2*x2 - 9.9495e-4*x3
          + 1.7177e-5*x2*x2 - 1.4149e-7*x2*x3 + 4.45737e-10*x3*x3);
     sgm:=1/(sqrt(2*pi)*numax*tauAP);
     y:=(u-DuDt*tauAP/2-VTh)/DuDt/tauAP;
     BurstOfAPs:=numax*dexp(-sqr(y)/2/sqr(sgm));    {1/s}
  end else begin
     BurstOfAPs:=0;
  end;
end;

procedure IntegrateNoise;
var  ie         :integer;
     rnd        :double;
begin
  for ie:=1 to 2 do begin
      rnd:=randG(0,1);
      if tauNoise<>0 then begin
         r_Noise[ie]:=r_Noise[ie] + (0-r_Noise[ie])/tauNoise*dt
                                  + rnd*sqrt(2*dt/tauNoise);
//       r_Noise:= max(r_Noise,0);
      end else begin
         r_Noise[ie]:=rnd;
      end;
  end;
end;

procedure Set_Ps;
begin
  pext:=Qns;
  if ((t>t0s) and (t<t0s+ts)) or ((t>t0s2) and (t<t0s2+ts)) then  begin
     pext:=pext + Iext{mkA} * 4{1/(mkA*s)};
  end;
  { Turn on Noise }
  if not(Form4.CheckBox8.Checked) then
     pext:=max(0,pext*(1+NoiseToSgn*r_Noise[1]));
end;

procedure WrightSystem;
var Qun,Qst,Qold        : double;
    ie,n_Axon_Delay     : integer;
begin
    { Stimulation }
    IntegrateNoise;
    Set_Ps;
    { Soma }
    for ie :=1 to 3 do begin
        Qold:=Q[ie];
        if IfPhase=0 then begin
           Qun:=BurstOfAPs(V[ie]-Vrest[ie], DuDt[ie],VThr0[i3_ie(ie)]);
           Qst:=QfromIs0(uu[ie],ss[ie],ie);
           Q[ie]:= max(Qun, Qst);
        end else begin
           Q[ie]:= PhaseDensity(ie);
        end;
        dQdt[ie]:=(Q[ie]-Qold)/dt;
    end;
    { Axons }
    { ----- exitation }
    {AxonEquationRennie(1);}
    {pn[1]:=Q[1];}
    if gam[1]>0 then n_Axon_Delay:=trunc(1/gam[1]/dts) else n_Axon_Delay:=0;
    pn[1]:=ro[1,n_Axon_Delay];
    { ----- inhibition }
    {AxonEquationRennie(2);}
    {pn[2]:=Q[2];}
    if gam[2]>0 then n_Axon_Delay:=trunc(1/gam[2]/dts) else n_Axon_Delay:=0;
    pn[2]:=ro[2,n_Axon_Delay];
    { Dendrites }
    SynapticCurrents;
    if Form4.CheckBox11.Checked then SolveEqForVGABA;
    if IfPhase=0 then begin
       MembranePotential;
    end else begin
       MembranePotential_Phase;
       if Form4.CheckBox10.Checked then EqForDispersion_Phase;
    end;
    SpikeProb[1]:=SpikeProb[1] + Q[1]*dt;
    SpikeProb[2]:=SpikeProb[2] + Q[2]*dt;
    DuDtmax[1]:=max(DuDtmax[1],DuDt[1]);
    DuDtmax[2]:=max(DuDtmax[2],DuDt[2]);
end;
end.
