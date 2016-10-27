
unit Wright;

interface
uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
     StdCtrls,TeEngine,
     PopulationO;

function SigmNMDA(V :double) :double;
PROCEDURE SynapticCurrents(pE3,pI3,pEE,pIE,pEI,pII :double);
procedure ReadFrequencyFunction;
function QfromU_S(u,s :double):double;
function QfromIs0(u,s :double; ie :integer):double;
procedure CheckFreqTable;
function BurstOfAPs(u,DuDt,VTh :double) :double;
procedure IntegrateNoise;
procedure Set_Ps;
procedure WrightSystem;

implementation
uses Math,Init,mathMy,Hodgkin,HH_canal,ph_Dens,ph_Volt,Threshold,
     Unit4,Unit7;

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
PROCEDURE SynapticCurrents(pE3,pI3,pEE,pIE,pEI,pII :double);
{
  Calculate the control variables 'uu'(V) and 'ss'(nondimensional).
}
var
     ampa,nmda                                          :vect2;
     Sum,gtAMPA,gtGABA,gtGABB,gtNMDA, Isyn,
     amp3,gaba,gab3,gabb,nmd3, quant, sc,
     c1,c2,c3,c4,al,be,z1,z2,z3,z4                      :double;
     k,l                                                :integer;
  function S(x :double) :double;
  begin if IfSigmoidForPresynRate=1 then S:=2/(1+dexp(-2*x))-1 else S:=x; end;
