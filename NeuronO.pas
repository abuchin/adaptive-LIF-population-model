unit NeuronO;

interface
uses
  Classes,typeNrnPars;

type
{==================================================================}
  TNeuron = class
  private
  protected
  public
    {Properties:}
    NP                                          :NeuronProperties;
    {Variables:}
    NV                                          :NeuronVariables;
    {Functions:}
    {*******************************************}
    procedure InitialConditions; virtual; abstract;
    procedure ConditionsAtSpike(sinceAP :double); virtual; abstract;
    procedure MembranePotential(uu,ss,tt,Iind,Vhold :double); virtual; abstract;

    constructor Create(NP :NeuronProperties);
  end;


implementation

constructor TNeuron.Create;
begin
  inherited Create;
end;

end.
