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
unit UMain;

interface

{$INCLUDE SVGIconImageList.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, ImgList,
  StdCtrls, Buttons, StdActns,
  ActnList, ExtCtrls, ComCtrls, ToolWin,
  Spin, SVGIconImageList, SVGIconImage, Vcl.ExtDlgs;

type
  TMainForm = class(TForm)
    ActionList: TActionList;
    ChangeIconAction: TAction;
    Panel1: TPanel;
    SelectThemeRadioGroup: TRadioGroup;
    TopToolBar: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    Panel2: TPanel;
    DeleteButton: TBitBtn;
    ChangeIconButton: TBitBtn;
    ClientPanel: TPanel;
    TreeView: TTreeView;
    ImageView: TListView;
    ImageListLabel: TLabel;
    GroupBox1: TGroupBox;
    BuildFromFilesButton: TButton;
    DeleteIconAction: TAction;
    SliderPanel: TPanel;
    TrackBar: TTrackBar;
    IconSizeLabel: TLabel;
    ButtonsPanel: TPanel;
    ClearButton: TButton;
    ShowImageEditorButton: TButton;
    DisabledAction: TAction;
    SVGIconImageList: TSVGIconImageList;
    OpenDialog: TOpenPictureDialog;
    SVGIconImage: TSVGIconImage;
    Splitter1: TSplitter;
    procedure ChangeIconActionExecute(Sender: TObject);
    procedure SelectThemeRadioGroupClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ShowImageEditorButtonClick(Sender: TObject);
    procedure TrackBarChange(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
    procedure DeleteIconActionExecute(Sender: TObject);
    procedure ImageViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure BuildFromFilesButtonClick(Sender: TObject);
    procedure SVGIconImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel2Resize(Sender: TObject);
  private
    FSVGIconImageListHot: TSVGIconImageList;
    FSVGIconImageListDisabled: TSVGIconImageList;
    {$IFDEF HiDPISupport}
    procedure FormAfterMonitorDpiChanged(Sender: TObject; OldDPI, NewDPI: Integer);
    {$ENDIF}
    procedure UpdateButtons;
    procedure UpdateGUI;
    procedure UpdateListView;
    procedure UpdateTreeView;
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
  , SVGIconUtils
  , SVGIconImageListEditorUnit;

procedure TMainForm.UpdateButtons;
begin
  DeleteButton.Action := DeleteIconAction;
  ChangeIconButton.Action := ChangeIconAction;
end;

procedure TMainForm.UpdateListView;
var
  LItemsCount: Integer;
begin
  LItemsCount := UpdateSVGIconListView(ImageView);
  ImageListLabel.Caption := Format('SVG Image List Preview: %d icons',[LItemsCount]);
end;

procedure TMainForm.BuildFromFilesButtonClick(Sender: TObject);
var
  LStart, LStop: cardinal;
  LCount: Integer;
begin
  if OpenDialog.Execute then
  begin
    Screen.Cursor := crHourGlass;
    try
      LStart := GetTickCount;
      LCount := SVGIconImageList.LoadFromFiles(OpenDialog.Files);
      LStop := GetTickCount;
    finally
      Screen.Cursor := crDefault;
    end;
    MessageDlg(Format('Built %d Icons in %d milliseconds!',
      [LCount, LStop - LStart]), mtInformation, [mbOK], 0);
  end;
  UpdateGUI;
end;

procedure TMainForm.ChangeIconActionExecute(Sender: TObject);
var
  LAction: TAction;
begin
  //Detach Action
  ChangeIconButton.Action := nil;
  LAction := Sender as TAction;
  //Change icon of the connected action
  LAction.ImageIndex := LAction.ImageIndex+1;
  //Attach Action
  ChangeIconButton.Action := ChangeIconAction;
end;

procedure TMainForm.ClearButtonClick(Sender: TObject);
begin
  //Clear Collection
  SVGIconImageList.Clear;
  UpdateGUI;
end;

procedure TMainForm.DeleteIconActionExecute(Sender: TObject);
begin
  if SVGIconImageList.SVGIconItems.Count > 0 then
  begin
    SVGIconImageList.SVGIconItems.Delete(0);
    UpdateGUI;
  end;
end;

{$IFDEF HiDPISupport}
procedure TMainForm.FormAfterMonitorDpiChanged(Sender: TObject; OldDPI, NewDPI: Integer);
begin
  UpdateGUI;
end;
{$ENDIF}

procedure TMainForm.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  FSVGIconImageListHot := TSVGIconImageList.Create(Self);
  FSVGIconImageListDisabled := TSVGIconImageList.Create(Self);

  {$IFDEF HiDPISupport}
  OnAfterMonitorDpiChanged := FormAfterMonitorDpiChanged;
  {$ENDIF}

  {$IFDEF DXE+}
  //Build available VCL Styles
  SelectThemeRadioGroup.Items.Clear;
  for I := 0 to High(TStyleManager.StyleNames) do
    SelectThemeRadioGroup.Items.Add(TStyleManager.StyleNames[I]);
  TStringList(SelectThemeRadioGroup.Items).Sort;
  SelectThemeRadioGroup.OnClick := nil;
  try
    SelectThemeRadioGroup.ItemIndex := SelectThemeRadioGroup.Items.IndexOf({$IFDEF D10_1+}'Windows10'{$ELSE}'Windows'{$ENDIF});
  finally
    SelectThemeRadioGroup.OnClick := SelectThemeRadioGroupClick;
  end;
  {$ENDIF}
  SelectThemeRadioGroupClick(SelectThemeRadioGroup);

  TreeView.Items[0].Expand(True);
  TreeView.Items[2].Expand(True);

  TrackBar.Position := SVGIconImageList.Height;
  TrackBarChange(TrackBar);
end;

procedure TMainForm.SelectThemeRadioGroupClick(Sender: TObject);
var
  LStyleName: string;
begin
  Screen.Cursor := crHourGlass;
  try
    LStyleName := SelectThemeRadioGroup.Items[SelectThemeRadioGroup.ItemIndex];
    {$IFDEF DXE+}
    TStyleManager.TrySetStyle(LStyleName);
    //UpdateIconFontsColorByStyle(IconFontsImageList); TODO
    {$ELSE}
    SelectThemeRadioGroup.Visible := False;
    {$ENDIF}

    UpdateGUI;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TMainForm.ImageViewSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  SVGIconImage.ImageIndex := Item.Index;
end;

procedure TMainForm.Panel2Resize(Sender: TObject);
begin
  SVGIconImage.Height := SVGIconImage.width;
end;

procedure TMainForm.ShowImageEditorButtonClick(Sender: TObject);
begin
  if EditSVGIconImageList(SVGIconImageList) then
    UpdateGUI;
end;

procedure TMainForm.SVGIconImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    SVGIconImage.ImageIndex := SVGIconImage.ImageIndex + 1
  else
    SVGIconImage.ImageIndex := SVGIconImage.ImageIndex - 1;
end;

procedure TMainForm.updateGUI;
var
  LSize: Integer;
begin
  LSize := SVGIconImageList.Height;
  IconSizeLabel.Caption := Format('Icons size: %d',[LSize]);
  TopToolBar.ButtonHeight := LSize + 2;
  TopToolBar.ButtonWidth := LSize + 2;
  TopToolBar.Height := LSize + 6;
  TreeView.Indent := LSize;

  UpdateButtons;
  UpdateListView;
  UpdateTreeView;
end;

procedure TMainForm.UpdateTreeView;
var
  LItem: TTreeNode;
  I: Integer;
begin
  for I := 0 to TreeView.Items.Count - 1 do
  begin
    LItem := TreeView.Items[I];
    if SVGIconImageList.SVGIconItems.Count > LItem.ImageIndex then
    begin
      LItem.Text := SVGIconImageList.SVGIconItems.Items[LItem.ImageIndex].IconName;
    end
    else
    begin
      LItem.Text := '';
    end;
  end;
end;

procedure TMainForm.TrackBarChange(Sender: TObject);
begin
  //Resize all icons into ImageList
  SVGIconImageList.Size := TrackBar.Position;
  UpdateGUI;
end;

initialization
  ReportMemoryLeaksOnShutdown := True;

end.
