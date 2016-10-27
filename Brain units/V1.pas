unit V1;
{ **********************************************************************
  The subprogram simulates a column of V1.
  **********************************************************************}

interface
procedure RingParameters;
procedure V1Column;
procedure MemorizedParameters_V1;

var
    pn1_smeared :double;

implementation
uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
     StdCtrls, ComCtrls, ExtCtrls,
     Init,mathMy,Wright,slice,other,other_2D,Hodgkin,HH_canal,
     graph_0d, graph_2D,wave,Unit1,Unit2,Unit8,
     ph_Dens,ph_Volt,Correspond,V1_liason;


procedure MeasureInNode(i,j :integer);
var l :integer;
begin
  From2D_To1node(i,j);
  Set_Ps_Ring(i,j);
  for l:=1 to 3 do Iadd[l]:= Current_Iind(l);
  case If_I_V_or_p of
    1: Vmod[nt]:=(PSC[3]+Current_Iind(3))*Square[i3]*1e9; {pA}
    2: Vmod[nt]:=V[3]-Vrest[3];
    3: Vmod[nt]:=Q[3];
    4: Vmod[nt]:=VatE[3]-Vrest[3];
    5: Vmod[nt]:=VatE[3]-Vrest[3];
  end;
end;

procedure Renamination_Ring;
var  i,j :integer;
begin
    for i:=0 to ni+1 do begin
        for j:=0 to nj+1 do begin
            Wpo[1,i,j]:=Wp[1,i,j];    Wp[1,i,j]:=Wpn[1,i,j];
            Wpo[2,i,j]:=Wp[2,i,j];    Wp[2,i,j]:=Wpn[2,i,j];
                                      Wp[3,i,j]:=Wpn[3,i,j];
        end;
    end;
end;

procedure RingParameters;
begin
  ni:=10;
  R_stim :=2;
  ni_stim:=trunc(180/360*ni);
  { Stimulation }
  t_end:=0.1{s};
  dt:=0.0002;
  tSt:=0.5{s};
  Iext:=10{mkA};
  I_ind:=0;
  { Adaptation }
  gKM[1]:=0;
  gAHP[1]:=0;
  { Dispersion }
  Nts:=50;
  ts_end:=0.050{s};
  sgm_V[1]:=0.004 {V};
  sgm_V[2]:=0.004 {V};
  { Synapses }
  IfBlockAMPA:=0;  IfBlockGABA:=0;  IfBlockNMDA:=1;  IfBlockGABB:=1;
  gAMP3[1]:=1;                    gAMP3[2]:=0;
  gGAB3[1]:=0;                    gGAB3[2]:=0;         {[Xiang, Karnup]}
  gAMPA[1]:=0.2*0;                gAMPA[2]:=1;
  gGABA[1]:=1;                    gGABA[2]:=0.7*0;
  gSyn_From_i3;
  CorrespondParametersToTheForm;
end;

procedure PrintTime;
var t1 :string;
begin
   str(t*1000:7:2,t1);
   t1:='t='+t1+' ms';
//   outtextxy(20,2,t1);
   Form8.Label4.Caption:=t1;
end;

procedure DrawChain;
var  i :integer;
begin
  PrintTime;
  Form8.Series1.Clear;
  Form8.Series2.Clear;
  Form8.Series3.Clear;
  Form8.Series4.Clear;
  Form8.Series6.Clear;
  Form8.Series7.Clear;
  for i:=0 to ni+1 do begin
      Form8.Series1.AddXY(i/ni*360-180, Vm[1,i,0]*1e3);
      Form8.Series2.AddXY(i/ni*360-180,Wpn[1,i,0]);
      Form8.Series3.AddXY(i/ni*360-180, WQ[1,i,0]);
      Set_Ps_Ring(i,0);
      Form8.Series4.AddXY(i/ni*360-180,pext);
//      Form8.Series5.AddXY(i/ni*360-180, Vm[2,i,0]*1e3);
      Form8.Series6.AddXY(i/ni*360-180, Vm[2,i,0]*1e3);
      Form8.Series7.AddXY(i/ni*360-180, WQ[2,i,0]);
  end;
  Application.ProcessMessages;
end;

procedure WriteChain;
var  i  :integer;
     s1 :string;
     F  :file;
