unit ph_Dens;

interface
uses Init;

function PhaseDensity(ie :integer{; Qst :double}) :double;

var
     ro,Hzrd,V0_ph,VE_ph,DuDt_ph,nn_ph,yK_ph,nA_ph,lA_ph,nM_ph,wAHP_ph,
     VT,sgmV,L_V0,L_VE,L_nn,L_yK,L_nA,L_lA,L_nM,L_wAHP
                                :array[1..3,0..MaxPh] of double;
     L_ro                       :array[0..MaxPh] of double;
     dts,ts_end                                         :double;
     Nts,IfFsgmRead,NP,Nerf                             :integer;
     cP                         :array[0..10] of double;
     erf                        :array[0..1000,1..2] of double;
{****************************************************}

implementation
uses mathMy,Hodgkin,HH_canal,threshold,Unit2,Unit4,graph_0d,ph_Volt;

procedure WriteDistrInPhase;
var aaa :text;
    x   :integer;
begin
  assign(aaa,'Ph_ro_V(x).dat'); rewrite(aaa);
  FOR x:=0 to Nts do begin {loop for phase}
      write  (aaa,dts*x*1000:8:3,' ',ro[i3,x]:11,' ',V0_ph[i3,x]*1000:9:4);
      writeln(aaa,' ',VE_ph[i3,x]*1000:9:4,' ',(VT[i3,x]+Vrest[i3])*1000:9:4);
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
     Nerf:=i;
  end;
  xb:=erf[0,1]; dx:=(erf[Nerf,1]-erf[0,1])/Nerf;
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

FUNCTION Int_F_tilde(a,b :double) :double;
{ Integral of the Hazard function:
  out=Int_a^b sqrt(2/pi)*exp(-x^2)/(1-erf(x)) dx }
var  er :double;
  function g(x:double):double;
  begin
    if x>4 then g:=1/sqrt(2)*(x*x+ln(sqrt(pi)*x)) else
    g:=-1/sqrt(2)*ln(1-Erfic(x));
  end;
BEGIN
{  if a>4           then begin  Int_F_tilde:=(b*b-a*a)/sqrt(2); exit;  end;
  if (b<-5)or(b<a) then begin  Int_F_tilde:=0;           exit;  end;
  er:=Erfic(a);
  Int_F_tilde:=1/sqrt(2)*(Erfic(b)-er)/(1-er);}
  if b<a then  Int_F_tilde:=0
         else  Int_F_tilde:=g(b)-g(a);
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
var ts,roi,S,dro, F,sigma_V,V_,dVdt,A,F_A           :double;
    i,k                                             :integer;
begin
  k:=i3_ie(ie);
  if nt=2 then WriteF_sigma;
  if nt=2 then WriteThreshold;
  if Round(0.035/dt)=nt then WriteDistrInPhase;
  if nt<=1 then InitialPhaseDensityAndPotential(ie);
  if IfSecondOrder=1 then  Limiters(ie);
  S:=0;
  FOR i:=Nts downto 1 do begin {loop for phase}
      ts:=dts*i;
      dVdt:=DuDt_ph[ie,i];
      if (Form4.CheckBox9.Checked)and(dVdt>=-minDVDt) then dVdt:=max(dVdt,minDVDt);
      VT[ie,i]:=VThreshold3(k,dVdt,ts);
      if Form4.CheckBox10.Checked then  sigma_V:= sgmV[ie,i] + 0.01*sgm_V[k]
                                  else  sigma_V:= sgm_V[k];
      if Form4.CheckBox7 .Checked then  sigma_V:=sigma_V*(1-dexp(-ts/tau_m[k]));
      V_:=(V0_ph[ie,i]-Vrest[ie]-VT[ie,i])/sigma_V/sqrt(2);
      { Derived from "frozen" Gauss }
      if (dVdt<0)   then F:=0 else F:=F_tilde(V_)/sigma_V*dVdt;
      { From self-similar Fokker-Planck }
      if (ts<0.008) then A:=0 else A:=fA_T(-V_*sqrt(2))/tau_m[k];
      if Form4.CheckBox9.Checked then A:=0;
      { Spike half-duration }
      if i*dts<=dT_AP[k] then begin F:=0; A:=0; end;
      {*** Transfer equation ***}
      if dt>=dts then Warning('Courant number>1');
      roi:=ro[ie,i];  if i=Nts then roi:=0;
      ro[ie,i]:=ro[ie,i] - dt*(roi-ro[ie,i-1])/dts;
      {***** Second order TVD-scheme *****}
      if IfSecondOrder=1 then begin
         ro[ie,i]:=ro[ie,i] - dt/dts*(1-dt/dts)/2*(L_ro[i]-L_ro[i-1]);
      end;
      {*** Source ***}
      dro:=min(ro[ie,i],dt*ro[ie,i]*(F+A));
      {**************************************************}
//      ro[ie,i]:=ro[ie,i]  - dro;
      if ro[ie,i]<1e-8 then ro[ie,i]:=0 else begin
         dro:=-dexp(ln(ro[ie,i]) - dt*(F+A)) + ro[ie,i];
         ro[ie,i]:=ro[ie,i] - dro;
      end;
      {**************************************************}
      Hzrd[ie,i]:=dro/dt;
      S:=S                                         + dro;
  END;
  ro[ie,0]:=ro[ie,0] - dt*ro[ie,0]/dts + S;
  PhaseDensity:=ro[ie,0];
  S:=0;  for i:=0 to Nts do S:=S+dts*ro[ie,i]; { Norm }
end;
{*********************************************************************}

end.
