unit Unit8;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DDSpinEdit, TeEngine, Series, ExtCtrls, TeeProcs,
  Chart, Init;

type
  TForm8 = class(TForm)
    GroupBox3: TGroupBox;
    DDSpinEdit7: TDDSpinEdit;
    StaticText9: TStaticText;
    DDSpinEdit3: TDDSpinEdit;
    StaticText8: TStaticText;
    Button1: TButton;
    Button2: TButton;
    Chart1: TChart;
    Series1: TLineSeries;
    Series2: TLineSeries;
    GroupBox2: TGroupBox;
    DDSpinEdit4: TDDSpinEdit;
    StaticText3: TStaticText;
    DDSpinEdit5: TDDSpinEdit;
    StaticText6: TStaticText;
    Label4: TLabel;
    GroupBox1: TGroupBox;
    DDSpinEdit1: TDDSpinEdit;
    StaticText2: TStaticText;
    StaticText1: TStaticText;
    DDSpinEdit2: TDDSpinEdit;
    Series3: TLineSeries;
    Series4: TLineSeries;
    StaticText4: TStaticText;
    DDSpinEdit6: TDDSpinEdit;
    Chart2: TChart;
    CheckBox2: TCheckBox;
    Series6: TLineSeries;
    Series7: TLineSeries;
    Button3: TButton;
    GroupBox4: TGroupBox;
    DDSpinEdit8: TDDSpinEdit;
    DDSpinEdit9: TDDSpinEdit;
    DDSpinEdit10: TDDSpinEdit;
    DDSpinEdit11: TDDSpinEdit;
    DDSpinEdit12: TDDSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    DDSpinEdit13: TDDSpinEdit;
    Label7: TLabel;
    Label8: TLabel;
    ComboBox1: TComboBox;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure DDSpinEdit1Change(Sender: TObject);
    procedure DDSpinEdit4Change(Sender: TObject);
    procedure DDSpinEdit5Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure GroupBox4DblClick(Sender: TObject);
    procedure DDSpinEdit11DblClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure DDSpinEdit7Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form8: TForm8;

implementation

uses Unit1, V1,RingModel,ph_Dens,ph_Volt,mathMy;

{$R *.dfm}

procedure TForm8.Button1Click(Sender: TObject);
begin
  StopKey:='C';
  DecideIfThreadAndExecute;
end;

procedure TForm8.DDSpinEdit1Change(Sender: TObject);
begin
  ni:=trunc(Form8.DDSpinEdit1.Value);
end;

procedure TForm8.DDSpinEdit4Change(Sender: TObject);
begin
  R_stim:=trunc(Form8.DDSpinEdit4.Value);
end;

procedure TForm8.DDSpinEdit5Change(Sender: TObject);
begin
  X_stim:=Form8.DDSpinEdit5.Value/180*pi;
end;

procedure TForm8.Button2Click(Sender: TObject);
begin
  Form8.Series1.Clear;
  Form8.Series2.Clear;
  Form8.Series3.Clear;
  Form8.Series4.Clear;
  Form8.Series6.Clear;
  Form8.Series7.Clear;
end;

procedure TForm8.Button3Click(Sender: TObject);
begin
  Form8.GroupBox4.Visible:=true;
  SimplestRing;
end;

procedure TForm8.GroupBox4DblClick(Sender: TObject);
begin
  Form8.GroupBox4.Visible:=false;
end;

procedure TForm8.DDSpinEdit11DblClick(Sender: TObject);
begin
  Form8.DDSpinEdit11.Value:=0;
end;

procedure TForm8.Button4Click(Sender: TObject);
begin
  MemorizedParameters_V1;
end;

procedure TForm8.DDSpinEdit7Change(Sender: TObject);
begin
  dt_out:=Form8.DDSpinEdit7.Value/1000;
end;

end.
