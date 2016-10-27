unit other;

interface
procedure MaximumsOfSignals(var VexpMax,VmodMax :double);
function TargetFuncOfSignalsUndimedWith(VexpMax,VmodMax :double) :double;
{**************** INPUTING/OUTPUTING **********************************}
procedure InitiateWriting;
procedure ViewSpikes;
procedure Writing;
procedure OutputSignals;
procedure OutputHistory;
procedure InitHistory;
procedure WriteCoefficients;
procedure OutputMaximumsOfV;
{**************** EXPERIMENTAL RECORDS ********************************}
procedure DontReadExpData;
procedure ReadExpData;
{**********************************************************************}
procedure Renamination;
procedure InitialConditions;

implementation
uses Init,MathMy,coeff,Unit1,Unit2,Unit6,ph_Dens,ph_Volt,HH_canal,threshold,
     Representatives, 
     Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

procedure MaximumsOfSignals(var VexpMax,VmodMax :double);
{
  Finding of maximum of signals 'Vexp' and 'Vmod'.
}
var  nt                    :integer;
begin
  { Maximum of 'Vexp' }
  VexpMax:=0;
  for nt:=1 to nt_end do  if abs(Vexp[nt,Smpl])>VexpMax then
      VexpMax:=abs(Vexp[nt,Smpl]);
  { Maximum of 'Vmod' }
  VmodMax:=0;
  for nt:=1 to nt_end do  if abs(Vmod[nt])     >VmodMax then
      VmodMax:=abs(Vmod[nt]);
end;

function TargetFuncOfSignalsUndimedWith(VexpMax,VmodMax :double) :double;
{
  Undimensioning of signals 'Vexp' and 'Vmod' and
  calculation of target Functional 'Func'.
}
var  nt   :integer;
     Func :double;
begin
  { Calculation of target Functional 'Func' }
  Func:=0;
  for nt:=1 to nt_end do
      Func:=Func*(nt-1)/nt + sqr(Vexp[nt,Smpl]/VexpMax-Vmod[nt]/VModMax)/nt;
  TargetFuncOfSignalsUndimedWith:=Func;
end;

{**************** INPUTING/OUTPUTING **********************************}

procedure ViewSpikes;
{ Draws spikes and Writes interspike intervals }
var
    iSp                                 :array[1..3] of integer;
    ie,x1,x2                            :integer;
    dt_Spike,freq,dt_w,eps,VTh,z,u,ddV  :double;
