program Lesson3;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  uMain in 'uMain.pas',
  uCleanup in '..\include\uCleanup.pas',
  res_path in '..\include\res_path.pas',
  sdl2 in '..\..\Pascal-SDL-2-Headers-master\sdl2.pas',
  sdl2_image in '..\..\Pascal-SDL-2-Headers-master\sdl2_image.pas';

begin
  Main;
end.

