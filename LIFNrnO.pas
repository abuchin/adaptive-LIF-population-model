unit LIFNrnO;

interface
uses
  typeNrnPars,NeuronO;

type
{==================================================================}
  TLIFNrn = class(TNeuron)
  private
  public
    procedure InitialConditions; override;
    procedure MembranePotential(uu,ss,tt,Iind,Vhold :double); override;
  end;

implementation

procedure TLIFNrn.InitialConditions;
begin
  NV.V:=NP.Vrest;
  NV.indic:=0;
//  Read_Threshold_from_File;
end;

{-----------------------------------------------------------------------}

procedure TLIFNrn.MembranePotential(uu,ss,tt,Iind,Vhold :double);
var Isyn :double;
BEGIN
  NV.Vold:=NV.V;
  NV.Thr:=NP.VThreshold2(NV.DVlinDt,NP.ThrShift,t-NV.tAP);
  { Conditions at spike }
  NV.indic:=0;
  if NV.V>NP.Vrest+NV.Thr then begin
     NV.indic:=2; NV.tAP:=t;
     NV.V:=NP.Vreset;
  end;
  { ---------------- Currents ----------------------------------- }
  Isyn:= -ss*(NV.V-NP.VK) + uu;
  { ---------------- Ohm's law ---------------------------------- }
  NV.Im:= -NP.gL*(NV.V-NP.VL) +Iind;
  NV.DVlinDt:=0;
  if (t>NV.tAP+NP.tau_abs)or(abs(NV.tAP)<0.001) then begin
     NV.DVlinDt:=1/NP.C_membr*(NV.Im+Isyn);
     NV.V:=NV.V + dt*NV.DVlinDt;
  end;
  NV.PSC:=(Isyn + NV.Im) *NP.Square*1e9; {pA}
  NV.Thr:=NP.VThreshold2(NV.DVlinDt,NP.ThrShift,t-NV.tAP);
END;

end.
