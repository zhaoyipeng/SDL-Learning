program Lesson2;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  sdl2 in '..\..\Pascal-SDL-2-Headers-master\sdl2.pas',
  res_path in '..\include\res_path.pas';

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
