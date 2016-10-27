unit ThresholdO;

interface
uses Sysutils,MathMyO,typeNrnPars;

procedure Read_Threshold_from_File(iTable :integer);
function TabulatedThreshold(HH_type_ :string; DVDt,ts :double) :double;
function VThreshold3(NP_:NeuronProperties; DVDt,ts :double) :double;
function VThreshold2(NP_:NeuronProperties; DVDt,ts :double) :double;

implementation
{---- Threshold --------------------------------------------------}

const
    MaxThr=2000;
type
    vecThr  =array[0..MaxThr]   of double;
    vecThr2 =array[1..2,0..MaxThr] of double;
var
     Thr_dVdt                   :vecThr2;
     nThr_dVdt                  :integer;
     dThr_DVDt,min_tAP_Thr_DVDt :array[1..2] of double;
     IfReadThr                  :array[1..2] of integer;

procedure Read_Threshold_from_File(iTable :integer);
{  Reads the dependence of the threshold Thr on dV/dt from file.
   File has 2 columns: X[0..MaxThr], Y[0..MaxThr].
   Interpolation (linear) is applied to fill the array 'Thr_dVdt[0..MaxThr]'. }
var
     n,nE,i                     :integer;
     xc,w,dum1,dum2,dum3,dum4,
     dum5,dum6,min_tAP,max_dVdt :double;
     X,Y                        :vecThr;
     FileName                   :string;
     ttt                        :text;
begin
  case iTable of
    1: FileName:='set_VTh(dVdt)_Lyle.dat';
    2: FileName:='set_VTh(dVdt)_Chow.dat';
  end;
  { Reading file }
  if not(FileExists(FileName)) then exit;
  AssignFile(ttt,FileName); reset(ttt);
  min_tAP:=1e6; max_dVdt:=0;
  n:=0;
  repeat  n:=n+1;
    { 1-Th   2-tAP  3-Iind  4-DVDt_Th  5-Th1  6-DVDt_Th1 }
    readln(ttt,dum1,dum2,dum3,dum4,dum5,dum6);
    X[n]:=dum6; Y[n]:=dum5;  {dVdt and Thr of the first spike}
//    X[n]:=dum4; Y[n]:=dum1;    {dVdt and Thr of the second spike}
    if dum2<=0 then n:=n-1 {skip zero-threshold data}
    else begin
         if (dum2<min_tAP)and(dum2>0)  then min_tAP :=dum2;
         if  dum4>=max_dVdt then begin  max_dVdt:=dum4; nE:=n;  end;
    end;
  until (eof(ttt)) or (n=MaxThr);
  close(ttt);
  { Time criterion }
  min_tAP_Thr_DVDt[iTable]:=min_tAP/1000;
  { Remeshing - Filling array 'Thr_dVdt' }
  nThr_dVdt:=200;
  dThr_dVdt[iTable]:=X[nE]/sqr(nThr_dVdt);
  i:=-1;
  repeat  i:=i+1;
    xc:=sqr(i)*dThr_dVdt[iTable];
    { Finding the nearest right point in array 'Y' }
    n:=1;
    repeat n:=n+1
    until (n=nE) or (X[n]>xc);
    { Linear interpolation }
    if (X[n]-X[n-1]>1e-8)and(Y[n-1]<>0)and(n<nE)and(X[n-1]<xc) then
        w:=(xc-X[n-1])/(X[n]-X[n-1])                           else  w:=1;
    Thr_dVdt[iTable,i]:= Y[n-1]*(1-w) + Y[n]*w;
  until (i=nThr_dVdt);
  IfReadThr[iTable]:=1;
end;

function TabulatedThreshold(HH_type_ :string; DVDt,ts :double) :double;
{ Takes threshold from tabulated array 'Thr_dVdt' }
var
     z,w        :double;
     i,iTable   :integer;
begin
  if (HH_type_='Lyle') or (HH_type_='Buchin') then iTable:=1 else
  if HH_type_='Chow' then iTable:=2 else begin
     { Default }
     TabulatedThreshold:=0.010 {V};
     exit;
  end;
  { Prepare table for threshold }
  if IfReadThr[iTable]<>1 then  Read_Threshold_from_File(iTable);
  { Take the value }
  w:=sqrt(max(0,DVDt)/dThr_dVdt[iTable]);
  if abs(w)>64000 then begin
     { Warning('DVDT is too big in "TabulatedThreshold"'); }
     w:=nThr_dVdt;
  end;
  i:=trunc(w);
  if i<=0         then z:=Thr_dVdt[iTable,0] else
  if i>=nThr_dVdt then z:=Thr_dVdt[iTable,nThr_dVdt] else begin
     w:=(DVDt-sqr(i)*dThr_dVdt[iTable])/((sqr(i+1)-sqr(i))*dThr_dVdt[iTable]);
     z:= Thr_dVdt[iTable,i]*(1-w) + Thr_dVdt[iTable,i+1]*w;
  end;
  if ts<min_tAP_Thr_DVDt[iTable] then z:=50{mV};
  TabulatedThreshold:=z/1000;
end;

function VThreshold3(NP_:NeuronProperties; DVDt,ts :double) :double;
var z :double;
begin
  if NP_.FixThr>0 then begin
     z:=NP_.FixThr;
  end else begin
     DVDt:=max(0.00001,DVDt);
     z:=TabulatedThreshold(NP_.HH_type,DVDt,ts) + NP_.ThrShift;
  end;
  VThreshold3:=z;
end;

function VThreshold2(NP_:NeuronProperties; DVDt,ts :double) :double;
var z :double;
begin
  if DVDt<1e-8 then VThreshold2:=0.100{V}
               else VThreshold2:=VThreshold3(NP_,DVDt,ts);
end;
{---------------------------------------------------------------------}

end.
