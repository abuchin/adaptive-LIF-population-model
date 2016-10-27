unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs,
  StdCtrls, DDSpinEdit,
  Init,mathMy,Correspond,ph_Dens,ph_Volt,Hodgkin;

type
  TForm4 = class(TForm)
    DDSpinEdit1: TDDSpinEdit;
    StaticText1: TStaticText;
    DDSpinEdit3: TDDSpinEdit;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    DDSpinEdit4: TDDSpinEdit;
    StaticText7: TStaticText;
    DDSpinEdit7: TDDSpinEdit;
    DDSpinEdit8: TDDSpinEdit;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
    StaticText10: TStaticText;
    DDSpinEdit9: TDDSpinEdit;
    DDSpinEdit10: TDDSpinEdit;
    DDSpinEdit11: TDDSpinEdit;
    DDSpinEdit12: TDDSpinEdit;
    DDSpinEdit13: TDDSpinEdit;
    DDSpinEdit14: TDDSpinEdit;
    StaticText11: TStaticText;
    DDSpinEdit15: TDDSpinEdit;
    DDSpinEdit16: TDDSpinEdit;
    StaticText12: TStaticText;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    DDSpinEdit17: TDDSpinEdit;
    DDSpinEdit18: TDDSpinEdit;
    StaticText13: TStaticText;
    DDSpinEdit19: TDDSpinEdit;
    DDSpinEdit20: TDDSpinEdit;
    StaticText14: TStaticText;
    DDSpinEdit21: TDDSpinEdit;
    StaticText15: TStaticText;
    Button1: TButton;
    GroupBox2: TGroupBox;
    StaticText16: TStaticText;
    StaticText17: TStaticText;
    StaticText18: TStaticText;
    StaticText19: TStaticText;
    StaticText20: TStaticText;
    StaticText21: TStaticText;
    DDSpinEdit22: TDDSpinEdit;
    DDSpinEdit23: TDDSpinEdit;
    DDSpinEdit24: TDDSpinEdit;
    DDSpinEdit25: TDDSpinEdit;
    DDSpinEdit26: TDDSpinEdit;
    DDSpinEdit27: TDDSpinEdit;
    DDSpinEdit28: TDDSpinEdit;
    DDSpinEdit29: TDDSpinEdit;
    DDSpinEdit30: TDDSpinEdit;
    DDSpinEdit31: TDDSpinEdit;
    DDSpinEdit32: TDDSpinEdit;
    DDSpinEdit33: TDDSpinEdit;
    DDSpinEdit34: TDDSpinEdit;
    DDSpinEdit35: TDDSpinEdit;
    DDSpinEdit36: TDDSpinEdit;
    DDSpinEdit37: TDDSpinEdit;
    StaticText22: TStaticText;
    CheckBox5: TCheckBox;
    DDSpinEdit38: TDDSpinEdit;
    StaticText23: TStaticText;
    DDSpinEdit39: TDDSpinEdit;
    DDSpinEdit40: TDDSpinEdit;
    DDSpinEdit41: TDDSpinEdit;
    DDSpinEdit43: TDDSpinEdit;
    StaticText25: TStaticText;
    DDSpinEdit44: TDDSpinEdit;
    StaticText26: TStaticText;
    CheckBox6: TCheckBox;
    DDSpinEdit45: TDDSpinEdit;
    StaticText27: TStaticText;
    GroupBox3: TGroupBox;
    DDSpinEdit46: TDDSpinEdit;
    StaticText28: TStaticText;
    StaticText29: TStaticText;
    DDSpinEdit47: TDDSpinEdit;
    DDSpinEdit48: TDDSpinEdit;
    StaticText30: TStaticText;
    GroupBox4: TGroupBox;
    StaticText24: TStaticText;
    DDSpinEdit42: TDDSpinEdit;
    DDSpinEdit49: TDDSpinEdit;
    DDSpinEdit50: TDDSpinEdit;
    StaticText6: TStaticText;
    DDSpinEdit51: TDDSpinEdit;
    DDSpinEdit52: TDDSpinEdit;
    StaticText2: TStaticText;
    DDSpinEdit2: TDDSpinEdit;
    StaticText5: TStaticText;
    DDSpinEdit5: TDDSpinEdit;
    DDSpinEdit53: TDDSpinEdit;
    DDSpinEdit54: TDDSpinEdit;
    StaticText31: TStaticText;
    DDSpinEdit55: TDDSpinEdit;
    DDSpinEdit56: TDDSpinEdit;
    DDSpinEdit57: TDDSpinEdit;
    StaticText32: TStaticText;
    DDSpinEdit58: TDDSpinEdit;
    StaticText33: TStaticText;
    DDSpinEdit59: TDDSpinEdit;
    StaticText34: TStaticText;
    DDSpinEdit60: TDDSpinEdit;
    DDSpinEdit61: TDDSpinEdit;
    DDSpinEdit62: TDDSpinEdit;
    DDSpinEdit63: TDDSpinEdit;
    StaticText35: TStaticText;
    DDSpinEdit64: TDDSpinEdit;
    StaticText36: TStaticText;
    DDSpinEdit65: TDDSpinEdit;
    StaticText37: TStaticText;
    DDSpinEdit66: TDDSpinEdit;
    StaticText38: TStaticText;
    DDSpinEdit67: TDDSpinEdit;
    StaticText39: TStaticText;
    DDSpinEdit68: TDDSpinEdit;
    DDSpinEdit69: TDDSpinEdit;
    StaticText40: TStaticText;
    DDSpinEdit6: TDDSpinEdit;
    StaticText41: TStaticText;
    DDSpinEdit70: TDDSpinEdit;
    GroupBox5: TGroupBox;
    DDSpinEdit71: TDDSpinEdit;
    StaticText42: TStaticText;
    DDSpinEdit72: TDDSpinEdit;
    StaticText43: TStaticText;
    DDSpinEdit73: TDDSpinEdit;
    CheckBox8: TCheckBox;
    SpecCond: TComboBox;
    CheckBox10: TCheckBox;
    StaticText44: TStaticText;
    DDSpinEdit74: TDDSpinEdit;
    i3_Combo: TComboBox;
    CheckBox9: TCheckBox;
    GroupBox6: TGroupBox;
    DDSpinEdit75: TDDSpinEdit;
    StaticText45: TStaticText;
    StaticText46: TStaticText;
    StaticText47: TStaticText;
    StaticText48: TStaticText;
    DDSpinEdit76: TDDSpinEdit;
    DDSpinEdit77: TDDSpinEdit;
    DDSpinEdit78: TDDSpinEdit;
    StaticText49: TStaticText;
    StaticText50: TStaticText;
    DDSpinEdit79: TDDSpinEdit;
    StaticText51: TStaticText;
    ComboBox1: TComboBox;
    DDSpinEdit80: TDDSpinEdit;
    DDSpinEdit81: TDDSpinEdit;
    StaticText52: TStaticText;
    StaticText53: TStaticText;
    StaticText54: TStaticText;
    DDSpinEdit82: TDDSpinEdit;
    CheckBox7: TCheckBox;
    GroupBox7: TGroupBox;
    DDSpinEdit83: TDDSpinEdit;
    DDSpinEdit84: TDDSpinEdit;
    StaticText55: TStaticText;
    StaticText56: TStaticText;
    DDSpinEdit85: TDDSpinEdit;
    DDSpinEdit86: TDDSpinEdit;
    StaticText57: TStaticText;
    DDSpinEdit87: TDDSpinEdit;
    DDSpinEdit88: TDDSpinEdit;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox15: TCheckBox;
    GroupBox8: TGroupBox;
    StaticText58: TStaticText;
    DDSpinEdit89: TDDSpinEdit;
    StaticText59: TStaticText;
    CheckBox16: TCheckBox;
    DDSpinEdit90: TDDSpinEdit;
    StaticText60: TStaticText;
    GroupBox9: TGroupBox;
    DDSpinEdit91: TDDSpinEdit;
    StaticText61: TStaticText;
    DDSpinEdit92: TDDSpinEdit;
    StaticText62: TStaticText;
    DDSpinEdit93: TDDSpinEdit;
    StaticText63: TStaticText;
    DDSpinEdit94: TDDSpinEdit;
    DDSpinEdit95: TDDSpinEdit;
    StaticText64: TStaticText;
    DDSpinEdit96: TDDSpinEdit;
    DDSpinEdit97: TDDSpinEdit;
    StaticText65: TStaticText;
    StaticText66: TStaticText;
    DDSpinEdit98: TDDSpinEdit;
    Button2: TButton;
    GroupBox10: TGroupBox;
    DDSpinEdit99: TDDSpinEdit;
    DDSpinEdit100: TDDSpinEdit;
    DDSpinEdit101: TDDSpinEdit;
    DDSpinEdit102: TDDSpinEdit;
    DDSpinEdit103: TDDSpinEdit;
    DDSpinEdit104: TDDSpinEdit;
    DDSpinEdit105: TDDSpinEdit;
    Button3: TButton;
    CheckBox11: TCheckBox;
    procedure DDSpinEdit1Change(Sender: TObject);
    procedure DDSpinEdit2Change(Sender: TObject);
    procedure DDSpinEdit3Change(Sender: TObject);
    procedure DDSpinEdit4Change(Sender: TObject);
    procedure DDSpinEdit5Change(Sender: TObject);
    procedure DDSpinEdit7Change(Sender: TObject);
    procedure DDSpinEdit8Change(Sender: TObject);
    procedure DDSpinEdit9Change(Sender: TObject);
    procedure DDSpinEdit10Change(Sender: TObject);
    procedure DDSpinEdit14Change(Sender: TObject);
    procedure DDSpinEdit13Change(Sender: TObject);
    procedure DDSpinEdit12Change(Sender: TObject);
    procedure DDSpinEdit11Change(Sender: TObject);
    procedure DDSpinEdit15Change(Sender: TObject);
    procedure DDSpinEdit16Change(Sender: TObject);
    procedure CheckBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckBox2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckBox3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckBox4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DDSpinEdit17Change(Sender: TObject);
    procedure DDSpinEdit18Change(Sender: TObject);
    procedure DDSpinEdit19Change(Sender: TObject);
    procedure DDSpinEdit20Change(Sender: TObject);
    procedure DDSpinEdit21Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure DDSpinEdit22Change(Sender: TObject);
    procedure DDSpinEdit23Change(Sender: TObject);
    procedure DDSpinEdit24Change(Sender: TObject);
    procedure DDSpinEdit25Change(Sender: TObject);
    procedure DDSpinEdit26Change(Sender: TObject);
    procedure DDSpinEdit27Change(Sender: TObject);
    procedure DDSpinEdit28Change(Sender: TObject);
    procedure DDSpinEdit29Change(Sender: TObject);
    procedure DDSpinEdit30Change(Sender: TObject);
    procedure DDSpinEdit31Change(Sender: TObject);
    procedure DDSpinEdit32Change(Sender: TObject);
    procedure DDSpinEdit33Change(Sender: TObject);
    procedure DDSpinEdit34Change(Sender: TObject);
    procedure DDSpinEdit35Change(Sender: TObject);
    procedure DDSpinEdit36Change(Sender: TObject);
    procedure DDSpinEdit37Change(Sender: TObject);
    procedure CheckBox5MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DDSpinEdit38Change(Sender: TObject);
    procedure DDSpinEdit39Change(Sender: TObject);
    procedure DDSpinEdit40Change(Sender: TObject);
    procedure DDSpinEdit41Change(Sender: TObject);
    procedure DDSpinEdit42Change(Sender: TObject);
    procedure DDSpinEdit43Change(Sender: TObject);
    procedure DDSpinEdit44Change(Sender: TObject);
    procedure CheckBox6MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DDSpinEdit45Change(Sender: TObject);
    procedure DDSpinEdit46Change(Sender: TObject);
    procedure DDSpinEdit47Change(Sender: TObject);
    procedure DDSpinEdit48Change(Sender: TObject);
    procedure DDSpinEdit53Change(Sender: TObject);
    procedure DDSpinEdit54Change(Sender: TObject);
    procedure DDSpinEdit52Change(Sender: TObject);
    procedure DDSpinEdit50Change(Sender: TObject);
    procedure DDSpinEdit49Change(Sender: TObject);
    procedure DDSpinEdit51Change(Sender: TObject);
    procedure DDSpinEdit56Change(Sender: TObject);
    procedure DDSpinEdit57Change(Sender: TObject);
    procedure DDSpinEdit58Change(Sender: TObject);
    procedure DDSpinEdit59Change(Sender: TObject);
    procedure DDSpinEdit60Change(Sender: TObject);
    procedure DDSpinEdit61Change(Sender: TObject);
    procedure DDSpinEdit62Change(Sender: TObject);
    procedure DDSpinEdit63Change(Sender: TObject);
    procedure DDSpinEdit64Change(Sender: TObject);
    procedure DDSpinEdit65Change(Sender: TObject);
    procedure DDSpinEdit66Change(Sender: TObject);
    procedure DDSpinEdit67Change(Sender: TObject);
    procedure DDSpinEdit68Change(Sender: TObject);
    procedure DDSpinEdit69Change(Sender: TObject);
    procedure DDSpinEdit6Change(Sender: TObject);
    procedure DDSpinEdit70Change(Sender: TObject);
    procedure DDSpinEdit71Change(Sender: TObject);
    procedure DDSpinEdit72Change(Sender: TObject);
    procedure DDSpinEdit73Change(Sender: TObject);
    procedure DDSpinEdit74Change(Sender: TObject);
    procedure i3_ComboChange(Sender: TObject);
    procedure CheckBox9Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DDSpinEdit80Change(Sender: TObject);
    procedure DDSpinEdit81Change(Sender: TObject);
    procedure CheckBox7Click(Sender: TObject);
    procedure DDSpinEdit56DblClick(Sender: TObject);
    procedure DDSpinEdit74DblClick(Sender: TObject);
    procedure DDSpinEdit55Change(Sender: TObject);
    procedure DDSpinEdit11DblClick(Sender: TObject);
    procedure DDSpinEdit8DblClick(Sender: TObject);
    procedure DDSpinEdit4DblClick(Sender: TObject);
    procedure DDSpinEdit12DblClick(Sender: TObject);
    procedure DDSpinEdit9DblClick(Sender: TObject);
    procedure DDSpinEdit13DblClick(Sender: TObject);
    procedure DDSpinEdit46DblClick(Sender: TObject);
    procedure DDSpinEdit83Change(Sender: TObject);
    procedure DDSpinEdit84Change(Sender: TObject);
    procedure DDSpinEdit87Change(Sender: TObject);
    procedure DDSpinEdit85Change(Sender: TObject);
    procedure DDSpinEdit88Change(Sender: TObject);
    procedure DDSpinEdit86Change(Sender: TObject);
    procedure DDSpinEdit63DblClick(Sender: TObject);
    procedure DDSpinEdit83DblClick(Sender: TObject);
    procedure DDSpinEdit84DblClick(Sender: TObject);
    procedure CheckBox14Click(Sender: TObject);
    procedure CheckBox15MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckBox16MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DDSpinEdit89DblClick(Sender: TObject);
    procedure DDSpinEdit91Change(Sender: TObject);
    procedure CheckBox16Click(Sender: TObject);
    procedure DDSpinEdit89Change(Sender: TObject);
    procedure DDSpinEdit90DblClick(Sender: TObject);
    procedure DDSpinEdit92DblClick(Sender: TObject);
    procedure DDSpinEdit92Change(Sender: TObject);
    procedure StaticText60DblClick(Sender: TObject);
    procedure DDSpinEdit93Change(Sender: TObject);
    procedure DDSpinEdit94Change(Sender: TObject);
    procedure DDSpinEdit93DblClick(Sender: TObject);
    procedure DDSpinEdit94DblClick(Sender: TObject);
    procedure DDSpinEdit67DblClick(Sender: TObject);
    procedure DDSpinEdit95Change(Sender: TObject);
    procedure DDSpinEdit95DblClick(Sender: TObject);
    procedure DDSpinEdit96Change(Sender: TObject);
    procedure DDSpinEdit97Change(Sender: TObject);
    procedure DDSpinEdit1DblClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure DDSpinEdit99Change(Sender: TObject);
    procedure DDSpinEdit100Change(Sender: TObject);
    procedure DDSpinEdit101Change(Sender: TObject);
    procedure DDSpinEdit102Change(Sender: TObject);
    procedure DDSpinEdit103Change(Sender: TObject);
    procedure DDSpinEdit104Change(Sender: TObject);
    procedure DDSpinEdit105Change(Sender: TObject);
    procedure CheckBox11Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

