unit AHPO_fr;

interface
uses ChannelO,MathMyO,NeuronO,typeNrnPars, unit1;

type
  TAHP = class(TChannel)
  private
//    oN :TNeuron;
    procedure tau_inf_AHP(v2 :double; var tau_w,w_inf :double);
  public
//    V,gAHP,VK,wAHP,dt :double;
//    IfBlockAHP :integer;
    function Current :double; override;
    function Conductance(x,y,z :double) :double; override;
    procedure Init; override;

    constructor Create(nrn: TNeuron);
  end;


implementation

constructor TAHP.Create(nrn: TNeuron);
begin      inherited Create; oN:=nrn;    end;

  { *** AHP  ***}
procedure TAHP.tau_inf_AHP(v2 :double; var tau_w,w_inf :double);
var temp:real;
begin
tau_w:= {form1.spinedit7.value;}400*5/(3.3*dexp((v2+35)/20)+dexp(-(v2+35)/20));
temp:=tau_w;
w_inf:= {0.0444}  1 / (1+dexp(-(v2 +35)/10));
end;


function TAHP.Conductance(x,y,z :double):double;
var  tau_w,w_inf,w_exp,w_inf_rest :double;
begin
{ if Form1.CheckBox1.Checked then on.NP.IfBlockAHP:=1; }
  Conductance:=x*(1-oN.NP.IfBlockAHP);
end;


function TAHP.Current :double;
var  v2,a,b,tau_w,w_inf,w_exp, tau_1 :double;
begin
  tau_inf_AHP({oN.Nv.Vrest*1000}form1.DDspinedit4.Value,tau_w, w_inf);
  tau_1:=Form1.SpinEdit11.value/10;

if form1.Checkbox18.checked
 then
BEgin
  if form1.CheckBox19.Checked then
        begin                                    //second frequency approximation

New_m2(1/tau_1, 1/tau_w, dt*1000, ( w_inf*Max_K(1/tau_1,1/tau_w)+
Xi*fr/1000*(1-oN.NV.wAHP) ), oN.NV.wAHP, U2_init);
       end
   else
  oN.NV.wAHP:=oN.NV.wAHP*(1-dt*1000/tau_w)             //first frequency approximation
   + dt*( Xi*fr*(1-oN.NV.wAHP) + w_inf*1000/tau_w )


end


else

BEGIN
   if form1.CheckBox19.Checked then             {second delta function approximation}
        begin
     if ifspike=1 then begin
W_init:=1/tau_1/tau_w/Max_k(1/tau_1,1/tau_w)*(w_inf*Max_k(1/tau_1,1/tau_w) + Xi) + W_init;
oN.NV.wAHP:=W_init*dt + oN.NV.wAHP;
                       end
                  else
New_m2(1/tau_1, 1/tau_w, dt*1000, ( w_inf*Max_K(1/tau_1,1/tau_w) ),oN.NV.wAHP, W_init);
        end

                               else
  begin                                        {first delta function approximation}
if ifspike=1 then oN.NV.wAHP:=oN.NV.wAHP + Xi*(1-oN.NV.wAHP)
              else
                  oN.NV.wAHP:=oN.NV.wAHP*(1-dt*1000/tau_w) + dt*w_inf*1000/tau_w;
  end;
END;


  Current :=oN.NP.gAHP*Conductance(oN.NV.wAHP,0,0)*(oN.NV.V-oN.NP.VK); { Current }
end;


procedure TAHP.Init;
var  tau1,tau2 :double;
begin
  tau_inf_AHP(oN.NV.V*1000,tau1,oN.NV.wAHP);
end;


end.
