unit EEG;

interface
uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
     StdCtrls,TeEngine;

procedure FindSigmoid;
function SteadyRateOfPopModel(Vinfty_VT,sgmV_VT,taum,taum_taus :double) :double;
function RateFromBiofizika2002(ie :integer):double;

implementation
uses Math,Init,mathMy,Hodgkin,HH_canal,ph_Dens,ph_Volt,Threshold,
     Unit1,Unit4,Unit7;

var
    SigmV       :array[1..2,0..1000] of double;
    dV_Sigm     :double;
    N_Sigm      :integer;
    exp_Int_0_u :array[0..500000] of double;

procedure ParametersForSigmoid;
begin
  N_Sigm:=400;
  dV_Sigm:=0.040{V}/N_Sigm;
end;

function IntForSteadyRate(a,b :double):double;
{ IntForSteadyRate=int_a^b exp(u^2) (1+erf(u)) du }
var S,dx,x,Arg  :double;
    i,N         :integer;
begin
  dx:=0.01;  N:=trunc((b-a)/dx)+1;  dx:=(b-a)/N;
  S:=0;
  for i:=1 to N do begin
      x:=a+(i-0.5)*dx;
      if x<-2.8 then Arg:=-1/x/sqrt(pi) else
      {*****************************}
      Arg:=dexp(x*x)*(1+Erfic(x));
      S:=S + Arg*dx;
      {*****************************}
  end;
  IntForSteadyRate:=S;
end;

procedure DrawAndWriteSigmoid;
var
    i                           :integer;
    I_1,I_2                     :double;
    aaa                         :text;
begin
  { Drawing }
  Form7.Visible:=true;
  if YesToClean=1 then begin
     Form7.Series1.Clear;
     Form7.Series2.Clear;
  end;
  for i:=0 to N_Sigm do begin
      Form7.Series1.AddXY((VL[1]+dV_Sigm*i)*1000,SigmV[1,i]);
      Form7.Series2.AddXY((VL[2]+dV_Sigm*i)*1000,SigmV[2,i]);
  end;
  Application.ProcessMessages;
  { Writing }
  assign(aaa,'Sigmoid(V).dat'); rewrite(aaa);
  for i:=0 to N_Sigm do begin
      write  (aaa,(VL[1]+dV_Sigm*i)*1000:9:4,' ',SigmV[1,i]:9:4,' ',dV_Sigm*i*gL[1]*1000:9:4,' ');
      writeln(aaa,(VL[2]+dV_Sigm*i)*1000:9:4,' ',SigmV[2,i]:9:4,' ',dV_Sigm*i*gL[2]*1000:9:4);
  end;
  close(aaa);
end;

procedure FindSigmoid;
{ Solution of eq.(5.104) from Gerstner for ISI=T:
  T=tau*sqrt(pi)*int_[(Vreset-x)/sgm]^[(VT-x)/sgm] exp(u^2)*(1+erf(u)) du
  where tau=C/gL, x is asymptotic potential. }
var
    i,ie,k,iter                 :integer;
    x,q,T_old,VT_,T_,tau,a,b    :double;
begin
  ParametersForSigmoid;
  for ie:=1 to 2 do begin
      k:=i3_ie(ie);
      tau:=C_membr[k]/gL[ie];                     {write the other conductances!!!}
      T_:=0;
      for i:=0 to N_Sigm do begin
          x:=VL[ie]+dV_Sigm*i;
          iter:=0;
          repeat  iter:=iter+1;
            T_old:=T_;
            q:=(x-Vreset[k])*dexp(-T_/tau);
            VT_:=VThreshold3(k,q/tau,min_tAP_Thr_DVDt[ie]);
            a:=(Vreset[k] -x)/sgm_V[k]/sqrt(2);
            b:=(VT_+VL[ie]-x)/sgm_V[k]/sqrt(2);
            {*************************************}
            T_:=tau*sqrt(pi)*IntForSteadyRate(a,b);
            {*************************************}
          until (abs(T_-T_old)<0.0001)or(iter>10);
          if (x>Vreset[k])and(T_>0.001) then  SigmV[ie,i]:=1/T_
          else                                SigmV[ie,i]:=0;
      end;
  end;
  IfSigmoidFound:=1;
  { Drawing and writing }
  DrawAndWriteSigmoid;
end;

procedure FindSigmoid_NotNoisy;
{ Solution of LIF is V(t)=x-exp(-t/tau)*(x-Vreset)
  where tau=C/gL, x is asymptotic potential.
  Eq. to be solved is VT(q/tau)=x-q, where q=(x-Vreset)/tau*exp(-T/tau). }
