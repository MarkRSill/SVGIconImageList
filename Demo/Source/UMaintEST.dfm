object MainForm: TMainForm
  Left = 916
  Top = 169
  Caption = 
    'SVG Icon ImageList Demo - Copyright (c) Ethea S.r.l. - Apache 2.' +
    '0 Open Source License'
  ClientHeight = 234
  ClientWidth = 258
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object SVGIconImage: TSVGIconImage
    AlignWithMargins = True
    Left = 40
    Top = 40
    Width = 178
    Height = 113
    Hint = 'TSVGIconImage with Delphi SVG Logo'
    Margins.Left = 40
    Margins.Top = 40
    Margins.Right = 40
    Margins.Bottom = 40
    AutoSize = False
    Center = True
    Proportional = True
    Stretch = True
    Opacity = 255
    Scale = 1.000000000000000000
    ImageList = SVGIconImageList
    ImageIndex = 0
    Align = alClient
    Data = {00000000}
  end
  object Panel1: TPanel
    Left = 0
    Top = 193
    Width = 258
    Height = 41
    Align = alBottom
    TabOrder = 0
    OnClick = Panel1Click
    ExplicitLeft = -8
    ExplicitTop = 72
    ExplicitWidth = 185
  end
  object SVGIconImageList: TSVGIconImageList
    Width = 32
    Height = 32
    Size = 32
    Left = 176
    Top = 176
    Images = {
      010000000B00000061006C00610072006D005F0063006C006F0063006B006002
      00003C7376672076657273696F6E3D22312220786D6C6E733D22687474703A2F
      2F7777772E77332E6F72672F323030302F737667222076696577426F783D2230
      20302034382034382220656E61626C652D6261636B67726F756E643D226E6577
      20302030203438203438223E0D0A202020203C636972636C652066696C6C3D22
      23433632383238222063783D223234222063793D2232342220723D223230222F
      3E0D0A202020203C636972636C652066696C6C3D2223656565222063783D2232
      34222063793D2232342220723D223136222F3E0D0A202020203C726563742078
      3D2231392220793D2232322E3122207472616E73666F726D3D226D6174726978
      282D2E373037202D2E373037202E373037202D2E3730372031322E3930342036
      322E35333729222066696C6C3D2223303030304646222077696474683D222E38
      22206865696768743D223133222F3E0D0A202020203C7265637420783D223233
      2220793D223131222077696474683D223222206865696768743D223133222F3E
      0D0A202020203C7265637420783D2232362E312220793D2232322E3722207472
      616E73666F726D3D226D6174726978282D2E373037202E373037202D2E373037
      202D2E3730372036352E3738372032372E323529222066696C6C3D2223303030
      304646222077696474683D22322E3322206865696768743D22392E32222F3E0D
      0A202020203C636972636C652063783D223234222063793D2232342220723D22
      32222F3E0D0A202020203C636972636C652066696C6C3D222343363238323822
      2063783D223234222063793D2232342220723D2231222F3E0D0A3C2F7376673E
      0D0A}
  end
end