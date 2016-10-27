unit HH_ChowO;

interface
uses typeNrnPars,CondBasedO,Chow_NaO,Chow_KO,NullChannelO;

type
{==================================================================}
  TChowNrn = class(TCondBasedNrn)
  private
  public

    constructor Create(NP :NeuronProperties);
  end;


implementation

constructor TChowNrn.Create(NP :NeuronProperties);
begin
  inherited Create(NP);
  chNa :=TChowNa.Create(self);
  chK  :=TChowK.Create(self);
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