uses Unit1;

{$R *.DFM}

procedure TForm4.DDSpinEdit42Change(Sender: TObject);
begin
  Vrest[3]:=Form4.DDSpinEdit42.Value/1e3;
end;

procedure TForm4.DDSpinEdit43Change(Sender: TObject);
begin
  if Form4.DDSpinEdit43.Value>0 then dt:=Form4.DDSpinEdit43.Value/1000;
  nt_end:=imin(trunc(t_end/dt), mMaxExp);
  dx:=max(dx,3*a_axon[1]*dt);       dy:=max(dy,dx);   {Courant condition}
end;

procedure TForm4.DDSpinEdit1Change(Sender: TObject);
begin
  Iext:=Form4.DDSpinEdit1.Value;
end;

procedure TForm4.DDSpinEdit2Change(Sender: TObject);
begin
  Square[1]:=Form4.DDSpinEdit2.Value/1e5;
end;

procedure TForm4.DDSpinEdit3Change(Sender: TObject);
begin
  tSt:=Form4.DDSpinEdit3.Value/1000;
end;

procedure TForm4.DDSpinEdit21Change(Sender: TObject);
begin
  Qns:=Form4.DDSpinEdit21.Value;
end;

procedure TForm4.DDSpinEdit4Change(Sender: TObject);
begin
  gAMPA[1]:=Form4.DDSpinEdit4.Value;
