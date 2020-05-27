{******************************************************************************}
{                                                                              }
{       SVG Icon ImageList: An extended ImageList for Delphi/VLC+FMX           }
{       to simplify use of Icons (resize, opacity and more...)                 }
{                                                                              }
{       Copyright (c) 2019-2020 (Ethea S.r.l.)                                 }
{       Author: Carlo Barazzetta                                               }
{       Contributors:                                                          }
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
unit FMX.SVGIconImageListEditorUnit;

interface

{$INCLUDE ..\Source\SVGIconImageList.inc}

uses
  System.SysUtils, System.Types, System.UITypes, FMX.Controls, System.Classes,
  System.Actions, FMX.Forms, FMX.Graphics, FMX.ActnList, FMX.StdCtrls, FMX.Colors, FMX.ListBox,
  FMX.Controls.Presentation, FMX.ImgList, FMX.Types, FMX.Layouts,
  System.ImageList, FMX.SVGIconImageList, FMX.Edit, FMX.EditBox, FMX.SpinBox,
  FMX.ScrollBox, FMX.Memo, FMX.Dialogs;

type
  TSVGIconImageListEditorFMX = class(TForm)
    PaButtons: TPanel;
    AddButton: TButton;
    DeleteButton: TButton;
    ClearAllButton: TButton;
    �: TPanel;
    Panel4: TPanel;
    OKButton: TButton;
    CancelButton: TButton;
    HelpButton: TButton;
    paClient: TPanel;
    ImageListGroupBox: TGroupBox;
    AutoSizeCheckBox: TCheckBox;
    DefaultOpacitySpinBox: TSpinBox;
    DefaultOpacityLabel: TLabel;
    ItemGroupBox: TGroupBox;
    IconName: TEdit;
    IconNameLabel: TLabel;
    OpacityLabel: TLabel;
    OpacitySpinBox: TSpinBox;
    IconPanel: TPanel;
    IconImage: TGlyph;
    ListBoxItemStyleBook: TStyleBook;
    SizeSpinBox: TSpinBox;
    SizeLabel: TLabel;
    IconsGroupBox: TGroupBox;
    ImageView: TListBox;
    TopSplitter: TSplitter;
    SVGText: TMemo;
    NewButton: TButton;
    OpenDialog: TOpenDialog;
    procedure ClearAllButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure IconNameExit(Sender: TObject);
    procedure ImageViewSelectItem(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AutoSizeCheckBoxClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DefaultOpacitySpinBoxChange(Sender: TObject);
    procedure OpacitySpinBoxChange(Sender: TObject);
    procedure SizeChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure SVGTextExit(Sender: TObject);
    procedure NewButtonClick(Sender: TObject);
  private
    FIconIndexLabel: string;
    FTotIconsLabel: string;
    FUpdating: Boolean;
    FEditingList: TSVGIconImageList;
    procedure AddNewItem;
    procedure DeleteSelectedItem;
    procedure ClearAllImages;
    procedure UpdateGUI;
    procedure SetImageOpacity(Opacity: Single);
    procedure SetImageIconName(IconName: String);
    function SelectedSVGIcon: TSVGIconSourceItem;
  public
    destructor Destroy; override;
  end;

function EditSVGIconImageList(const AImageList: TSVGIconImageList): Boolean;

implementation

{$R *.fmx}

uses
  Winapi.Messages
  , Winapi.Windows
  , Winapi.shellApi;

function UpdateSVGIconListView(const AListBox: TListBox): Integer;
var
  I: Integer;
  LItem: TSVGIconSourceItem;
  LListItem: TListBoxItem;
  LSVGIconImageList: TSVGIconImageList;
begin
  LSVGIconImageList := AListBox.Images as TSVGIconImageList;
  AListBox.Items.BeginUpdate;
  try
    AListBox.Clear;
    Result := LSVGIconImageList.Source.Count;
    for I := 0 to Result -1 do
    begin
      LItem := LSVGIconImageList.Source.Items[I] as TSVGIconSourceItem;
      LListItem := TListBoxItem.Create(AListBox);
      LListItem.StyleLookup := 'CustomListBoxItemStyle';
      AListBox.AddObject(LListItem);
      LListItem.Text :=
        Format('%d.%s', [LItem.Index,Litem.IconName]);
       LListItem.ImageIndex := I;
    end;
  finally
    AListBox.Items.EndUpdate;
  end;
end;

function UpdateSVGIconListViewCaptions(const AListBox: TListBox;
  const AShowCaption: Boolean = True): Integer;
var
  I: Integer;
  LItem: TSVGIconSourceItem;
  LSVGIconImageList: TSVGIconImageList;
begin
  LSVGIconImageList := AListBox.Images as TSVGIconImageList;
  //AListView.Items.BeginUpdate;
  try
    Result := LSVGIconImageList.Source.Count;
    for I := 0 to Result -1 do
    begin
      LItem := LSVGIconImageList.Source[I] as TSVGIconSourceItem;
      if AShowCaption then
      begin
        AListBox.Items[I] := Format('%d.%s', [LItem.Index, Litem.IconName]);
      end
      else
        AListBox.Items[I] := '';
    end;
  finally
    //AListView.Items.EndUpdate;
  end;
end;

function EditSVGIconImageList(const AImageList: TSVGIconImageList): Boolean;
var
  LEditor: TSVGIconImageListEditorFMX;
begin
  LEditor := TSVGIconImageListEditorFMX.Create(nil);
  with LEditor do
  begin
    try
      //Screen.Cursor := crHourglass;
      try
        FEditinglist.Assign(AImageList);
        //DefaultFontName.ItemIndex := DefaultFontName.Items.IndexOf(FEditingList.FontName);
        SizeSpinBox.Value := FEditingList.Size;
        AutoSizeCheckBox.IsChecked := FEditingList.AutoSizeBitmaps;
        DefaultOpacitySpinBox.Value := FEditingList.Opacity * 100;
        ImageView.Images := FEditinglist;
        UpdateSVGIconListView(ImageView);
        //UpdateGUI;
        if ImageView.Items.Count > 0 then
          ImageView.ItemIndex := 0;

        //if SavedBounds.Right - SavedBounds.Left > 0 then
        //  BoundsRect := SavedBounds;
      finally
        //Screen.Cursor := crDefault;
      end;
      Result := ShowModal = mrOk;
      if Result then
        AImageList.Assign(FEditingList);
      //Savedprocedure TSVGIconImageListEditorFMX.AddButtonClick(Sender: TObject);
      //Bounds := BoundsRect;
    finally
      DisposeOf;
    end;
  end;
end;

{ TSVGIconImageListEditorFMX }

procedure TSVGIconImageListEditorFMX.HelpButtonClick(Sender: TObject);
begin
  ShellExecute(0, 'open',
    PChar('https://github.com/EtheaDev/SVGIconImageList/wiki/Component-Editor-(FMX)'), nil, nil,
    SW_SHOWNORMAL)
end;

procedure TSVGIconImageListEditorFMX.SizeChange(Sender: TObject);
begin
  FEditingList.Size := Round(SizeSpinBox.Value);
  UpdateGUI;
end;

procedure TSVGIconImageListEditorFMX.SVGTextExit(Sender: TObject);
begin
  SelectedSVGIcon.SVGText := SVGText.Lines.Text;
  UpdateGUI;
end;

procedure TSVGIconImageListEditorFMX.AutoSizeCheckBoxClick(Sender: TObject);
begin
  FEditingList.AutoSizeBitmaps := AutoSizeCheckBox.IsChecked;
  UpdateGUI;
end;

procedure TSVGIconImageListEditorFMX.SetImageIconName(IconName: String);
begin
  SelectedSVGIcon.IconName := IconName;
  UpdateGUI;
  UpdateSVGIconListViewCaptions(ImageView);
end;

procedure TSVGIconImageListEditorFMX.SetImageOpacity(Opacity: Single);
begin
  SelectedSVGIcon.Opacity := Opacity / 100;
  UpdateGUI;
end;

procedure TSVGIconImageListEditorFMX.UpdateGUI;
var
  LIsItemSelected: Boolean;
  LSVGIconItem: TSVGIconSourceItem;
  {$IFNDEF UNICODE}
  S: WideString;
  {$ENDIF}
begin
  FUpdating := True;
  try
    LSVGIconItem := SelectedSVGIcon;
    LIsItemSelected := LSVGIconItem <> nil;
    ClearAllButton.Enabled := FEditingList.Count > 0;
    DeleteButton.Enabled := LIsItemSelected;
    OpacitySpinBox.Enabled := LIsItemSelected;
    IconName.Enabled := LIsItemSelected;
    SVGText.Enabled := LIsItemSelected;
    //ShowCharMapButton.Enabled := (FEditingList.FontName <> '');
    IconsGroupBox.Text := Format(FTotIconsLabel, [FEditingList.Count]);
    if LIsItemSelected then
    begin
      ItemGroupBox.Text := Format(FIconIndexLabel,[LSVGIconItem.Index]);
      IconName.Text := LSVGIconItem.IconName;
      SVGText.Lines.Text := LSVGIconItem.SVGText;
      OpacitySpinBox.Value := LSVGIconItem.Opacity * 100;
      IconImage.ImageIndex := LSVGIconItem.Index;
      IconImage.Repaint;
    end
    else
    begin
      IconName.Text := '';
      SVGText.Lines.Clear;
      IconImage.ImageIndex := -1;
    end;
  finally
    FUpdating := False;
  end;
end;

procedure TSVGIconImageListEditorFMX.DeleteSelectedItem;
var
  LIndex: Integer;
begin
  LIndex := ImageView.Selected.Index;
  FEditingList.DeleteIcon(LIndex);
  UpdateSVGIconListView(ImageView);
  if LIndex < ImageView.Items.Count then
    ImageView.ItemIndex := LIndex
  else if ImageView.Items.Count > 0 then
    ImageView.ItemIndex := LIndex-1;
  UpdateGUI;
end;

destructor TSVGIconImageListEditorFMX.Destroy;
begin
  inherited;
end;

procedure TSVGIconImageListEditorFMX.ClearAllImages;
begin
  //Screen.Cursor := crHourglass;
  try
    FEditingList.ClearIcons;
  finally
    //Screen.Cursor := crDefault;
  end;
end;

(*
procedure TSVGIconImageListEditorFMX.CloseCharMap(Sender: TObject;
  var Action: TCloseAction);
begin
  if FCharMap.ModalResult = mrOK then
  begin
    if FCharMap.CharsEdit.Text <> '' then
    begin
      FEditingList.AddIcons(FCharMap.CharsEdit.Text, FCharMap.DefaultFontName.Text);
      UpdateSVGIconListView(ImageView);
    end;
  end;
end;
*)

procedure TSVGIconImageListEditorFMX.ClearAllButtonClick(Sender: TObject);
begin
  ClearAllImages;
  UpdateSVGIconListView(ImageView);
  UpdateGUI;
end;

(*
procedure TSVGIconImageListEditorFMX.SVGIconImageListFontMissing(
  const AFontName: TFontName);
begin
  MessageDlg(Format(ERR_SVGIcon_FONT_NOT_INSTALLED,[AFontName]),
    mtError, [mbOK], 0);
end;
*)

procedure TSVGIconImageListEditorFMX.IconNameExit(Sender: TObject);
begin
  if FUpdating then Exit;
  SetImageIconName(IconName.Text);
  UpdateGUI;
end;

procedure TSVGIconImageListEditorFMX.ImageViewSelectItem(Sender: TObject);
begin
  UpdateGUI;
end;

procedure TSVGIconImageListEditorFMX.NewButtonClick(Sender: TObject);
begin
  AddNewItem;
end;

procedure TSVGIconImageListEditorFMX.OpacitySpinBoxChange(Sender: TObject);
begin
  if FUpdating then Exit;
  SetImageOpacity(OpacitySpinBox.Value);
end;

procedure TSVGIconImageListEditorFMX.DefaultOpacitySpinBoxChange(
  Sender: TObject);
begin
  if FUpdating then Exit;
  SetImageOpacity(DefaultOpacitySpinBox.Value);
end;

procedure TSVGIconImageListEditorFMX.DeleteButtonClick(Sender: TObject);
begin
  DeleteSelectedItem;
end;

procedure TSVGIconImageListEditorFMX.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if ModalResult = mrOK then
    OKButton.SetFocus
  else
    CancelButton.SetFocus;
end;

procedure TSVGIconImageListEditorFMX.FormCreate(Sender: TObject);
begin
  Caption := Format(Caption, [SVGIconImageListVersion]);
  FUpdating := True;
  FEditingList := TSVGIconImageList.Create(nil);
  FIconIndexLabel := ItemGroupBox.Text;
  FTotIconsLabel := IconsGroupBox.Text;
  IconImage.Images := FEditingList;
end;

procedure TSVGIconImageListEditorFMX.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FEditingList);
  //Screen.Cursors[crColorPick] := 0;
