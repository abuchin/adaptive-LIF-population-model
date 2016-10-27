unit HH_LyleO;

interface
uses typeNrnPars,CondBasedO,
     Lyle_NaO,Lyle_KO,Lyle_KAO,Lyle_KMO,Lyle_KDO,Lyle_HO,Lyle_NaRO,
     AHPO,NullChannelO;

type
  arr4x4=array[1..4,1..4] of double;

{==================================================================}
  TLyleNrn = class(TCondBasedNrn)
  private
  public
    constructor Create(NP :NeuronProperties);
  end;

implementation

constructor TLyleNrn.Create(NP :NeuronProperties);
begin
  chNa :=TLyleNa.Create(self);
  chK  :=TLyleK.Create(self);
  chKA :=TLyleKA.Create(self);
  chKM :=TLyleKM.Create(self);
  chKD :=TLyleKD.Create(self);
  chH  :=TLyleH.Create(self);
  chNaR:=TLyleNaR.Create(self);
  chAHP:=TAHP.Create(self);
  chCaH:=TNullChannel.Create;
  chCaT:=TNullChannel.Create;
  chKCa:=TNullChannel.Create;
  chNaP:=TNullChannel.Create;
  chBst:=TNullChannel.Create;
  inherited Create(NP);
end;

end.