end;

procedure TForm4.DDSpinEdit5Change(Sender: TObject);
begin
  ThrCorrection[1]:=Form4.DDSpinEdit5.Value/1000;
end;

procedure TForm4.DDSpinEdit6Change(Sender: TObject);
begin
  tauNoise:=Form4.DDSpinEdit6.Value/1000;
end;

procedure TForm4.DDSpinEdit7Change(Sender: TObject);
begin
  t_end:=Form4.DDSpinEdit7.Value/1000;
  nt_end:=imin(trunc(t_end/dt), mMaxExp);
end;

procedure TForm4.DDSpinEdit45Change(Sender: TObject);
begin
  roE:=Form4.DDSpinEdit45.Value;
end;

{*** Conductances ***}

procedure TForm4.DDSpinEdit8Change(Sender: TObject);
begin
  gAMP3[1]:=Form4.DDSpinEdit8.Value;
end;

procedure TForm4.DDSpinEdit9Change(Sender: TObject);
begin
  gGABA[1]:=Form4.DDSpinEdit9.Value;
end;

procedure TForm4.DDSpinEdit10Change(Sender: TObject);
begin
  gGABB[1]:=Form4.DDSpinEdit10.Value;
end;

procedure TForm4.DDSpinEdit11Change(Sender: TObject);
begin
  gAMP3[2]:=Form4.DDSpinEdit11.Value;