begin
  {**************************************}
  OneStepForRepresentativeNeurons(@t,@dt);
  {**************************************}
  eps:=0.03;       { for unsteady burst to evoke AP }
  for ie:=1 to 2 do begin
      { Interpolation of voltage }
      z:=(t-t_prev_Spike[ie])/dts;  if t_prev_Spike[ie]<0 then z:=Nts;
      x1:=imin(Nts,trunc(z)+1);
      VTh:=VT[i3_ie(ie),x1];//hreshold3(i3_ie(ie),DuDt_ph[ie,x1]);
         { linear interpolation }
      if (x1<>Nts)and(t-t_prev_Spike[ie]>dT_AP[ie]+dts) then
           u:=(V0_ph[ie,x1]-V0_ph[ie,x1-1])*(z-x1+1)+V0_ph[ie,x1-1]
      else u:= V0_ph[ie,x1];
      if not(Form6.CheckBox2.Checked) then begin
         { Counting spikes by threshold model }
         ddV:=(DuDt_ph[ie,x1]-DuDt_ph[ie,x1-1])/dts;
         if (u-Vrest[ie]>VTh)and
            ((t-t_prev_Spike[ie]>dT_AP[ie])and(ddV<1000{V/s^2}))and
            (DuDt_ph[ie,x1]>0) then begin
             t_prev_Spike[ie]:=t;
         end;
      end else begin
         { Counting spikes by firing rate }
         iSp[ie]:=trunc(SpikeProb[ie]+eps);
         if ((SpikeProb[ie]+eps-iSp[ie])<Q[ie]*dt)and(Q[ie]>0)and(iSp[ie]>0) then begin
             t_prev_Spike[ie]:=t;
         end;
      end;
  end;
  { Drawing }
  if Form1.CheckBox1.Checked then begin
  for ie:=1 to 2 do begin
      z:=(t-t_prev_Spike[ie])/dts;  if t_prev_Spike[ie]<0 then z:=Nts;
      x1:=imin(Nts,trunc(z)+1);
      { linear interpolation }
      if (x1<>Nts){and(t-t_prev_Spike[ie]>dT_AP[ie]+dts)} then
           u:=(V0_ph[ie,x1]-V0_ph[ie,x1-1])*(z-x1+1)+V0_ph[ie,x1-1]
      else u:= V0_ph[ie,x1];
      if t=t_prev_Spike[ie] then u:=0;
      { Drawing }
      if (trunc(nt/n_show)=nt/n_show) then begin
          case ie of
          1: Form6.Series1.AddXY(t*1e3,u*1e3);
          2: Form6.Series2.AddXY(t*1e3,u*1e3);
          end;
          { Markers }
          case ie of
          1: begin Form2.Series14.Clear;
                   Form2.Series14.AddXY(z*dts*1e3,(u-Vrest[1])*1e3); end;
          2: begin Form2.Series15.Clear;
                   Form2.Series15.AddXY(z*dts*1e3,(u-Vrest[2])*1e3); end;
          end;
          { Conductances }
          if (Form6.CheckBox3.Checked)and(ie=i3) then begin
             Form6.Series3.AddXY(t*1e3,  nM_ph[i3,x1]);
             Form6.Series4.AddXY(t*1e3,wAHP_ph[i3,x1]);
          end;
          Application.ProcessMessages;
      end;
      { Writing }
      if (Form6.CheckBox1.Checked)and(trunc(nt/n_Write)=nt/n_Write) then begin
         append(ff6);
         { Columns: t, V[1], nM[1], wAHP[1], V[2], nM[2], wAHP[2]. }
         if ie=1 then  write  (ff6,t*1e3:10:3,' ',u*1e3:10:3,' ',
                               nM_ph[1,x1]:9:4,' ',wAHP_ph[1,x1]:9:4)
                 else  writeln(ff6,           ' ',u*1e3:10:3,' ',
                               nM_ph[2,x1]:9:4,' ',wAHP_ph[2,x1]:9:4);
         close(ff6);
      end;
  end;  {of loop for 'ie'}
  end;
end;

procedure InitiateWriting;
begin
  AssignFile(ccc,'VeViVrAP.dat');
  if FileExists('VeViVrAP.dat')and(iHist=1) then  append (ccc)
                                            else  rewrite(ccc);
  CloseFile(ccc);
  { Control values }
{  assign(ddd,'u_s(t).dat');
  if (WriteOrNot=0) or (iHist=1) then  rewrite(ddd)
                                 else  append (ddd);}
end;

procedure Writing;
var V0ex,Vex,Vmod_ :double;
begin
  append(ccc);
  if If_I_V_or_p=1 then begin
                     Vex:= -Vexp[nt,Smpl];
                     Vmod_:=-Vmod[nt];
                    end else
  if (If_I_V_or_p=2) or (If_I_V_or_p=4) or (If_I_V_or_p=5) then begin
                     Vex:=Vexp[nt,Smpl]*1000;
                     if IfChangeVrest=1 then Vmod_:=(Vmod[nt])*1000
                                        else Vmod_:=(Vmod[nt])*1000;
                    end else
  if If_I_V_or_p=3 then begin
                     Vex:=Vexp[nt,Smpl];
                     Vmod_:=Vmod[nt];
  end;
  {           1-A            2-B        3-C               }
  write  (ccc,t*1000:8:3,' ',Vex:10:3,' ',Vmod_:10:3,' ');
  {           4-D              5-E                        }
  write  (ccc,V[1]*1000:10:3,' ',V[2]*1000:10:3,' ');
  {           6-F         7-G         8-H                 }
  write  (ccc,Q[1]:10:3,' ',Q[2]:10:3,' ',pext:10:3,' ');
  {           9-I                   10-K                  }
  write  (ccc,VatE[3]*1000:10:3,' ',Iadd[1]*Square[1]*1e9:10:3,' ');
  {           11-K               12-L                    }
  writeln(ccc,mAMPA[i3]:10:4,' ',mGABA[i3]:10:4,' ');
  CloseFile(ccc);
