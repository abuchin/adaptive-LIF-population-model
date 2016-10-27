unit HH_PassiveO;

interface
uses typeNrnPars,CondBasedO,NullChannelO;

type
  arr4x4=array[1..4,1..4] of double;

{==================================================================}
  TPassiveNrn = class(TCondBasedNrn)
  private
  public
    constructor Create(NP :NeuronProperties);
  end;

implementation

constructor TPassiveNrn.Create(NP :NeuronProperties);
begin
  inherited Create(NP);
  chNa :=TNullChannel.Create;
  chK  :=TNullChannel.Create;
  chKA :=TNullChannel.Create;
  chKM :=TNullChannel.Create;
  chKD :=TNullChannel.Create;
  chH  :=TNullChannel.Create;
  chNaR:=TNullChannel.Create;
  chAHP:=TNullChannel.Create;
  chCaH:=TNullChannel.Create;
  chCaT:=TNullChannel.Create;
  chKCa:=TNullChannel.Create;
  chNaP:=TNullChannel.Create;
  chBst:=TNullChannel.Create;
end;

end.
