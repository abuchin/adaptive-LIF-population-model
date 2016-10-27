unit Unit6;   {Form6 - Single neuron spikes}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, TeeProcs, TeEngine, Chart, Series, StdCtrls,
  Init;

type
  TForm6 = class(TForm)
    Chart1: TChart;
    Chart2: TChart;
    Series1: TFastLineSeries;
    Series2: TFastLineSeries;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Chart3: TChart;
    Series3: TLineSeries;
    Series4: TLineSeries;
    Series5: TLineSeries;
    Series6: TLineSeries;
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;
  ff6: TextFile;
implementation

{$R *.DFM}

procedure TForm6.CheckBox1Click(Sender: TObject);
begin
  if Form6.CheckBox1.Checked then begin
     AssignFile(ff6,'ViewSpikes.dat'); rewrite(ff6); CloseFile(ff6);
  end;
end;

procedure TForm6.CheckBox3Click(Sender: TObject);
begin
  Form6.Chart3.Visible:=Form6.CheckBox3.Checked;
end;

end.
