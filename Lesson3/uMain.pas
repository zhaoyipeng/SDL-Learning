unit uMain;

interface

uses
  sdl2,
  sdl2_image,
  uCleanup,
  res_path;

const
  SCREEN_WIDTH: Integer = 640;
  SCREEN_HEIGHT: Integer = 480;
  //We'll just be using square tiles for now
  TILE_SIZE: Integer = 40;

function Main: Integer;

implementation

/// <summary>
/// Log an SDL error with some error message to the output stream of our choice
/// </summary>
/// <param name="msg">The error message to write, format will be msg error: SDL_GetError()</param>
procedure logSDLError(const msg: string);
begin
  Writeln(msg, ' error: ', SDL_GetError);
end;

/// <summary>
/// Loads an image into a texture on the rendering device
/// </summary>
/// <param name="AFile">The image file to load</param>
/// <param name="ren">The renderer to load the texture onto</param>
/// <returns>the loaded texture, or nil if something went wrong.</returns>
function loadTexture(const AFile: string; ren: PSDL_Renderer): PSDL_Texture;
var
  texture: PSDL_Texture;
begin
  texture := IMG_LoadTexture(ren, PAnsiChar(AnsiString(AFile)));
  if texture = nil then
  begin
    logSDLError('LoadTexture');
  end;
  Result := texture;
end;


/// <summary>
/// Draw an SDL_Texture to an SDL_Renderer at position x, y, with some desired
/// width and height
/// </summary>
/// <param name="tex">The source texture we want to draw</param>
/// <param name="ren">The renderer we want to draw to</param>
/// <param name="x">The x coordinate to draw to</param>
/// <param name="y">The y coordinate to draw to</param>
/// <param name="w">The width of the texture to draw</param>
/// <param name="h">The height of the texture to draw</param>
procedure renderTexture(tex: PSDL_Texture; ren: PSDL_Renderer; x, y, w, h: Integer); overload;
var
  dst: TSDL_Rect;
begin
  // Setup the destination rectangle to be at the position we want
  dst.x := x;
  dst.y := y;
  dst.w := w;
  dst.h := h;
  SDL_RenderCopy(ren, tex, nil, @dst);
end;

/// <summary>
/// Draw an SDL_Texture to an SDL_Renderer at position x, y, preserving
/// the texture's width and height
/// </summary>
/// <param name="tex">The source texture we want to draw</param>
/// <param name="ren">The renderer we want to draw to</param>
/// <param name="x">The x coordinate to draw to</param>
/// <param name="y">The y coordinate to draw to</param>
procedure renderTexture(tex: PSDL_Texture; ren: PSDL_Renderer; x, y: Integer); overload;
var
  w, h: Integer;
begin
  SDL_QueryTexture(tex, nil, nil, @w, @h);
  renderTexture(tex, ren, x, y, w, h);
end;

function Main: Integer;
var
  window: PSDL_Window;
  renderer: PSDL_Renderer;
  resPath    : string;
  background, image      : PSDL_Texture;
  i, bW, bH, iW, iH, x, y : integer;
begin
  //Start up SDL and make sure it went ok
  if SDL_Init(SDL_INIT_EVERYTHING) <> 0 then
  begin
    logSDLError('SDL_Init');
    Exit(1);
  end;

  //Setup our window and renderer
  window := SDL_CreateWindow('Lesson 2', 100, 100, SCREEN_WIDTH, SCREEN_HEIGHT, SDL_WINDOW_SHOWN);
  if window = nil then
  begin
    logSDLError('CreateWindow');
    SDL_Quit();
    Exit(1);
  end;
  renderer := SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED or SDL_RENDERER_PRESENTVSYNC);
  if renderer = nil then
  begin
    logSDLError('CreateRenderer');
    cleanup(window);
    SDL_Quit();
    Exit(1);
  end;

  //The textures we'll be using
  resPath := getResourcePath('Lesson2');
  background := loadTexture((resPath) + 'background.bmp', renderer);
  image := loadTexture(resPath + 'image.bmp', renderer);
  //Make sure they both loaded ok
  if (background = nil)  or  (image = nil) then
  begin
    cleanup(background);
    cleanup(image);
    cleanup(renderer);
    cleanup(window);
    SDL_Quit();
    Exit(1);
  end;

  //A sleepy rendering loop, wait for 3 seconds and render and present the screen each time
  for i := 0 to 2 do
  begin
    //Clear the window
    SDL_RenderClear(renderer);
    //Get the width and height from the texture so we know how much to move x,y by
    //to tile it correctly
    SDL_QueryTexture(background, nil, nil, @bW, @bH);
    //We want to tile our background so draw it 4 times
    renderTexture(background, renderer, 0, 0);
    renderTexture(background, renderer, bW, 0);
    renderTexture(background, renderer, 0, bH);
    renderTexture(background, renderer, bW, bH);
    //Draw our image in the center of the window
    //We need the foreground image's width to properly compute the position
    //of it's top left corner so that the image will be centered
    SDL_QueryTexture(image, nil, nil, @iW, @iH);
    x := SCREEN_WIDTH div 2 - iW div 2;
    y := SCREEN_HEIGHT div 2 - iH div 2;
    renderTexture(image, renderer, x, y);
    //Update the screen
    SDL_RenderPresent(renderer);
    //Take a quick break after all that hard work
    SDL_Delay(1000);
  end;
  cleanup(background);
  cleanup(image);
  cleanup(renderer);
  cleanup(window);
  SDL_Quit();
  Result := 0;
end;

end.
