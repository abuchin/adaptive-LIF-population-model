unit graph_0d;

interface
uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
     StdCtrls,TeEngine;

procedure PrintTime;
procedure PrintCoefficients;
procedure PrintSpikeProb;
procedure Warning(t1 :string);
function Color_u(x,min,max :double) :integer;
PROCEDURE Initial_Picture;
PROCEDURE Evolution;
procedure DrawPhaseSpace;

implementation
uses Init,MathMy,Unit1,Unit2,Unit4,Unit5,Unit6,Unit7,Bp2Delphi,
     other,ph_Dens,ph_Volt,Wright;



procedure PrintTime;
var t1 :string;
begin
   setcolor(3);
   str(t*1000:7:2,t1);
   t1:='t='+t1+' ms';
//   outtextxy(20,2,t1);
   Form1.Label1.Caption:=t1;
end;

procedure PrintCoefficients;
var t1,t2,t3 :string;
    i        :integer;
    dum      :longint;
begin
   setcolor(8);
   t1:='';  t3:='    ';
   for i:=1 to round(min(8,m)) do begin
       if abs(g_dg[i])>1e-3 then
          str(g_dg[i]:13:4,t2)
       else
          str(g_dg[i]:12,t2);
       t1:=t1+t2+',';
       t3:=t3+'  '+strC[ig_iC[i]];
   end;
   Form1.CoeMemo.Clear;
   Form1.CoeMemo.Lines.Add(t3);
   Form1.CoeMemo.Lines.Add(t1);
   if m>=9 then begin
      t1:='';  t3:=' ';
      for i:=9 to m do begin
          str(g_dg[i]:9:3,t2);
          t1:=t1+t2+',';
          t3:=t3+' '+strC[ig_iC[i]];
      end;
      dum:=Form1.CoeMemo.Lines.Add(t3);
      Form1.CoeMemo.Lines.Add(t1);
   end;
end;

procedure PrintSpikeProb;
var t1,t2,t3 :string;
    i        :integer;
begin
   setcolor(8);
   t1:='SpikeProb[1]=';
   str(SpikeProb[1]:5:3,t2);
   t1:=t1+t2;
   Form1.Memo2.Lines.Add(t1);
   //outtextxy(150,140,t1);
   t1:='SpikeProb[2]=';
   str(SpikeProb[2]:5:3,t2);
   t1:=t1+t2;
   Form1.Memo2.Lines.Add(t1);
   //outtextxy(150,155,t1);
end;

procedure Warning(t1 :string);
begin
   Form1.Chart4.Visible:=false;
   Form1.Chart5.Visible:=false;
   setcolor(1);
   Form1.CoeMemo.Font.Color:=clRed;
//   Form1.CoeMemo.Font.Size:=20;
   Form1.CoeMemo.Lines.Add(t1);
   {outtextxy(30,40,t1);}
   StopKey:='P'; Pause;
   Form1.Chart4.Visible:=true;
   Form1.Chart5.Visible:=true;
end;

function Color_u(x,min,max :double) :integer;
var  sc :double;
begin
  sc:=abs(max-min);  if sc<1e-6 then sc:=1e-6;
  if x<min then x:=min else if x>max then x:=max;
  Color_u:=14-round(abs(x-min)/sc*14);
end;

PROCEDURE Initial_Picture;
var
   nl,nle,ntl,i : longint;
   t1,t2,t3,t4  : string;
   tl,Ve_sc,TimeAxisMax     : double;
