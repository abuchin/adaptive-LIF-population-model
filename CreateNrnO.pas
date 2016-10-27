unit CreateNrnO;

interface
uses
  Classes,typeNrnPars,NeuronO;

procedure CreateNeuronByTypeO(NP :NeuronProperties; var ANrn :TNeuron);

{*********************************************************************}
var   ANrn :TNeuron;
{*********************************************************************}

implementation
uses
     ThreshNrnO,LIFNrnO,
     HH_CalmarO,HH_DestO,HH_migliO,HH_ChowO,HH_LyleO, HH_Buchin,HH_CumminsO,
     HH_PassiveO;


procedure CreateNeuronByTypeO(NP :NeuronProperties; var ANrn :TNeuron);
begin
  { Create Object-Neuron }
  IF      NP.IfThrModel=1 THEN  ANrn:=TThreshNrn.Create(NP)
  ELSE IF NP.IfLIF=1      THEN  ANrn:=TLIFNrn.Create(NP)
  ELSE BEGIN
    if      NP.HH_type='Calmar'   then ANrn:=TCalmarNrn.Create(NP)
    else if NP.HH_type='Destexhe' then ANrn:=TDestNrn.Create(NP)
    else if NP.HH_type='Lyle'     then ANrn:=TLyleNrn.Create(NP)
    else if NP.HH_type='Migliore' then ANrn:=TMigliNrn.Create(NP)
    else if NP.HH_type='Cummins'  then ANrn:=TCumNrn.Create(NP)
    else if NP.HH_type='Chow'     then ANrn:=TChowNrn.Create(NP)
    else if NP.HH_type='Passive'  then ANrn:=TPassiveNrn.Create(NP)
    else if NP.HH_type='Buchin'   then ANrn:=TBuchinNrn.Create(NP)
    else ANrn:=nil;//Warning('The type HH_type is wrong in "NeuronO.CreateNeuronByType"');
  END;
  { Set Parameters }
  ANrn.NP:=NP;
end;
{
                         ______________
                        |              |
                        |              |
                        |   TNeuron    |
                        |      in      |
                        |   NeuronO    |
                       /|              |
                     /  |______________|
                   /          |       \
    _____________/_     ______|_____   \ _________
   |               |   |            |   |         |
   | TCondBasedNrn |   | TThreshNrn |   | TLIFNrn |
   | CondBasedO    |   | ThreshNrnO |   | LIFNrnO |
   |_______________|   |____________|   |_________|
           |
         __|_________________________________________________________________________________
  ______|______   ______|_____   ______|___   ______|___   ______|____   ______|____   ______|___
 |             | |            | |          | |          | |           | |           | |          |
 | TPassiveNrn | | TCalmarNrn | | TDestNrn | | TLyleNrn | | TMigliNrn | | TCumNrn   | | TChowNrn |
 | HH_PassiveO | | HH_CalmarO | | HH_DestO | | HH_LyleO | | HH_migliO | |HH_CumminsO| | HH_ChowO |
 |_____________| |____________| |__________| |__________| |___________| |___________| |__________|

   TNullChannel    TCalmarNa     TCalmarNa     TLyleNa      TMigliNa      TCumNa        TChowNa
                   TCalmarK      TDestexheK    TLyleK       TMigliK       TCumK         TChowK
                                               TLyleKA                    TCumKA
                                 TDestexheKM   TLyleKM
                                               TLyleKD                    TCumKD
                                               TLyleH
                   TCalmarNaR    TCalmarNaR    TLyleNaR     TCalmarNaR    TCumNaR
                   TAHP          TAHP          TAHP                       TAHP
                                                                          TCumCaH
                                 TDestexheCaT                             TCumCaT
                                 TKepecsKCa
}

end.