end;

procedure TForm4.DDSpinEdit12Change(Sender: TObject);
begin
  gAMPA[2]:=Form4.DDSpinEdit12.Value;
end;

procedure TForm4.DDSpinEdit13Change(Sender: TObject);
begin
  gGABA[2]:=Form4.DDSpinEdit13.Value;
end;

procedure TForm4.DDSpinEdit14Change(Sender: TObject);
begin
  gGABB[2]:=Form4.DDSpinEdit14.Value;
end;

procedure TForm4.DDSpinEdit15Change(Sender: TObject);
begin
  gGAB3[1]:=Form4.DDSpinEdit15.Value;

end;

procedure TForm4.DDSpinEdit16Change(Sender: TObject);
begin
  gGAB3[2]:=Form4.DDSpinEdit16.Value;
end;

procedure TForm4.DDSpinEdit17Change(Sender: TObject);
begin
  gNMDA[1]:=Form4.DDSpinEdit17.Value;
end;

procedure TForm4.DDSpinEdit18Change(Sender: TObject);
begin
  gNMDA[2]:=Form4.DDSpinEdit18.Value;
end;

procedure TForm4.DDSpinEdit19Change(Sender: TObject);
begin
  gNMD3[1]:=Form4.DDSpinEdit19.Value;
end;