BEGIN
                  { Preparations }
   shift_step:=25;
   x_sc:=220;  y_sc:=130;
   x_pole:=0;        y_pole:=0;
                  { Cleaning }
   if YesToClean=1 then begin
      Form1.Series8.Clear;
      Form1.Series9.Clear;
      Form1.Series10.Clear;
      Form1.Series11.Clear;
      Form1.Series12.Clear;
      Form1.Series13.Clear;
      Form1.Series14.Clear;
      Form1.Series15.Clear;
      Form5.Series1.Clear;
      Form5.Series2.Clear;
      Form5.Series3.Clear;
      Form5.Series4.Clear;
      Form5.Series5.Clear;
      Form5.Series6.Clear;
      Form5.Series7.Clear;
      Form5.Series8.Clear;
      Form5.Series9.Clear;
      Form5.Series10.Clear;
      Form5.Series11.Clear;
      Form5.Series12.Clear;
      Form6.Series1.Clear;
      Form6.Series2.Clear;
      Form6.Series3.Clear;
      Form6.Series4.Clear;
      Form7.Series1.Clear;
      Form7.Series2.Clear;
      Form7.Series3.Clear;
      Form7.Series4.Clear;
      Form1.Series1.Clear;
      Form1.Series2.Clear;
      Form1.Series3.Clear;
      if nt<=1 then begin
         Form1.Series4.Clear;
         Form1.Series5.Clear;
         Form1.Series6.Clear;
         Form1.Series7.Clear;
      end;
   end;
      x_shift:=320;     y_shift:=250;
{      ChangePalette;}
                     { Amplitudes }
      xU:=1000;
      yU:=2;
                     { *** Axes *** }
      if           If_I_V_or_p=1 then begin
          Form1.Series10.VertAxis:=aLeftAxis;
          Form1.Series11.VertAxis:=aLeftAxis;
      end else if (If_I_V_or_p=2)or(If_I_V_or_p=4)or(If_I_V_or_p=5) then begin
          Form1.Series10.VertAxis:=aRightAxis;
          Form1.Series11.VertAxis:=aRightAxis;
      end else if  If_I_V_or_p=3 then begin
          Form1.Series10.ParentChart:=Form1.Chart6;
          Form1.Series11.ParentChart:=Form1.Chart6;
          Form1.Series10.VertAxis:=aLeftAxis;
          Form1.Series11.VertAxis:=aLeftAxis;
      end;
      TimeAxisMax:=MinIfNotZero(PlotWindow,t_end*1000);
      Form1.Chart1.BottomAxis.Maximum:=TimeAxisMax;
      Form1.Chart2.BottomAxis.Maximum:=TimeAxisMax;
      Form1.Chart3.BottomAxis.Maximum:=TimeAxisMax;
      Form1.Chart6.BottomAxis.Maximum:=TimeAxisMax;
      Form1.Chart7.BottomAxis.Maximum:=TimeAxisMax;
      Form5.Chart1.BottomAxis.Maximum:=TimeAxisMax;
      Form5.Chart2.BottomAxis.Maximum:=TimeAxisMax;
      Form5.Chart3.BottomAxis.Maximum:=TimeAxisMax;
      Form6.Chart1.BottomAxis.AutomaticMaximum:=(TimeAxisMax=t_end*1000);
      Form6.Chart2.BottomAxis.AutomaticMaximum:=(TimeAxisMax=t_end*1000);
      Form6.Chart3.BottomAxis.AutomaticMaximum:=(TimeAxisMax=t_end*1000);
      Form6.Chart1.BottomAxis.Maximum:=1e6;
      Form6.Chart2.BottomAxis.Maximum:=1e6;
      Form6.Chart3.BottomAxis.Maximum:=1e6;
      Form6.Chart1.BottomAxis.Minimum:=t*1e3;
      Form6.Chart2.BottomAxis.Minimum:=t*1e3;
      Form6.Chart3.BottomAxis.Minimum:=t*1e3;
      Form6.Chart1.BottomAxis.Maximum:=t*1e3+TimeAxisMax;
      Form6.Chart2.BottomAxis.Maximum:=t*1e3+TimeAxisMax;
      Form6.Chart3.BottomAxis.Maximum:=t*1e3+TimeAxisMax;
                     { ***      *** }
      { Sample - 'Black' }
      MaximumsOfSignals(VexpMax,VmodMax);
      Ve_sc:=VI_sc;  if IfUndimensionate=1 then  Ve_sc:=VexpMax;
      xU:=TimeAxisMax/dt;
      nle:=round(nt+xU);  if nle>nt_end then nle:=nt_end;
      for nl:=nt to nle do begin
          ntl:=trunc(nl-trunc(nl/xU)*xU);
          tl:=ntl*dt*1000 {ms};
          if nl<mMaxExp then begin
             Form1.Series10.AddXY(tl, Vexp[nl,Smpl]*Ve_sc);
          end;
      end;
      { Coefficients }
      PrintCoefficients;
      { Data file name }
      Form1.Label2.Caption:=SmplFile[Smpl];
      { Number of Newton iteration }
      setcolor(1);
      str(nFunk:4,t1);
      t1:='nFunk='+t1+'  ';
      outtextxy(450,30,t1);
      str(Functional:11,t1);
      t1:='Residual='+t1+'  ';
      outtextxy(450,45,t1);
      Application.ProcessMessages;
END;

