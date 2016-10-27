program Project2;

{%File 'ModelSupport\LIFNrnO\LIFNrnO.txvpck'}
{%File 'ModelSupport\MathMy\mathMy.txvpck'}
{%File 'ModelSupport\Cum_CaHO\Cum_CaHO.txvpck'}
{%File 'ModelSupport\Chow_KO\Chow_KO.txvpck'}
{%File 'ModelSupport\NullChannelO\NullChannelO.txvpck'}
{%File 'ModelSupport\NeuronO\NeuronO.txvpck'}
{%File 'ModelSupport\HH_PassiveO\HH_PassiveO.txvpck'}
{%File 'ModelSupport\Lyle_KMO\Lyle_KMO.txvpck'}
{%File 'ModelSupport\HH_MigliO\HH_MigliO.txvpck'}
{%File 'ModelSupport\Lyle_KO\Lyle_KO.txvpck'}
{%File 'ModelSupport\Buchin_KMO\Buchin_KMO.txvpck'}
{%File 'ModelSupport\ThresholdO\ThresholdO.txvpck'}
{%File 'ModelSupport\Migli_KO\Migli_KO.txvpck'}
{%File 'ModelSupport\Lyle_NaRO\Lyle_NaRO.txvpck'}
{%File 'ModelSupport\CreateNrnO\CreateNrnO.txvpck'}
{%File 'ModelSupport\Cum_CaTO\Cum_CaTO.txvpck'}
{%File 'ModelSupport\Dest_KO\Dest_KO.txvpck'}
{%File 'ModelSupport\typeNrnPars\typeNrnPars.txvpck'}
{%File 'ModelSupport\Cum_KO\Cum_KO.txvpck'}
{%File 'ModelSupport\CondBasedO\CondBasedO.txvpck'}
{%File 'ModelSupport\Calmar_NaO\Calmar_NaO.txvpck'}
{%File 'ModelSupport\Migli_NaO\Migli_NaO.txvpck'}
{%File 'ModelSupport\Calmar_NaRO\Calmar_NaRO.txvpck'}
{%File 'ModelSupport\AHPO\AHPO.txvpck'}
{%File 'ModelSupport\Lyle_KDO\Lyle_KDO.txvpck'}
{%File 'ModelSupport\HH_CumminsO\HH_CumminsO.txvpck'}
{%File 'ModelSupport\EEG\EEG.txvpck'}
{%File 'ModelSupport\HH_CalmarO\HH_CalmarO.txvpck'}
{%File 'ModelSupport\Cum_KDO\Cum_KDO.txvpck'}
{%File 'ModelSupport\HH_Buchin\HH_Buchin.txvpck'}
{%File 'ModelSupport\HH_ChowO\HH_ChowO.txvpck'}
{%File 'ModelSupport\Cum_KAO\Cum_KAO.txvpck'}
{%File 'ModelSupport\AHPO_fr\AHPO_fr.txvpck'}
{%File 'ModelSupport\Lyle_NaO\Lyle_NaO.txvpck'}
{%File 'ModelSupport\Migli_KAO\Migli_KAO.txvpck'}
{%File 'ModelSupport\Lyle_KAO\Lyle_KAO.txvpck'}
{%File 'ModelSupport\SetNrnPars\SetNrnPars.txvpck'}
{%File 'ModelSupport\Chow_NaO\Chow_NaO.txvpck'}
{%File 'ModelSupport\Unit1\Unit1.txvpck'}
{%File 'ModelSupport\Dest_KCaO\Dest_KCaO.txvpck'}
{%File 'ModelSupport\Dest_CaTO\Dest_CaTO.txvpck'}
{%File 'ModelSupport\KepecsWang_KCaO\KepecsWang_KCaO.txvpck'}
{%File 'ModelSupport\HH_LyleO\HH_LyleO.txvpck'}
{%File 'ModelSupport\ChannelO\ChannelO.txvpck'}
{%File 'ModelSupport\ThreshNrnO\ThreshNrnO.txvpck'}
{%File 'ModelSupport\BstO\BstO.txvpck'}
{%File 'ModelSupport\Unit2\Unit2.txvpck'}
{%File 'ModelSupport\Cum_NaO\Cum_NaO.txvpck'}
{%File 'ModelSupport\Lyle_HO\Lyle_HO.txvpck'}
{%File 'ModelSupport\Cum_NaRO\Cum_NaRO.txvpck'}
{%File 'ModelSupport\Dest_KMO\Dest_KMO.txvpck'}
{%File 'ModelSupport\HH_DestO\HH_DestO.txvpck'}
{%File 'ModelSupport\Init\Init.txvpck'}
{%File 'ModelSupport\KoshHax\KoshHax.txvpck'}
{%File 'ModelSupport\MathMyO\MathMyO.txvpck'}
{%File 'ModelSupport\Calmar_KO\Calmar_KO.txvpck'}
{%File 'ModelSupport\default.txvpck'}

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  AHPO in '..\AHPO.pas',
  BstO in '..\BstO.pas',
  Calmar_KO in '..\Calmar_KO.pas',
  Calmar_NaO in '..\Calmar_NaO.pas',
  Calmar_NaRO in '..\Calmar_NaRO.pas',
  ChannelO in '..\ChannelO.pas',
  Chow_KO in '..\Chow_KO.pas',
  Chow_NaO in '..\Chow_NaO.pas',
  CondBasedO in '..\CondBasedO.pas',
  CreateNrnO in '..\CreateNrnO.pas',
  Cum_CaHO in '..\Cum_CaHO.pas',
  Cum_CaTO in '..\Cum_CaTO.pas',
  Cum_KAO in '..\Cum_KAO.pas',
  Cum_KDO in '..\Cum_KDO.pas',
  Cum_KO in '..\Cum_KO.pas',
  Cum_NaO in '..\Cum_NaO.pas',
  Cum_NaRO in '..\Cum_NaRO.pas',
  Dest_CaTO in '..\Dest_CaTO.pas',
  Dest_KCaO in '..\Dest_KCaO.pas',
  Dest_KMO in '..\Dest_KMO.pas',
  Dest_KO in '..\Dest_KO.pas',
  HH_CalmarO in '..\HH_CalmarO.pas',
  HH_ChowO in '..\HH_ChowO.pas',
  HH_CumminsO in '..\HH_CumminsO.pas',
  HH_DestO in '..\HH_DestO.pas',
  HH_LyleO in '..\HH_LyleO.pas',
  HH_MigliO in '..\HH_MigliO.pas',
  HH_PassiveO in '..\HH_PassiveO.pas',
  KepecsWang_KCaO in '..\KepecsWang_KCaO.pas',
  LIFNrnO in '..\LIFNrnO.pas',
  Lyle_HO in '..\Lyle_HO.pas',
  Lyle_KAO in '..\Lyle_KAO.pas',
  Lyle_KDO in '..\Lyle_KDO.pas',
  Lyle_KMO in '..\Lyle_KMO.pas',
  Lyle_KO in '..\Lyle_KO.pas',
  Lyle_NaO in '..\Lyle_NaO.pas',
  Lyle_NaRO in '..\Lyle_NaRO.pas',
  Migli_KAO in '..\Migli_KAO.pas',
  Migli_KO in '..\Migli_KO.pas',
  Migli_NaO in '..\Migli_NaO.pas',
  NeuronO in '..\NeuronO.pas',
  NullChannelO in '..\NullChannelO.pas',
  SetNrnPars in '..\SetNrnPars.pas',
  ThreshNrnO in '..\ThreshNrnO.pas',
  typeNrnPars in '..\typeNrnPars.pas',
  MathMyO in '..\MathMyO.pas',
  KoshHax in '..\KoshHax.pas',
  HH_Buchin in '..\HH_Buchin.pas',
  AHPO_fr in '..\AHPO_fr.pas',
  Buchin_KMO in '..\Buchin_KMO.pas',
  EEG in '..\Brain units\EEG.pas',
  init in '..\Brain units\init.pas',
  mathMy in '..\Brain units\mathMy.pas',
  ThresholdO in 'ThresholdO.pas',
  Unit2 in 'Unit2.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
