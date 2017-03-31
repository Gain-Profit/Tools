object FUtama: TFUtama
  Left = 320
  Top = 158
  Width = 322
  Height = 208
  BorderIcons = [biSystemMenu]
  Caption = 'Aplikasi Hapus Transaksi'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 88
    Width = 289
    Height = 73
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'Aplikasi ini Akan Menghapus Seluruh Transaksi '#13#10'Dan Menjadikan S' +
      'eluruh Stok Barang Menjadi 0'#13#10'sekaligus akan Menghapus Seluruh T' +
      'ransaksi Akuntansi.'
    Color = clRed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 132
    Height = 13
    Caption = 'Masukkan Kode Keamanan'
  end
  object BtnHapus: TButton
    Left = 8
    Top = 56
    Width = 289
    Height = 25
    Caption = 'Hapus Seluruh Transaksi'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = BtnHapusClick
  end
  object EdKeamanan: TEdit
    Left = 8
    Top = 24
    Width = 289
    Height = 21
    TabOrder = 0
  end
  object Con: TMyConnection
    Left = 256
    Top = 136
  end
end