procedure TForm4.DDSpinEdit20Change(Sender: TObject);
begin
  gNMD3[2]:=Form4.DDSpinEdit20.Value;
end;

procedure TForm4.DDSpinEdit99Change(Sender: TObject);
begin
  gAMP3[3]:=Form4.DDSpinEdit99.Value;
end;

procedure TForm4.DDSpinEdit100Change(Sender: TObject);
begin
  gNMD3[3]:=Form4.DDSpinEdit100.Value;
end;

procedure TForm4.DDSpinEdit101Change(Sender: TObject);
begin
  gGAB3[3]:=Form4.DDSpinEdit101.Value;
end;

procedure TForm4.DDSpinEdit102Change(Sender: TObject);
begin
  gAMPA[3]:=Form4.DDSpinEdit102.Value;
end;

procedure TForm4.DDSpinEdit103Change(Sender: TObject);
begin
  gNMDA[3]:=Form4.DDSpinEdit103.Value;
end;

procedure TForm4.DDSpinEdit104Change(Sender: TObject);
begin
  gGABA[3]:=Form4.DDSpinEdit104.Value;
end;

procedure TForm4.DDSpinEdit105Change(Sender: TObject);
begin
  gGABB[3]:=Form4.DDSpinEdit105.Value;
end;

{*** CheckBoxes ***}

procedure TForm4.CheckBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  IfBlockAMPA:=1-IfBlockAMPA;
  DisableSpinEdits;
end;

procedure TForm4.CheckBox2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  IfBlockNMDA:=1-IfBlockNMDA;
  DisableSpinEdits;
end;

procedure TForm4.CheckBox3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  IfBlockGABA:=1-IfBlockGABA;
  DisableSpinEdits;
end;

procedure TForm4.CheckBox4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  IfBlockGABB:=1-IfBlockGABB;
  DisableSpinEdits;
end;

procedure TForm4.CheckBox6MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  IfBlockK:=1-IfBlockK;
  DisableSpinEdits;
end;

procedure TForm4.CheckBox5MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  IfInSyn_al_EQ_beta:=1-IfInSyn_al_EQ_beta;
  DisableSpinEdits;
end;

procedure TForm4.CheckBox15MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  IfSigmoidForPresynRate:=1-IfSigmoidForPresynRate;
  DisableSpinEdits;
end;

procedure TForm4.CheckBox16MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  IfEqForVGABA:=1-IfEqForVGABA;
  DisableSpinEdits;
end;

{ Details: time constants }

procedure TForm4.Button1Click(Sender: TObject);
begin
  Form4.GroupBox2.Visible:=not(Form4.GroupBox2.Visible);
  Form4.GroupBox3.Visible:=not(Form4.GroupBox3.Visible);
  Form4.GroupBox4.Visible:=not(Form4.GroupBox4.Visible);
  Form4.GroupBox5.Visible:=not(Form4.GroupBox5.Visible);
end;

procedure TForm4.DDSpinEdit22Change(Sender: TObject);
begin
  alAMPA[1]:=Form4.DDSpinEdit22.Value;
end;

procedure TForm4.DDSpinEdit23Change(Sender: TObject);
begin
  alNMDA[1]:=Form4.DDSpinEdit23.Value;
end;

procedure TForm4.DDSpinEdit24Change(Sender: TObject);
begin
  alGABA[1]:=Form4.DDSpinEdit24.Value;
end;

procedure TForm4.DDSpinEdit25Change(Sender: TObject);
begin
  alGABB[1]:=Form4.DDSpinEdit25.Value;
end;

procedure TForm4.DDSpinEdit26Change(Sender: TObject);
begin
  beAMPA[1]:=Form4.DDSpinEdit26.Value;
end;

procedure TForm4.DDSpinEdit27Change(Sender: TObject);
begin
  beNMDA[1]:=Form4.DDSpinEdit27.Value;
end;