end;

procedure TSVGIconImageListEditorFMX.FormResize(Sender: TObject);
begin
  if ClientWidth < 610 then
    ClientWidth := 610;
  if ClientHeight < 390 then
    ClientHeight := 390;
end;

function TSVGIconImageListEditorFMX.SelectedSVGIcon: TSVGIconSourceItem;
begin
  if (ImageView.Selected <> nil) and (ImageView.Selected.Index < FEditingList.Source.Count) then
    Result := FEditingList.Source.Items[ImageView.Selected.Index] as TSVGIconSourceItem
  else
    Result := nil;
end;

procedure TSVGIconImageListEditorFMX.AddButtonClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    //Screen.Cursor := crHourGlass;
    try
      FEditingList.LoadFromFiles(OpenDialog.Files);
      UpdateSVGIconListView(ImageView);
    finally
      //Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TSVGIconImageListEditorFMX.AddNewItem;
var
  LInsertIndex: Integer;
begin
  if (ImageView.Selected <> nil) then
    LInsertIndex := ImageView.Selected.Index +1
  else
    LInsertIndex := ImageView.Items.Count;
  FEditingList.InsertIcon(LInsertIndex,'','');
  UpdateSVGIconListView(ImageView);
  ImageView.ItemIndex := LInsertIndex;
end;

end.