{*********************************************************************}
PROCEDURE Evolution;
var
     Vm_sc,tl,t_sc,ts           : double;
     i,k,ntl,nWindow            : integer;
BEGIN
  t_sc:=MinIfNotZero(PlotWindow,t_end*1000)+1e-8;
  nWindow:=trunc(t*1000{ms}/t_sc);
  tl:=t*1000{ms}-nWindow*t_sc;
  if (nWindow>0) then begin
   if (tl<=dt*n_show*1000) then begin
      Initial_Picture;
   end;
  end;
  PrintTime;
  PrintSpikeProb;
  { axon firing rate - 'Red' }
  Form1.Series2.AddXY(tl, pn[1]);
  Form1.Series3.AddXY(tl, pn[2]);
  { Long History }
  if Form1.Chart4.Enabled then begin
     Form1.Series4.AddXY(t*1000, pn[1]);
     Form1.Series5.AddXY(t*1000, V[1]*1000);
     Form1.Series6.AddXY(t*1000, pn[2]);
     Form1.Series7.AddXY(t*1000, V[2]*1000);
  end;
  Form1.Series8 .AddXY(tl, V[1]*1000);
  Form1.Series12.AddXY(tl, V[2]*1000);
  { Conductances }
  if Form1.CheckBox2.Checked then begin
     Form5.Series1.AddXY(tl,mGABB[1]);
     Form5.Series2.AddXY(tl,mAMPA[1]+mAMP3[1]);
     Form5.Series3.AddXY(tl,mNMDA[1]*SigmNMDA(V[1]));
     Form5.Series4.AddXY(tl,mGABA[1]+mGAB3[1]);
     Form5.Series5.AddXY(tl,mAMPA[2]+mAMP3[2]);
     Form5.Series6.AddXY(tl,mGABA[2]+mGAB3[2]);
     Form5.Series7.AddXY(tl, mBst[1]);
     Form5.Series8.AddXY(tl, wAHP_ph[i3,0]);
     Form5.Series9.AddXY(tl, nM_ph[i3,0]);
     Form5.Series10.AddXY(tl, g_ph[i3,0]/gL[i3]);
     Form5.Series11.AddXY(tl,eAMP[1]);
     Form5.Series12.AddXY(tl,eGAB[1]);
     { Writing }
     if Form5.CheckBox2.Checked then begin
        append(f51);  append(f52);
        write  (f51,t*1e3:10:3,' ',mAMPA[1]:10:5,' ',mAMPA[2]:10:5,' ');
        write  (f51,mNMDA[1]:10:5,' ',mNMDA[2]:10:5,' ');
        write  (f51,mGABA[1]:10:5,' ',mGABA[2]:10:5,' ');
        writeln(f51,mGABB[1]:10:5,' ',mGABB[2]:10:5,' ');
        writeln(f52,t*1e3:10:3,' ',mBst[1] :10:5,' ',wAHP[2] :10:5,' ');
        close(f51);   close(f52);
     end;
  end;
  { Current - 'Green'; Iadd - 'Maroon' dashed }
  Form1.Series9 .AddXY(tl, PSC[1]);
  Form1.Series13.AddXY(tl, PSC[2]);
  if Form4.CheckBox8.Checked then begin
     Form1.Series1.AddXY(tl, Iadd[1]*Square[1]*1e9);
  end else begin
     if pext<1900 then   { To avoid stupid Delphi error }
     Form1.Series1.AddXY(tl, pext);
  end;
  { registered potential - 'Lime' }
  Vm_sc:=VI_sc;  {if IfUndimensionate=1 then  Vm_sc:=VmodMax;}
  Form1.Series11.AddXY(tl, Vmod[nt]*Vm_sc);
  Application.ProcessMessages;
END;

procedure DrawPhaseSpace;
var
     ts,m_roE,m_roI,m_HzE,m_HzI         :double;
     i,k                                :integer;
