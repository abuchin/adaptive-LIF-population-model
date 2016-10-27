unit HH_MigliO;

interface
uses typeNrnPars,CondBasedO,
     NullChannelO,Migli_NaO,Migli_KO,Calmar_NaRO,Cum_NaRO;

type
{==================================================================}
  TMigliNrn = class(TCondBasedNrn)
  private
  public
    constructor Create(NP :NeuronProperties);
  end;


implementation

constructor TMigliNrn.Create(NP :NeuronProperties);
begin
  inherited Create(NP);
  chNa :=TMigliNa.Create(self);
  chK  :=TMigliK.Create(self);
  chKA :=TNullChannel.Create;
  chKM :=TNullChannel.Create;
  chKD :=TNullChannel.Create;
  chH  :=TNullChannel.Create;
  if      NP.NaR_type='Krylov'  then  chNaR:=TCalmarNaR.Create(self)
  else if NP.NaR_type='Cummins' then  chNaR:=TCumNaR.Create(self)
  else                                chNaR:=TNullChannel.Create;
  chAHP:=TNullChannel.Create;
  chCaH:=TNullChannel.Create;
  chCaT:=TNullChannel.Create;
  chKCa:=TNullChannel.Create;
  chNaP:=TNullChannel.Create;
  chBst:=TNullChannel.Create;
end;


end.
