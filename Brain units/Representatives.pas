unit Representatives;

interface
uses
  Init, Unit1, Unit6,
  typeNrnPars, NeuronO, CreateNrnO, SetNrnPars;

procedure WhatHappensInRepresentativeNeurons;
procedure OneStepForRepresentativeNeurons(Pt,Pdt :Pdouble);

var
  NPE,NPI      :NeuronProperties;
  ANrnE,ANrnI  :TNeuron;

implementation

procedure InitiateNeurons;
begin
  { Define the type of neuron }
  NPE.HH_type :=HH_type[1];
  NPE.HH_order:=HH_order[1];
  NPI.HH_type :=HH_type[2];
  NPI.HH_order:=HH_order[2];
  { Set parameters according to the type of neuron }
  HodgkinPhysParameters(NPE);
  HodgkinPhysParameters(NPI);
  NPE.NaThreshShift:=ThrCorrection[1];
  NPI.NaThreshShift:=ThrCorrection[2];
  { Create an object and set initial conditions }
  CreateNeuronByTypeO(NPE, ANrnE);
  CreateNeuronByTypeO(NPI, ANrnI);
  ANrnE.InitialConditions;
  ANrnI.InitialConditions;
  Form6.Series5.Clear;
  Form6.Series6.Clear;
end;

procedure WhatHappensInRepresentativeNeurons;
begin
  Form1.CheckBox1.Checked:=true;
  Form6.Visible:=true;
  Form6.CheckBox2.Checked:=false;
  Form6.CheckBox3.Checked:=false;
  Form6.CheckBox1.Visible:=false;
  Form6.CheckBox2.Visible:=false;
  Form6.CheckBox3.Visible:=false;
  Form6.Series1.Active:=false;
  Form6.Series2.Active:=false;
  { If switch on when simulating, create an object and set initial conditions }
  if nt>1 then begin
     InitiateNeurons;
  end;
end;

procedure OneStepForRepresentativeNeurons(Pt,Pdt :Pdouble);
begin
  { At t=0 create an object and set initial conditions }
  if nt=1 then begin
     InitiateNeurons;
  end;
  t:=Pt^;  dt:=Pdt^;
  {******* One step of integration *******************************}
  ANrnE.MembranePotential(uuE[1]+uuI[1],ssE[1]+ssI[1],0,Iadd[1],0);
  ANrnI.MembranePotential(uuE[2]+uuI[2],ssE[2]+ssI[2],0,Iadd[2],0);
  {***************************************************************}
  { Draw }
  if (trunc(nt/n_show)=nt/n_show)or(nt=1) then begin
     Form6.Series5.AddXY(t*1000,ANrnE.NV.V*1000);
     Form6.Series6.AddXY(t*1000,ANrnI.NV.V*1000);
  end;
  if nt>=nt_end then begin
     ANrnE.Free;
     ANrnI.Free;
  end;
end;

end.
