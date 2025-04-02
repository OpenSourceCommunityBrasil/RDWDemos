object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Serializa'#231#227'o de JSON - B'#225'sico'
  ClientHeight = 442
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object mJSONResult: TMemo
    Left = 0
    Top = 152
    Width = 628
    Height = 290
    Align = alBottom
    TabOrder = 0
  end
  object Button1: TButton
    Left = 72
    Top = 72
    Width = 75
    Height = 25
    Caption = 'JsonValue'
    TabOrder = 1
    OnClick = Button1Click
  end
end
