unit Lyle_NaRO;

interface
uses typeNrnPars,ChannelO,MathMyO,NeuronO;

type
  TLyleNaR = class(TChannel)
  private
//    oN :TNeuron;
    procedure tau_inf_NaR_Lyle(v2 :double; var tau_m,m_inf,tau_h,h_inf :double);
  public
//    V,gNaR,VNa,FRT,mmR,hhR,dt :double;
//    IfBlockNa,IfReduced :integer;
    function Current :double; override;
    function Conductance(x,y,z :double) :double; override;
    procedure Init; override;

    constructor Create(nrn: TNeuron);
  end;

implementation

constructor TLyleNaR.Create(nrn: TNeuron);
begin      inherited Create; oN:=nrn;    end;

{-------- NaR - rep -----------------------}
procedure TLyleNaR.tau_inf_NaR_Lyle(v2 :double; var tau_m,m_inf,tau_h,h_inf :double);
var a,b :double;
begin
  { Eq. for 'm' }
  a:=0.67*dexp( (v2+34)*0.5*6*oN.NP.FRT);
  b:=0.67*dexp(-(v2+34)*0.5*6*oN.NP.FRT);
  tau_m:= 1 / (a + b);    tau_m:=max(tau_m,5.0);
  m_inf:= a / (a + b);
  { Eq. for 'h' }
  a:=0.0023*dexp( (v2+42.5)*0.17*(-30)*oN.NP.FRT);
  b:=0.0023*dexp(-(v2+42.5)*0.83*(-30)*oN.NP.FRT);
  tau_h:= 1 / (a + b);    tau_h:=max(tau_h,3.0);
  h_inf:= a / (a + b);
end;

function TLyleNaR.Conductance(x,y,z :double):double;
begin
  Conductance :=sqr(x)*istep(y,3)*(1-oN.NP.IfBlockNa);
end;

function TLyleNaR.Current:double;
var  tau_m,m_inf, tau_h,h_inf,m2h3 :double;
begin
  tau_inf_NaR_Lyle(oN.NV.V*1000, tau_m,m_inf,tau_h,h_inf);
  oN.NV.mmR:=oN.NV.mmR+E_exp(dt,tau_m)*(m_inf-oN.NV.mmR);
  oN.NV.hhR:=oN.NV.hhR+E_exp(dt,tau_h)*(h_inf-oN.NV.hhR);
  if oN.NP.IfReduced=1 then oN.NV.mmR:=m_inf;
  Current:=oN.NP.gNaR*Conductance(oN.NV.mmR,oN.NV.hhR,0)*(oN.NV.V-oN.NP.VNa);
end;

procedure TLyleNaR.Init;
var  tau1,tau2 :double;
begin
  tau_inf_NaR_Lyle(oN.NV.V*1000, tau1,oN.NV.mmR,tau2,oN.NV.hhR);
end;

end.
