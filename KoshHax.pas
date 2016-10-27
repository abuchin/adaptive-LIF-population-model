unit KoshHax;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TeEngine, Series, ExtCtrls, TeeProcs;

type
x=double;

{n}
function alfan(x:double):double;
function alfann(x:double):double;
function gamman(x:double):double;
function gammann(x:double):double;

{m}
function alfam(x:double):double;
function alfamm(x:double):double;
function gammam(x:double):double;
function gammamm(x:double):double;

{h}
function alfah(x:double):double;
function gammah(x:double):double;

{Iahp}
function tauw(x:double):double;
function w8(x:double):double;

{Imi}
function a(x:double):double;
function b(x:double):double;
function taux(x:double):double;
function x8(x:double):double;



implementation
{n}
function alfan(x:double):double;
begin alfan:=0.01*(x-10)/(1-exp(1-0.1*x));end;

function alfann(x:double):double;
begin alfann:=0.1/exp(1-0.1*x);end;

function gamman(x:double):double;
begin gamman:=alfan(x) + 0.125*exp(-x/80);end;

function gammann(x:double):double;
begin gammann:=alfann(x) + 0.125*exp(-x/80);end;


{m}
function alfam(x:double):double;
begin alfam:=0.1*(x-25)/(1-exp(2.5-0.1*x));end;

function alfamm(x:double):double;
begin alfamm:=1/exp(2.5-0.1*x);end;

function gammam(x:double):double;
begin gammam:=alfam(x) + 4*exp(-x/18) ;end;

function gammamm(x:double):double;
begin gammamm:=alfamm(x) + 4*exp(-x/18) ;end;


{h}
function alfah(x:double):double;
begin alfah:=0.07*exp(-x/20);end;

function gammah(x:double):double;
begin gammah:=alfah(x) + 1/(1+exp(3-0.1*x));end;



{Iahp}
function tauw(x:double):double;
begin tauw:=400*5/( 3.3*exp((x+35)/20)+exp(-(x+35)/20) ) ;end;

function w8(x:double):double;
begin w8:=1/(1+exp(-(x+35)/10)) ;end;


{Imi}
function a(x:double):double;
begin a:=0.003*exp(0.135*(x-15)) ;end;

function b(x:double):double;
begin b:=0.003*exp(-0.090*(x-15)) ;end;

function taux(x:double):double;
begin taux:=1/(a(x)+b(x))+8 ;end;

function x8(x:double):double;
begin x8:=a(x)/(a(x)+b(x)) ;end;


End.
