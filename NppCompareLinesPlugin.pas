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

unit NppCompareLinesPlugin;

interface

uses
  Windows, Classes, SysUtils,
  Registry,
  NppPlugin, SciSupport, AboutForms, AdvancedOptionsDockingFrm;

type

  TNppCompareLinesPlugin = class(TNppPlugin)
    NppLines :TStringList;
    //
    nppFirstLine, nppLastLine :Integer;
    nppEOLMode, EOLSize       :Integer;
    nppGotLastLineWOEOL       :Boolean;
  public
    clDeleteDuplicates        :Boolean;
    clDeleteEmptyLines        :Boolean;
    clDeleteLeadingSpaces     :Boolean;
    clDeleteLeadingNumbers    :Boolean;
    clIgnoreCase              :Boolean;
    //
    clSortLines               :Boolean;
    clSortDirection           :Integer;
    clSortType                :Integer;
    //
    constructor Create;
    destructor Destroy; override;
    //
    procedure NppGetFirstAndLastLines;
    //
    procedure NppGetSelectedLines;
    procedure NppSetLinesToSelected;
    //
    procedure FnNppCompareLines;
    //
    procedure FnNppAdvancedOptionsDocking;
    procedure FnAbout;
    //
    procedure DoNppnToolbarModification; override;
  end;

//---

const
  cl_sdSortAscending      = 0;
  cl_sdSortDescending     = 1;
  //
  cl_stSortAlphabetically = 0;
  cl_stSortByLineLength   = 1;
  cl_stSortNumeric        = 2;
  //cl_stSortByFirstChars   = 3;
  //cl_stSortByLastChars   = 4;

//---

procedure _FnCompareLines; cdecl;
procedure _FnAdvancedOptionsDocking; cdecl;
procedure _FnAbout; cdecl;

//---

var
  NppCLP: TNppCompareLinesPlugin;

implementation

procedure _FnCompareLines; cdecl;
begin
 if Assigned(NppCLP) then
    NppCLP.FnNppCompareLines;
end;

procedure _FnAdvancedOptionsDocking; cdecl;
begin
 if Assigned(NppCLP) then
    NppCLP.FnNppAdvancedOptionsDocking;
end;

procedure _FnAbout; cdecl;
begin
 if Assigned(NppCLP) then
    NppCLP.FnAbout;
end;


{ TNppCompareLinesPlugin }

constructor TNppCompareLinesPlugin.Create;
var
  sk  :TShortcutKey;
  Reg :TRegistry;
begin
  inherited;
  //
  NppLines := nil;
  //Default values:
  clDeleteDuplicates     := True;
  clDeleteEmptyLines     := True;
  clDeleteLeadingSpaces  := False;
  clDeleteLeadingNumbers := False;
  clIgnoreCase           := True;
  //
  clSortLines            := True;
  clSortDirection        := cl_sdSortAscending;
  clSortType             := cl_stSortAlphabetically;

  //Initialize plugin:
  self.PluginName := 'Compare &Lines';
    //Prepare ShortcutKey:
    sk.IsCtrl := false; sk.IsAlt := true; sk.IsShift := false;
    sk.Key := #76; //ALT +L

  self.AddFuncItem('Compare Lines (Sort, Delete Duplicates, etc)', _FnCompareLines, sk);
  self.AddFuncItem('Show Advanced Options', _FnAdvancedOptionsDocking);
  self.AddFuncItem('About', _FnAbout);

  //Read saved configuration:
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CURRENT_USER;
  if Reg.OpenKey('SOFTWARE\Notepad++ Compare Lines Plugin',False) then begin
     if Reg.ValueExists('DeleteDuplicates') then
        clDeleteDuplicates := Reg.ReadBool('DeleteDuplicates');
     if Reg.ValueExists('DeleteEmptyLines') then
        clDeleteEmptyLines := Reg.ReadBool('DeleteEmptyLines');
     if Reg.ValueExists('DeleteLeadingSpaces') then
        clDeleteLeadingSpaces := Reg.ReadBool('DeleteLeadingSpaces');
     if Reg.ValueExists('DeleteLeadingNumbers') then
        clDeleteLeadingNumbers := Reg.ReadBool('DeleteLeadingNumbers');
     if Reg.ValueExists('IgnoreCase') then
        clIgnoreCase := Reg.ReadBool('IgnoreCase');
     //
     if Reg.ValueExists('SortLines') then
        clSortLines := Reg.ReadBool('SortLines');
     //
     if Reg.ValueExists('SortDirection') then
        clSortDirection := Reg.ReadInteger('SortDirection');
     if Reg.ValueExists('SortType') then
        clSortType := Reg.ReadInteger('SortType');
  end;
  Reg.Free;
  //
