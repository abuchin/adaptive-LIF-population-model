unit HH_DestO;

interface
uses typeNrnPars,CondBasedO,
     NullChannelO,Calmar_NaO,Calmar_NaRO,Cum_NaRO,Dest_KMO,Dest_KO,
     KepecsWang_KCaO,Dest_CaTO,AHPO;

type
{==================================================================}
  TDestNrn = class(TCondBasedNrn)
  private
  public
    constructor Create(NP :NeuronProperties);
  end;

implementation

constructor TDestNrn.Create(NP :NeuronProperties);
begin
  inherited Create(NP);
  chNa :=TCalmarNa.Create(self);
  chK  :=TDestexheK.Create(self);
  chKA :=TNullChannel.Create;
  chKM :=TDestexheKM.Create(self);
  chKD :=TNullChannel.Create;
  chH  :=TNullChannel.Create;
  if      NP.NaR_type='Krylov'  then  chNaR:=TCalmarNaR.Create(self)
  else if NP.NaR_type='Cummins' then  chNaR:=TCumNaR.Create(self)
  else                                chNaR:=TNullChannel.Create;
  chAHP:=TAHP.Create(self);
  chCaH:=TNullChannel.Create;
  chCaT:=TDestexheCaT.Create(self);
  chKCa:=TKepecsKCa.Create(self);
  chNaP:=TNullChannel.Create;
  chBst:=TNullChannel.Create;
end;

end.