end;


procedure OutputSignals;
{
        Output in file the registered sample 'Vexp[nt,Smpl]'
                       and modelled          'Vmod[nt]'
}
var i,j,nt :integer;
    Vrest_l {VexpMax,VmodMax} :double;
    tt      :string;
    OutFile :string;
begin
  if Smpl=0 then Exit;
  tt:=SmplFile[Smpl];
  { Find the dot in the file name }
  i:=1;  while (tt[i]<>'.')and(i<Length(tt)) do i:=i+1;
  { Change the extention on '.dat' }
  OutFile:=tt[1];
  for j:=2 to i-1 do  OutFile:=OutFile+tt[j];
  OutFile:=OutFile+'.dat';
  assign(ddd,OutFile);  rewrite(ddd);
  { Define 'Vrest' }
  if IfChangeVrest=1 then  Vrest_l:=Vrest[3]
                     else  Vrest_l:=Vrest[1];
  {MaximumsOfSignals(VexpMax,VmodMax);}
  for nt:=0 to nt_end do begin
      write  (ddd,nt*dt*1000:8:3,' ');
      if IfUndimensionate=1 then
         writeln(ddd,Vexp[nt,Smpl]/VexpMax:8:3,
                 ' ',Vmod[nt]     /VmodMax:8:3,' ')
      else
         if (If_I_V_or_p=1)or(If_I_V_or_p=3) then
            writeln(ddd, Vexp[nt,Smpl]              :8:3,
                    ' ', Vmod[nt]                   :8:3,' ')
         else if IfDataStartsFromZero=1 then
            writeln(ddd,(Vexp[nt,Smpl]-Vrest_l)*1000:8:3,
                    ' ',(Vmod[nt]     -Vrest_l)*1000:8:3,' ')
              else
            writeln(ddd,(Vexp[nt,Smpl]        )*1000:8:3,
                    ' ',(Vmod[nt]             )*1000:8:3,' ');
  end;
  close(ddd);
end;

procedure OutputHistory;
var i :integer;
begin
  { History }
  assign(ggg,'history.dat');  append(ggg);
  write(ggg,iHist:3,' ',m:3);  for i:=1 to m  do  write(ggg,' ',g_dg[i]:13);
  write(ggg,' ',mC:2);         for i:=1 to mC do  write(ggg,ifC[i]:2);
  writeln(ggg);
  close(ggg);
end;

procedure InitHistory;
var  i,m :integer;
     s :string;
     hhh :text;
begin
  assign(ggg,'history.dat');
  if IfReadHistory=1 then begin
     { Read old History }
     reset(ggg);
     readln(ggg);
     repeat
       read(ggg,iHist,m);  for i:=1 to m  do  read(ggg,g[i]);
       read(ggg,mC);       for i:=1 to mC do  read(ggg,ifC[i]);
       readln(ggg);
       Define_ig_iC;
       CoeffFrom_g(g);
     until eof(ggg);
     AssignCoeffToChange;
     close(ggg);
  end else begin
     { Initiate History }
     AssignCoeffToChange;
     rewrite(ggg);
     writeln(ggg,'iHist   m    g[1]      g[2]       g[3]       ...   ');
     close(ggg);
     g_FromCoeff(g);
     OutputHistory;
  end;
end;

procedure WriteCoefficients;
var  k :integer;
begin
  write('g=');
  for k:=1 to m do  write(g[k]:12:7,' ');     writeln;
  writeln('***************************************************************');
end;

procedure OutputMaximumsOfV;
{
  Finding maximum of 'Vmod', Slopes and SpikeProbabilities and writing them.
}
var  nt                    :integer;
     SlopeMax,VMax,tOfMax  :double;
