unit frequency_wx;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TeEngine, Series, ExtCtrls, TeeProcs, Chart,Spin,unit1;



type
    TForm1 = class(TForm)
    Button2: TButton;
    Chart1: TChart;
    Series1: TLineSeries;
    Label1: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    Label2: TLabel;

    { mas=array[0..10000] of double;}


procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1 :TForm1;

  implementation




procedure TForm1.Button2Click(Sender: TObject);

{Procedure frequency(X:mas);}
var
{vmaxx:mas;}

t_spikee:mas;
fr:mas;
i:integer;
{nt_end:integer;}


Begin

nt_end:=Form1.SpinEdit2.Value;

for i:=1 to nt_end do
begin
if (MembranePotentialMax[i-1]<MembranePotentialMax[i]) and
 (MembranePotentialMax[i]>MembranePotentialMax[i+1])
 then begin
            {vmaxx[i]:=vmax[i];}
            t_spikee[i]:=t_spike[i];
      end;
End;

for i:=5 to 400 do
 begin
if abs(t_spikee[i+1]-t_spikee[i])-abs(t_spikee[i]-t_spikee[i-1])<0.2
    then fr[i]:=3/(t_spikee[i+1]+t_spikee[i]+t_spikee[i-1]);
 end;

End;




end.

