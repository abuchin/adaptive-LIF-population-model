unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TeEngine, Series, ExtCtrls, TeeProcs, Chart,
  typeNrnPars, NeuronO, CreateNrnO, SetNrnPars, Spin, Koshhax, MathMyo,
   EEG, Init, Math, DDSpinEdit;


type
    mas=array[0..100000] of double;
    TForm1 = class(TForm)
    Chart1: TChart;
    Series1: TLineSeries;
    Label1: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    Label2: TLabel;
    Label4: TLabel;
    Chart5: TChart;
    LineSeries4: TLineSeries;
    Label5: TLabel;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Label6: TLabel;
    Label10: TLabel;
    Chart6: TChart;
    LineSeries5: TLineSeries;
    CheckBox5: TCheckBox;
    SpinEdit13: TSpinEdit;

    Label13: TLabel;
    Label3: TLabel;
    Chart8: TChart;
    Series3: TLineSeries;
    CheckBox8: TCheckBox;
    Chart9: TChart;
    Series5: TLineSeries;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox15: TCheckBox;
    CheckBox16: TCheckBox;
    CheckBox6: TCheckBox;
    Button2: TButton;
    CheckBox9: TCheckBox;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    Chart2: TChart;
    LineSeries1: TLineSeries;
    SpinEdit7: TSpinEdit;
    SpinEdit8: TSpinEdit;
    Label7: TLabel;
    Label8: TLabel;
    CheckBox17: TCheckBox;
    CheckBox18: TCheckBox;
    SpinEdit9: TSpinEdit;
    Label9: TLabel;
    CheckBox19: TCheckBox;
    Label11: TLabel;
    SpinEdit11: TSpinEdit;
    Series7: TLineSeries;
    Label14: TLabel;
    SpinEdit14: TSpinEdit;
    Series9: TLineSeries;
    Series10: TLineSeries;
    Series8: TLineSeries;
    CheckBox20: TCheckBox;
    CheckBox21: TCheckBox;
    Series12: TLineSeries;
    SpinEdit15: TSpinEdit;
    Label15: TLabel;
    SpinEdit16: TSpinEdit;
    Label16: TLabel;
    ListBox1: TListBox;
    CheckBox22: TCheckBox;
    CheckBox23: TCheckBox;
    CheckBox24: TCheckBox;
    CheckBox25: TCheckBox;
    CheckBox26: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox7: TCheckBox;
    Label17: TLabel;
    Label18: TLabel;
    CheckBox27: TCheckBox;
    CheckBox28: TCheckBox;
    SpinEdit17: TSpinEdit;
    Label19: TLabel;
    SpinEdit18: TSpinEdit;
    Label20: TLabel;
    SpinEdit19: TSpinEdit;
    Label21: TLabel;
    Chart3: TChart;
    LineSeries2: TLineSeries;
    LineSeries3: TLineSeries;
    Chart4: TChart;
    LineSeries6: TLineSeries;
    LineSeries7: TLineSeries;
    Series2: TLineSeries;
    CheckBox29: TCheckBox;
    CheckBox30: TCheckBox;
    Label22: TLabel;
    SpinEdit12: TSpinEdit;
    Label12: TLabel;
    CheckBox31: TCheckBox;
    Label23: TLabel;
    SpinEdit21: TSpinEdit;
    CheckBox32: TCheckBox;
    Label24: TLabel;
    DDSpinEdit1: TDDSpinEdit;
    DDSpinEdit2: TDDSpinEdit;
    DDSpinEdit3: TDDSpinEdit;
    DDSpinEdit4: TDDSpinEdit;
    DDSpinEdit5: TDDSpinEdit;
    procedure CheckBox7Click(Sender: TObject);
    procedure CheckBox10Click(Sender: TObject);



procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  Form1 :TForm1;
  NP    :NeuronProperties;
  ANrn  :TNeuron;
  ANrn1  :TNeuron;
  MembranePotentialMax, MembranePotentialMax1, spike_time, spike_time1,
  {temp,} temp1 : mas;
   freq, time, oldnoise :mas;
  nt_end,nt,ifspike:integer;

  t,w_simple,w_f, Vrest,sum,Xi, Zi,
  Int_w_full,Int_w_simple, fr,
  t1, t0, dt :real;

  U_init, W_init, U2_init, temp, tau_1:double;

  noise_ratio,omega, color_noise, modA: double;

  implementation

uses Unit2;


Procedure Read_File (var TXT:integer);
{Data from Full population models}
var
 aaa:text;
 p{, frequency, time}:mas;
 i:integer;

BegiN



if TXT=1 then
{Im=500 pA; sigm=2; Vrest=65.7 mV; Vreset=75.1 mV; tau_m=14.4 ms; Vt=10 mV}
 begin
   assign(aaa,'LIF+AHP+KM_500pA_VT10_sgmV2_Vrest65_7_Vreset75_1_taum14_4.dat'); reset(aaa);
   i:=-1;
   repeat i:=i+1;
   readln(aaa,time[i],p[i],p[i],p[i],p[i],freq[i]);
   Form1.Series2.AddXY( time[i], freq[i]);
//   application.ProcessMessages;
   until (eof(aaa));

     close(aaa);
 end;

if TXT=2 then
{Im=500 pA; sigm=2; Vrest=65.7 mV; Vreset=75.1 mV; tau_m=14.4 ms; Vt=10 mV}
 begin
   assign(aaa,'RD.dat'); reset(aaa);
   i:=-1;
   repeat i:=i+1;
   readln(aaa,time[i],p[i],p[i],p[i],p[i],freq[i]);
   Form1.Series2.AddXY( time[i], freq[i]);
   until (eof(aaa));
     close(aaa);
 end;

if TXT=3 then
{Im=500 pA; sigm=2; Vrest=65.7 mV; Vreset=75.1 mV; tau_m=14.4 ms; Vt=10 mV}
 begin
   assign(aaa,'LIF+KM_500pA_VT10_sgmV2_Vrest65_7_Vreset75_1_taum14_4.dat'); reset(aaa);
  // assignfile(qqq,'frM.dat'); rewrite(qqq);
   i:=-1;
   repeat i:=i+1;
   readln(aaa,time[i],p[i],p[i],p[i],p[i],freq[i]);
   //writeln(qqq,' ',frequency[i]:10:3);
   Form1.Series2.AddXY( time[i], freq[i]);
   until (eof(aaa));
     close(aaa);
  //   close(qqq);
 end;

if TXT=4 then
{Im=500 pA; sigm=2; Vrest=65.7 mV; Vreset=75.1 mV; tau_m=14.4 ms; Vt=10 mV}
 begin
   assign(aaa,'LIF+AHP_500pA_VT10_sgmV2_Vrest65_7_Vreset75_1_taum14_4.dat'); reset(aaa);
   i:=-1;
   repeat i:=i+1;
   readln(aaa,time[i],p[i],p[i],p[i],p[i],freq[i]);
   Form1.Series2.AddXY( time[i], freq[i]);
   until (eof(aaa));
     close(aaa);
 end;

if TXT=5 then
{Im=500 pA; sigm=2; Vrest=65.7 mV; Vreset=75.1 mV; tau_m=14.4 ms; Vt=10 mV}
 begin
   assign(aaa,'Pop+all.dat'); reset(aaa);
   i:=-1;
   repeat i:=i+1;
   readln(aaa,time[i],freq[i]);
   Form1.Series2.AddXY( time[i], freq[i]);
   until (eof(aaa));
     close(aaa);
 end;

 if TXT=6 then
{Im=500 pA; sigm=2; Vrest=65.7 mV; Vreset=75.1 mV; tau_m=14.4 ms; Vt=10 mV}
 begin
   assign(aaa,'RD+all.dat'); reset(aaa);
   i:=-1;
   repeat i:=i+1;
   readln(aaa,time[i],p[i],p[i],p[i],p[i],freq[i]);
   Form1.Series2.AddXY( time[i], freq[i]);
   until (eof(aaa));
     close(aaa);
 end;

 if TXT=7 then
{Voltage induced by noise}
 begin
   assign(aaa,'Fig1B_Mainen1995_V.dat'); reset(aaa);
   i:=-1;
   repeat i:=i+1;
   readln(aaa,time[i],freq[i]);
