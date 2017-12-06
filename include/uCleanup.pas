unit uCleanup;

interface

uses
  sdl2;

procedure cleanup(win : PSDL_Window); overload;
procedure cleanup(ren : PSDL_Renderer); overload;
procedure cleanup(tex : PSDL_Texture); overload;
procedure cleanup(surf : PSDL_Surface); overload;


implementation

procedure cleanup(win : PSDL_Window);
begin
  if (win = nil) then
    Exit;
  SDL_DestroyWindow(win);
end;

procedure cleanup(ren : PSDL_Renderer);
begin
  if (ren = nil) then
    Exit;
  SDL_DestroyRenderer(ren);
end;

procedure cleanup(tex : PSDL_Texture);
begin
  if (tex = nil) then
    Exit;
  SDL_DestroyTexture(tex);
end;

procedure cleanup(surf : PSDL_Surface);
begin
  if (surf <> nil) then
    Exit;
  SDL_FreeSurface(surf);
end;

end.