begin
  { One file *************************************************}
  s1:='V1(t,x).dat';
  assign(xxx,s1);
  if nt=1 then begin
     rewrite(xxx);
     writeln(xxx,'ZONE T="',s1,'"');
     writeln(xxx,'I=',ni+1:3,',J=',trunc(t_end/dt_out)+1:3,',K=1,F=POINT');
  end else append(xxx);
  for i:=0 to ni do begin
      Set_Ps_Ring(i,0);
      write  (xxx,t*1000:9:5,' ',(i/ni-0.5)*180:9:5);
      write  (xxx,' ',Vm[1,i,0]*1e3:8:4,' ',Wpn[1,i,0]:8:4);
      write  (xxx,' ',WQ[1,i,0]:8:4,' ',pext:8:4);
      writeln(xxx,' ',Vm[2,i,0]*1e3:8:4,' ',WQ[2,i,0]:8:4);
  end;
  close(xxx);
  { A few files **********************************************}
  str(round(t*1000):3, s1);
  s1:='xy'+s1+'e.dat';
  assign(sss,s1);  rewrite(sss);
  for i:=0 to ni do begin
      Set_Ps_Ring(i,0);
      write  (sss,(i/ni-0.5)*180:9:5,' ',Vm[1,i,0]*1e3:8:4,' ',Wpn[1,i,0]:8:4);
      write  (sss,' ',WQ[1,i,0]:8:4,' ',pext:8:4);
      writeln(sss,' ',Vm[2,i,0]*1e3:8:4,' ',WQ[2,i,0]:8:4);
  end;
  close(sss);
end;

{=====================================================================}
procedure V1Column;
{
  Simulation by the ring model.
}
var
      Qold1,Qold2,pIE                           :double;
      i,j,iFunc,ntP,nl,n_dr_                    :integer;
begin
  if KeepParams=0 then  CommonParameters;
  case Smpl of
  0: ;
  1: ParametersFromFile;
  2: ParametersFromFile2;
  3: ParametersFromFile3;
  4: ParametersFromFile4;
  5: ParametersFromFile5;
  6: ParametersFromFile6;
  7: ParametersFromFile7;
  8: ParametersFromFile8;
  9: ParametersFromFile9;
  else
     ParametersFromFile;
  end;
  OtherParameters;
  InitialConditions_2D;
  for i:=0 to ni+1 do begin
      for j:=0 to nj+1 do begin
          From2D_To1node(i,j);
          InitialConditionsHodgkin;
          From1node_To2D(i,j);
      end;
  end;
  if DrawOrNot =1 then  Initial_Picture_2D;
  if DrawOrNot =1 then  Initial_Picture;
  if WriteOrNot=1 then  InitiateWriting;
  REPEAT
    { ----- Step ----- }
    t:=t+dt;   nt:=nt+1;

    for i:=0 to ni+1 do begin
      for j:=0 to nj+1 do begin
          From2D_To1node(i,j);
          { Soma }
          Qold1:=Q[1];
          Qold2:=Q[2];
          Q[1]:= PhaseDensity(1);
          Q[2]:= PhaseDensity(2);
          dQdt[1]:=(Q[1]-Qold1)/dt;
          dQdt[2]:=(Q[2]-Qold2)/dt;
          From1node_To2D(i,j);
      end;
    end;
    {-------------}
    AnalytPoissonEq(1);
    AnalytPoissonEq(2);
//    PoissonEq(1);
//    PoissonEq(2);
    if Form8.CheckBox2.Checked then  SmearExcitatoryInputIntoInterneurons;
    {-------------}
    for i:=0 to ni+1 do begin
      for j:=0 to nj+1 do begin
          From2D_To1node(i,j);
          { ----- inhibition }
{          pn[2]:=Q[2];}
          { Stimulation }
          IntegrateNoise;
          Set_Ps_Ring(i,j);
          { Dendrites }
          if Form8.CheckBox2.Checked then pIE:=pn1_smeared else pIE:=pn[1];
          SynapticCurrents(pext,pext, pn[1],pIE, pn[2],pn[2]);
          if IfPhase=0 then begin
             MembranePotential;
          end else begin
             MembranePotential_Phase;
          end;
          SpikeProb[1]:=SpikeProb[1] + Q[1]*dt;
          SpikeProb[2]:=SpikeProb[2] + Q[2]*dt;
          { Drawing }
          if (j=0)and(i=ni_stim) and (DrawOrNot=1) then begin
              if (nt mod n_show=0)or(nt=1)                then Evolution;
              if (nt mod n_DrawPhase=0)and(Form2.Visible) then DrawPhaseSpace;
          end;
          {***}
          From1node_To2D(i,j);
      end;
    end;
    Renamination_Ring;
    {**************************************}
    { Measurement }
    MeasureInNode(i_view,j_view);
    { Drawing }
    n_dr_:=trunc(Form8.DDSpinEdit3.Value);
    if ((trunc(nt/n_dr_)=nt/n_dr_)or(nt=1))then DrawChain;
    if (dt_out>0)and((nt=1)or(abs(t-trunc(t/dt_out)*dt_out)<dt)) then WriteChain;
    if (WriteOrNot=1) and (trunc(nt/2)=nt/2) then Writing;
    Application.ProcessMessages;
    Pause;
  UNTIL nt>=nt_end;
end;

procedure MemorizedParameters_V1;
begin
  Iext:=2.5; {mkA}
  Qns:=10; {Hz}
  gAMPA[1]:=1;  gAMPA[2]:=2;
  gGABA[1]:=2;
  ni:=40;
  { The rest params are in "E_v(t)_Lyle.id" }
  CorrespondParametersToTheForm;
end;

end.