begin
  if not(Form2.Visible) then exit;
     Form2.Chart1.BottomAxis.Maximum:=ts_end*1e3;
     Form2.Chart2.BottomAxis.Maximum:=ts_end*1e3;
     Form2.Chart3.BottomAxis.Maximum:=ts_end*1e3;
     Form2.Chart4.BottomAxis.Maximum:=ts_end*1e3;
     Form2.SeriesE_ro.Clear;
     Form2.SeriesE_V .Clear;
     Form2.SeriesE_VE.Clear;
     Form2.SeriesE_nn.Clear;
     Form2.SeriesI_nn.Clear;
     Form2.SeriesI_ro.Clear;
     Form2.SeriesI_V .Clear;
     Form2.SeriesI_VE.Clear;
     Form2.SeriesE_VT.Clear;
     Form2.SeriesI_VT.Clear;
     Form2.SeriesE_V_p_sgm.Clear;
     Form2.SeriesE_V_m_sgm.Clear;
     Form2.SeriesI_V_p_sgm.Clear;
     Form2.SeriesI_V_m_sgm.Clear;
     Form2.Series1.Clear;
     Form2.Series2.Clear;
     Form2.Series3.Clear;
     Form2.Series4.Clear;
     Form2.Series5.Clear;
     Form2.Series6.Clear;
     Form2.Series7.Clear;
     Form2.Series8.Clear;
     Form2.Series9.Clear;
     Form2.Series10.Clear;
     Form2.Series11.Clear;
     Form2.Series12.Clear;
     Form2.Series16.Clear;
     Form2.Series17.Clear;
     { Maximums }
     m_roE:=0; m_roI:=0;
     m_HzE:=0; m_HzI:=0;
     for i:=0 to Nts do begin
         m_roE:=max(m_roE,ro[1,i]);
         m_roI:=max(m_roI,ro[2,i]);
         m_HzE:=max(m_HzE,Hzrd[1,i]);
         m_HzI:=max(m_HzI,Hzrd[2,i]);
     end;
     k:=1;
     for i:=0 to Nts do begin
         ts:=i*dts*1e3;
         Form2.SeriesE_ro.AddXY (ts,  ro[k,i]);
         Form2.SeriesE_V.AddXY  (ts, (V0_ph[k,i]-Vrest[k])*1000);
         if HH_order[k]='2-points' then
         Form2.SeriesE_VE.AddXY (ts, (VE_ph[k,i]-Vrest[k])*1000);
         Form2.SeriesE_nn.AddXY (ts,  nn_ph[k,i]);
         Form2.SeriesI_nn.AddXY (ts,  nn_ph[2,i]);
         Form2.Series1.AddXY    (ts,  yK_ph[k,i]);
         Form2.Series4.AddXY    (ts,  yK_ph[2,i]);
         Form2.Series2.AddXY    (ts,  nA_ph[k,i]);
         Form2.Series5.AddXY    (ts,  nA_ph[2,i]);
         Form2.Series3.AddXY    (ts,  lA_ph[k,i]);
         Form2.Series6.AddXY    (ts,  lA_ph[2,i]);
         Form2.Series7.AddXY    (ts,  nM_ph[k,i]);
         Form2.Series8.AddXY    (ts,  nM_ph[2,i]);
         Form2.Series9.AddXY    (ts,  wAHP_ph[k,i]);
         Form2.Series10.AddXY   (ts,  wAHP_ph[2,i]);
         Form2.Series16.AddXY   (ts,  g_ph[k,i]/gL[k]);
         Form2.Series17.AddXY   (ts,  g_ph[2,i]/gL[2]);
         Form2.SeriesI_ro.AddXY (ts,  ro[2,i]);
         Form2.SeriesI_V.AddXY  (ts, (V0_ph[2,i]-Vrest[2])*1000);
         if HH_order[2]='2-points' then
         Form2.SeriesI_VE.AddXY (ts, (VE_ph[2,i]-Vrest[2])*1000);
         Form2.SeriesE_VT.AddXY (ts,  VT[k,i]*1e3);
         Form2.SeriesI_VT.AddXY (ts,  VT[2,i]*1e3);
         Form2.SeriesE_V_p_sgm.AddXY (ts, (V0_ph[k,i]-Vrest[k]+sgmV[k,i])*1e3);
         Form2.SeriesE_V_m_sgm.AddXY (ts, (V0_ph[k,i]-Vrest[k]-sgmV[k,i])*1e3);
         Form2.SeriesI_V_p_sgm.AddXY (ts, (V0_ph[2,i]-Vrest[2]+sgmV[2,i])*1e3);
         Form2.SeriesI_V_m_sgm.AddXY (ts, (V0_ph[2,i]-Vrest[2]-sgmV[2,i])*1e3);
         if m_HzE>0 then Form2.Series11.AddXY(ts, Hzrd[1,i]/m_HzE*m_roE);
         if m_HzI>0 then Form2.Series12.AddXY(ts, Hzrd[2,i]/m_HzI*m_roI);
     end;
end;

end.
