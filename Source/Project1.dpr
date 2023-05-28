program Project1;

uses
  Forms, Windows, Dialogs,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {Form2};

{$R *.res}
{$R 'uac_win.res'}

begin
  SetWindowLong(Application.Handle, GWL_EXSTYLE,
          GetWindowLong(Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW);

  Form2 := TForm2.Create(Application);
  Form2.Show;
  
  while Form2.Timer1.Enabled do
  Application.ProcessMessages;

  Application.Initialize;
  Application.CreateForm(TForm1, Form1);

  Form2.Hide;
  Form2.Free;

  Application.Run;
end.
