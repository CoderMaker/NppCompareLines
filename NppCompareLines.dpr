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

library NppCompareLines;

{$R 'NppCompareLines-res.res' 'NppCompareLines-res.rc'}

uses
  SysUtils,
  Classes,
  Types,
  Windows,
  Messages,
  nppplugin in 'lib\nppplugin.pas',
  scisupport in 'lib\SciSupport.pas',
  NppForms in 'lib\NppForms.pas' {NppForm},
  NppDockingForms in 'lib\NppDockingForms.pas' {NppDockingForm},
  NppCompareLinesPlugin in 'NppCompareLinesPlugin.pas',
  AboutForms in 'AboutForms.pas' {AboutFrm},
  AdvancedOptionsDockingFrm in 'AdvancedOptionsDockingFrm.pas' {AdvancedOptionsFrm};

{$R *.res}

{$Include 'lib\NppPluginInclude.pas'}

begin
  { First, assign the procedure to the DLLProc variable }
  DllProc := @DLLEntryPoint;
  { Now invoke the procedure to reflect that the DLL is attaching to the process }
  DLLEntryPoint(DLL_PROCESS_ATTACH);
end.