if Form1.CheckBox29.Checked then Form1.Series12.AddXY( time[i], freq[i]);
if form1.ListBox1.ItemIndex=1 then  Form1.Series8.AddXY( time[i], freq[i]);
   until time[i]>=nt_end*dt*1000;//(eof(aaa));
     close(aaa);
 end;

 EnD;

Function if_spike(A,B,C:double):integer;


Begin
if  (B>A) and (B>C) {and (A>0) and(B>0) and (C>0)} then
 begin

 if_spike:=1;
 end
        else if_spike:=0;
End;

Function frequency (X, Y :mas):real;

var
 spike_max:mas;
 p,n:integer;
 i:integer;
 temp:double;

BegiN

p:=0;
for i:=1 to nt do
bEGIN


if (X[i]>X[i-1]) and
   (X[i]>X[i+1])
then

BEgin

p:=p+1;
n:=p;
                                {intitialisation of t1 and t0}
 {if p=1 then  begin
              t1:=Y[i]; t0:=0;
              end

         else begin}
              t0:=t1; t1:=Y[i];
              //end;
//temp:=frequency(X,Y);
{if t*1000<= t0 + 2*(t1-t0) then frequency:=1000/(t1-t0)
                           else}  frequency:=n/t;
                                 //frequency:=({temp +} 1/(1+t1-t0){/n} );

ENd;

eND;

EnD;
{$R *.dfm}

Procedure Parametersforneuron;
begin

{Parameters for Lyle neuron}
if Form1.CheckBox28.Checked=false then ANRN.Np.gKD:=0;
if Form1.CheckBox8.Checked=false then Anrn.NP.gNa:=0;
if Form1.CheckBox15.Checked=false then Anrn.NP.gKa:=0;
if Form1.CheckBox3.Checked=false then ANrn.NP.gAHP:=0;
if Form1.CheckBox4.Checked=false then ANrn.NP.gKM:=0;
if Form1.CheckBox14.Checked=false then ANrn.NP.gH:=0;
if Form1.CheckBox16.Checked=false then ANrn.NP.gK:=0;

ANrn.NP.Square:=Form1.SpinEdit16.Value/1000000;
ANrn.NP.tau_m:=Form1.Spinedit17.Value/10000;
anrn.np.Vrest:=Form1.DDSpinEdit4.Value/1000;
anrn.np.Vreset:=Form1.SpinEdit18.Value/10000;
ANrn.NP.Square:=Form1.SpinEdit19.Value/1000000;          {e-5 cm^2}


{Parameters for Buchin neuron}
if Form1.CheckBox1.Checked=false then Anrn1.NP.gAHP:=0;
if Form1.CheckBox2.Checked=false then Anrn1.NP.gKM:=0;
if Form1.CheckBox5.Checked=false then ANrn1.NP.gNa:=0;
if Form1.CheckBox12.Checked=false then ANrn1.NP.gKA:=0;
if Form1.CheckBox11.Checked=false then ANrn1.NP.gH:=0;
if Form1.CheckBox13.Checked=false then ANrn1.NP.gK:=0;
if Form1.CheckBox27.Checked=false then ANRN1.Np.gKD:=0;

ANrn1.NP.tau_m:=Form1.Spinedit15.Value/10000;             {s}
ANrn1.NP.Square:=Form1.SpinEdit16.Value/1000000;          {e-5 cm^2}
anrn1.np.Vrest:=Form1.SpinEdit14.Value/1000;
anrn1.np.Vreset:=Form1.SpinEdit13.Value/1000;

end;