procedure TForm4.DDSpinEdit28Change(Sender: TObject);
begin
  beGABA[1]:=Form4.DDSpinEdit28.Value;
end;

procedure TForm4.DDSpinEdit29Change(Sender: TObject);
begin
  beGABB[1]:=Form4.DDSpinEdit29.Value;
end;

procedure TForm4.DDSpinEdit30Change(Sender: TObject);
begin
  alAMPA[2]:=Form4.DDSpinEdit30.Value;
end;

procedure TForm4.DDSpinEdit31Change(Sender: TObject);
begin
  alNMDA[2]:=Form4.DDSpinEdit31.Value;
end;

procedure TForm4.DDSpinEdit32Change(Sender: TObject);
begin
  alGABA[2]:=Form4.DDSpinEdit32.Value;
end;

procedure TForm4.DDSpinEdit33Change(Sender: TObject);
begin
  alGABB[2]:=Form4.DDSpinEdit33.Value;
end;

procedure TForm4.DDSpinEdit34Change(Sender: TObject);
begin
  beAMPA[2]:=Form4.DDSpinEdit34.Value;
end;

procedure TForm4.DDSpinEdit35Change(Sender: TObject);
begin
  beNMDA[2]:=Form4.DDSpinEdit35.Value;
end;

procedure TForm4.DDSpinEdit36Change(Sender: TObject);
begin
  beGABA[2]:=Form4.DDSpinEdit36.Value;
end;

procedure TForm4.DDSpinEdit37Change(Sender: TObject);
begin
  beGABB[2]:=Form4.DDSpinEdit37.Value;
end;

procedure TForm4.DDSpinEdit38Change(Sender: TObject);
begin
  VAMPA:=Form4.DDSpinEdit38.Value/1e3;
end;

procedure TForm4.DDSpinEdit39Change(Sender: TObject);
begin
  VNMDA:=Form4.DDSpinEdit39.Value/1e3;
end;

procedure TForm4.DDSpinEdit40Change(Sender: TObject);
begin
  VGABA:=Form4.DDSpinEdit40.Value/1e3;
end;

procedure TForm4.DDSpinEdit41Change(Sender: TObject);
begin
  VGABB:=Form4.DDSpinEdit41.Value/1e3;
end;

procedure TForm4.DDSpinEdit44Change(Sender: TObject);
begin
  Mg:=Form4.DDSpinEdit44.Value;
end;

{ Stimulation Group }
procedure TForm4.DDSpinEdit46Change(Sender: TObject);
begin
  I_ind:=Form4.DDSpinEdit46.Value;
end;

procedure TForm4.DDSpinEdit47Change(Sender: TObject);
begin
  nu_ind:=Form4.DDSpinEdit47.Value;
end;

procedure TForm4.DDSpinEdit48Change(Sender: TObject);
begin
  t_ind:=Form4.DDSpinEdit48.Value/1e3;
end;

procedure TForm4.DDSpinEdit70Change(Sender: TObject);
begin
  NoiseToSgn:=Form4.DDSpinEdit70.Value;
end;

{ Properties Group }
procedure TForm4.DDSpinEdit49Change(Sender: TObject);
begin
  Vrest[1]:=Form4.DDSpinEdit49.Value/1e3;
end;

procedure TForm4.DDSpinEdit50Change(Sender: TObject);
begin
  Vrest[2]:=Form4.DDSpinEdit50.Value/1e3;
end;

procedure TForm4.DDSpinEdit51Change(Sender: TObject);
begin
  tau_m[1]:=Form4.DDSpinEdit51.Value/1e3;
end;

procedure TForm4.DDSpinEdit52Change(Sender: TObject);
begin
  tau_m[2]:=Form4.DDSpinEdit52.Value/1e3;
end;

procedure TForm4.DDSpinEdit53Change(Sender: TObject);
begin
  ThrCorrection[2]:=Form4.DDSpinEdit53.Value/1e3;
end;

procedure TForm4.DDSpinEdit54Change(Sender: TObject);
begin
  Square[2]:=Form4.DDSpinEdit54.Value/1e5;
end;

procedure TForm4.DDSpinEdit55Change(Sender: TObject);
begin
  sgm_V[1]:=Form4.DDSpinEdit55.Value/1000;
end;

procedure TForm4.DDSpinEdit73Change(Sender: TObject);
begin
  sgm_V[2]:=Form4.DDSpinEdit73.Value/1000;
end;

procedure TForm4.DDSpinEdit56Change(Sender: TObject);
begin
  gAHP[1]:=Form4.DDSpinEdit56.Value;
end;

procedure TForm4.DDSpinEdit57Change(Sender: TObject);
begin
  gAHP[2]:=Form4.DDSpinEdit57.Value;
end;

procedure TForm4.DDSpinEdit58Change(Sender: TObject);
begin
  gam[1]:=Form4.DDSpinEdit58.Value;
end;

procedure TForm4.DDSpinEdit59Change(Sender: TObject);
begin
  gam[2]:=Form4.DDSpinEdit59.Value;
end;

