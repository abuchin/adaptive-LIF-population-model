unit Lyle_NaO;

interface
uses typeNrnPars,ChannelO,MathMyO,NeuronO;

type
  arr4x4=array[1..4,1..4] of double;

  TLyleNa = class(TChannel)
  private
//    oN :TNeuron;
    XNa :array[1..4] of double;

    function TransitionRate(v2,t_max,k,V12,t_min :double) :double;
    procedure alphas_Na_Lyle(v2 :double; var A :arr4x4);
    function gNa_inf_Lyle:double;
  public
//    V,gNa,VNa,NaThreshShift,mm,hh,dt :double;
//    IfBlockNa :integer;
    function Current :double; override;
    function Conductance(x,y,z :double) :double; override;
    procedure Init; override;

    constructor Create(nrn: TNeuron);
  end;

implementation

constructor TLyleNa.Create(nrn: TNeuron);
begin  inherited Create; oN:=nrn; end;

{-------- Na - Markov model -----------------------}
function TLyleNa.TransitionRate(v2,t_max,k,V12,t_min :double) :double;
{ Calculate rate for Markov model, according to eq.(4)
  [Lyle, Interpretations..., p.78] }
var a,ex_ :double;
begin
  if t_max=888 then a:=0 else a:=1/(t_max-t_min);
  ex_:=dexp((v2-V12-oN.NP.NaThreshShift*1000)/k);
  if a+ex_=0 then  TransitionRate:=0
             else  TransitionRate:=1/(t_min+1/(a+ex_));
end;

procedure TLyleNa.alphas_Na_Lyle(v2 :double; var A :arr4x4);
var i,j :integer;
{ States: 1-O, 2-I, 3-C1, 4-C2 as in [Lyle, Interpretations..., p.92] }
begin
  for i:=1 to 4 do
      for j:=1 to 4 do  A[i,j]:=0;
  A[4,1]:=TransitionRate(v2,888, 1,-51,1/3);
  A[1,4]:=TransitionRate(v2,888,-2,-57,1/3);
  A[3,1]:=TransitionRate(v2,888, 1,-42,1/3);
  A[1,3]:=TransitionRate(v2,888,-2,-51,1/3);
  A[1,2]:=3;
  A[2,3]:=TransitionRate(v2,100,-1,-53,  1);
  A[3,4]:=TransitionRate(v2,100,-1,-60,  1);
end;

function TLyleNa.gNa_inf_Lyle:double;
{ Calculates stationary solution for Na-conductance }
var
     A          :arr4x4;
     L          :matr;
     X,B        :vect;
     S          :double;
     i,j        :integer;
begin
  alphas_Na_Lyle(oN.NV.V*1000, A);
  for i:=1 to 4 do for j:=1 to 4 do  L[i,j]:=A[j,i];
  for i:=1 to 3 do begin
      S:=0;
      for j:=1 to 4 do  S:=S+A[i,j];
      L[i,i]:= -S;
      B[i]:=0;
  end;
  B[4]:=1;   L[4,1]:=1; L[4,2]:=1; L[4,3]:=1; L[4,4]:=1; {Normalization}
  LinearSistem(4, L, B, X);
  for i:=1 to 4 do  XNa[i]:=X[i];
  oN.NV.mm:=XNa[1];  oN.NV.hh:=1;
  gNa_inf_Lyle:=oN.NP.gNa*oN.NV.mm*(1-oN.NP.IfBlockNa);
end;

function TLyleNa.Conductance(x,y,z :double):double;
begin
  Conductance:=x*(1-oN.NP.IfBlockNa);
end;

function TLyleNa.Current:double;
var
     A          :arr4x4;
     Sp,Sm      :double;
     i,j        :integer;
begin
  alphas_Na_Lyle(oN.NV.V*1000, A);
  for i:=1 to 3 do begin
      Sp:=0; Sm:=0;
      for j:=1 to 4 do  if i<>j then begin
          Sp:=Sp + dt*1000*A[j,i]*XNa[j];
          Sm:=Sm + dt*1000*A[i,j];
      end;
      XNa[i]:=XNa[i] + Sp - Sm*XNa[i];
  end;
  XNa[4]:=1 - XNa[1] - XNa[2] - XNa[3];      {Normalization}
  oN.NV.mm:=XNa[1];  oN.NV.hh:=1;
  Current:=oN.NP.gNa*Conductance(oN.NV.mm,0,0)*(oN.NV.V-oN.NP.VNa);
end;

procedure TLyleNa.Init;
var   dum :double;
begin
      dum:= gNa_inf_Lyle;
end;

end.