procedure  ReadExpData(var nE,tt:mas);
{
  Reading of experimental data as arrays: tE[0..200] -- time moments;
  E[0..N] -- values.
  Interpolation (linear) is applied to fill the array 'Vexp'.
}
var
     i,j,Max_j               :integer;
     k                     :double;
     E,tE                  :array[0..10000] of double;
begin

 assignfile(aaa,'Fig 1b Mainenen  (noise).dat');  reset(aaa);
  j:=-1;
  repeat  j:=j+1;                                {reading}
    readln(aaa,tE[j],E[j]);
  until (eof(aaa));
  Max_j:=j;

 close(aaa);

  { Filling array 'Vmod' }

  nt:=-1;

  repeat  nt:=nt+1;                    {creating new time mass}
    tt[nt]:=nt*dt;
    nE[nt]:=0;
  until  nt>=nt_end;



for nt:=0 to nt_end do begin                  {linear interpolation}
           for j:=0 to Max_j do  begin
if (tE[j+1]>tt[nt]*1000) and (tt[nt]*1000>tE[j]) then      begin
                      //if tt[nt]*1000>=tE[j+1] then  j:=j+1;
                      if nE[nt]=0 then  begin
                        // Form1.Series8.AddXY(tt[nt]*1000, (tE[j+1]-tE[j]));
                         k:=(E[j+1]-E[j])/(tE[j+1]-tE[j]);
                         nE[nt]:=k*tt[nt]*1000+E[j]-k*tE[j];    {pA & ms}
                                        end;
                                                 end;
                                 end;
                       end;
end;


procedure TForm1.Button1Click(Sender: TObject);
var
    i:integer;
    Iind,Iind1, p,U0, U, V_T, Tr, tt, frfr, ttemp, noise   :double;
    time, input :mas;
begin

  { Set parameters }
  nt_end:=Form1.SpinEdit2.Value*10;

  dt:= 0.0001;

  { Defining the types of neurons }
  NP.HH_type:='Lyle';
  NP.HH_order:='1-point';
  HodgkinPhysParameters(NP);
  CreateNeuronByTypeO(NP, ANrn);

  NP.HH_type:='Buchin';
  NP.HH_order:='1-point';
  HodgkinPhysParameters(NP);
  CreateNeuronByTypeO(NP, ANrn1);

  Parametersforneuron;

ANrn1.InitialConditions;
ANrn.InitialConditions;

  Form1.Series1.Clear;
  Form1.Series2.Clear;
  Form1.Series3.Clear;
  Form1.LineSeries2.Clear;
  Form1.Series5.Clear;
  Form1.Series7.Clear;
  Form1.Series8.Clear;
  Form1.Series12.Clear;

  Form1.LineSeries1.Clear;
  Form1.LineSeries3.Clear;
  Form1.LineSeries4.Clear;
  Form1.LineSeries5.Clear;
  Form1.LineSeries6.Clear;
  Form1.Series2.Clear;
//  Form1.LineSeries9.Clear;

  Xi:=form1.spinedit4.Value/1000;
  Zi:=form1.spinedit3.Value/1000;
  nt:=0;

   ifspike:=0;
   modA:=Form1.DDSpinEdit2.Value;

  t1:=0; t0:=0;

  U_init:=0; W_init:=0; U2_init:=0;

Vrest:=form1.DDSpinEdit4.Value;

if Form1.Checkbox25.Checked then i:=1;               {RD+AHP+M}
if Form1.Checkbox22.Checked then i:=2;               {RD}
if Form1.Checkbox23.Checked then i:=3;               {RD+M}
if Form1.Checkbox24.Checked then i:=4;               {RD+AHP}
if Form1.Checkbox26.Checked then i:=5;               {Neurons}

Read_File(i);
{
  for i:=0 to 10000 do begin
                        MembranePotentialMax1[i]:=0;
                        MembranePotentialMax[i]:=0;
                        Spike_time1[i]:=0;
                        Spike_time[i]:=0;
                        end;
}
if form1.RadioButton8.Checked then Tr:=-70;
if form1.RadioButton7.Checked then Tr:=0;



