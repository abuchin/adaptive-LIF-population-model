unit MathMy;

interface

uses MyTypes;

function abs(x:double):double;
function sgn(x:double):integer;
function max(x,y:double):double;
function min(x,y:double):double;
function imax(x,y:integer):integer;
function imin(x,y:integer):integer;
function IfTrue(x :boolean):integer;
function LimRev(x,limit :double):double;
function trunc_my(x :double):integer;
function ThetaF(x :double):double;
function MinMod(x,y :double):double;
function dln(x :double) :double;
function dexp(x :double) :double;
function E_exp(dt,tau :double):double;
function alpha(x,y :double):double;
function step(a,b :double) :double;
function istep(x :double; n :integer) :double;
function zBst(y :double):double;
function Sigmoid(x :double) :double;
function Gauss(x,sigma :double) :double;
procedure LinearSistem(n:integer; A:matr; B:vect; var X:vect);
procedure ReverseMatrix(n:integer; A:matr; var A_1:matr);
procedure PrintMatrix(n :integer; A :matr);
procedure Matr_Vect(n:integer; A:matr; B:vect; var C:vect);
procedure LinearSistem_2x2(A:matr_2x2; B:vect_2; var X:vect_2);
procedure New_m1(al,beta,dt,T :double; var m,U,W :double);
procedure New_m (al,beta,dt,T :double; var m,U,W :double);

implementation
{
}

function abs(x:double):double;
  begin  if x<0 then abs:=-x else abs:=x;  end;
function sgn(x:double):integer;
  begin  if x<0 then sgn:=-1 else sgn:=1;  end;
function max(x,y:double):double;
  begin  if x>y then max:=x  else max:=y;  end;
function min(x,y:double):double;
  begin  if x<y then min:=x  else min:=y;  end;
function imax(x,y:integer):integer;
  begin  if x>y then imax:=x  else imax:=y;  end;
function imin(x,y:integer):integer;
  begin  if x<y then imin:=x  else imin:=y;  end;

function IfTrue(x :boolean):integer;
begin
  if x then IfTrue:=1 else IfTrue:=0;
end;

function LimRev(x,limit :double):double;
begin
  if x<limit then LimRev:=0
             else LimRev:=1/x;
end;

function trunc_my(x :double):longint;
begin
  if      abs(x)<1   then  trunc_my:=0
  else if  x> 1e8    then  trunc_my:=trunc( 1e8)
  else if  x<-1e8    then  trunc_my:=trunc(-1e8)
  else                     trunc_my:=trunc(x);
end;

function ThetaF(x :double):double;
begin    if x>0 then ThetaF:=1 else ThetaF:=0; end;

function MinMod(x,y :double):double;
var  abs_x,abs_y,minimum :double;
begin
     abs_x:=abs(x);
     abs_y:=abs(y);
     minimum:=min(abs_x,abs_y);
     if      minimum=abs_x  then  MinMod:=x
     else if minimum=abs_y  then  MinMod:=y
     else                         MinMod:=0;
end;

function dln(x :double) :double;
begin
  if x<1e-20 then  dln:=0  else  dln:=ln(x);
end;

function dexp(x :double) :double;
begin
  if      x<-20 then begin
     dexp:=0{exp(-20)}
  end else if x> 20 then begin
     dexp:=exp( 20)
  end else begin
     dexp:=exp(x);
  end;
end;

function E_exp(dt,tau :double):double;
begin    E_exp:= 1 - dexp(-dt*1000/tau); end;

function alpha(x,y :double):double;
begin
  if abs(x)<1e-10 then alpha:=0
  else if (x>0) and (y> -1e-10) then alpha:=arctan(y/x)
  else if (x>0) and (y<=-1e-10) then alpha:=2*pi+arctan(y/x)
  else {if x<0 then}                 alpha:=pi+arctan(y/x);
end;

function step(a,b :double) :double;    { step = a**b }
begin
  step:=exp(b*ln(a));
end;

function istep(x :double; n :integer) :double;
var  i :integer;  s :double;
begin
  if n=1 then istep:=x
         else if n=2 then istep:=sqr(x)
                     else if n=3 then istep:=x*sqr(x)
                                 else if n=4 then istep:=sqr(sqr(x))
                                             else  begin
     s:=1;
     if  n>0  then for i:=1 to n  do s:=s*x
     else {if n<0} for i:=1 to -n do s:=s/x;
     istep:=s;
                                                   end;
end;

function zBst(y :double):double;
begin  zBst:=y/(1+y);  end;

function Sigmoid(x :double) :double;
begin    Sigmoid:=2/(1+dexp(-2*x)) - 1;  end;

function Gauss(x,sigma :double) :double;
begin
  if sigma<>0 then Gauss:=dexp(-sqr(x/sigma))/(sqrt(pi)*sigma)
              else Gauss:=0;