BEGIN
  { ---------------- Intensity of transmitter emission ---------- }
  quant:=dt_T;
  amp3   :=S(pE3 *quant);
  gab3   :=S(pI3 *quant);
  nmd3   :=S(pE3 *quant);
  ampa[1]:=S(pEE*quant);   ampa[2]:=S(pIE*quant);
  gaba   :=S(pEI*quant);
  gabb   :=S(pEI*quant);
  nmda[1]:=S(pEE*quant);   nmda[2]:=S(pIE*quant);
  { Blockage }
  if IfBlockAMPA=1 then begin  amp3:=0; ampa[1]:=0; ampa[2]:=0;  end;
  if IfBlockGABA=1 then begin  gab3:=0; gaba:=0;  end;
  if IfBlockGABB=1 then begin  gabb:=0;           end;
  if IfBlockNMDA=1 then begin  nmd3:=0; nmda[1]:=0; nmda[2]:=0;  end;
  { Exclusions }
  if IfAMPAGABAinp_NE_local=0 then begin
     for l:=1 to 2 do begin
         alAMP3[l]:=alAMPA[l];  beAMP3[l]:=beAMPA[l];
         alGAB3[l]:=alGABA[l];  beGAB3[l]:=beGABA[l];
     end;
  end;
  { ---------------- Synaptic conductances ---------------------- }
  for l:=1 to 2 do begin
     { Nonlinear effects: beta depends on stimulus [B.Morales et al. 2002] }
     if (IfSigmoidForPresynRate=1)and((factorI>0)or(factorE>0)) then begin
        z1:=mAMP3[l];///(Max_K(alAMP3[l],beAMP3[l])*quant);
        z2:=mGAB3[l];///(Max_K(alGAB3[l],beGAB3[l])*quant);
        z3:=mAMPA[l];///(Max_K(alAMPA[l],beAMPA[l])*quant);
        z4:=mGABA[l];///(Max_K(alGABA[l],beGABA[l])*quant);
        c1:=1+(z1)*factorE;
        c2:=1+(z2)*factorI;
        c3:=1+(z3)*factorE;
        c4:=1+(z4)*factorI;
        if Form4.DDSpinEdit90.Enabled then begin   {'al_amp,gab='}
           { Integrates extracellular mediator into 'amp', 'gab'. }
           al:=Form4.DDSpinEdit90.Value; {Hz}; be:=5000 {Hz};
           New_m(al,be,dt,amp3+ampa[l], eAMP[l],UeAMP[l],WeAMP[l]);
           New_m(al,be,dt,gab3+gaba,    eGAB[l],UeGAB[l],WeGAB[l]);
           sc:=Max_K(al,5000)*quant;
           c1:=1 + eAMP[l]/sc *factorE;   c3:=c1;
           c2:=1 + eGAB[l]/sc *factorI;   c4:=c2;
        end;
    end else begin c1:=1; c2:=1; c3:=1; c4:=1; end;
    New_m2(alAMP3[l]/c1,beAMP3[l]/c1,dt,amp3   , mAMP3[l],UAMP3[l]);
    New_m2(alGAB3[l]/c2,beGAB3[l]/c2,dt,gab3   , mGAB3[l],UGAB3[l]);
    New_m2(alNMDA[l],   beNMDA[l],   dt,nmd3,    mNMD3[l],UNMD3[l]);
    New_m2(alAMPA[l]/c3,beAMPA[l]/c3,dt,ampa[l], mAMPA[l],UAMPA[l]);
    New_m2(alGABA[l]/c4,beGABA[l]/c4,dt,gaba   , mGABA[l],UGABA[l]);
    New_m2(alGABB[l],   beGABB[l],   dt,gabb,    mGABB[l],UGABB[l]);
    New_m2(alNMDA[l],   beNMDA[l],   dt,nmda[l], mNMDA[l],UNMDA[l]);
{   New_m(alAMP3[l]/c1,beAMP3[l]/c1,dt,amp3   *c1, mAMP3[l],UAMP3[l],WAMP3[l]);
    New_m(alGAB3[l]/c2,beGAB3[l]/c2,dt,gab3   *c2, mGAB3[l],UGAB3[l],WGAB3[l]);
    New_m(alNMDA[l],   beNMDA[l],   dt,nmd3,       mNMD3[l],UNMD3[l],WNMD3[l]);
    New_m(alAMPA[l]/c3,beAMPA[l]/c3,dt,ampa[l]*c3, mAMPA[l],UAMPA[l],WAMPA[l]);
    New_m(alGABA[l]/c4,beGABA[l]/c4,dt,gaba   *c4, mGABA[l],UGABA[l],WGABA[l]);
    New_m(alGABB[l],   beGABB[l],   dt,gabb,       mGABB[l],UGABB[l],WGABB[l]);
    New_m(alNMDA[l],   beNMDA[l],   dt,nmda[l],    mNMDA[l],UNMDA[l],WNMDA[l]);}
  end;
  { ---------------- Remember old Currents ---------------------- }
  for l:=1 to 3 do begin
      {IsynE_old[l]:=IsynE[l];
      IsynI_old[l]:=IsynI[l];}
      uuE_old[l]:=uuE[l];
      ssE_old[l]:=ssE[l];
  end;
  { ---------------- Currents ----------------------------------- }
  for l:=1 to 3 do begin
    k:=l;  if l=3 then  k:=i3;
    gtAMPA:= gAMPA[l]*mAMPA[k] + gAMP3[l]*mAMP3[k];
    gtGABA:= gGABA[l]*mGABA[k] + gGAB3[l]*mGAB3[k];
    gtGABB:= gGABB[l]*mGABB[k];
    gtNMDA:=(gNMDA[l]*mNMDA[k] + gNMD3[l]*mNMD3[k])*SigmNMDA(V[l]);
//    IsynE[l]:= -gtAMPA*(V[l]-VAMPA) - gtNMDA*(V[l]-VNMDA);
//    IsynI[l]:= -gtGABA*(V[l]-VGABA) - gtGABB*(V[l]-VGABB);
//    Sum:=        gtAMPA*(Vus-VAMPA)    + gtNMDA*(Vus-VNMDA)
//               + gtGABA*(Vus-VGABA)    + gtGABB*(Vus-VGABB);
    { Control variables }