//assignfile(ccc,'input_150pA.dat'); rewrite (ccc);
//assignfile(ccc,'fr_noisesign=0.05_I=150pA_sigmV=1_tau_cor=3.dat'); rewrite (ccc);
//assignfile(qqq,'INPut_noisesign=0.05_I=150pA_sigmV=1_tau_cor=3.dat'); rewrite(qqq);
//assignfile(aaa,'RD+AHP.dat'); reset(aaa);
//assignfile(ccc,'fr_noisetosignal=0.01_tau=3ms_sigma=1.0.dat'); rewrite (ccc);
//assignfile(aaa,'noise (Ermentrout 2008).dat'); reset (aaa);
if (Form1.ListBox1.ItemIndex=1) //or (Form1.ListBox1.ItemIndex=3)
                               then begin
                                    ReadExpData(input,time);
                                    nt:=7;
                                    Read_File(nt);
                                    end;

if (Form1.ListBox1.ItemIndex=4) and (nt=0) then repeat i:=i+1; t:=i*dt;
                                            oldnoise[i]:=randG(0,1);
                                            until  t*1000>=nt_end/10;
nt:=0;
omega:=form1.SpinEdit12.Value;
color_noise:=0;
noise_ratio:=Form1.SpinEdit1.Value*Form1.DDSpinEdit1.Value;

  REPEAT

    nt:=nt+1;                                          { time step }
                                                   //step current
    if Form1.ListBox1.ItemIndex=0 then  begin
                         t:=nt*dt;
           if form1.CheckBox31.Checked=false then begin
    Iind:=Form1.SpinEdit1.Value/(ANrn.NP.Square*1e9);
    Iind1:=Form1.SpinEdit1.Value/(ANrn1.NP.Square*1e9);
                                                  end
                                             else
                                                  begin
    Iind:=Form1.SpinEdit1.Value*sin(omega*t)/(ANrn.NP.Square*1e9);
    Iind1:=Form1.SpinEdit1.Value*sin(omega*t)/(ANrn1.NP.Square*1e9);
                                                  end;

  //                     writeln(ccc,t*1000:10:3,' ',tt:10:5);
 //  if Form1.CheckBox30.Checked then Form1.Series3.AddXY( t*1000, Iind1*ANrn.NP.Square*1e9);
                                         end;



    if Form1.ListBox1.ItemIndex=1 then  begin         {readfile}
                         t:=time[nt];
                         Iind:=Form1.SpinEdit1.Value/150*input[nt]/(ANrn.NP.Square*1e9);
                         Iind1:=Form1.SpinEdit1.Value/150*input[nt]/(ANrn1.NP.Square*1e9);
   if Form1.CheckBox30.Checked  then  Form1.Series3.AddXY( t*1000, input[nt]);
  //   Form1.Series4.AddXY( t*1000, RateFromBiofizika2002(U));
                                         end;

    if Form1.ListBox1.ItemIndex=2 then  begin         {white noise modulation}
    t:=nt*dt;
if form1.CheckBox31.Checked=false then  begin
Iind:=(randg(0,form1.DDspinedit1.value*form1.spinedit1.value) +Form1.SpinEdit1.Value )/(ANrn.NP.Square*1e9);
Iind1:=( randg(0,form1.DDspinedit1.value*form1.spinedit1.value) +Form1.SpinEdit1.Value )/(ANrn1.NP.Square*1e9);
                                        end
                                             else
                                                  begin
Iind:=(Form1.SpinEdit1.Value + modA*sin(omega*t) + randg(0,form1.DDspinedit1.value*form1.spinedit1.value) )/(ANrn.NP.Square*1e9);
Iind1:=(Form1.SpinEdit1.Value + modA*sin(omega*t) + randg(0,form1.DDspinedit1.value*form1.spinedit1.value) )/(ANrn1.NP.Square*1e9);
                                                  end;
