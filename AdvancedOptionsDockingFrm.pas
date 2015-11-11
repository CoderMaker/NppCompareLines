{
    This file is part of NppCompareLines Plugin for Notepad++
    Copyright (C) 2015  Alex Joy

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}

unit AdvancedOptionsDockingFrm;

interface

uses
  Windows, Controls, StdCtrls, ExtCtrls, Classes,
  SciSupport, NppPlugin, NppDockingForms;

type
  TAdvancedOptionsFrm = class(TNppDockingForm)
    CloseBtn: TButton;
    DeleteDuplicatesCB: TCheckBox;
    SortCB: TCheckBox;
    SortDirectionRG: TRadioGroup;
    DoThisBtn: TButton;
    DeleteEmptyLinesCB: TCheckBox;
    IgnoreCaseCB: TCheckBox;
    UndoBtn: TButton;
    CloseBevel: TBevel;
    DeleteLeadingSpacesCB: TCheckBox;
    DeleteLeadingNumbersCB: TCheckBox;
    SortTypeRG: TRadioGroup;
    procedure CloseBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormHide(Sender: TObject);
    procedure FormFloat(Sender: TObject);
    procedure FormDock(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DoThisBtnClick(Sender: TObject);
    procedure UndoBtnClick(Sender: TObject);
    procedure DeleteDuplicatesCBClick(Sender: TObject);
    procedure DeleteEmptyLinesCBClick(Sender: TObject);
    procedure IgnoreCaseCBClick(Sender: TObject);
    procedure SortCBClick(Sender: TObject);
    procedure SortDirectionRGClick(Sender: TObject);
    procedure DeleteLeadingSpacesCBClick(Sender: TObject);
    procedure DeleteLeadingNumbersCBClick(Sender: TObject);
    procedure SortTypeRGClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AdvancedOptionsFrm: TAdvancedOptionsFrm;

implementation

{$R *.dfm}

uses NppCompareLinesPlugin;

procedure TAdvancedOptionsFrm.FormCreate(Sender: TObject);
begin
  self.NppDefaultDockingMask := DWS_DF_FLOATING; // whats the default docking position
  self.KeyPreview := true; // special hack for input forms
  self.OnFloat := self.FormFloat;
  self.OnDock := self.FormDock;
  inherited;
end;

procedure TAdvancedOptionsFrm.CloseBtnClick(Sender: TObject);
begin
  inherited;
  self.Hide;
end;

// special hack for input forms
// This is the best possible hack I could came up for
// memo boxes that don't process enter keys for reasons
// too complicated... Has something to do with Dialog Messages
// I sends a Ctrl+Enter in place of Enter
procedure TAdvancedOptionsFrm.FormKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if (Key = #13) then
     Self.DoThisBtn.Click;
end;

// Docking code calls this when the form is hidden by either "x" or self.Hide
procedure TAdvancedOptionsFrm.FormHide(Sender: TObject);
begin
  inherited;
  SendMessage(self.Npp.NppData.NppHandle, NPPM_SETMENUITEMCHECK, self.CmdID, 0);
end;

procedure TAdvancedOptionsFrm.FormDock(Sender: TObject);
begin
  SendMessage(self.Npp.NppData.NppHandle, NPPM_SETMENUITEMCHECK, self.CmdID, 1);
end;

procedure TAdvancedOptionsFrm.FormFloat(Sender: TObject);
begin
  SendMessage(self.Npp.NppData.NppHandle, NPPM_SETMENUITEMCHECK, self.CmdID, 1);
end;

procedure TAdvancedOptionsFrm.FormShow(Sender: TObject);
begin
  inherited;
  SendMessage(self.Npp.NppData.NppHandle, NPPM_SETMENUITEMCHECK, self.CmdID, 1);
end;

procedure TAdvancedOptionsFrm.UndoBtnClick(Sender: TObject);
begin
  SendMessage(self.Npp.NppData.ScintillaMainHandle, SCI_UNDO, 0, 0);
end;

//

procedure TAdvancedOptionsFrm.DoThisBtnClick(Sender: TObject);
begin
  if Assigned(NppCLP) then
     NppCLP.FnNppCompareLines;
end;

procedure TAdvancedOptionsFrm.DeleteDuplicatesCBClick(Sender: TObject);
begin
  if Assigned(NppCLP) then
     NppCLP.clDeleteDuplicates := DeleteDuplicatesCB.Checked;
end;

procedure TAdvancedOptionsFrm.DeleteEmptyLinesCBClick(Sender: TObject);
begin
  if Assigned(NppCLP) then
     NppCLP.clDeleteEmptyLines := DeleteEmptyLinesCB.Checked;
end;

procedure TAdvancedOptionsFrm.DeleteLeadingSpacesCBClick(Sender: TObject);
begin
  if Assigned(NppCLP) then
     NppCLP.clDeleteLeadingSpaces := DeleteLeadingSpacesCB.Checked;
end;

procedure TAdvancedOptionsFrm.DeleteLeadingNumbersCBClick(Sender: TObject);
begin
  if Assigned(NppCLP) then
     NppCLP.clDeleteLeadingNumbers := DeleteLeadingNumbersCB.Checked;
end;

procedure TAdvancedOptionsFrm.IgnoreCaseCBClick(Sender: TObject);
begin
  if Assigned(NppCLP) then
     NppCLP.clIgnoreCase := IgnoreCaseCB.Checked;
end;

procedure TAdvancedOptionsFrm.SortCBClick(Sender: TObject);
begin
  if Assigned(NppCLP) then
     NppCLP.clSortLines := SortCB.Checked;
end;

procedure TAdvancedOptionsFrm.SortDirectionRGClick(Sender: TObject);
begin
  if Assigned(NppCLP) then
     NppCLP.clSortDirection := SortDirectionRG.ItemIndex;
end;


procedure TAdvancedOptionsFrm.SortTypeRGClick(Sender: TObject);
begin
  if Assigned(NppCLP) then
     NppCLP.clSortType := SortTypeRG.ItemIndex;
end;

end.
