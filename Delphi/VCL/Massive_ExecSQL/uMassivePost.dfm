object fMassivePost: TfMassivePost
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'MassivePost'
  ClientHeight = 348
  ClientWidth = 382
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnClose = FormClose
  TextHeight = 15
  object Label1: TLabel
    Left = 52
    Top = 23
    Width = 50
    Height = 15
    Caption = 'EMP_NO:'
  end
  object Label2: TLabel
    Left = 32
    Top = 47
    Width = 70
    Height = 15
    Caption = 'FIRST_NAME:'
  end
  object Label3: TLabel
    Left = 34
    Top = 76
    Width = 68
    Height = 15
    Caption = 'LAST_NAME:'
  end
  object Label4: TLabel
    Left = 35
    Top = 106
    Width = 67
    Height = 15
    Caption = 'PHONE_EXT:'
  end
  object Label5: TLabel
    Left = 42
    Top = 135
    Width = 60
    Height = 15
    Caption = 'HIRE_DATE:'
  end
  object Label6: TLabel
    Left = 72
    Top = 162
    Width = 30
    Height = 15
    Caption = 'DEPT:'
  end
  object Label7: TLabel
    Left = 79
    Top = 192
    Width = 23
    Height = 15
    Caption = 'JOB:'
  end
  object Label8: TLabel
    Left = 37
    Top = 219
    Width = 65
    Height = 15
    Caption = 'JOB_GRADE:'
  end
  object Label9: TLabel
    Left = 57
    Top = 260
    Width = 45
    Height = 15
    Caption = 'SALARY:'
  end
  object Label10: TLabel
    Left = 20
    Top = 239
    Width = 82
    Height = 15
    Caption = 'JOB_COUNTRY:'
  end
  object Label11: TLabel
    Left = 65
    Top = 281
    Width = 37
    Height = 15
    Caption = 'TIMEC:'
  end
  object DBTEMP_NO: TDBText
    Left = 108
    Top = 23
    Width = 67
    Height = 15
    AutoSize = True
    DataField = 'EMP_NO'
    DataSource = fPrincipal.dsClientSQLEmployee
  end
  object DBTHIRE_DATE: TDBText
    Left = 108
    Top = 135
    Width = 77
    Height = 15
    AutoSize = True
    DataField = 'HIRE_DATE'
    DataSource = fPrincipal.dsClientSQLEmployee
  end
  object DBTJOB_GRADE: TDBText
    Left = 108
    Top = 219
    Width = 81
    Height = 15
    AutoSize = True
    DataField = 'JOB_GRADE'
    DataSource = fPrincipal.dsClientSQLEmployee
  end
  object DBTJOB_COUNTRY: TDBText
    Left = 108
    Top = 239
    Width = 98
    Height = 15
    AutoSize = True
    DataField = 'JOB_COUNTRY'
    DataSource = fPrincipal.dsClientSQLEmployee
  end
  object DBTSALARY: TDBText
    Left = 108
    Top = 260
    Width = 62
    Height = 15
    AutoSize = True
    DataField = 'SALARY'
    DataSource = fPrincipal.dsClientSQLEmployee
  end
  object DBTTIMEC: TDBText
    Left = 108
    Top = 281
    Width = 54
    Height = 15
    AutoSize = True
    DataField = 'TIMEC'
    DataSource = fPrincipal.dsClientSQLEmployee
  end
  object DBEFIRST_NAME: TDBEdit
    Left = 108
    Top = 44
    Width = 233
    Height = 23
    CharCase = ecUpperCase
    DataField = 'FIRST_NAME'
    DataSource = fPrincipal.dsClientSQLEmployee
    TabOrder = 0
  end
  object DBELAST_NAME: TDBEdit
    Left = 108
    Top = 73
    Width = 233
    Height = 23
    CharCase = ecUpperCase
    DataField = 'LAST_NAME'
    DataSource = fPrincipal.dsClientSQLEmployee
    TabOrder = 1
  end
  object DBEPHONE_EXT: TDBEdit
    Left = 108
    Top = 103
    Width = 53
    Height = 23
    CharCase = ecUpperCase
    DataField = 'PHONE_EXT'
    DataSource = fPrincipal.dsClientSQLEmployee
    TabOrder = 2
  end
  object DBLCBDEPT_NO: TDBLookupComboBox
    Left = 108
    Top = 159
    Width = 173
    Height = 23
    DataField = 'DEPT_NO'
    DataSource = fPrincipal.dsClientSQLEmployee
    KeyField = 'DEPT_NO'
    ListField = 'DEPARTMENT'
    ListSource = fPrincipal.dsClientSQLDep_No
    TabOrder = 3
  end
  object DBLCBJOB_CODE: TDBLookupComboBox
    Left = 108
    Top = 189
    Width = 173
    Height = 23
    DataField = 'JOB_CODE'
    DataSource = fPrincipal.dsClientSQLEmployee
    KeyField = 'JOB_CODE'
    ListField = 'JOB_TITLE'
    ListSource = fPrincipal.dsClientSQLJobs
    TabOrder = 4
  end
  object bMassivePost: TButton
    Left = 28
    Top = 310
    Width = 163
    Height = 26
    Caption = 'Post/ApplyUpdates'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = bMassivePostClick
  end
  object bMassiveCencel: TButton
    Left = 197
    Top = 310
    Width = 163
    Height = 26
    Caption = 'Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = bMassiveCencelClick
  end
end
