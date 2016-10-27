unit other_2D;

interface
procedure From2D_To1node(i,j :integer);
procedure From1node_To2D(i,j :integer);
procedure WriteFromNode(i,j :integer);
procedure WritingField;
procedure WritingSectionOf2D;
procedure Renamination_2D;
procedure InitialConditions_2D;
procedure BoundaryConditions(ie :integer);

implementation
uses Init,MathMy,ph_Dens,ph_Volt,Hodgkin,HH_canal;

procedure From2D_To1node(i,j :integer);
{ Renames (i,j)-values of 2D arrays to values for 1 node.}
var ie,s :integer;
begin
  for ie:=1 to 3 do begin
      V[ie]   :=Vm[ie,i,j];
      VatE[ie]:=WVatE[ie,i,j];
      DuDt[ie]:=WDuDt[ie,i,j];
      if IfPhase=1 then begin
         for s:=0 to Nts do begin
             ro[ie,s]      :=Wro[ie,s,i,j];
             V0_ph[ie,s]   :=WV0_ph[ie,s,i,j];
             VE_ph[ie,s]   :=WVE_ph[ie,s,i,j];
             DuDt_ph[ie,s] :=WDuDt_ph[ie,s,i,j];
             nn_ph[ie,s]   :=Wnn_ph[ie,s,i,j];
             yK_ph[ie,s]   :=WyK_ph[ie,s,i,j];
             nA_ph[ie,s]   :=WnA_ph[ie,s,i,j];
             lA_ph[ie,s]   :=WlA_ph[ie,s,i,j];
             nM_ph[ie,s]   :=WnM_ph[ie,s,i,j];
             wAHP_ph[ie,s] :=WwAHP_ph[ie,s,i,j];
             IsynE_ph[ie,s]:=WIsynE_ph[ie,s,i,j];
             IsynI_ph[ie,s]:=WIsynI_ph[ie,s,i,j];
         end;
      end;
      p[ie] :=Wp[ie,i,j];
      pn[ie]:=Wpn[ie,i,j];
      po[ie]:=Wpo[ie,i,j];
      Q[ie] :=WQ[ie,i,j];
      dQdt[ie]:=WdQdt[ie,i,j];
  end;
  for ie:=1 to 2 do begin
      wAHP[ie]:=W_wAHP[ie,i,j];
      r_noise[ie]:=Wr_noise[ie,i,j];
      { Synaptic conductanses ----------------------}
      mAMP3[ie]:=W_mAMP3[ie,i,j];
      mAMPA[ie]:=W_mAMPA[ie,i,j];
      mGABB[ie]:=W_mGABB[ie,i,j];
      mGABA[ie]:=W_mGABA[ie,i,j];
      mGAB3[ie]:=W_mGAB3[ie,i,j];
      mNMD3[ie]:=W_mNMD3[ie,i,j];
      mNMDA[ie]:=W_mNMDA[ie,i,j];
      UAMP3[ie]:=W_UAMP3[ie,i,j];  WAMP3[ie]:=W_WAMP3[ie,i,j];
      UGAB3[ie]:=W_UGAB3[ie,i,j];  WGAB3[ie]:=W_WGAB3[ie,i,j];
      UAMPA[ie]:=W_UAMPA[ie,i,j];  WAMPA[ie]:=W_WAMPA[ie,i,j];
      UGABA[ie]:=W_UGABA[ie,i,j];  WGABA[ie]:=W_WGABA[ie,i,j];
      UGABB[ie]:=W_UGABB[ie,i,j];  WGABB[ie]:=W_WGABB[ie,i,j];
      UNMD3[ie]:=W_UNMD3[ie,i,j];  WNMD3[ie]:=W_WNMD3[ie,i,j];
      UNMDA[ie]:=W_UNMDA[ie,i,j];  WNMDA[ie]:=W_WNMDA[ie,i,j];
      UAMP3[ie]:=W_UAMP3[ie,i,j];
      eAMP[ie] :=W_eAMP[ie,i,j];
      UeAMP[ie]:=W_UeAMP[ie,i,j];  WeAMP[ie]:=W_WeAMP[ie,i,j];
      eGAB[ie] :=W_eGAB[ie,i,j];
      UeGAB[ie]:=W_UeGAB[ie,i,j];  WeGAB[ie]:=W_WeGAB[ie,i,j];
  end;
  for ie:=1 to 3 do begin
     { Control parameters }
      ss[ie]:=W_ss[ie,i,j];       { Inhibition }
      uu[ie]:=W_uu[ie,i,j] {mV};  { Excitation }
      ssE[ie]:=W_ssE[ie,i,j];       { Inhibition }
      ssI[ie]:=W_ssI[ie,i,j];       { Inhibition }
      uuE[ie]:=W_uuE[ie,i,j] {mV};  { Excitation }
      uuI[ie]:=W_uuI[ie,i,j] {mV};  { Excitation }
  end;
end;

