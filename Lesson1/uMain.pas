unit uMain;

interface

uses
  sdl2,
  res_path;

function Main: Integer;

implementation

function Main: Integer;
var
  win: PSDL_Window;
  ren: PSDL_Renderer;
  bmp: PSDL_Surface;
  tex: PSDL_Texture;
  imagePath: string;
  i: Integer;
begin

  // First we need to start up SDL, and make sure it went ok
  if (SDL_Init(SDL_INIT_VIDEO) <> 0) then
  begin
    Writeln('SDL_Init Error: ', SDL_GetError);
    Exit(1);
  end;

  // Now create a window with title "Hello World" at 100, 100 on the screen with w:640 h:480 and show it
  win := SDL_CreateWindow('Hello World!', 100, 100, 640, 480, SDL_WINDOW_SHOWN);
  // Make sure creating our window went ok
  if (win = nil) then
  begin
    Writeln('SDL_CreateWindow Error: ', SDL_GetError);
    Exit(1)
  end;

  // Create a renderer that will draw to the window, -1 specifies that we want to load whichever
  // video driver supports the flags we're passing
  // Flags: SDL_RENDERER_ACCELERATED: We want to use hardware accelerated rendering
  // SDL_RENDERER_PRESENTVSYNC: We want the renderer's present function (update screen) to be
  // synchronized with the monitor's refresh rate
  ren := SDL_CreateRenderer(win, -1, SDL_RENDERER_ACCELERATED or SDL_RENDERER_PRESENTVSYNC);
  if (ren = nil) then
  begin
    SDL_DestroyWindow(win);
    Writeln('SDL_CreateRenderer Error: ', SDL_GetError);
    SDL_Quit();
    Exit(1);
  end;

  // SDL 2.0 now uses textures to draw things but SDL_LoadBMP returns a surface
  // this lets us choose when to upload or remove textures from the GPU
  imagePath := getResourcePath('Lesson1') + 'hello.bmp';
  bmp := SDL_LoadBMP(PAnsiChar(AnsiString(imagePath)));
  if (bmp = nil) then
  begin
    SDL_DestroyRenderer(ren);
    SDL_DestroyWindow(win);
    Writeln('SDL_LoadBMP Error: ', SDL_GetError);
    SDL_Quit();
    Exit(1);
  end;

  // To use a hardware accelerated texture for rendering we can create one from
  // the surface we loaded
  tex := SDL_CreateTextureFromSurface(ren, bmp);
  // We no longer need the surface
  SDL_FreeSurface(bmp);
  if (tex = nil) then
  begin
    SDL_DestroyRenderer(ren);
    SDL_DestroyWindow(win);
    Writeln('SDL_CreateTextureFromSurface Error: ', SDL_GetError);
    SDL_Quit();
    Exit(1);
  end;

  // A sleepy rendering loop, wait for 3 seconds and render and present the screen each time
  for i := 0 to 2 do
  begin
    // First clear the renderer
    SDL_RenderClear(ren);
    // Draw the texture
    SDL_RenderCopy(ren, tex, nil, nil);
    // Update the screen
    SDL_RenderPresent(ren);
    // Take a quick break after all that hard work
    SDL_Delay(1000);
  end;

  // Clean up our objects and quit
  SDL_DestroyTexture(tex);
  SDL_DestroyRenderer(ren);
  SDL_DestroyWindow(win);
  SDL_Quit();
end;

end.
