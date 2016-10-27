unit Buchin_KMO;

interface
uses typeNrnPars,ChannelO,MathMyO,NeuronO, unit1;

type
  TLyleKM = class(TChannel)
  private
//    oN :TNeuron;
    procedure tau_inf_KM_Lyle(v2 :double; var tau_n,n_inf :double);
  public
//    V,gKM,VKM,FRT,nM,dt :double;
//    IfBlockKM :integer;
    function Current :double; override;
    function Conductance(x,y,z :double) :double; override;
    procedure Init; override;

    constructor Create(nrn: TNeuron);
  end;

implementation

constructor TLyleKM.Create(nrn: TNeuron);
begin      inherited Create; oN:=nrn;    end;

{---------------- KM -----------------}
procedure TLyleKM.tau_inf_KM_Lyle(v2 :double; var tau_n,n_inf :double);
var a,b :double;
begin
  { Eq. for 'nM' }
  a:=0.003*dexp( (v2+45)*0.6*6*oN.NP.FRT);
  b:=0.003*dexp(-(v2+45)*0.4*6*oN.NP.FRT);
  tau_n:= {form1.spinedit8.value/10;} 1 / (a + b) + 8;
  n_inf:= a / (a + b);
end;

function TLyleKM.Conductance(x,y,z :double):double;
begin


  Conductance :=x*x*(1-oN.NP.IfBlockKM);
end;

function TLyleKM.Current:double;
var  tau_n,n_inf, n_last,  m_max, temp, temp1 :double;
Begin
  tau_inf_KM_Lyle(form1.spinedit14.Value/10, tau_n, n_inf);
  tau_1:=Form1.SpinEdit9.value/10;                      {potential is constant!}


if form1.CheckBox18.Checked                     {frequency approximation}
 then
BEgin
  if form1.CheckBox17.Checked then
        begin                             {second frequency approximation}

New_m2(1/tau_1, 1/tau_n, dt*1000, ( n_inf*Max_K(1/tau_1,1/tau_n) +
Zi*fr/1000*(1-oN.NV.nM){*tau_n} ), oN.NV.nM, U_init);


        end
   else
    oN.NV.nM:=oN.NV.nM*(1-dt*1000/tau_n)      {first frequency approximation}
     + dt*( Zi*fr*(1-oN.NV.nM) + n_inf*1000/tau_n );
     end

ELse


BEGIN
   if form1.CheckBox17.Checked then             {second delta function approximation}
        begin
     if ifspike=1 then begin

U_init:=1/tau_1/tau_n/Max_k(1/tau_1,1/tau_n)*(n_inf*Max_k(1/tau_1,1/tau_n) + Zi) + U_init;
oN.NV.nM:=U_init*dt + oN.NV.nM;

                       end
                  else
New_m2(1/tau_1, 1/tau_n, dt*1000, ( n_inf*Max_K(1/tau_1,1/tau_n) ),oN.NV.nM, U_init);
        end

                               else
  begin                                   {first delta function approximation}
if ifspike=1 then oN.NV.nM:=oN.NV.nM + Zi*(1-oN.NV.nM)
              else
                  oN.NV.nM:=oN.NV.nM*(1-dt*1000/tau_n) + dt*1000/tau_n*n_inf ;
  end;
END;

  Current :=oN.NP.gKM*Conductance(oN.NV.nM,0,0)*(oN.NV.V-oN.NP.VKM);    { Current }
end;

procedure TLyleKM.Init;
var  tau1,tau2 :double;
begin
  tau_inf_KM_Lyle(oN.NV.V*1000, tau1,oN.NV.nM);
end;

end.
