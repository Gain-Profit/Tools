unit UTerbilang;

interface

uses System.SysUtils;

function MyTerbilang(ABilangan: Double): string;

const
  NL : ARRAY[0..9] of string
        = ('', 'Satu', 'Dua', 'Tiga', 'Empat', 'Lima', 'Enam', 'Tujuh',
           'Delapan', 'Sembilan');

implementation

function NolKiri(X: string; N: byte): string;
var
  I: Integer;
begin
  Result := X;
  if N > Length(X) then
  begin
    for I := Length(X) to Pred(N) do
      Result := '0' + Result;
  end;
end;

function NolTrim(x: string): string;
begin
  while (x[1] = '0') do
    Delete (x, 1, 1);
  Result := x;
end;

function SaySat(ASatuan: string): string;
begin
  Result := Format('%s ', [ NL[StrToInt(ASatuan)] ]);
end;

function SayPul(APuluhan: string): string;
begin
  if APuluhan[1] = '1' then
  begin
    if APuluhan[2] = '1' then
      Result := 'Sebelas ' else
    if APuluhan[2] = '0' then
      Result := 'Sepuluh ' else
      Result := Format('%sBelas ', [SaySat(APuluhan[2])]);
  end else
  if CharInSet(APuluhan[1], ['2'..'9']) then
    Result := Format('%sPuluh %s',[ SaySat(APuluhan[1]), SaySat(APuluhan[2]) ]) else
    Result := SaySat(APuluhan[2]);
end;

function SayRat(ARatusan: string): string;
begin
  if ARatusan[1] = '1' then
    Result := Format('Seratus %s', [SayPul(ARatusan[2] + ARatusan[3])]) else
  if CharInSet(ARatusan[1], ['2'..'9']) then
    Result := Format('%sRatus %s', [ SaySat(ARatusan[1]),
      SayPul(ARatusan[2] + ARatusan[3]) ]) else
    Result := SayPul(ARatusan[2] + ARatusan[3]);
end;

function SayRibu(ARibuan: string): string;
var
  LKiri, LKanan : string;
begin
  ARibuan := NolKiri(ARibuan, 6);
  Lkiri := Copy(ARibuan, 1, 3);
  Lkanan := Copy(ARibuan, 4, 3);
  if (Length(NolTrim(LKiri)) = 1) and (LKiri[3] = '1') then
     Result := Format('Seribu %s', [SayRat(Lkanan)]) else
  if Length(NolTrim(LKiri)) <> 0 then
     Result := Format('%sRibu %s', [SayRat(LKiri), SayRat(Lkanan)]) else
     Result := SayRat(Lkanan);
end;

function SayJuta(Ajutaan: string): string;
var
  LKiri, LKanan : string;
begin
  Ajutaan := NolKiri(Ajutaan, 9);
  LKiri := Copy(Ajutaan,1,3);
  LKanan := Copy(Ajutaan,4,6);
  if Length(NolTrim(LKiri)) <> 0 then
     Result := Format('%sJuta %s', [SayRat(LKiri), SayRibu(LKanan)]) else
     Result := SayRibu(LKanan);
end;

function SayMil(AMilyaran: string) : string;
var
  LKiri, LKanan : string;
begin
  AMilyaran := NolKiri(AMilyaran, 12);
  LKiri := Copy(AMilyaran,1,3);
  LKanan := Copy(AMilyaran,4,9);
  if Length(NolTrim(LKiri)) <> 0 then
     Result := Format('%sMilyar %s', [SayRat(LKiri), SayJuta(LKanan)]) else
     Result := SayJuta(LKanan);
end;

function SayTril(ATrilyun: string) : string;
var
  LKiri, LKanan : string;
begin
  ATrilyun := nolkiri(ATrilyun, 15);
  LKiri := Copy(ATrilyun,1,3);
  LKanan := Copy(ATrilyun,4,12);
  if Length(NolTrim(LKiri)) <> 0 then
     Result := Format('%sTrillyun %s', [SayRat(LKiri), SayMil(LKanan)]) else
     Result := SayMil(LKanan);
end;

function MyTerbilang(ABilangan: Double): string;
var
  LBilText, LInduk, LKoma, LTanda, TI, TK : string;
  I : Integer;
  LDecimal : Char;
begin
  //Inisialisasi
  LDecimal := FormatSettings.DecimalSeparator;
  LBilText := FloatToStr(ABilangan);
  LInduk  :=  LBilText;

  //Mencari titik lalu memisahkan keduanya--
  if pos(LDecimal, LBilText) > 0 then
  begin
    LKoma :=  LInduk;
    Delete(LKoma, 1, pos(LDecimal, LBilText));
    Delete(LInduk, pos('.', LInduk), Length(LKoma) + 1);
    LTanda := 'Koma ';
  end;
  //Menulis Angka Induk----------------------
  case length(LInduk) of
  0      : TI   := '';
  1      : Begin
            if LInduk = '0' then
            TI := 'Nol' else
            TI := SaySat(LInduk);
          End;
  2      : TI:= SayPul(LInduk);
  3      : TI:= SayRat(LInduk);
  4..6   : TI:= SayRibu(LInduk);
  7..9   : TI:= SayJuta(LInduk);
  10..12 : TI:= SayMil(LInduk);
  13..15 : TI:= SayTril(LInduk);
  end;
//Menulis angka koma------------------------
  for I := 0 to (Length(LKoma)-1) do
  begin
     Case StrToInt(Copy(LKoma, I + 1, 1)) of
     0 : TK := TK + 'Nol ';
     1 : TK := TK + 'Satu ';
     2 : TK := TK + 'Dua ';
     3 : TK := TK + 'Tiga ';
     4 : TK := TK + 'Empat ';
     5 : TK := TK + 'Lima ';
     6 : TK := TK + 'Enam ';
     7 : TK := TK + 'Tujuh ';
     8 : TK := TK + 'Delapan ';
     9 : TK := TK + 'Sembilan ';
     end;
  end;
  //Tulis Semuanya-----------------------
  Result := TI + LTanda + TK;
end;

end.