procedure From1node_To2D(i,j :integer);
{ Renames (i,j)-values of 2D arrays to values for 1 node.}
var ie,s :integer;
begin
  for ie:=1 to 3 do begin
      Vm[ie,i,j]   :=V[ie] ;
      WVatE[ie,i,j]:=VatE[ie];
      WDuDt[ie,i,j]:=DuDt[ie];
      if IfPhase=1 then begin
         for s:=0 to Nts do begin
             Wro[ie,s,i,j]      :=ro[ie,s];
             WV0_ph[ie,s,i,j]   :=V0_ph[ie,s];
             WVE_ph[ie,s,i,j]   :=VE_ph[ie,s];
             WDuDt_ph[ie,s,i,j] :=DuDt_ph[ie,s];
             Wnn_ph[ie,s,i,j]   :=nn_ph[ie,s]  ;
             WyK_ph[ie,s,i,j]   :=yK_ph[ie,s]  ;
             WnA_ph[ie,s,i,j]   :=nA_ph[ie,s]  ;
             WlA_ph[ie,s,i,j]   :=lA_ph[ie,s]  ;
             WnM_ph[ie,s,i,j]   :=nM_ph[ie,s]  ;
             WwAHP_ph[ie,s,i,j] :=wAHP_ph[ie,s];
             WIsynE_ph[ie,s,i,j]:=IsynE_ph[ie,s];
             WIsynI_ph[ie,s,i,j]:=IsynI_ph[ie,s];
         end;
      end;
      Wp[ie,i,j] :=p[ie] ;
      Wpn[ie,i,j]:=pn[ie];
      Wpo[ie,i,j]:=po[ie];
      WQ[ie,i,j] :=Q[ie];
      WdQdt[ie,i,j]:=dQdt[ie];
  end;
  for ie:=1 to 2 do begin
      W_wAHP[ie,i,j]:=wAHP[ie];
      Wr_noise[ie,i,j]:=r_noise[ie];
      { Synaptic conductanses ----------------------}
      W_mAMP3[ie,i,j]:=mAMP3[ie];
      W_mAMPA[ie,i,j]:=mAMPA[ie];
      W_mGABB[ie,i,j]:=mGABB[ie];
      W_mGABA[ie,i,j]:=mGABA[ie];
      W_mGAB3[ie,i,j]:=mGAB3[ie];
      W_mNMD3[ie,i,j]:=mNMD3[ie];
      W_mNMDA[ie,i,j]:=mNMDA[ie];
      W_UAMP3[ie,i,j]:=UAMP3[ie];  W_WAMP3[ie,i,j]:=WAMP3[ie];
      W_UGAB3[ie,i,j]:=UGAB3[ie];  W_WGAB3[ie,i,j]:=WGAB3[ie];
      W_UAMPA[ie,i,j]:=UAMPA[ie];  W_WAMPA[ie,i,j]:=WAMPA[ie];
      W_UGABA[ie,i,j]:=UGABA[ie];  W_WGABA[ie,i,j]:=WGABA[ie];
      W_UGABB[ie,i,j]:=UGABB[ie];  W_WGABB[ie,i,j]:=WGABB[ie];
      W_UNMD3[ie,i,j]:=UNMD3[ie];  W_WNMD3[ie,i,j]:=WNMD3[ie];
      W_UNMDA[ie,i,j]:=UNMDA[ie];  W_WNMDA[ie,i,j]:=WNMDA[ie];
      W_eAMP[ie,i,j] :=eAMP[ie];
      W_UeAMP[ie,i,j]:=UeAMP[ie];  W_WeAMP[ie,i,j]:=WeAMP[ie];
      W_eGAB[ie,i,j] :=eGAB[ie];
      W_UeGAB[ie,i,j]:=UeGAB[ie];  W_WeGAB[ie,i,j]:=WeGAB[ie];
  end;
  for ie:=1 to 3 do begin
      { Control parameters }
      W_ss[ie,i,j]:=ss[ie];       { Inhibition }
      W_uu[ie,i,j]:=uu[ie];       { Excitation }
      W_ssE[ie,i,j]:=ssE[ie];       { Inhibition }
      W_ssI[ie,i,j]:=ssI[ie];       { Inhibition }
      W_uuE[ie,i,j]:=uuE[ie];       { Excitation }
      W_uuI[ie,i,j]:=uuI[ie];       { Excitation }
  end;
end;

{**********************************************************************}

procedure WriteFromNode(i,j :integer);
begin
  append(nnn);
  write  (nnn,t*1000:8:4,' ',Wpn[1,i,j]:10:3,' ',Wpn[2,i,j]:10:3,' ');
  writeln(nnn,Vm[1,i,j]*1000:10:3,' ', Vm[2,i,j]*1000:10:3);
  close(nnn);
end;

procedure WritingField;
var  i,j :integer;
     s1  :string;
begin
  str(round(t*1000):3, s1);
  s1:='xy'+s1+'e.dat';
  assign(sss,s1);  rewrite(sss);
  writeln(sss,'ZONE T="',s1,'"');
  writeln(sss,'I=',nj:3,',J=',ni:3,',K=1,F=POINT');
  for i:=1 to ni do  for j:=1 to nj do begin
      write  (sss,i*dx:9:5,' ',j*dy:9:5,' ',Vm[1,i,j]:8:4,' ',Vm[2,i,j]:8:4);
      writeln(sss,' ',Wp[1,i,j]:8:4,' ',Wp[2,i,j]:8:4);
  end;
  close(sss);
