unit Threshold;

interface
uses Init;

procedure WriteThreshold;
function VThreshold3(ie :integer; DVDt,ts :double) :double;

const  MaxThr=2000;
type vecThr1  =array[0..MaxThr] of double;
     vecThr2  =array[1..2,0..MaxThr] of double;
var
     nThr_DVDt                          :integer;
     Thr_DVDt                           :vecThr2;
     dThr_DVDt,min_tAP_Thr_DVDt         :array[1..2] of double;
     IfReadThr                          :array[1..2] of integer;
{****************************************************}

implementation
uses Sysutils,mathMy,Hodgkin,HH_canal,Unit1,Unit2,Unit4,graph_0d;


function VThreshold2(ie :integer; DVDt :double) :double;
var z,x,x2,x3,x4,x5 :double;
begin
//  if DVDt<0 then z:=100 {mV} else begin
     if DVDt<0.00001 then DVDt:=0.00001;
     if i3_ie(ie)=1 then begin
        {*** Pyramid ***}
        {for 'Migliore' fitted to [Ali, Fig1A] }
        z:=6.96+exp( 5.04980E-001*ln(DVDt) +  1.98047E+000)
          +ThrCorrection[1]*1000;
     end else if i3_ie(ie)=2 then begin
        {*** Interneuron ***}
        if HH_type[ie]='Chow' then begin
           {for 'Chow'     fitted to [Japon. paper, Fig.2A], bistratified cell }
           x:=DVDt;  x2:=DVDt*DVDt;  x3:=x*x2;  x4:=x2*x2;  x5:=x2*x3;
           z:=6.0059+  23.2162*x -32.3496*x2 +29.339*x3  -15.441*x4 +4.921*x5
             -0.9636*x4*x2 +0.11332*x4*x3 -7.3404E-003*x4*x4
             +2.01287E-004*x4*x5
             +ThrCorrection[2]*1000;
        end else begin
           {for 'Migliore' fitted to [Ali, Fig1A] }
           z:=7.52+exp( 4.57625E-001*ln(DVDt) +  1.96531E+000)
             +ThrCorrection[2]*1000;
        end;
     end else  Warning('Error in VThreshold.');

//  end;
  VThreshold2:=z/1000;
end;

//procedure ReadThrFile;
{ Reads table for threshold }
{var aaa :text;
    i   :integer;
    dum2,dum3 :double;
begin
  assign(aaa,'VTh(tAP).dat'); reset(aaa);
  i:=0;
  while not(eof(aaa)) do begin
     i:=i+1;
     readln(aaa,Thr_DVDt[i,1],dum2,dum3,Thr_DVDt[i,2]);
  end;
  nThr_DVDt:=i;
  IfReadThr:=1;
  close(aaa);
end;}

procedure Read_Threshold_from_File(ie :integer);
{  Reads the dependence of the threshold Thr on dV/dt from file.
   File has 2 columns: X[0..MaxThr], Y[0..MaxThr].
   Interpolation (linear) is applied to fill the array 'Thr_dVdt[0..MaxThr]'. }
var
     n,nE,i                     :integer;
     xc,w,dum1,dum2,dum3,dum4,
     dum5,dum6,min_tAP,max_dVdt :double;
     X,Y                        :vecThr1;
     FileName                   :string;
     ttt                        :text;
begin
  case ie of
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
  min_tAP_Thr_DVDt[ie]:=min_tAP/1000;
  { Remeshing - Filling array 'Thr_dVdt' }
  nThr_dVdt:=200;
  dThr_dVdt[ie]:=X[nE]/sqr(nThr_dVdt);
  i:=-1;
  repeat  i:=i+1;
    xc:=sqr(i)*dThr_dVdt[ie];
    { Finding the nearest right point in array 'Y' }
    n:=1;
    repeat n:=n+1
    until (n=nE) or (X[n]>xc);
    { Linear interpolation }
    if (X[n]-X[n-1]>1e-8)and(Y[n-1]<>0)and(n<nE)and(X[n-1]<xc) then
        w:=(xc-X[n-1])/(X[n]-X[n-1])                           else  w:=1;
    Thr_dVdt[ie,i]:= Y[n-1]*(1-w) + Y[n]*w;
  until (i=nThr_dVdt);
  IfReadThr[ie]:=1;
end;

function TabulatedThreshold(ie :integer; DVDt :double) :double;
{ Takes threshold from tabulated array 'Thr_dVdt' }
var
     z,w        :double;
     i,j        :integer;
begin
  w:=sqrt(max(0,DVDt)/dThr_dVdt[ie]);
  if abs(w)>64000 then begin
     Warning('DVDT is too much in "TabulatedThreshold"');
  end;
  i:=trunc(w);//trunc(sqrt(max(0,DVDt)/dThr_dVdt[ie]));
  if i<=0         then z:=Thr_dVdt[ie,0] else
  if i>=nThr_dVdt then begin
     if Form4.CheckBox13.Checked then
                       z:=100 {mV}
     else              z:=Thr_dVdt[ie,nThr_dVdt];
  end else begin
     w:=(DVDt-sqr(i)*dThr_dVdt[ie])/((sqr(i+1)-sqr(i))*dThr_dVdt[ie]);
     z:= Thr_dVdt[ie,i]*(1-w) + Thr_dVdt[ie,i+1]*w;
  end;
  TabulatedThreshold:=z/1000;
end;

procedure WriteThreshold;
var aaa :text;
    i   :integer;
    dVdt:double;
begin
  assign(aaa,'Check_Thr(dVdt).dat'); rewrite(aaa);
  FOR i:=0 to 2000 do begin
      dVdt:=i/400;
      writeln(aaa,dVdt:9:4,' ',VThreshold3(i3,dVdt,0.010{s})*1000:9:4,' ');
  END;
  close(aaa);
end;

function VThreshold3(ie :integer; DVDt,ts :double) :double;
var
    i,k :integer;
    kk  :double;
    S   :string;
begin
  k:=i3_ie(ie);
  { Apply fixed constant threshold }
  S:=Form4.SpecCond.Items[Form4.SpecCond.ItemIndex];
  if (S='FixThreshold=14mV')or
    ((S='Fix T=14mV for E-cells')and(k=1))or
    ((S='Fix T=14mV for I-cells')and(k=2)) then begin
     VThreshold3:=0.014+ThrCorrection[k]; exit;
  end;
  { Apply approximated function for Thr(DVDt) }
  if (k=1)and(HH_type[k]<>'Lyle') then begin
      VThreshold3:=VThreshold2(k,DVDt);
      Exit;
  end;

//  if DVDt<0.00001 then begin  VThreshold3:=0.100 {V}; Exit; end;
//  if DVDt<0.00001 then DVDt:=0.00001;     { 15.02.2006 }
  { Prepare table for threshold }
  if IfReadThr[k]<>1 then  Read_Threshold_from_File(k);
  VThreshold3:=TabulatedThreshold(k,DVDt) + ThrCorrection[k];
  if ts<min_tAP_Thr_DVDt[k] then VThreshold3:=0.050{V};
end;

end.
