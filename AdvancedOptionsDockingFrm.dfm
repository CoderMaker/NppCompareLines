inherited AdvancedOptionsFrm: TAdvancedOptionsFrm
  Left = 242
  Width = 194
  Height = 505
  BorderStyle = bsSizeToolWin
  Caption = 'Sort, Delete Duplicates, etc'
  Constraints.MinWidth = 150
  OnCreate = FormCreate
  OnHide = FormHide
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object CloseBevel: TBevel
    Left = 6
    Top = 417
    Width = 167
    Height = 11
    Anchors = [akLeft, akTop, akRight]
    Shape = bsBottomLine
  end
  object CloseBtn: TButton
    Left = 26
    Top = 433
    Width = 132
    Height = 24
    Cursor = crHandPoint
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Close'
    TabOrder = 2
    OnClick = CloseBtnClick
  end
  object DeleteDuplicatesCB: TCheckBox
    Left = 10
    Top = 12
    Width = 163
    Height = 17
    Cursor = crHandPoint
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Delete Duplicates'
    Checked = True
    State = cbChecked
    TabOrder = 3
    OnClick = DeleteDuplicatesCBClick
  end
  object SortCB: TCheckBox
    Left = 10
    Top = 153
    Width = 163
    Height = 17
    Cursor = crHandPoint
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Sort'
    Checked = True
    State = cbChecked
    TabOrder = 6
    OnClick = SortCBClick
  end
  object SortDirectionRG: TRadioGroup
    Left = 21
    Top = 180
    Width = 153
    Height = 70
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Sort Direction'
    ItemIndex = 0
    Items.Strings = (
      'Sort Ascending'
      'Sort Descending')
    TabOrder = 7
    TabStop = True
    OnClick = SortDirectionRGClick
  end
  object DoThisBtn: TButton
    Left = 10
    Top = 348
    Width = 158
    Height = 37
    Cursor = crHandPoint
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Do This!'
    Default = True
    TabOrder = 0
    OnClick = DoThisBtnClick
  end
  object DeleteEmptyLinesCB: TCheckBox
    Left = 10
    Top = 39
    Width = 163
    Height = 17
    Cursor = crHandPoint
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Delete Empty Lines'
    Checked = True
    State = cbChecked
    TabOrder = 4
    OnClick = DeleteEmptyLinesCBClick
  end
  object IgnoreCaseCB: TCheckBox
    Left = 10
    Top = 123
    Width = 163
    Height = 17
    Cursor = crHandPoint
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Ignore Case'
    Checked = True
    State = cbChecked
    TabOrder = 5
    OnClick = IgnoreCaseCBClick
  end
  object UndoBtn: TButton
    Left = 57
    Top = 393
    Width = 92
    Height = 25
    Cursor = crHandPoint
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Undo'
    TabOrder = 1
    OnClick = UndoBtnClick
  end
  object DeleteLeadingSpacesCB: TCheckBox
    Left = 10
    Top = 66
    Width = 163
    Height = 17
    Cursor = crHandPoint
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Delete Leading Spaces'
    TabOrder = 8
    OnClick = DeleteLeadingSpacesCBClick
  end
  object DeleteLeadingNumbersCB: TCheckBox
    Left = 10
    Top = 93
    Width = 163
    Height = 17
    Cursor = crHandPoint
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Delete Leading Numbers'
    TabOrder = 9
    OnClick = DeleteLeadingNumbersCBClick
  end
  object SortTypeRG: TRadioGroup
    Left = 21
    Top = 258
    Width = 153
    Height = 79
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Sort Type'
    ItemIndex = 0
    Items.Strings = (
      'Sort Alphabetically'
      'Sort By Line Length'
      'Sort Numeric')
    TabOrder = 10
    TabStop = True
    OnClick = SortTypeRGClick
  end
end