end;

{-----------------------------------------------------------------}
{     Matrixes                                                    }
{-----------------------------------------------------------------}

procedure LinearSistem(n:integer; A:matr; B:vect; var X:vect);
{ Solver for system of linear equations AX=B with A[n,n] by Gauss method. }
var
     k,l,i,j    :integer;
     t,q,eps    :double;
begin
  eps:={0.00000001}1e-20;
  { Consisting of triangular matrix. }
  k:=1;
  REPEAT
    if abs(A[k,k])<eps then begin     { replace strings 'k' and 'l' }
       l:=k;  repeat  l:=l+1  until A[l,k]<>0;
       for j:=k to n do begin
           t:=A[k,j];
           A[k,j]:=A[l,j];
           A[l,j]:=t;
       end;
       t:=B[k];  B[k]:=B[l];  B[l]:=t;
    end;
    for i:=k+1 to n do begin
        q:=-A[i,k]/A[k,k];
        A[i,k]:=0;
        for j:=k+1 to n do begin
            A[i,j]:=A[i,j]+q*A[k,j];
        end;
        B[i]:=B[i]+q*B[k];
    end;
    k:=k+1;
  UNTIL k=n;
  { Solution. }
  X[n]:=B[n]/A[n,n];
  for i:=n-1 downto 1 do begin
      X[i]:=B[i];
      for j:=1 to n-i do begin
          X[i]:=X[i]-A[i,i+j]*X[i+j];
      end;
      X[i]:=X[i]/A[i,i];
  end;
end;

procedure ReverseMatrix(n:integer; A:matr; var A_1:matr);
var
    b,x :vect;
    i,j :integer;
begin
  for i:=1 to n do begin
      for j:=1 to n do  if i=j then b[j]:=1 else b[j]:=0;
      LinearSistem(n,A,b,x);
      for j:=1 to n do  A_1[j,i]:=x[j];
  end;
end;

procedure PrintMatrix(n :integer; A :matr);
var i,j :integer;
begin
  for i:=1 to n do begin
      for j:=1 to n do write(A[i,j]:10,' ');
      writeln;
  end;
end;

procedure Matr_Vect(n:integer; A:matr; B:vect; var C:vect);
{ Multiplying of matrix A[n,n] on vector B[n]: A*B=C. }
var
  i,j :integer;
begin
  for i:=1 to n do begin
      C[i]:=0;
      for j:=1 to n do begin
          C[i]:=C[i]+A[i,j]*B[j];
      end;
  end;
end;

procedure LinearSistem_2x2(A:matr_2x2; B:vect_2; var X:vect_2);
{ Solver for system of 2x2 linear equations AX=B. }
var
     eps,det    :double;
begin
  eps:=1e-8;
  if abs(A[1,1])<eps then begin
     A[1,1]:=A[1,1]+A[2,1];
     A[1,2]:=A[1,2]+A[2,2];
     B[1]:=B[1]+B[2];
  end;
  det:=A[2,2]*A[1,1]-A[1,2]*A[2,1];
  if abs(det)>1e-8 then begin
     X[2]:=(B[2]-B[1]/A[1,1]*A[2,1])/det*A[1,1];
     X[1]:=(B[1]-A[1,2]*X[2])/A[1,1];
  end else begin
     X[2]:=-13;
     X[1]:=-13;
  end;
end;

{-----------------------------------------------------------------}
{     Differential Equations                                      }
{-----------------------------------------------------------------}

procedure New_m1(al,beta,dt,T :double; var m,U,W :double);
{ Step of eq.  dm/dt = al*T*(1-m) - beta*m }
begin
  if dt*al*T>=1 then
     m:=al*T/(al*T+beta)
  else begin
     m:=m + dt*(al*T*(1-m)-beta*m);
  end;
end;

procedure New_m (al,beta,dt,T :double; var m,U,W :double);
{
 Step of eq.  ddm/ddt + (al+beta) dm/dt + al beta m = al beta T
 or equivalent system:      m = al*beta/(beta-al)(U-W)
                        dU/dt = T (1-m) -   al U
                        dW/dt = T (1-m) - beta U
}
begin
//  if IfInSyn_al_EQ_beta=1 then  beta:=al;
  if dt*(al+beta)>=1 then
     m:=T
  else begin
     if abs(al-beta)<0.001 then begin
        U :=U+dt*al*(T - U);
        m :=m+dt*al*(U - m);
     end else begin
        U :=U+dt*(T -   al*U);
        W :=W+dt*(T - beta*W);
        m :=al*beta/(beta-al)*(U - W);
     end;
  end;
end;

{--------- END OF FILE -----------------------------------------}
end.
