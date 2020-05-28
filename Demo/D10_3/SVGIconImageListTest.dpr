program SVGIconImageListTest;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  UMaintEST in '..\Source\UMaintEST.pas' {MainForm},
  SVGIconImageListEditorUnit in '..\..\Packages\SVGIconImageListEditorUnit.pas' {SVGIconImageListEditor},
  SVGIconImageList in '..\..\source\SVGIconImageList.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10');
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
