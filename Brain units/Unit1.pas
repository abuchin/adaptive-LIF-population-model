unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, IBCtrls, ColorGrd,
  Menus,Unit2,Unit5,Unit6, DDSpinEdit, TeEngine, Series,
  TeeProcs, Chart;

type
  TForm1 = class(TForm)
    Memo2: TMemo;
    StopButton: TButton;
    SimplexButton: TButton;
    ShowButton: TButton;
    CoeMemo: TMemo;
    WaveButton: TButton;
    ClearButton: TButton;
    VariationButton: TButton;
    PauseButton: TButton;
    PopupMenuForShow: TPopupMenu;
    Smpl1: TMenuItem;
    Smpl2: TMenuItem;
    Smpl3: TMenuItem;
    Smpl4: TMenuItem;
    Smpl5: TMenuItem;
    Smpl6: TMenuItem;
    Smpl7: TMenuItem;
    Smpl8: TMenuItem;
    Smpl9: TMenuItem;
    Smpl0: TMenuItem;
    Smpl10: TMenuItem;
    Smpl11: TMenuItem;
    Smpl12: TMenuItem;
    Smpl13: TMenuItem;
    Smpl14: TMenuItem;
    Smpl15: TMenuItem;
    Smpl16: TMenuItem;
    Smpl17: TMenuItem;
    Smpl18: TMenuItem;
    Smpl19: TMenuItem;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Chart1: TChart;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Parameters1: TMenuItem;
    HHtype2: TMenuItem;
    Passive1: TMenuItem;
    Calmar1: TMenuItem;
    Destexhe1: TMenuItem;
    Migliore1: TMenuItem;
    HHorder1: TMenuItem;
    N1point1: TMenuItem;
    N2points1: TMenuItem;
    Chow1: TMenuItem;
    Lyle1: TMenuItem;
    Label1: TLabel;
    Chart2: TChart;
    Series2: TLineSeries;
    Chart3: TChart;
    Series3: TLineSeries;
    TVDscheme1: TMenuItem;
    CheckBox4: TCheckBox;
    Chart4: TChart;
    Chart5: TChart;
    Chart6: TChart;
    Chart7: TChart;
    ComboBox1: TComboBox;
    Series6: TFastLineSeries;
    Series7: TFastLineSeries;
    Series4: TFastLineSeries;
    Series5: TFastLineSeries;
    Series8: TFastLineSeries;
    Series9: TFastLineSeries;
    Series10: TFastLineSeries;
    Series11: TFastLineSeries;
    Series12: TFastLineSeries;
    Series13: TFastLineSeries;
    CheckBox5: TCheckBox;
    Thread1: TMenuItem;
    CheckBox6: TCheckBox;
    PopupMenu1: TPopupMenu;
    NotNoisySteadyRate1: TMenuItem;
    NoisySteadyRate1: TMenuItem;
    Button1: TButton;
    SteadyStateOfPopModel1: TMenuItem;
    Series1: TLineSeries;
    HHtype11: TMenuItem;
    Chow2: TMenuItem;
    Calmar2: TMenuItem;
    Passive2: TMenuItem;
    HHorder11: TMenuItem;
    N2points2: TMenuItem;
    N1point2: TMenuItem;
    Label2: TLabel;
    Series14: TLineSeries;
    Series15: TLineSeries;
    procedure StopButtonClick(Sender: TObject);
    procedure SimplexButtonClick(Sender: TObject);
    procedure ShowButtonClick(Sender: TObject);
    procedure WaveButtonClick(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
    procedure VariationButtonClick(Sender: TObject);
    procedure PauseButtonClick(Sender: TObject);
    procedure Smpl1Click(Sender: TObject);
    procedure Smpl2Click(Sender: TObject);
    procedure Smpl3Click(Sender: TObject);
    procedure Smpl4Click(Sender: TObject);
    procedure Smpl6Click(Sender: TObject);
    procedure Smpl5Click(Sender: TObject);
    procedure Smpl7Click(Sender: TObject);
    procedure Smpl8Click(Sender: TObject);
    procedure Smpl9Click(Sender: TObject);
    procedure Smpl0Click(Sender: TObject);
    procedure PopupMenuForShowPopup(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Smpl10Click(Sender: TObject);
    procedure Smpl11Click(Sender: TObject);
    procedure Smpl12Click(Sender: TObject);
    procedure Smpl13Click(Sender: TObject);
    procedure Smpl14Click(Sender: TObject);
    procedure Smpl15Click(Sender: TObject);
    procedure Smpl16Click(Sender: TObject);
    procedure Smpl17Click(Sender: TObject);
    procedure Smpl18Click(Sender: TObject);
    procedure Smpl19Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure N1point1Click(Sender: TObject);
    procedure N2points1Click(Sender: TObject);
    procedure Passive1Click(Sender: TObject);
    procedure Calmar1Click(Sender: TObject);
    procedure Destexhe1Click(Sender: TObject);
    procedure Migliore1Click(Sender: TObject);
    procedure Chow1Click(Sender: TObject);
    procedure Lyle1Click(Sender: TObject);
    procedure TVDscheme1Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure Chart4DblClick(Sender: TObject);
    procedure Chart1DblClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Chart6ClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure Chart7ClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure Chart3ClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure Chart2ClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure Chart5ClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure Chart4ClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure CheckBox5Click(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure NotNoisySteadyRate1Click(Sender: TObject);
    procedure NoisySteadyRate1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SteadyStateOfPopModel1Click(Sender: TObject);
    procedure Series10DblClick(Sender: TChartSeries; ValueIndex: Integer;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Series9DblClick(Sender: TChartSeries; ValueIndex: Integer;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure N1point2Click(Sender: TObject);
    procedure N2points2Click(Sender: TObject);
    procedure Passive2Click(Sender: TObject);
    procedure Calmar2Click(Sender: TObject);
    procedure Chow2Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

//
//  BrainThread
//
  BrainThread = class(TThread)
  private
    { Private declarations }
  protected
  public
    procedure Execute; override;
    procedure Treat_Key;
    procedure ForSynchronization;
    procedure MySynchronize;
  end;
//
// WaitingThread
//
  WaitingThread = class(TThread)
  private
    { Private declarations }
  protected
//  public
    procedure Execute; override;
    procedure ForSynchronization;
  end;
  procedure Pause; {in 'key.inc'}

var
  MyThread1 :BrainThread;
  MyThread2 :WaitingThread;
  Thread1Active : boolean; // used to test if thread 1 is active
  Thread2Active : boolean; // used to test if thread 2 is active

var
  Form1: TForm1;
  gtest   :integer;
  dum :longint;
  s1  :string;
  StopKey :Char;

procedure DecideIfThreadAndExecute;
procedure Change_HH_type;

implementation

uses Init,mathMy,Hodgkin,HH_canal,coeff,ph_Dens,ph_Volt,Wright,
     other,other_2D,BP2Delphi,graph_0d,graph_2d,
     wave,exp_nu_Pyr,Slice,slice_2D,V1,run, Correspond,Representatives,
     Unit3,Unit4,Unit13, Unit8,Unit7;


{$R *.DFM}

{===================================================}

procedure ChooseAndExecute;
begin
  if StopKey='2' then begin
     StopKey:=' ';
     System_2D;
  end else if StopKey='h' then begin  { 1D Show }
     StopKey:=' ';
     Shower;
  end else if StopKey='F' then begin  { Simplex }
     StopKey:=' ';
     Simplex;
  end else if StopKey='V' then begin
     StopKey:=' ';
     Variation;
  end else if StopKey='C' then begin
     StopKey:=' ';
     V1Column;
  end;
end;

procedure DecideIfThreadAndExecute;
begin
  if Form1.Thread1.Checked then begin
     MyThread1:=BrainThread.Create(False);
     Thread1Active:=true;
  end else begin
     ChooseAndExecute;
  end;
end;

{===================================================}

procedure TForm1.ClearButtonClick(Sender: TObject);
var memYesToClean :integer;
begin
  memYesToClean:=1;
  Initial_Picture;
  Form1.Series1.Active:=true;
  Form1.Series2.Active:=true;
  Form1.Series3.Active:=true;
  Form1.Series4.Active:=true;
  Form1.Series5.Active:=true;
  Form1.Series6.Active:=true;
  Form1.Series7.Active:=true;
  Form1.Series8.Active:=true;
  Form1.Series9.Active:=true;
  Form1.Series10.Active:=true;
  Form1.Series11.Active:=true;
  Form1.Series12.Active:=true;
  Form1.Series13.Active:=true;
  Form2.Visible:=true;
  YesToClean:=memYesToClean;
end;

procedure TForm1.StopButtonClick(Sender: TObject);
begin
  StopKey:='S';
  t_end:=t;
  nt_end:=imin(trunc(t_end/dt), mMaxExp);
  CorrespondParametersToTheForm;
end;

procedure TForm1.SimplexButtonClick(Sender: TObject);
begin
  Form1.Memo2.Visible    :=true;
  Form1.CoeMemo.Visible  :=true;
  StopKey:='F';
  DecideIfThreadAndExecute;
end;

procedure TForm1.ShowButtonClick(Sender: TObject);
begin
  Form1.Memo2.Visible    :=true;
  StopKey:='h';
  DecideIfThreadAndExecute;
end;

procedure TForm1.WaveButtonClick(Sender: TObject);
begin
  Form1.Memo2.Visible    :=false;
  Form1.CoeMemo.Visible  :=false;
  Form3.Visible:=true;
//  Form1.ThreadCheckBox.Checked:=True;
  StopKey:='2';
end;

procedure TForm1.VariationButtonClick(Sender: TObject);
begin
  Form1.Memo2.Visible    :=true;
  Form1.CoeMemo.Visible  :=false;
  StopKey:='V';
  DecideIfThreadAndExecute;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Form1.Memo2.Visible    :=false;
  Form1.CoeMemo.Visible  :=false;
  Form8.Visible:=true;
  StopKey:='C';
  RingParameters;
end;

procedure TForm1.PauseButtonClick(Sender: TObject);
begin
  if StopKey='P' then StopKey:=' ' else
  StopKey:='P';
{  if (MyThread1<>nil) then begin
      if Thread1Active then  MyThread1.Suspend else MyThread1.Resume;
      Thread1Active:=not(Thread1Active);
  end;}
end;

procedure TForm1.FormShow(Sender: TObject);
begin
//  DefaultParameters_2D;
  DefaultParameters;
  TeeDefaultCapacity:=100000;
end;

{===========================================================}
                        { THREADS }
{===========================================================}

{ WaitingThread }

procedure Pause;
begin
  if StopKey='P' then begin
     repeat
       Application.ProcessMessages;
     until StopKey<>'P';
  end;
{  if MyThread2=nil then begin
     MyThread2:=WaitingThread.Create(False);
     Thread2Active:=true;
  end;}
end;

procedure WaitingThread.ForSynchronization;
begin
  StopKey:=StopKey;
end;

procedure WaitingThread.Execute;
begin
  StopKey:=' ';
  repeat
    MyThread2.Synchronize(MyThread2.ForSynchronization);
  until StopKey='P';
  StopKey:=' ';
  MyThread2.Suspend;
  MyThread2.Terminate;
end;

{ BrainThread }

procedure BrainThread.Treat_Key;
var  a              :char;
begin
  a:=StopKey;
  if (a<>' ')and(ord(a)<>0) then begin
     if a='S' then begin
        iHist:=0; nt:=nt_end; istop:=1
     end else
     if a='P' then Pause;
  end;
end;

procedure BrainThread.Execute;
begin
  ChooseAndExecute;
end;

procedure BrainThread.ForSynchronization;
begin
  StopKey:=StopKey;
end;

procedure BrainThread.MySynchronize;
begin
  Synchronize(MyThread1.ForSynchronization);
end;

{===========================================================}
                        { PopMenu }
{===========================================================}

procedure TForm1.Smpl1Click(Sender: TObject);
begin
  Form1.Smpl1.Checked:=true;
  AssignSmpl;
end;

procedure TForm1.Smpl2Click(Sender: TObject);
begin
  Form1.Smpl2.Checked:=true;
  AssignSmpl;
end;

procedure TForm1.Smpl3Click(Sender: TObject);
begin
  Form1.Smpl3.Checked:=true;
  AssignSmpl;
end;

procedure TForm1.Smpl4Click(Sender: TObject);
begin
  Form1.Smpl4.Checked:=true;
  AssignSmpl;
end;

procedure TForm1.Smpl5Click(Sender: TObject);
begin
  Form1.Smpl5.Checked:=true;
  AssignSmpl;
end;

procedure TForm1.Smpl6Click(Sender: TObject);
begin
  Form1.Smpl6.Checked:=true;
  AssignSmpl;
end;

procedure TForm1.Smpl7Click(Sender: TObject);
begin
  Form1.Smpl7.Checked:=true;
  AssignSmpl;
end;

procedure TForm1.Smpl8Click(Sender: TObject);
begin
  Form1.Smpl8.Checked:=true;
  AssignSmpl;
end;

procedure TForm1.Smpl9Click(Sender: TObject);
begin
  Form1.Smpl9.Checked:=true;
  AssignSmpl;
end;

procedure TForm1.Smpl10Click(Sender: TObject);
begin
  Form1.Smpl10.Checked:=true;
  AssignSmpl;
end;

procedure TForm1.Smpl11Click(Sender: TObject);
begin
  Form1.Smpl11.Checked:=true;
  AssignSmpl;
end;

procedure TForm1.Smpl12Click(Sender: TObject);
begin
  Form1.Smpl12.Checked:=true;
  AssignSmpl;
end;

procedure TForm1.Smpl13Click(Sender: TObject);
begin
  Form1.Smpl13.Checked:=true;
  AssignSmpl;
end;

procedure TForm1.Smpl14Click(Sender: TObject);
begin
  Form1.Smpl14.Checked:=true;
  AssignSmpl;
end;

procedure TForm1.Smpl15Click(Sender: TObject);
begin
  Form1.Smpl15.Checked:=true;
  AssignSmpl;
end;

procedure TForm1.Smpl16Click(Sender: TObject);
begin
  Form1.Smpl16.Checked:=true;
  AssignSmpl;
end;

procedure TForm1.Smpl17Click(Sender: TObject);
begin
  Form1.Smpl17.Checked:=true;
  AssignSmpl;
end;

procedure TForm1.Smpl18Click(Sender: TObject);
begin
  Form1.Smpl18.Checked:=true;
  AssignSmpl;
end;

procedure TForm1.Smpl19Click(Sender: TObject);
begin
  Form1.Smpl19.Checked:=true;
  AssignSmpl;
end;

procedure TForm1.Smpl0Click(Sender: TObject);
begin
  Form1.Smpl0.Checked:=true;
  AssignSmpl;
end;

procedure TForm1.PopupMenuForShowPopup(Sender: TObject);
begin
  CorrespondParametersToTheForm;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if Form1.CheckBox1.Checked then WhatHappensInRepresentativeNeurons;
  Form6.Visible:=Form1.CheckBox1.Checked;
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
  Form5.Visible:=Form1.CheckBox2.Checked;
end;

procedure TForm1.CheckBox3Click(Sender: TObject);
begin
  Form13.Visible:=Form1.CheckBox3.Checked;
end;

procedure TForm1.CheckBox4Click(Sender: TObject);
begin
  if Form1.CheckBox4.Checked then  begin
     WriteOrNot:=1;
     InitiateWriting;
  end else begin
     WriteOrNot:=0;
//     CloseFile(ccc);
  end;
end;

procedure TForm1.CheckBox6Click(Sender: TObject);
begin
  YesToClean:=1-YesToClean;
  CorrespondParametersToTheForm;
end;

{===========================================================}
                        { Main Menu }
{===========================================================}

procedure Change_HH_order;
begin
//  k:=i3_ie(i3);
  if Form1.N1point1. Checked then  HH_order[1]:='1-point';
  if Form1.N2points1.Checked then  HH_order[1]:='2-points';
  if Form1.N1point2. Checked then  HH_order[2]:='1-point';
  if Form1.N2points2.Checked then  HH_order[2]:='2-points';
  DefaultCanalParameters(1);
  DefaultCanalParameters(2);
  CorrespondParametersToTheForm;
end;

procedure TForm1.N1point1Click(Sender: TObject);
var  k :integer;
begin
  Form1.N1point1.Checked:=true;
  Change_HH_order;
end;

procedure TForm1.N2points1Click(Sender: TObject);
var  k :integer;
begin
  Form1.N2points1.Checked:=true;
  Change_HH_order;
end;

procedure TForm1.N1point2Click(Sender: TObject);
begin
  Form1.N1point2.Checked:=true;
  Change_HH_order;
end;

procedure TForm1.N2points2Click(Sender: TObject);
begin
  Form1.N2points2.Checked:=true;
  Change_HH_order;
end;

procedure Change_HH_type;
var  k :integer;
begin
//  k:=i3_ie(i3);
  if Form1.Passive1. Checked then  HH_type[1]:='Passive';
  if Form1.Calmar1.  Checked then  HH_type[1]:='Calmar';
  if Form1.Destexhe1.Checked then  HH_type[1]:='Destexhe';
  if Form1.Migliore1.Checked then  HH_type[1]:='Migliore';
  if Form1.Chow1.    Checked then  HH_type[1]:='Chow';
  if Form1.Lyle1.    Checked then  HH_type[1]:='Lyle';
  if Form1.Passive2. Checked then  HH_type[2]:='Passive';
  if Form1.Calmar2.  Checked then  HH_type[2]:='Calmar';
  if Form1.Chow2.    Checked then  HH_type[2]:='Chow';
  DefaultCanalParameters(1);
  DefaultCanalParameters(2);
  CorrespondParametersToTheForm;
end;

procedure TForm1.Passive1Click(Sender: TObject);
begin
  Form1.Passive1. Checked:=true;
  Form4.CheckBox12.Checked:=true;
  Form4.GroupBox6.Visible:=true;
  Form4.GroupBox7.Visible:=true;
  Change_HH_type;
end;

procedure TForm1.Calmar1Click(Sender: TObject);
begin
  Form1.Calmar1. Checked:=true;
  Change_HH_type;
end;

procedure TForm1.Destexhe1Click(Sender: TObject);
begin
  Form1.Destexhe1. Checked:=true;
  Change_HH_type;
end;

procedure TForm1.Migliore1Click(Sender: TObject);
begin
  Form1.Migliore1. Checked:=true;
  Change_HH_type;
end;

procedure TForm1.Chow1Click(Sender: TObject);
begin
  Form1.Chow1. Checked:=true;
  Change_HH_type;
end;

procedure TForm1.Lyle1Click(Sender: TObject);
begin
  Form1.Lyle1. Checked:=true;
  Change_HH_type;
end;

procedure TForm1.Passive2Click(Sender: TObject);
begin
  Form1.Passive2. Checked:=true;
  Form4.CheckBox12.Checked:=true;
  Form4.GroupBox6.Visible:=true;
  Form4.GroupBox7.Visible:=true;
  Change_HH_type;
end;

procedure TForm1.Calmar2Click(Sender: TObject);
begin
  Form1.Calmar2. Checked:=true;
  Change_HH_type;
end;

procedure TForm1.Chow2Click(Sender: TObject);
begin
  Form1.Chow2. Checked:=true;
  Change_HH_type;
end;

procedure TForm1.TVDscheme1Click(Sender: TObject);
begin
  IfSecondOrder:=1-IfSecondOrder;
  CorrespondParametersToTheForm;
end;

procedure TForm1.Chart4DblClick(Sender: TObject);
begin
  Form1.Chart4.Enabled:=false;
  Form1.Chart4.Visible:=false;
  Form1.Chart5.Visible:=false;
end;

procedure TForm1.Chart1DblClick(Sender: TObject);
begin
  Form1.Chart1.Enabled:=false;
  Form1.Chart1.Visible:=false;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  If_I_V_or_p:=Form1.ComboBox1.ItemIndex+1;
end;

procedure TForm1.Chart6ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Series.Active:=not(Series.Active);
end;

procedure TForm1.Chart7ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Series.Active:=not(Series.Active);
end;

procedure TForm1.Chart3ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Series.Active:=not(Series.Active);
end;

procedure TForm1.Chart2ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Series.Active:=not(Series.Active);
end;

procedure TForm1.Chart5ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Series.Active:=not(Series.Active);
end;

procedure TForm1.Chart4ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Series.Active:=not(Series.Active);
end;

procedure TForm1.CheckBox5Click(Sender: TObject);
begin
  Form7.Visible:=true;
  t_end:=0.050;
  I_ind:=500;
  Nts:=1;
  HH_Type[1]:='Passive';
  HH_Type[2]:='Passive';
  {***}
  Form4.SpecCond.ItemIndex:=0; {'FixThreshold=14mV'}
  Form4.DDSpinEdit5.Value:=-4;
  Form4.DDSpinEdit53.Value:=-4;
  ThrCorrection[1]:=Form4.DDSpinEdit5.Value/1000;
  ThrCorrection[2]:=Form4.DDSpinEdit53.Value/1000;
  {***}
  Form1.Passive1. Checked:=true;
  Form4.CheckBox12.Checked:=true;
  Form4.GroupBox6.Visible:=true;
  Form4.GroupBox7.Visible:=true;
  Form4.GroupBox8.Visible:=true;
  Change_HH_type;
  {***}
  Form1.CheckBox6.Checked:=false;
  YesToClean:=0;
  CorrespondParametersToTheForm;
end;

procedure TForm1.NotNoisySteadyRate1Click(Sender: TObject);
begin
  Form1.NotNoisySteadyRate1.Checked:=true;
end;

procedure TForm1.NoisySteadyRate1Click(Sender: TObject);
begin
  Form1.NoisySteadyRate1.Checked:=true;
end;

procedure TForm1.SteadyStateOfPopModel1Click(Sender: TObject);
begin
  Form1.SteadyStateOfPopModel1.Checked:=true;
  Form4.DDSpinEdit83.Value:=Vrest[1]*1000;
  Vreset[1]:=Form4.DDSpinEdit83.Value/1000;
end;

procedure TForm1.Series10DblClick(Sender: TChartSeries;
  ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  Form1.Series10.Active:=false;
end;

procedure TForm1.Series9DblClick(Sender: TChartSeries; ValueIndex: Integer;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Form1.Series9.Active:=false;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  StopKey:=Key;
end;

END.