begin
  assign(ccc,'Istim.dat');
  if (iHist<>1) and (FileExists('Istim.dat'))
                            then  append(ccc)
                            else  rewrite (ccc);
  { Maximum of 'Vmod' }
  VMax:=0;  SlopeMax:=0;
  for nt:=2 to nt_end do begin
      if abs(Vmod[nt])>VMax then begin
         VMax:=abs(Vmod[nt]);  tOfMax:=nt*dt;
      end;
      if (Vmod[nt]-Vmod[nt-1])/dt > SlopeMax then begin
         SlopeMax:=(Vmod[nt]-Vmod[nt-1])/dt;
      end;
  end;
  {           A            B                  C                            }
  write  (ccc,Iext:7:0,' ',DuDtmax[1]:9:2,' ',DuDtmax[2]:9:2,' ');
  {           D                        E                                   }
  write  (ccc,SpikeProb[1]*100:9:5,' ',SpikeProb[2]*100:9:5,' ');
  {           F                G                                           }
  writeln(ccc,VMax*1e3:9:2,' ',tOfMax*1e3:9:2);
  close(ccc);
end;

{**************** EXPERIMENTAL RECORDS ********************************}

procedure  DontReadExpData;
var  nt :integer;
begin
  for nt:=0 to nt_end do  Vexp[nt,Smpl]:=0;
end;

procedure  ReadExpData;
{
  Reading of experimental data as arrays: tE[0..200] -- time moments;
  E[0..200] -- values.
  Interpolation (linear) is applied to fill the array 'Vexp'.
}
var
     n,nt,nE            :integer;
     t,w                :double;
     E,tE               :array[0..250] of double;
begin
  if (Smpl=0)or(SmplFile[Smpl]='NoFile') then begin
                                  DontReadExpData;
                                  Exit;
  end;
  { Reading file }
//  ChDir(MainDir);
  assign(aaa,MainDir+SmplFile[Smpl]);  reset(aaa);
  n:=0;
  repeat  n:=n+1;
    readln(aaa,tE[n],E[n]);
  until (eof(aaa)) or (n=250);
  nE:=n;
  close(aaa);
  { Filling array 'Vexp' }
  nt:=-1;
  repeat  nt:=nt+1;
    t:=nt*dt/scx_Smpl+shift_Smp;
    { Finding of the nearest right point in array 'E' }
    n:=0;
    repeat n:=n+1
    until (n=nE) or (tE[n]>t);
    { Linear interpolation }
    if n=1 then                      w:=1
    else if tE[n]-tE[n-1]>1e-8 then  w:=(t-tE[n-1])/(tE[n]-tE[n-1])
                               else  w:=0;
    Vexp[nt,Smpl]:=(E[n-1]*(1-w) + E[n]*w)*scy_Smpl{ - Vrest[1]};
    { Shift to Vrest }
    if (If_I_V_or_p=2)and(IfDataStartsFromZero=1) then
        Vexp[nt,Smpl]:=Vexp[nt,Smpl] + Vrest[3];
  until (nt=mMaxExp) or (nt=nt_end);
end;

{**********************************************************************}
procedure Renamination;
begin
            po[1]:=p[1];  p[1]:=pn[1];
            po[2]:=p[2];  p[2]:=pn[2];
                          p[3]:=pn[3];
end;

{**********************************************************************}
procedure InitialConditions;
var  ie         :integer;
begin
  p[1] :=0;     p[2] :=0;     p[3] :=0;   pext:=Qns;
  po[1]:=0;     po[2]:=0;     po[3]:=0;
  Q[1] :=0;     Q[2] :=0;     Q[3] :=0;
  V[1]:=Vrest[1];
  V[2]:=Vrest[2];
  {if IfChangeVrest=1 then}  V[3]:=Vrest[3] {for registrated cell}
                     {else  V[3]:=0}        {for Stimulating spike};
  { Intermediates for Ohm's law  ----------------------}
  for ie:=1 to 3 do begin
      VatE[ie]:=Vrest[ie];
      VatI[ie]:=Vrest[ie];
//      IsynE[ie]:=0;
//      IsynI[ie]:=0;
  end;
  t:=0;   nt:=0;
  for ie:=1 to 3 do begin
      SpikeProb[ie]:=0;
      t_prev_Spike[ie]:=-1e6;
  end;
  { Noise }
  r_Noise[1]:=0;  r_Noise[2]:=0;
end;





end.
 