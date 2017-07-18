unit UTerbilang;

interface

uses SysUtils;

type TStr15= String[15];

function MyTerbilang(Bilangan:Double):String;

const
  NL : ARRAY[0..9] OF STRING[8]
           = ( '','Satu','Dua','Tiga','Empat','Lima','Enam','Tujuh',
               'Delapan','Sembilan');

implementation

Function nolkiri(x:string;n:byte):string;
var p : integer;
    s : TStr15;
begin
  p := length(x);
  if n > p then
  begin
    fillchar(s,(n-p)+1,'0');
    s[0] := AnsiChar(n-p);
    x := s+x;
  end;
  nolkiri := x;
end;

Function noltrim (x:TStr15):string;
begin
  if (x[0] <> #0) then
     while (x[1] = '0') and (x[0] <> #0) do
           delete (x,1,1);
     noltrim := x;
end;

function saysat(sat:TStr15):string;
var angka,i : integer;
begin
  if sat[1]='0' then saysat := '' else
  begin
    val(sat[1],angka,i);
    saysat := nl[angka]+' '
  end;
end;

function saypul(pul : TStr15) : STRING;
begin
  if pul[1] = '1' then
  begin
    if pul[2] = '1' then saypul := 'Sebelas ' else
    if pul[2] = '0' then saypul := 'Sepuluh ' else
       saypul := saysat(pul[2])+'Belas '
  end else
  if pul[1] in['2'..'9'] then
     saypul := saysat(pul[1])+'Puluh '+ saysat(pul[2])
  else saypul := saysat(pul[2]);
end;

function sayrat(rat : TStr15) : string;
begin
  if rat[1] = '1' then
     sayrat := 'Seratus '+ saypul(rat[2]+rat[3]) else
  if rat[1] in['2'..'9'] then
     sayrat := saysat(rat[1])+'Ratus '+ saypul(rat[2]+rat[3])
  else sayrat := saypul(rat[2]+rat[3]);
end;

function sayribu(ribu : TStr15) : string;
var a,b : TStr15;
begin
  ribu := nolkiri(ribu,6);
  a := copy(ribu,1,3);
  b := copy(ribu,4,3);
  if (length(noltrim(a)) = 1) and (a[3] = '1') then
     sayribu := 'Seribu '+ sayrat(b) else
  if length(noltrim(a)) <> 0 then
     sayribu := sayrat(a)+'Ribu '+ sayrat(b)
  else sayribu := sayrat(b);
end;

function sayjuta(juta : TStr15) : string;
var a,b : TStr15;
begin
  juta := nolkiri(juta,9);
  a := copy(juta,1,3);
  b := copy(juta,4,6);
  if length(noltrim(a)) <> 0 then
     sayjuta :=  sayrat(a)+'Juta '+sayribu(b)
  else sayjuta := sayribu(b);
end;

function saymill(mill : TStr15) : string;
var a,b : TStr15;
begin
  mill := nolkiri(mill,12);
  a := copy(mill,1,3);
  b := copy(mill,4,9);
  if length(noltrim(a)) <> 0 then
     saymill :=  sayrat(a)+'Milyar '+sayjuta(b)
  else saymill := sayjuta(b);
end;

function saytril(tril : TStr15) : string;
var a,b : TStr15;
begin
  tril := nolkiri(tril,15);
  a := copy(tril,1,3);
  b := copy(tril,4,12);
  if length(noltrim(a)) <> 0 then
     saytril :=  sayrat(a)+'Trillyun '+saymill(b)
  else saytril :=  saymill(b);
end;

function MyTerbilang;
var
   a, b, x, y, Induk, Koma, TI, TK, Tanda: String;
    c,d,e,f : Integer;
   bilText:String;
begin
//Inisialisasi
  c:=0;
  BilText := FloatToStr(bilangan);
  x:=  bilText;
  y:=x;
  TI:='';
  TK:='';
  Tanda:='';
//Mencari titik lalu memisahkan keduanya--
  if pos('.',BilText)>0 then
  begin
     while pos('.',y)>0 do
       delete(y,1,1);
       f:=Length(y);
     while pos('.',x)>0 do
       delete(x,pos('.',x),f+1);
     Induk:=x;
     Koma:=y;
     Tanda :='Koma ';
  end
//Mencari komalalu memisahkan keduanya----
  else
    if pos(',',BilText)>0 then
    begin
     while pos(',',y)>0 do
       delete(y,1,1);
       f:=Length(y);
     while pos(',',x)>0 do
       delete(x,pos(',',x),f+1);
     Induk:=x;
     Koma:=y;
     Tanda:='Koma ';
    end;
//Menulis Angka Induk----------------------
   case length(x) of
   0      : TI   := '';
   1      : Begin
              if x='0' then TI:='Nol' else
              TI   := saysat(x);
            End;
   2      : TI:= saypul(x);
   3      : TI:= sayrat(x);
   4..6   : TI:= sayribu(x);
   7..9   : TI:= sayjuta(x);
   10..12 : TI:= saymill(x);
   13..15 : TI:= saytril(x);
   end;
//Menulis angka koma------------------------
  for d:=0 to (Length(Koma)-1) do
  begin
     c:=c+1;
     a:=Copy(Koma,c,1);
     e:=StrToIntdef(a,0);
     Case e of
     0 : b:='Nol ';
     1 : b:='Satu ';
     2 : b:='Dua ';
     3 : b:='Tiga ';
     4 : b:='Empat ';
     5 : b:='Lima ';
     6 : b:='Enam ';
     7 : b:='Tujuh ';
     8 : b:='Delapan ';
     9 : b:='Sembilan ';
     end;
     TK:=TK+b;
  end;
//Tulis Semuanya-----------------------
MyTerbilang:=TI+Tanda+TK;
end;

end.