end;

destructor TNppCompareLinesPlugin.Destroy;
var
  Reg :TRegistry;
begin //Save configuration:
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CURRENT_USER;
  if Reg.OpenKey('SOFTWARE\Notepad++ Compare Lines Plugin',True) then begin
     Reg.WriteBool('DeleteDuplicates', clDeleteDuplicates);
     Reg.WriteBool('DeleteEmptyLines', clDeleteEmptyLines);
     Reg.WriteBool('DeleteLeadingSpaces', clDeleteLeadingSpaces);
     Reg.WriteBool('DeleteLeadingNumbers', clDeleteLeadingNumbers);
     Reg.WriteBool('IgnoreCase', clIgnoreCase);
     Reg.WriteBool('SortLines', clSortLines);
     //
     Reg.WriteInteger('SortDirection', clSortDirection);
     Reg.WriteInteger('SortType', clSortType);
  end;
  Reg.Free;
  //
  if Assigned(NppLines) then
     NppLines.Free;
  //
  inherited;
end;


procedure TNppCompareLinesPlugin.NppGetFirstAndLastLines;
var
  tmpInt :Integer;
  LinesCount :Integer;
  nppCursorPos1, nppCursorPos2 :Integer;
begin
  LinesCount := SendMessage(self.NppData.ScintillaMainHandle, SCI_GETLINECOUNT, 0, LPARAM(0));
  //
  nppCursorPos1 := SendMessage(self.NppData.ScintillaMainHandle, SCI_GETANCHOR, 0, LPARAM(0));
  nppCursorPos2 := SendMessage(self.NppData.ScintillaMainHandle, SCI_GETCURRENTPOS, 0, LPARAM(0));
  if nppCursorPos1>nppCursorPos2 then begin
     tmpInt := nppCursorPos1;
     nppCursorPos1 := nppCursorPos2;
     nppCursorPos2 := tmpInt;
  end;
  //
  nppFirstLine := SendMessage(self.NppData.ScintillaMainHandle, SCI_LINEFROMPOSITION, nppCursorPos1, 0);
  nppLastLine  := SendMessage(self.NppData.ScintillaMainHandle, SCI_LINEFROMPOSITION, nppCursorPos2, 0);
  //
  if nppFirstLine=nppLastLine then begin
     nppFirstLine := 0;
     nppLastLine  := LinesCount-1;
  end;
  //
  nppEOLMode := SendMessage(self.NppData.ScintillaMainHandle, SCI_GETEOLMODE, 0, LPARAM(0));
  if nppEOLMode=SC_EOL_CRLF then begin
     EOLSize := 2;
  end else
  if (nppEOLMode=SC_EOL_CR)or(nppEOLMode=SC_EOL_LF) then begin
     EOLSize := 1;
  end else
     EOLSize := 1;
end;

procedure TNppCompareLinesPlugin.NppGetSelectedLines;
var
  s :string;
  i :Integer;
  LineLength :Integer;