//if form1.CheckBox30.Checked then  Form1.Series3.AddXY(t*1000,Iind1*ANrn.NP.Square*1e9);
                                        end;

    if Form1.ListBox1.ItemIndex=3 then  begin        {colored noise modulation}
    t:=nt*dt;
    color_noise:=color_noise-dt*1000/Form1.SpinEdit21.Value*color_noise
    +sqrt(2*dt*1000/Form1.SpinEdit21.Value)*noise_ratio*randG(0,1);

    if form1.CheckBox31.Checked=false then begin
Iind:=(Form1.SpinEdit1.Value + color_noise)/(ANrn.NP.Square*1e9);
Iind1:=(Form1.SpinEdit1.Value + color_noise)/(ANrn1.NP.Square*1e9);
                                           end
                                             else
                                                   begin
Iind:=( Form1.SpinEdit1.Value + modA*sin(omega*t) + color_noise )/(ANrn.NP.Square*1e9);
Iind1:=( Form1.SpinEdit1.Value + modA*sin(omega*t) + color_noise )/(ANrn1.NP.Square*1e9);
                                                   end;
                                        end;

if Form1.ListBox1.ItemIndex=4 then  begin        {constant colored noise modulation}
    t:=nt*dt;
    color_noise:=color_noise-dt*1000/Form1.SpinEdit21.Value*color_noise
    +sqrt(2*dt*1000/Form1.SpinEdit21.Value)*noise_ratio*oldnoise[nt];

    if form1.CheckBox31.Checked=false then begin
Iind:=(Form1.SpinEdit1.Value + color_noise)/(ANrn.NP.Square*1e9);
Iind1:=(Form1.SpinEdit1.Value + color_noise)/(ANrn1.NP.Square*1e9);
                                           end
                                             else
                                                   begin
Iind:=( Form1.SpinEdit1.Value + modA*sin(omega*t) + color_noise )/(ANrn.NP.Square*1e9);
Iind1:=( Form1.SpinEdit1.Value + modA*sin(omega*t) + color_noise )/(ANrn1.NP.Square*1e9);
                                                   end;
                                    end;

if form1.CheckBox30.Checked then Form1.Series3.AddXY(t*1000,Iind*ANrn.NP.Square*1e9);
if form1.CheckBox32.Checked then Form1.Series7.AddXY( t*1000, Iind*ANrn.NP.Square*1e9);

    ANrn.MembranePotential(0,0,0,Iind,0);
    Form1.Series1.AddXY(t*1000,ANrn.NV.V*1000);
    //writeln(qqq,Iind1*ANrn1.NP.Square*1e9:10:3);

    ANrn1.MembranePotential(0,0,0,Iind1,0);
    if  form1.RadioButton8.Checked then begin if ifspike=1 then ANrn1.NV.V:=100/1000; end;
    Form1.LineSeries4.AddXY(t*1000,ANrn1.NV.V*1000);

//writeln(ccc, t*1000:10:3,' ',ANrn1.NV.V*1000:10:5);

   if  form1.RadioButton8.Checked then if ifspike=1 then begin ANrn1.NV.V:=form1.spinedit13.value/10/1000; end;

    Form1.LineSeries5.AddXY(t*1000,ANrn.NV.wAHP);
    //writeln(aaa,t*1000:10:3,' ',ANrn.NV.wAHP:10:5);

    Form1.LineSeries2.AddXY(t*1000,ANrn.NV.nM);
    //writeln(qqq,t*1000:10:3,' ',ANrn.NV.nM:10:5);

    Form1.LineSeries1.AddXY(t*1000,ANrn1.NV.wAHP);
    //writeln(aaa,t*1000:10:3,' ',ANrn1.NV.wAHP:10:5);

    Form1.LineSeries6.AddXY(t*1000,ANrn1.NV.nM);

    //writeln(ccc,t*1000:10:3,' ',ANrn1.NV.nM:10:5);

U:=ANrn1.NV.V*1000;

 if form1.RadioButton8.Checked then
   begin
    ifspike:=0;
    V_T:=form1.DDSpinEdit3.value;
     if ANrn1.NV.V*1000 >= (V_T + form1.spinedit13.value/10)
       then begin

       ANrn1.NV.V:=form1.spinedit13.value/10/1000;

       ifspike:=1;
            end;
   end
   else

