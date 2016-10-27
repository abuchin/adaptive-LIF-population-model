unit HH_Buchin;

interface
uses typeNrnPars,CondBasedO,
     Lyle_NaO,Lyle_KO,Lyle_KAO,Buchin_KMO, Lyle_KDO,Lyle_HO,Lyle_NaRO,
     AHPO_fr ,NullChannelO;

type
  arr4x4=array[1..4,1..4] of double;

{==================================================================}
  TBuchinNrn = class(TCondBasedNrn)
  private
  public
    constructor Create(NP :NeuronProperties);
  end;

implementation

constructor TBuchinNrn.Create(NP :NeuronProperties);
begin
  chNa :=TLyleNa.Create(self);
  chK  :=TLyleK.Create(self);
  chKA :=TLyleKA.Create(self);   {remake}
  chKM :=TLyleKM.Create(self);
  chKD :=TLyleKD.Create(self);
  chH  :=TLyleH.Create(self);
  chNaR:=TLyleNaR.Create(self);
  chAHP:=TAHP.Create(self);      {remake}
  chCaH:=TNullChannel.Create;
  chCaT:=TNullChannel.Create;
  chKCa:=TNullChannel.Create;
  chNaP:=TNullChannel.Create;
  chBst:=TNullChannel.Create;
  inherited Create(NP);
end;

end.
