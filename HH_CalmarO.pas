unit HH_CalmarO;

interface
uses typeNrnPars,CondBasedO,
     NullChannelO,Calmar_NaO,Calmar_KO,Calmar_NaRO,Cum_NaRO,AHPO;

type
{==================================================================}
  TCalmarNrn = class(TCondBasedNrn)
  private
  public
    constructor Create(NP :NeuronProperties);
  end;

implementation

constructor TCalmarNrn.Create(NP :NeuronProperties);
begin
  inherited Create(NP);
  chNa :=TCalmarNa.Create(self);
  chK  :=TCalmarK.Create(self);
  chKA :=TNullChannel.Create;
  chKM :=TNullChannel.Create;
  chKD :=TNullChannel.Create;
  chH  :=TNullChannel.Create;
  if      NP.NaR_type='Krylov'  then  chNaR:=TCalmarNaR.Create(self)
  else if NP.NaR_type='Cummins' then  chNaR:=TCumNaR.Create(self)
  else                             chNaR:=TNullChannel.Create;
  chAHP:=TAHP.Create(self);
  chCaH:=TNullChannel.Create;
  chCaT:=TNullChannel.Create;
  chKCa:=TNullChannel.Create;
  chNaP:=TNullChannel.Create;
  chBst:=TNullChannel.Create;
end;

end.
