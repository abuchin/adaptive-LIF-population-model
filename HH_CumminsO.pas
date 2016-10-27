unit HH_CumminsO;

interface
uses typeNrnPars,CondBasedO,NullChannelO,AHPO,
     Cum_NaO,Cum_NaRO,Cum_KO,Cum_KAO,Cum_KDO,Cum_CaTO,Cum_CaHO,
     Calmar_NaRO;

type
{==================================================================}
  TCumNrn = class(TCondBasedNrn)
  private
  public
    constructor Create(NP :NeuronProperties);
  end;

implementation

constructor TCumNrn.Create(NP :NeuronProperties);
begin
  inherited Create(NP);
  chNa :=TCumNa.Create(self);
  chK  :=TCumK.Create(self);
  chKA :=TCumKA.Create(self);
  chKM :=TNullChannel.Create;
  chKD :=TCumKD.Create(self);
  chH  :=TNullChannel.Create;
  if      NP.NaR_type='Krylov'  then  chNaR:=TCalmarNaR.Create(self)
  else if NP.NaR_type='Cummins' then  chNaR:=TCumNaR.Create(self)
  else                                chNaR:=TNullChannel.Create;
  chAHP:=TAHP.Create(self);
  chCaH:=TCumCaH.Create(self);
  chCaT:=TCumCaT.Create(self);
  chKCa:=TNullChannel.Create;
  chNaP:=TNullChannel.Create;
  chBst:=TNullChannel.Create;
end;

end.
