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

unit AboutForms;

interface

uses
  Windows, Classes, Controls, StdCtrls,
  NppForms;

type
  TAboutFrm = class(TNppForm)
    FineBtn: TButton;
    VersionLb: TLabel;
    DeveloperLb: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutFrm: TAboutFrm;

implementation

{$R *.dfm}

end.