var
    i,ie,k,iter                 :integer;
    x,q,VT_old,VT_,T_,tau       :double;
begin
  ParametersForSigmoid;
  for ie:=1 to 2 do begin
      k:=i3_ie(ie);
      tau:=C_membr[k]/gL[ie];
      for i:=0 to N_Sigm do begin
          x:=VL[ie]+dV_Sigm*i;
          q:=(x-Vreset[k])/2;
          VT_:=VThreshold3(k,q/tau,min_tAP_Thr_DVDt[ie]);
          iter:=0;
          repeat  iter:=iter+1;
            VT_old:=VT_;
            q:=x-VL[ie]-VT_;
            VT_:=VThreshold3(k,q/tau,min_tAP_Thr_DVDt[ie]);
          until (abs(VT_-VT_old)<0.0001)or(iter>10);
          if (x>Vreset[k])and(q>0) then begin
              T_:=-tau*ln(q/(x-Vreset[k]));
              SigmV[ie,i]:=1/T_;
          end else SigmV[ie,i]:=0;
      end;
  end;
  IfSigmoidFound:=1;
  { Drawing and writing }
  DrawAndWriteSigmoid;
end;

procedure FindSteadyStateOfPopModel;
{  See comments to "function SteadyRateOfPopModel" }
var
    i,ie,k,iter,Nj,j,l,Nj_eps            :integer;
    x,q,T_old,VT_,T_,taum,taum_taus,Vinfty_VT,sgmV_VT,a,b,
    Int_0_a,u,du,V_,ts_,dts_,A_,F_,H_,eps  :double;
begin
  ParametersForSigmoid;
  if YesToClean=1 then begin
     Form7.Series3.Clear;
     Form7.Series4.Clear;
  end;
  for ie:=1 to 2 do begin
      k:=i3_ie(ie);
      taum:=C_membr[k]/gL[ie];
      taum_taus:=Form4.DDSpinEdit98.Value;
      SigmV[ie,0]:=0;
      for i:=1 to N_Sigm do begin
          x:=VL[ie]+dV_Sigm*i; {=V_infty}
          VT_:=VThreshold3(k,x,min_tAP_Thr_DVDt[ie]);
          Vinfty_VT:=(x-VL[ie])/VT_;
          sgmV_VT:=sgm_V[k]/VT_;
          {******************************************************************}
          SigmV[ie,i]:=SteadyRateOfPopModel(Vinfty_VT,sgmV_VT,taum,taum_taus);
          {******************************************************************}
          { Draw phase space - rho(ts) and u(ts)}
          a:=Vinfty_VT;
          Nj:=trunc(Form7.DDSpinEdit6.Value);  du:=a/Nj;
          for l:=1 to Nj-1 do begin
              u:=du*(l-1/2);
              if (ie=1)and(i mod 50 = 0)and(i>0) then begin
                 ts_:=-ln(1-u/a);
                 Form7.Series3.AddXY(ts_,exp_Int_0_u[l]);
                 Form7.Series4.AddXY(ts_,u);
              end;
          end;
          Application.ProcessMessages;
          { Exception when no firing, i.e. when rho(u=a)/rho0=0.001 }
          // if Int_0_u[Nj]<-ln(0.99) then Int_0_a:=100;
{          if dV_Sigm*i<0.001 then begin
             VT_:=VThreshold3(k,VL[ie],min_tAP_Thr_DVDt[ie]);
             a:=dV_Sigm*i/VT_;
             b:=VT_/sgm_V[k]/sqrt(2);
             Int_0_a:=1/fA_T(b*(1-a),Form4.DDSpinEdit98.Value);
          end;}
      end;
  end;
  IfSigmoidFound:=1;
  { Drawing and writing }
  DrawAndWriteSigmoid;
end;

{*********************************************************************}
function SteadyRateOfPopModel(Vinfty_VT,sgmV_VT,taum,taum_taus :double) :double;
{
  See p.90 of my Big Book.
  Solution of eqs.
  du/dt=-u+a
  drho/dt=-rho*A(T)+rho*[dT/dt]*sqrt(2)*Fsigma(-T),
  with u=(V-VL)/(VT-VL),  T=(VT-V)/sgm.
  Solution for f-I curve is
  nu=1/(int_0^a exp(-int_0^u H(u)/(a-u)*du)/(a-u)),
  H(u)=A(T) + (a-u)*(VT-VL)/sgm*Fsigma(-T).
}
var
    Nj,j,l,Nj_eps                                 :integer;
    a,b,du,u,eps,Int_0_u,Int_0_a,V_,A_,F_,H_,ts_  :double;
