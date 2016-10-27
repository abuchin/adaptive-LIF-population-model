unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TeEngine, Series, ExtCtrls, TeeProcs, Chart;

type
  TForm2 = class(TForm)
    Chart1: TChart;
    SeriesE_ro: TFastLineSeries;
    SeriesE_VE: TFastLineSeries;
    SeriesE_V_p_sgm: TFastLineSeries;
    SeriesE_V_m_sgm: TFastLineSeries;
    Chart2: TChart;
    SeriesI_ro: TFastLineSeries;
    SeriesI_VE: TFastLineSeries;
    SeriesI_V_p_sgm: TFastLineSeries;
    SeriesI_V_m_sgm: TFastLineSeries;
    Chart3: TChart;
    SeriesE_nn: TFastLineSeries;
    Chart4: TChart;
    SeriesI_nn: TFastLineSeries;
    Series1: TLineSeries;
    Series2: TLineSeries;
    Series3: TLineSeries;
    Series4: TLineSeries;
    Series5: TLineSeries;
    Series6: TLineSeries;
    Series7: TLineSeries;
    Series8: TLineSeries;
    Series9: TLineSeries;
    Series10: TLineSeries;
    SeriesE_V: TLineSeries;
    SeriesI_V: TLineSeries;
    Series11: TFastLineSeries;
    Series12: TFastLineSeries;
    Series13: TPointSeries;
    SeriesE_VT: TLineSeries;
    SeriesI_VT: TLineSeries;
    Series14: TPointSeries;
    Series15: TPointSeries;
    Series16: TLineSeries;
    Series17: TLineSeries;
    procedure Chart1DblClick(Sender: TObject);
    procedure Chart1ClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure Chart2ClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure Chart4ClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure Chart3ClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}

procedure TForm2.Chart1DblClick(Sender: TObject);
begin
  Form2.Visible:=false;
end;

procedure TForm2.Chart1ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Series.Active:=not(Series.Active);
end;

procedure TForm2.Chart2ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Series.Active:=not(Series.Active);
end;

procedure TForm2.Chart4ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Series.Active:=not(Series.Active);
end;

procedure TForm2.Chart3ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Series.Active:=not(Series.Active);
end;

end.