if nt>3 then
begin
ifspike:=if_spike(MembranePotentialMax1[nt-3],
MembranePotentialMax1[nt-2],MembranePotentialMax1[nt-1]);

end;

//Form1.Series2.AddXY(t*1000, ifspike);

fr:=RateFromBiofizika2002(U);
//writeln(ccc, t*1000:10:3,' ', fr:10:3);

if Form1.CheckBox6.Checked then
  begIN

  {2 massives for frequency}
if ANrn.NV.V*1000>0 then  begin
                           MembranePotentialMax[nt]:=ANrn.NV.V*1000;
                           Spike_time[nt]:=t*1000;
                          end;

if ANrn1.NV.V*1000>Tr then  begin
                            MembranePotentialMax1[nt]:=ANrn1.NV.V*1000;
                            Spike_time1[nt]:=t*1000;
                           end;

//Form1.Series3.AddXY( t*1000,frequency(MembranePotentialMax,Spike_time));
//Form1.Series4.AddXY( t*1000,frequency(MembranePotentialMax1,Spike_time1));
  eND;

if Form1.CheckBox9.checked then

Form1.Series5.AddXY( t*1000, RateFromBiofizika2002(U));

//readln(aaa,tt,ttemp,ttemp,ttemp,ttemp,frfr);
//writeln(aaa, fr:10:3,' ', t*1000:10:3);
// writeln(ccc,t*1000:10:3, ' ', RateFromBiofizika2002(U):10:3);

//Application.Processmessages;
  UNTIL t*1000>=nt_end/10;                       {end of the integration}
//time:=0; input:=0;
// closefile(ccc);
 //  closefile(qqq);
//closefile(qqq);
//closefile(ccc);

  ANrn.Free;
  ANrn1.Free;

end;


procedure TForm1.CheckBox10Click(Sender: TObject);
begin
if Form1.CheckBox10.Checked then begin
                                form1.Chart2.Visible:=true;
                                form1.Chart6.Visible:=true;
                                form1.Chart4.Visible:=true;
                                form1.Chart3.Visible:=true;
                                form1.Checkbox18.Visible:=true;
                                form1.Checkbox17.Visible:=true;
                                form1.Checkbox19.Visible:=true;
                                form1.Spinedit7.Visible:=true;
                                form1.Spinedit11.Visible:=true;
                                form1.Spinedit4.Visible:=true;
                                form1.Spinedit8.Visible:=true;
                                form1.Spinedit9.Visible:=true;
                                form1.Spinedit3.Visible:=true;
                                form1.Label8.Visible:=true;
                                form1.Label9.Visible:=true;
                                form1.Label5.Visible:=true;
                                form1.Label7.Visible:=true;
                                form1.Label11.Visible:=true;
                                form1.Label4.Visible:=true;
                                  end
                                 else
                               begin
                                form1.Chart2.Visible:=false;
                                form1.Chart6.Visible:=false;
                                form1.Chart3.Visible:=false;
                                form1.Chart4.Visible:=false;
                                form1.Checkbox18.Visible:=false;
                                form1.Checkbox17.Visible:=false;
                                form1.Checkbox19.Visible:=false;
                                form1.Spinedit7.Visible:=false;
                                form1.Spinedit11.Visible:=false;
                                form1.Spinedit4.Visible:=false;
                                form1.Spinedit8.Visible:=false;
                                form1.Spinedit9.Visible:=false;
                                form1.Spinedit3.Visible:=false;
                                form1.Label8.Visible:=false;
                                form1.Label9.Visible:=false;
                                form1.Label5.Visible:=false;
                                form1.Label7.Visible:=false;
                                form1.Label11.Visible:=false;
                                form1.Label4.Visible:=false;
                               end;
end;

procedure TForm1.CheckBox7Click(Sender: TObject);
begin
if Form1.CheckBox7.Checked then Form2.Visible:=true
                           else Form2.Visible:=false;

end;

end.