end;

function FileExists(FileName: string): Boolean;
{ Boolean function that returns True if the file exists; otherwise,
  it returns False. Closes the file if it exists. }
 var
  F: file;
begin
  {$I-}
  AssignFile(F, FileName);
  FileMode := 0;  {Set file access to read only }
  Reset(F);
  CloseFile(F);
  {$I+}
  FileExists := (IOResult = 0) and (FileName <> '');
end;

procedure WritingSectionOf2D;
var  i,j :integer;
     s1  :string;
begin
  s1:='2D(t,x).dat';
  if (FileExists(s1))and(t>0.001+dt) then begin
     assign(xxx,s1); append(xxx);
  end else begin
     assign(xxx,s1); rewrite(xxx);
     writeln(xxx,'ZONE T="',s1,'"');
     writeln(xxx,'I=',ni:3,',J=',trunc(t_end*1000)-1:3,',K=1,F=POINT');
  end;
  j:=nj_stim;
  for i:=1 to ni do begin
      write  (xxx,t*1000:9:5,' ',i*dx*1000:9:5,' ',Vm[1,i,j]:8:4,' ',Vm[2,i,j]:8:4);
      writeln(xxx,' ',Wp[1,i,j]:8:4,' ',Wp[2,i,j]:8:4);
  end;
  close(xxx);
end;

procedure Renamination_2D;
var  i,j :integer;
begin
    for i:=0 to ni+1 do begin
        for j:=0 to nj+1 do begin
            Wpo[1,i,j]:=Wp[1,i,j];    Wp[1,i,j]:=Wpn[1,i,j];
            Wpo[2,i,j]:=Wp[2,i,j];    Wp[2,i,j]:=Wpn[2,i,j];
                                      Wp[3,i,j]:=Wpn[3,i,j];
            Wu [1,i,j]:=Wun[1,i,j];  Wv [1,i,j]:=Wvn[1,i,j];
            Wu [2,i,j]:=Wun[2,i,j];  Wv [2,i,j]:=Wvn[2,i,j];
        end;
    end;
end;

{**********************************************************************}
procedure InitialConditions_2D;
var  i,j,ie :integer;
begin
  for i:=0 to ni+1 do begin
      for j:=0 to nj+1 do begin
          for ie:=1 to 3 do begin
              Wp [ie,i,j]:=0;
              Wpo[ie,i,j]:=0;
              WQ[ie,i,j] :=0;
              Vm[ie,i,j]:=Vrest[ie];
              { Intermediates for Ohm's law  ----------------------}
              WVatE[ie,i,j]:=Vrest[ie];
              W_uuE[ie,i,j]:=0;
              W_uuI[ie,i,j]:=0;
              W_ssE[ie,i,j]:=0;
              W_ssI[ie,i,j]:=0;
          {if (sqr(i)+sqr(j))<round(sqr(ni_2)) then begin}
          {if i>ni_2 then begin}
          {if (i>=ni_2-3) and (i<=ni_2+3) then begin}
{              Wpn[3,i,j]:=100;  }
{          end; }
              Wu[ie,i,j]:=0;   Wv[ie,i,j]:=0;
              Ww[ie,i,j]:= (Wp[ie,i,j]-Wpo[ie,i,j])/dt
                         + gam[i3_ie(ie)]*Wp[ie,i,j];
              Wun[ie,i,j]:=0;  Wvn[ie,i,j]:=0;
              { Noise }
              Wr_Noise[ie,i,j]:=0;
          end;
      end;
  end;
  {if IfChangeVrest=1 then}  V[3]:=Vrest[3] {for registrated cell}
                     {else  V[3]:=0}        {for Stimulating spike};
  SpikeProb[1]:=0;  SpikeProb[2]:=0;
  t:=0;   nt:=0;
end;

procedure BoundaryConditions(ie :integer);
var  i,j :integer;
begin
    { Soft conditions }
    for i:=0 to ni+1 do begin
        Wpn[ie,i,0]:=Wpn[ie,i,1];     Wpn[ie,i,nj+1]:=Wpn[ie,i,nj];
        Wvn[ie,i,0]:=0;               Wvn[ie,i,nj+1]:=0;
        Ww[ie,i,0]:=Ww[ie,i,1];       Ww[ie,i,nj+1]:=Ww[ie,i,nj];
    end;
    for j:=0 to nj+1 do begin
        Wpn[ie,0,j]:=Wpn[ie,1,j];     Wpn[ie,ni+1,j]:=Wpn[ie,ni,j];
        Wun[ie,0,j]:=0;               Wun[ie,ni+1,j]:=0;
        Ww[ie,0,j]:=Ww[ie,1,j];       Ww[ie,ni+1,j]:=Ww[ie,ni,j];
    end;
end;
end.
