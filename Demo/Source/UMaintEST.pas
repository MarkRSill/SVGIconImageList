{******************************************************************************}
{                                                                              }
{       SVG Icon ImageList: An extended ImageList for Delphi/VCL               }
{       to simplify use of Icons (resize, colors and more...)                  }
{                                                                              }
{       Copyright (c) 2019-2020 (Ethea S.r.l.)                                 }
{       Author: Carlo Barazzetta                                               }
{       Contributors:                                                          }
{         Nicola Tambascia                                                     }
{                                                                              }
{       https://github.com/EtheaDev/SVGIconImageList                           }
{                                                                              }
{******************************************************************************}
{                                                                              }
{  Licensed under the Apache License, Version 2.0 (the "License");             }
{  you may not use this file except in compliance with the License.            }
{  You may obtain a copy of the License at                                     }
{                                                                              }
{      http://www.apache.org/licenses/LICENSE-2.0                              }
{                                                                              }
{  Unless required by applicable law or agreed to in writing, software         }
{  distributed under the License is distributed on an "AS IS" BASIS,           }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    }
{  See the License for the specific language governing permissions and         }
{  limitations under the License.                                              }
{                                                                              }
{******************************************************************************}
unit UMaintEST;

interface

{$INCLUDE SVGIconImageList.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, ImgList,
  StdCtrls, Buttons, StdActns,
  ActnList, ExtCtrls, ComCtrls, ToolWin,
  System.Actions, System.ImageList,
  Spin, SVGIconImageList, SVGIconImage, Vcl.ExtDlgs;

type
  TMainForm = class(TForm)
    SVGIconImageList: TSVGIconImageList;
    SVGIconImage: TSVGIconImage;
    Panel1: TPanel;
    procedure FormResize(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
  private
    {$IFDEF HiDPISupport}
    procedure FormAfterMonitorDpiChanged(Sender: TObject; OldDPI, NewDPI: Integer);
    {$ENDIF}
    procedure UpdateGUI;
  public
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  Themes
  {$IFDEF DXE3+}
  , UITypes
  {$ENDIF}
  , SVG
  , SVGIconUtils
  , SVGIconImageListEditorUnit;

{$IFDEF HiDPISupport}
procedure TMainForm.FormAfterMonitorDpiChanged(Sender: TObject; OldDPI, NewDPI: Integer);
begin
  UpdateGUI;
end;
{$ENDIF}

procedure TMainForm.FormResize(Sender: TObject);
begin
  panel1.Caption := Format('width:%d - height:%d',
   [SVGIconImage.Width, SVGIconImage.Height]);
end;

procedure TMainForm.Panel1Click(Sender: TObject);
begin
  SVGIconImage.Repaint;
end;

procedure TMainForm.updateGUI;
begin
end;

initialization
  ReportMemoryLeaksOnShutdown := True;

end.
