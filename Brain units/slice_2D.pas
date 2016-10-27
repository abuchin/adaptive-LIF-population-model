unit slice_2D;
{ **********************************************************************
  The subprogram simulates 2D-slice.
  **********************************************************************}

interface
procedure DefaultParameters_2D;
procedure System_2D;

implementation
uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
     StdCtrls, ComCtrls, ExtCtrls,
     Init,mathMy,Wright,slice,other,other_2D,Hodgkin,HH_canal,
     graph_0d, graph_2D,wave,Unit1,Unit3,ph_Dens,ph_Volt,Correspond;

procedure DefaultParameters_2D;
  procedure put (var x:double;  val:double);   begin if x=0 then x:=val; end;
  procedure iput(var x:integer; val:integer);  begin if x=0 then x:=val; end;
begin
  put(a_axon[1],1{.39} {m/s});       put(a_axon[2],1 {m/s});
{************************ Calculation parameters ********************}
  dt:=0.000025/1.5;
  iput(ni,20);  iput(nj,1);
  Nts:=30; ts_end:=0.060{s};
  t_end:=0.100{s};
  ni_2:=trunc(ni/2);
  nj_2:=trunc(nj/2);
  iput(R_stim,4);  iput(ni_stim,trunc(3/4*ni)); iput(nj_stim,trunc(nj/2));
  put(dx,60*a_axon[1]*dt);   dy:=dx;   {Courant condition}
  dx2:=dx/2;                dy2:=dy/2;
  OrderOfWaveEq:=2; 
  { Output file }
  dt_out:=0.010 {s};
  WriteOrNot:=1;
  assign(nnn,'focal_2D.dat');  rewrite(nnn);  close(nnn);
{*****************************************************************}
  CorrespondParametersToTheForm;
end;

procedure Set_Ps_2D(i,j :integer);
var R_:double;
begin
  pext:=Qns;
  if (t>t0s) and (t<t0s+tSt) then  begin
{      if ((i>=ni_2-5)and(i<=ni_2+5))and(j<=5) then }
      { distance from electrode center}
      R_:=sqrt(sqr(i-ni_stim)+sqr(j-nj_stim));
      if R_<=R_stim then begin
//      if sqr(i-3/4*ni)<=sqr(8) then
          pext:=pext + Iext{mkA} * 4{1/(mkA*s)};
      end else begin
          pext:=pext + Iext{mkA} * 4{1/(mkA*s)} * R_stim/R_;
      end;
  end;
end;

procedure MeasureInNode(i,j :integer);
var l :integer;
begin
  From2D_To1node(i,j);
  Set_Ps_2D(i,j);
  for l:=1 to 3 do Iadd[l]:= Current_Iind(l);
  case If_I_V_or_p of
    1: Vmod[nt]:=(PSC[3]+Current_Iind(3))*Square[i3]*1e9; {pA}
    2: Vmod[nt]:=V[3]-Vrest[3];
    3: Vmod[nt]:=Q[3];
    4: Vmod[nt]:=VatE[3]-Vrest[3];
    5: Vmod[nt]:=VatE[3]-Vrest[3];
  end;
end;

{**************************************************************************}
procedure System_2D;
{
  Simulation by Wright's model, comparison with sample 'Vexp',
  calculation of residual in 'dimF'-th different intervals.
}
var
      Func,Qun1,Qun2,Qst1,Qst2,Qold1,Qold2      : double;
      i,j,iFunc,ntP,nl,n_dr_                    : integer;
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
  ReadExpData;
  InitialConditions_2D;
  for i:=0 to ni+1 do begin
      for j:=0 to nj+1 do begin
          From2D_To1node(i,j);
          InitialConditionsHodgkin;
          From1node_To2D(i,j);
      end;
  end;
  if DrawOrNot =1 then  Initial_Picture_2D;
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
          if IfPhase=0 then begin
             Qun1:=BurstOfAPs(V[1]-Vrest[1], DuDt[1],VThr0[i3_ie(1)]);
             Qun2:=BurstOfAPs(V[2]-Vrest[2], DuDt[2],VThr0[i3_ie(2)]);
             Qst1:=QfromIs0(uu[1],ss[1],1);
             Qst2:=QfromIs0(uu[2],ss[2],2);
             Q[1]:= max(Qun1, Qst1);
             Q[2]:= max(Qun2, Qst2);
          end else begin
             Q[1]:= PhaseDensity(1);
             Q[2]:= PhaseDensity(2);
          end;
          dQdt[1]:=(Q[1]-Qold1)/dt;
          dQdt[2]:=(Q[2]-Qold2)/dt;
          From1node_To2D(i,j);
      end;
    end;
    {-------------}
    AxonEquation(1);
    AxonEquation(2);
    BoundaryConditions(1);
    BoundaryConditions(2);
    {-------------}
    for i:=0 to ni+1 do begin
      for j:=0 to nj+1 do begin
          From2D_To1node(i,j);
          { ----- inhibition }
{          pn[2]:=Q[2];}
          { Stimulation }
          IntegrateNoise;
          Set_Ps_2D(i,j);
          { Dendrites }
          SynapticCurrents(pext,pext, pn[1],pn[1], pn[2],pn[2]);
          if IfPhase=0 then begin
             MembranePotential;
          end else begin
             MembranePotential_Phase;
          end;
{          if (i=ni_stim)and(j=nj_stim)and(round(nt/10)*10=nt)
              then  DrawPhaseSpace;}
          SpikeProb[1]:=SpikeProb[1] + Q[1]*dt;
          SpikeProb[2]:=SpikeProb[2] + Q[2]*dt;
          DuDtmax[1]:=max(DuDtmax[1],DuDt[1]);
          DuDtmax[2]:=max(DuDtmax[2],DuDt[2]);
          From1node_To2D(i,j);
      end;
    end;
    Renamination_2D;
    {**************************************}
    { Measurement }
    MeasureInNode(i_view,j_view);
    { Drawing }
    n_dr_:=trunc(Form3.DDSpinEdit3.Value);
    if (round(nt/n_dr_)*n_dr_=nt) then
        Draw_Lattice(1,ni,nj,{jwiew=}nj_2,Wpn);
    if ((trunc(nt/n_show)=nt/n_show)or(nt=1))then
        GraphicsFor1Node({ie=}1, i_view,j_view);
    if (WriteOrNot=1) and (trunc(nt/2)=nt/2) then Writing;
    //WriteFromNode(ni_stim, nj_stim);
    if (abs(t-trunc(t*1000)/1000)<dt) then WritingSectionOf2D;
    if (abs(t-0.005)<dt)or(abs(t-trunc(t/dt_out)*dt_out)<dt) then WritingField;
    MyThread1.Treat_Key;
    Application.ProcessMessages;
    Pause;
  UNTIL nt>=nt_end;
//  if WriteOrNot=1 then  close(ccc);
end;
{--------------------EOF---------------------------------------------------}

end.
