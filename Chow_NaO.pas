unit Chow_NaO;

interface
uses typeNrnPars,ChannelO,MathMyO,NeuronO, unit1;

type
  TChowNa = class(TChannel)
  private
//    oN :TNeuron;
    procedure tau_inf(v2 :double; var m_inf,tau_h,h_inf :double);
  public
//    V,gNa,VNa,mm,hh,dt :double;
//    IfBlockNa,NaThreshShift :integer;
    function Current :double; override;
    function Conductance(x,y,z :double) :double; override;
    procedure Init; override;

    constructor Create(nrn: TNeuron);
  end;

implementation

constructor TChowNa.Create(nrn: TNeuron);
begin  inherited Create; oN:=nrn; end;

{--------------------------------------------------------------}
procedure TChowNa.tau_inf(v2 :double; var m_inf,tau_h,h_inf :double);
var  v3,a,b :double;
begin
  v3:= v2 - oN.NP.NaThreshShift*1000;
  tau_h:= 0.6/(1+dexp(-0.12*(v2+67)));
  m_inf:=   1/(1+dexp(-0.08*(v3+26)));
  h_inf:=   1/(1+dexp( 0.13*(v2+38)));
end;

function TChowNa.Conductance(x,y,z :double) :double;
begin
{ if Form1.CheckBox5.Checked then ANrn1.NP.IfblockNa:=1;}
  Conductance:=istep(x,3)*y*(1-on.NP.IfBlockNa);
end;

function TChowNa.Current :double;
var  m_inf,tau_h,h_inf,h_exp :double;
begin
  tau_inf(oN.NV.V*1000, m_inf,tau_h,h_inf);
  h_exp:= 1 - dexp(-dt*1000/tau_h);
  oN.NV.hh:=oN.NV.hh+h_exp*(h_inf-oN.NV.hh);
  oN.NV.mm:=m_inf;
  Current:=oN.NP.gNa*Conductance(on.NV.mm,oN.NV.hh,0)*(oN.NV.V-oN.NP.VNa)*(1-oN.NP.IfBlockNa);
end;

procedure TChowNa.Init;
var  tau1,tau2 :double;
begin
  tau_inf(oN.NV.V*1000, oN.NV.mm,tau1,oN.NV.hh);
end;

end.