//   uu[l]:=Current_Iind(l)-Sum;          {V}
//   ss[l]:=gtAMPA + gtNMDA + gtGABA + gtGABB;
    uuE[l]:= -gtAMPA*(Vus-VAMPA) - gtNMDA*(Vus-VNMDA);
    uuI[l]:= -gtGABA*(Vus-VGABA) - gtGABB*(Vus-VGABB);
    ssE[l]:=gtAMPA + gtNMDA;
    ssI[l]:=gtGABA + gtGABB;
    uu[l]:=uuE[l]+uuI[l];
    ss[l]:=ssE[l]+ssI[l];
    Isyn:= -(ssE[l]+ssI[l])*(V[l]-Vus) + uuE[l] + uuI[l];
    PSC[l]:=(Isyn + Current_Iind(l)) *Square[i3_ie(l)]*1e9; {pA}
  end;
END;

procedure SolveEqForVGABA;
var k,tau,max,min,m_thr,x0 :double;
begin
  k    :=Form4.DDSpinEdit76.Value;
  tau  :=Form4.DDSpinEdit75.Value/1000;
  max  :=Form4.DDSpinEdit77.Value/1000;
  min  :=Form4.DDSpinEdit78.Value/1000;
  m_thr:=Form4.DDSpinEdit79.Value;
//  Form4.DDSpinEdit79.Enabled:=false;
  if mGABA[2]<m_thr then k:=0;
//  Form4.DDSpinEdit76.Value:=k;
  VGABA:=VGABA+dt/tau*(max-VGABA + k*mGABA[2]*(min-VGABA));
//  x0:=max; if mGABA[2]>m_thr then x0:=min;
//  VGABA:=VGABA+dt/tau*(x0-VGABA);
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
     x:=DuDt{/VTh}*tauAP/sgm_V[1];
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
var iStim :integer;
begin
  pext:=Qns;
  if dtSt>0 then iStim:=trunc((t-t0s)/dtSt) else iStim:=0;
  if ((t>t0s) and(t<t0s +tSt)) or
//     ((t>dtSt)and(t<dtSt+tSt)) or
     ((dtSt>0)and(iStim<=nStimuli)and(t-t0s<iStim*dtSt+tSt))then begin
     pext:=pext + Iext{muA} * pext_Iext {Hz/muA};
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
    {Q[1]:=}APopE.Density;
    {Q[2]:=}APopI.Density;
    { Axons }
    { ----- exitation }
    {AxonEquationRennie(1);}
    {pn[1]:=Q[1];}
    if gam[1]>0 then n_Axon_Delay:=trunc(1/gam[1]/dts) else n_Axon_Delay:=0;
    pn[1]:=ro[1,n_Axon_Delay];
//    pn[1]:=APopE.ro_at_ts(1/gam[1]);
    { ----- inhibition }
    {AxonEquationRennie(2);}
    {pn[2]:=Q[2];}
    if gam[2]>0 then n_Axon_Delay:=trunc(1/gam[2]/dts) else n_Axon_Delay:=0;
    pn[2]:=ro[2,n_Axon_Delay];
//    pn[2]:=APopI.ro_at_ts(1/gam[2]);
    { Dendrites }
    SynapticCurrents(pext,pext, pn[1],pn[1], pn[2],pn[2]);
    if Form4.CheckBox16.Checked then SolveEqForVGABA;
    if IfPhase=0 then begin
       MembranePotential;
    end else begin
       MembranePotential_Phase;
       APopE.MembranePotential(t,uu[1],ss[1],0,Iadd[1],Vrest[3]);
       APopI.MembranePotential(t,uu[2],ss[2],0,Iadd[2],Vrest[3]);
       if Form4.CheckBox10.Checked then EqForDispersion_Phase;
    end;
    SpikeProb[1]:=SpikeProb[1] + Q[1]*dt;
    SpikeProb[2]:=SpikeProb[2] + Q[2]*dt;
    DuDtmax[1]:=max(DuDtmax[1],DuDt[1]);
    DuDtmax[2]:=max(DuDtmax[2],DuDt[2]);
end;

end.