begin
  if not Assigned(NppLines) then
     NppLines := TStringList.Create
  else
     NppLines.Clear;
  //
  NppGetFirstAndLastLines;
  //
  for i := nppFirstLine to nppLastLine do begin
      LineLength := SendMessage(self.NppData.ScintillaMainHandle, SCI_LINELENGTH, WPARAM(i), LPARAM(0));
      SetLength(s, LineLength);
      SendMessage(self.NppData.ScintillaMainHandle, SCI_GETLINE, WPARAM(i), LPARAM(PChar(s)));
      NppLines.Add(s);
  end;
  //
  nppGotLastLineWOEOL := False;
  //
  if (NppLines.Count>0) then begin
     s := NppLines.Strings[NppLines.Count-1];
     if (nppEOLMode=SC_EOL_CRLF) and (Copy(s,Length(s)-1,2)<>#$D#$A) then begin //windows
        NppLines.Strings[NppLines.Count-1] := NppLines.Strings[NppLines.Count-1]+#$D#$A;
        nppGotLastLineWOEOL := True;
     end else
     if (nppEOLMode=SC_EOL_CR) and(Copy(s,Length(s),1)<>#$D) then begin //unix
        NppLines.Strings[NppLines.Count-1] := NppLines.Strings[NppLines.Count-1]+#$D;
        nppGotLastLineWOEOL := True;
     end else
     if (nppEOLMode=SC_EOL_LF) and(Copy(s,Length(s),1)<>#$A) then begin //mac
        NppLines.Strings[NppLines.Count-1] := NppLines.Strings[NppLines.Count-1]+#$A;
        nppGotLastLineWOEOL := True;
     end;
  end;
end;

procedure TNppCompareLinesPlugin.NppSetLinesToSelected;
var
  i :Integer;
  s :string;
  //
  nppCursorPos1, nppCursorPos2 :Integer;
begin
  if not Assigned(NppLines) then
     Exit;//!
  //
  NppGetFirstAndLastLines;
  //
  nppCursorPos1 := SendMessage(self.NppData.ScintillaMainHandle, SCI_POSITIONFROMLINE, nppFirstLine, 0);
  nppCursorPos2 := SendMessage(self.NppData.ScintillaMainHandle, SCI_POSITIONFROMLINE, nppLastLine+1, 0);
  //
  SendMessage(self.NppData.ScintillaMainHandle, SCI_BEGINUNDOACTION, 0, 0);
  SendMessage(self.NppData.ScintillaMainHandle, SCI_SETTARGETSTART, nppCursorPos1, 0);
  SendMessage(self.NppData.ScintillaMainHandle, SCI_SETTARGETEND, nppCursorPos2, 0);
  SendMessage(self.NppData.ScintillaMainHandle, SCI_REPLACETARGET, 0, LPARAM(PChar('')));
  //
  if (nppGotLastLineWOEOL) and (NppLines.Count>0) then begin
     s := NppLines.Strings[NppLines.Count-1];
     if (nppEOLMode=SC_EOL_CRLF) and (Copy(s,Length(s)-1,2)=#$D#$A) then begin //windows
        Delete(s,Length(s)-1,2);
        NppLines.Strings[NppLines.Count-1] := s;
     end else
     if ( (nppEOLMode=SC_EOL_CR) and(Copy(s,Length(s),1)=#$D) ) //unix
        or ( (nppEOLMode=SC_EOL_LF) and(Copy(s,Length(s),1)=#$A) ) then begin //mac
        Delete(s,Length(s),1);
        NppLines.Strings[NppLines.Count-1] := s;
     end;
  end;
  //
  for i := 0 to NppLines.Count-1 do begin
      SendMessage(self.NppData.ScintillaMainHandle, SCI_ADDTEXT, WPARAM(Length(NppLines.Strings[i])), LPARAM(PChar(NppLines.Strings[i])));
  end;
  //
  SendMessage(self.NppData.ScintillaMainHandle, SCI_SETANCHOR, nppCursorPos1, LPARAM(0));
  nppCursorPos2 := nppCursorPos1+Length(NppLines.Text)-NppLines.Count*EOLSize;
  SendMessage(self.NppData.ScintillaMainHandle, SCI_SETCURRENTPOS, nppCursorPos2, LPARAM(0));
  //
  SendMessage(self.NppData.ScintillaMainHandle, SCI_ENDUNDOACTION, 0, 0);
end;

function StringListCompareStrings(List: TStringList; Index1, Index2: Integer): Integer;
var n1, n2 :Integer;
    sn1, sn2 :string;
    SortedByNumber :Boolean;
//
  function GetLeadingNumberFromLine(const s:string):string;
  var
    i :Integer;
  begin
     Result := '';
     for i := 1 to Length(s) do begin
        if (s[i]>='0') and (s[i]<='9') then
           Result := Result+s[i]
        else
           Break;
     end;
  end;
//
begin
  Result := 0; //Warning off
  if NppCLP.clSortType=cl_stSortByLineLength then begin
     Result := Length(List.Strings[Index1])-Length(List.Strings[Index2]);
  end else begin
     SortedByNumber := False;
     if NppCLP.clSortType=cl_stSortNumeric then begin
        sn1 := GetLeadingNumberFromLine(List.Strings[Index1]);
        sn2 := GetLeadingNumberFromLine(List.Strings[Index2]);
        //
        if (sn1<>'') and (sn2<>'') then begin
           try
             n1 := StrToInt(sn1);
             n2 := StrToInt(sn2);
             Result := n1-n2;
             SortedByNumber := True;
           except end;
        end;
     end;
     //
     if not SortedByNumber then begin
        if NppCLP.clIgnoreCase then
           Result := AnsiCompareText(List.Strings[Index1], List.Strings[Index2])
        else
           Result := AnsiCompareStr(List.Strings[Index1], List.Strings[Index2]);
     end;
  end;
  //
  if NppCLP.clSortDirection=cl_sdSortDescending then
     Result := Result*-1;
end;

procedure TNppCompareLinesPlugin.FnNppCompareLines;
var
  i, z :Integer;
  rem :Boolean;
  s :String;
begin
  NppGetSelectedLines;
  //
  if clDeleteLeadingSpaces or clDeleteLeadingNumbers then begin
     for i := 0 to NppLines.Count-1 do begin
         s := NppLines.Strings[i];
         while Length(s)>=1 do begin
           if ( (clDeleteLeadingSpaces)and(s[1]=' ') )
              or ( (clDeleteLeadingNumbers)and( (s[1]>='0') and (s[1]<='9') ) ) then
              Delete(s,1,1)
           else
              Break;
         end;
         NppLines.Strings[i] := s;
     end;
  end;
  //
  if (clDeleteEmptyLines)or(clDeleteDuplicates) then begin
     i := 0;
     while i<NppLines.Count do begin
       if (clDeleteEmptyLines) and ( (NppLines.Strings[i]=#$D#$A) or (NppLines.Strings[i]=#$D)
                                     or (NppLines.Strings[i]=#$A) or (NppLines.Strings[i]='') ) then
          NppLines.Delete(i)
       else
       if (clDeleteDuplicates)then begin
          z := i+1;
          while z < NppLines.Count do begin
            if (clIgnoreCase) then
               rem := CompareText(NppLines.Strings[i],NppLines.Strings[z])=0
            else
               rem := CompareStr(NppLines.Strings[i],NppLines.Strings[z])=0;
            //
            if rem then
               NppLines.Delete(z)
            else
               Inc(z);
          end;
          //
          Inc(i);
       end else
          Inc(i);
     end;
  end;
  //
  if clSortLines then
     NppLines.CustomSort(StringListCompareStrings);
  //
  NppSetLinesToSelected;
end;

procedure TNppCompareLinesPlugin.FnAbout;
var
  a: TAboutFrm;
begin
  a := TAboutFrm.Create(self);
  a.ShowModal;
  a.Free;
end;


procedure TNppCompareLinesPlugin.FnNppAdvancedOptionsDocking;
begin
  if (not Assigned(AdvancedOptionsFrm)) then
     AdvancedOptionsFrm := TAdvancedOptionsFrm.Create(self, 1);
  //
  AdvancedOptionsFrm.DeleteDuplicatesCB.Checked     := NppCLP.clDeleteDuplicates;
  AdvancedOptionsFrm.DeleteEmptyLinesCB.Checked     := NppCLP.clDeleteEmptyLines;
  AdvancedOptionsFrm.DeleteLeadingSpacesCB.Checked  := NppCLP.clDeleteLeadingSpaces;
  AdvancedOptionsFrm.DeleteLeadingNumbersCB.Checked := NppCLP.clDeleteLeadingNumbers;
  AdvancedOptionsFrm.IgnoreCaseCB.Checked           := NppCLP.clIgnoreCase;
  AdvancedOptionsFrm.SortCB.Checked                 := NppCLP.clSortLines;
  //
  AdvancedOptionsFrm.SortDirectionRG.ItemIndex      := NppCLP.clSortDirection;
  AdvancedOptionsFrm.SortTypeRG.ItemIndex           := NppCLP.clSortType;
  //
  AdvancedOptionsFrm.Show;
end;


procedure TNppCompareLinesPlugin.DoNppnToolbarModification;
var
  tb :TToolbarIcons;
begin
  tb.ToolbarIcon := 0;
  tb.ToolbarBmp := LoadImage(Hinstance, 'IDB_TB_COMPARELINES', IMAGE_BITMAP, 0, 0, (LR_DEFAULTSIZE or LR_LOADMAP3DCOLORS));
  SendMessage(self.NppData.NppHandle, NPPM_ADDTOOLBARICON, WPARAM(self.CmdIdFromDlgId(0)), LPARAM(@tb));
end;

initialization
  NppCLP := TNppCompareLinesPlugin.Create;
end.
