unit Unit5;  {Form5 - Conductances}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TeEngine, Series, ExtCtrls, TeeProcs, Chart;

type
  TForm5 = class(TForm)
    Chart1: TChart;
    Series1: TFastLineSeries;
    Series2: TFastLineSeries;
    Series3: TFastLineSeries;
    Series4: TFastLineSeries;
    Chart2: TChart;
    Series5: TFastLineSeries;
    Series6: TFastLineSeries;
    Chart3: TChart;
    Series7: TFastLineSeries;
    Series8: TFastLineSeries;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Series9: TFastLineSeries;
    CheckBox3: TCheckBox;
    Chart4: TChart;
    Series10: TFastLineSeries;
    Series11: TFastLineSeries;
    Series12: TFastLineSeries;
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure Chart1ClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure Chart3ClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure Chart2ClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure CheckBox3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;
  f51: TextFile;
  f52: TextFile;

implementation

{$R *.DFM}

procedure TForm5.CheckBox1Click(Sender: TObject);
begin
  Form5.Chart3.Visible:=Form5.CheckBox1.Checked;
end;

procedure TForm5.CheckBox3Click(Sender: TObject);
begin
  Form5.Chart4.Visible:=Form5.CheckBox3.Checked;
end;

procedure TForm5.CheckBox2Click(Sender: TObject);
begin
  if Form5.CheckBox2.Checked then begin
     AssignFile(f51,'SynCond.dat'); rewrite(f51); CloseFile(f51);
     AssignFile(f52,'InnerCond.dat'); rewrite(f52); CloseFile(f52);
  end;
end;

procedure TForm5.Chart1ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Series.Active:=not(Series.Active);
end;

procedure TForm5.Chart3ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Series.Active:=not(Series.Active);
end;

procedure TForm5.Chart2ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Series.Active:=not(Series.Active);
end;

end.
