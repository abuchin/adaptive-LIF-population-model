unit Unit3;   {Form3 for 2D-slice}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, DDSpinEdit, Menus,
  Init, TeEngine, Series, TeeProcs, Chart;

type
  TForm3 = class(TForm)
    GroupBox1: TGroupBox;
    DDSpinEdit1: TDDSpinEdit;
    StaticText1: TStaticText;
    DDSpinEdit2: TDDSpinEdit;
    StaticText2: TStaticText;
    GroupBox2: TGroupBox;
    DDSpinEdit4: TDDSpinEdit;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    DDSpinEdit5: TDDSpinEdit;
    DDSpinEdit6: TDDSpinEdit;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    GroupBox3: TGroupBox;
    DDSpinEdit7: TDDSpinEdit;
    StaticText9: TStaticText;
    DDSpinEdit8: TDDSpinEdit;
    DDSpinEdit9: TDDSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    DDSpinEdit3: TDDSpinEdit;
    StaticText8: TStaticText;
    Button1: TButton;
    Button2: TButton;
    Label3: TLabel;
    DDSpinEdit10: TDDSpinEdit;
    DDSpinEdit11: TDDSpinEdit;
    Chart1: TChart;
    Series4: TLineSeries;
    Series3: TLineSeries;
    Series2: TLineSeries;
    Series1: TLineSeries;
    Chart2: TChart;
    Series5: TLineSeries;
    Series6: TLineSeries;
    Chart3: TChart;
    Series8: TLineSeries;
    Series9: TLineSeries;
    CheckBox1: TCheckBox;
    procedure DDSpinEdit1Change(Sender: TObject);
    procedure DDSpinEdit2Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DDSpinEdit4Change(Sender: TObject);
    procedure DDSpinEdit5Change(Sender: TObject);
    procedure DDSpinEdit6Change(Sender: TObject);
    procedure DDSpinEdit7Change(Sender: TObject);
    procedure DDSpinEdit9Change(Sender: TObject);
    procedure DDSpinEdit8Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure DDSpinEdit10Change(Sender: TObject);
    procedure DDSpinEdit11Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses Unit1, slice_2D,ph_Dens,ph_Volt,mathMy;

{$R *.DFM}

procedure TForm3.FormShow(Sender: TObject);
begin
  DefaultParameters_2D;
end;

{ SpinEdits }
procedure TForm3.DDSpinEdit1Change(Sender: TObject);
begin
  try
    ni:=imin(trunc(Form3.DDSpinEdit1.Value),mXMax);
  except
    ni:=10;
  end;
  ni_2:=trunc(ni/2);
  if ni_stim=0 then begin
     ni_stim:=trunc(3/4*ni);
     Form3.DDSpinEdit5.Value:=ni_stim;
  end;
  Form3.StaticText4.Caption:='='+IntToStr(trunc(dx*ni*1000))+' mm';
end;

procedure TForm3.DDSpinEdit2Change(Sender: TObject);
begin
  try
    nj:=imin(trunc(Form3.DDSpinEdit2.Value),mYMax);
  except
    nj:=10;
  end;
  nj_2:=trunc(nj/2);
  if nj_stim=0 then begin
     nj_stim:=trunc(1/2*nj);
     Form3.DDSpinEdit6.Value:=nj_stim;
  end;
  Form3.StaticText5.Caption:='='+IntToStr(trunc(dy*nj*1000))+' mm';
end;

procedure TForm3.DDSpinEdit4Change(Sender: TObject);
begin
  try
    R_stim:=trunc(Form3.DDSpinEdit4.Value);
  except
    R_stim:=10;
  end;
end;

procedure TForm3.DDSpinEdit5Change(Sender: TObject);
begin
  try
    ni_stim:=trunc(Form3.DDSpinEdit5.Value);
  except
    ni_stim:=trunc(3/4*ni);
  end;
  if i_view=0 then i_view:=ni_stim;
end;

procedure TForm3.DDSpinEdit6Change(Sender: TObject);
begin
  try
    nj_stim:=trunc(Form3.DDSpinEdit6.Value);
  except
    nj_stim:=trunc(nj/2);
  end;
  if j_view=0 then j_view:=nj_stim;
end;

procedure TForm3.DDSpinEdit7Change(Sender: TObject);
begin
  try
    dt_out:=Form3.DDSpinEdit7.Value/1000;
  except
    dt_out:=0.010 {s};
  end;
end;

procedure TForm3.DDSpinEdit8Change(Sender: TObject);
begin
  dx:=a_axon[1]*Form3.DDSpinEdit8.Value*dt;
  Form3.StaticText4.Caption:='='+IntToStr(trunc(dx*ni*1000))+' mm';
  dy:=dy;
  Form3.DDSpinEdit9.Value:=Form3.DDSpinEdit8.Value;
  Form3.StaticText5.Caption:='='+IntToStr(trunc(dy*nj*1000))+' mm';
end;

procedure TForm3.DDSpinEdit9Change(Sender: TObject);
begin
  dy:=a_axon[1]*Form3.DDSpinEdit9.Value*dt;
  Form3.StaticText5.Caption:='='+IntToStr(trunc(dy*nj*1000))+' mm';
end;

{ Buttons }

procedure TForm3.Button1Click(Sender: TObject);
begin
  StopKey:='2';
  DecideIfThreadAndExecute;
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  Form3.Series1.Clear;
  Form3.Series2.Clear;
  Form3.Series3.Clear;
  Form3.Series4.Clear;
  Form3.Series5.Clear;
  Form3.Series6.Clear;
  Form3.Series8.Clear;
  Form3.Series9.Clear;
end;

procedure TForm3.DDSpinEdit10Change(Sender: TObject);
begin
  i_view:=trunc(Form3.DDSpinEdit10.Value);
end;

procedure TForm3.DDSpinEdit11Change(Sender: TObject);
begin
  j_view:=trunc(Form3.DDSpinEdit11.Value);
end;

end.