procedure TForm4.DDSpinEdit60Change(Sender: TObject);
begin
  gBst[1]:=Form4.DDSpinEdit60.Value;
end;

procedure TForm4.DDSpinEdit61Change(Sender: TObject);
begin
  gBst[2]:=Form4.DDSpinEdit61.Value;
end;

procedure TForm4.DDSpinEdit62Change(Sender: TObject);
begin
  tau_Bst:=Form4.DDSpinEdit62.Value;
end;

procedure TForm4.DDSpinEdit63Change(Sender: TObject);
begin
  Nts:=trunc(Form4.DDSpinEdit63.Value);
  Nts:=imin(Nts,MaxPh);
end;

procedure TForm4.DDSpinEdit63DblClick(Sender: TObject);
begin
  Form4.DDSpinEdit63.Value:=1;
  Nts:=trunc(Form4.DDSpinEdit63.Value);
end;

procedure TForm4.DDSpinEdit64Change(Sender: TObject);
begin
  ts_end:=Form4.DDSpinEdit64.Value/1000;
end;

procedure TForm4.DDSpinEdit65Change(Sender: TObject);
begin
  gGJ_I[2]:=Form4.DDSpinEdit65.Value;
end;

procedure TForm4.DDSpinEdit66Change(Sender: TObject);
begin
  gGJ_E[1]:=Form4.DDSpinEdit66.Value;
end;

procedure TForm4.DDSpinEdit67Change(Sender: TObject);
begin
  dtSt:=Form4.DDSpinEdit67.Value/1000;
end;

procedure TForm4.DDSpinEdit68Change(Sender: TObject);
begin
  gNaP[1]:=Form4.DDSpinEdit68.Value;
end;

procedure TForm4.DDSpinEdit69Change(Sender: TObject);
begin
  gNaP[2]:=Form4.DDSpinEdit69.Value;
end;

procedure TForm4.DDSpinEdit74Change(Sender: TObject);
begin
  gKM[1]:=Form4.DDSpinEdit74.Value;
end;

{ Show parameters group }

procedure TForm4.DDSpinEdit71Change(Sender: TObject);
begin
  n_show:=trunc(Form4.DDSpinEdit71.Value);
end;

procedure TForm4.DDSpinEdit72Change(Sender: TObject);
begin
  PlotWindow:=min(Form4.DDSpinEdit72.Value,t_end*1000);
end;

procedure TForm4.DDSpinEdit80Change(Sender: TObject);
begin
  n_DrawPhase:=trunc(Form4.DDSpinEdit80.Value);
end;

procedure TForm4.DDSpinEdit81Change(Sender: TObject);
begin
  n_Write:=trunc(Form4.DDSpinEdit81.Value);
end;

procedure TForm4.i3_ComboChange(Sender: TObject);
begin
  i3:=3-i3;
  CorrespondParametersToTheForm;
end;

procedure TForm4.CheckBox7Click(Sender: TObject);
begin
  CorrespondParametersToTheForm;
end;

procedure TForm4.CheckBox9Click(Sender: TObject);
begin
  CorrespondParametersToTheForm;
end;

procedure TForm4.CheckBox14Click(Sender: TObject);
begin
  CorrespondParametersToTheForm;
end;

procedure TForm4.CheckBox16Click(Sender: TObject);
begin
  if (Form4.CheckBox16.Checked)or(Form4.CheckBox12.Checked) then begin
      Form4.GroupBox6.Visible:=true;
      Form4.GroupBox7.Visible:=true;
      Form4.GroupBox8.Visible:=true;
      Form4.GroupBox9.Visible:=true;
  end else begin
      Form4.GroupBox6.Visible:=false;
      Form4.GroupBox7.Visible:=false;
      Form4.GroupBox8.Visible:=false;
      Form4.GroupBox9.Visible:=false;
  end;
  VGABA0:=VGABA;
end;

procedure TForm4.FormShow(Sender: TObject);
begin
  Form4.ComboBox1.ItemIndex:=0;
end;

procedure TForm4.DDSpinEdit56DblClick(Sender: TObject);
begin
  Form4.DDSpinEdit56.Value:=0;
end;

procedure TForm4.DDSpinEdit74DblClick(Sender: TObject);
begin
  Form4.DDSpinEdit74.Value:=0;
end;

procedure TForm4.DDSpinEdit11DblClick(Sender: TObject);
begin
  Form4.DDSpinEdit11.Value:=0;
end;

procedure TForm4.DDSpinEdit8DblClick(Sender: TObject);
begin
  Form4.DDSpinEdit8.Value:=0;
end;

procedure TForm4.DDSpinEdit4DblClick(Sender: TObject);
begin
  Form4.DDSpinEdit4.Value:=0;
end;

procedure TForm4.DDSpinEdit12DblClick(Sender: TObject);
begin
  Form4.DDSpinEdit12.Value:=0;
end;

procedure TForm4.DDSpinEdit9DblClick(Sender: TObject);
begin
  Form4.DDSpinEdit9.Value:=0;