begin
  a:=Vinfty_VT;  b:=1/sgmV_VT/sqrt(2);
  Nj:=trunc(Form7.DDSpinEdit6.Value);  du:=a/Nj;
  eps:=trunc(a*Form7.DDSpinEdit7.Value/du)*du;  {otstup ot a}
  { Tabulate "int_0^u H(u)/(a-u)*du" }
  Int_0_u:=0; exp_Int_0_u[0]:=1;
  Nj_eps:=trunc((a-eps)/du);
  for l:=1 to Nj-1 do begin
      u:=du*(l-1/2);
      V_:=-b*(1-u);
      A_:=fA_T(-V_,taum_taus);
      F_:=(a-u)*b*sqrt(2)*F_tilde(V_);
      if Form4.CheckBox9. Checked then A_:=0; {'Without A'}
      if Form4.CheckBox14.Checked then F_:=0; {'Without F'}
      H_:=A_+F_;
      if l<=Nj_eps then begin
         {*************************************}
         Int_0_u:=Int_0_u + H_/(a-u)*du;
         {*************************************}
         exp_Int_0_u[l]:=dexp(-Int_0_u);
      end else begin
         exp_Int_0_u[l]:=exp_Int_0_u[Nj_eps] * step((a-du*l)/eps,A_);
      end;
      { Draw phase space - rho(ts) and u(ts)}
      //Form7.Series3.AddXY(u,exp_Int_0_u[l]);
  end;
  exp_Int_0_u[Nj]:=0;
          Application.ProcessMessages;
  { Integrate for ISI }
  Int_0_a:=0;
  for j:=1 to Nj_eps do begin
      u:=du*(j-1/2);
      {*************************************************************}
      Int_0_a:=Int_0_a + (exp_Int_0_u[j]+exp_Int_0_u[j-1])/2/(a-u)*du;
      {*************************************************************}
  end;
  V_:=-b*(1-a);  A_:=fA_T(-V_,taum_taus);
  if eps>du then Int_0_a:=Int_0_a + 1/A_*exp_Int_0_u[Nj_eps];
  {*************************************}
  SteadyRateOfPopModel:=1/(taum*Int_0_a);
  {*************************************}
end;

{*********************************************************************}
function RateFromBiofizika2002(ie :integer):double;
{ Calculates rate as done in [Biofizika 2002]
nu=max(nu_steady,nu_unsteady),
nu_steady=f(V_) is sigmoid-like "f-V curve";
nu_unsteady=f(V_,dVdt,sigma_V) considers crossing the threshold
by Gaussian set of neuron potentials. }
var
   nu_steady,nu_unsteady,dVdt,sigma_V,V_,U      :double;
   k,i                                          :integer;
begin
  k:=i3_ie(ie);
  U:=V0_ph[ie,Nts];
  { Steady firing }
  if ((IfSigmoidFound<>1)or(nt=1))and(ie=1) then begin { Initiate f-I curve }
     if      Form1.NoisySteadyRate1.Checked       then FindSigmoid
     else if Form1.NotNoisySteadyRate1.Checked    then FindSigmoid_NotNoisy
     else if Form1.SteadyStateOfPopModel1.Checked then FindSteadyStateOfPopModel;
  end;
  i:=round((U-VL[ie])/dV_Sigm);
  if (i<0)or(i>N_Sigm) then nu_steady:=0 else
  {********************}
  nu_steady:=SigmV[k,i];
  {********************}
  if Form4.CheckBox9. Checked then nu_steady:=0;    {'Without A'}
  { Unsteady firing }
  sigma_V:= sgm_V[k];
  dVdt:=max(DuDt_ph[ie,Nts],0);
  VT[ie,Nts]:=VThreshold3(k,dVdt,min_tAP_Thr_DVDt[k]);
  V_:=(U-Vrest[ie]-VT[ie,Nts])/sigma_V/sqrt(2);
  {**************************************************}
  nu_unsteady:=1/sqrt(2*pi)/sigma_V*dexp(-V_*V_)*dVdt;
  {**************************************************}
  if Form4.CheckBox14.Checked then nu_unsteady:=0;    {'Without F'}
  RateFromBiofizika2002:={max}(nu_steady+nu_unsteady);
end;

end.