end;

procedure TForm4.DDSpinEdit13DblClick(Sender: TObject);
begin
  Form4.DDSpinEdit13.Value:=0;
end;

procedure TForm4.DDSpinEdit46DblClick(Sender: TObject);
begin
  Form4.DDSpinEdit46.Value:=0;
end;

procedure TForm4.DDSpinEdit83Change(Sender: TObject);
begin
  Vreset[1]:=Form4.DDSpinEdit83.Value/1e3;
end;

procedure TForm4.DDSpinEdit84Change(Sender: TObject);
begin
  Vreset[2]:=Form4.DDSpinEdit84.Value/1e3;
end;

procedure TForm4.DDSpinEdit83DblClick(Sender: TObject);
begin
  Vreset[1]:=Vrest[1];
  Form4.DDSpinEdit83.Value:=Vreset[1]*1e3;
end;

procedure TForm4.DDSpinEdit84DblClick(Sender: TObject);
begin
  Vreset[2]:=Vrest[2];
  Form4.DDSpinEdit84.Value:=Vreset[2]*1e3;
end;

procedure TForm4.DDSpinEdit85Change(Sender: TObject);
begin
  gKA[1]:=Form4.DDSpinEdit85.Value;
end;

procedure TForm4.DDSpinEdit86Change(Sender: TObject);
begin
  gKA[2]:=Form4.DDSpinEdit86.Value;
end;

procedure TForm4.DDSpinEdit87Change(Sender: TObject);
begin
  gK[1]:=Form4.DDSpinEdit87.Value;
end;

procedure TForm4.DDSpinEdit88Change(Sender: TObject);
begin
  gK[2]:=Form4.DDSpinEdit88.Value;
end;

procedure TForm4.DDSpinEdit89DblClick(Sender: TObject);
begin
  Form4.DDSpinEdit89.Value:=0;
end;

procedure TForm4.DDSpinEdit92DblClick(Sender: TObject);
begin
  Form4.DDSpinEdit92.Value:=0;
end;

procedure TForm4.DDSpinEdit91Change(Sender: TObject);
begin
  pext_Iext:=Form4.DDSpinEdit91.Value;
end;

procedure TForm4.DDSpinEdit89Change(Sender: TObject);
begin
  factorI:=Form4.DDSpinEdit89.Value;
end;

procedure TForm4.DDSpinEdit92Change(Sender: TObject);
begin
  factorE:=Form4.DDSpinEdit92.Value;
end;

procedure TForm4.DDSpinEdit90DblClick(Sender: TObject);
begin
  Form4.DDSpinEdit90.Enabled:=not(Form4.DDSpinEdit90.Enabled);
end;

procedure TForm4.StaticText60DblClick(Sender: TObject);
begin
  Form4.DDSpinEdit90.Enabled:=not(Form4.DDSpinEdit90.Enabled);
end;

procedure TForm4.DDSpinEdit93Change(Sender: TObject);
begin
  t0s:=Form4.DDSpinEdit93.Value/1e3;
end;

procedure TForm4.DDSpinEdit94Change(Sender: TObject);
begin
  nStimuli:=trunc(Form4.DDSpinEdit94.Value);
end;

procedure TForm4.DDSpinEdit93DblClick(Sender: TObject);
begin
  Form4.DDSpinEdit93.Value:=0;
  t0s:=0;
end;

procedure TForm4.DDSpinEdit94DblClick(Sender: TObject);
begin
  Form4.DDSpinEdit94.Value:=0;
  nStimuli:=0;
end;

procedure TForm4.DDSpinEdit67DblClick(Sender: TObject);
begin
  Form4.DDSpinEdit67.Value:=0;
  dtSt:=0;
end;

procedure TForm4.DDSpinEdit95Change(Sender: TObject);
begin
  dt_T:=Form4.DDSpinEdit95.Value/1e3;
end;

procedure TForm4.DDSpinEdit95DblClick(Sender: TObject);
begin
  Form4.DDSpinEdit95.Value:=0;
  dt_T:=0;
end;

procedure TForm4.DDSpinEdit96Change(Sender: TObject);
begin
  C_membr[1]:=Form4.DDSpinEdit96.Value/1e3;
end;

procedure TForm4.DDSpinEdit97Change(Sender: TObject);
begin
  C_membr[2]:=Form4.DDSpinEdit97.Value/1e3;
end;

procedure TForm4.DDSpinEdit1DblClick(Sender: TObject);
begin
  Form4.DDSpinEdit1.Value:=0;
  Iext:=0;
end;

procedure TForm4.Button3Click(Sender: TObject);
begin
  Form4.GroupBox10.Visible:=false;
end;

procedure TForm4.Button2Click(Sender: TObject);
begin
  Form4.GroupBox10.Visible:=true;
end;

procedure TForm4.CheckBox11Click(Sender: TObject);
begin
  if not(Form4.CheckBox11.Checked) then gSyn_From_i3;
  CorrespondParametersToTheForm;
end;

end.
