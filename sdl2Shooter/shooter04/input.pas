
unit input;

{$mode objfpc}
{$H+}

// ******************** interface ********************
interface

function doInput: Boolean;

// ******************** implementation ********************
implementation

uses
  {sdl2}
  sdl2,
  {base}
  structs;

// 
procedure doKeyUp(event: PSDL_KeyboardEvent);
begin
  if event^.repeat_ = 0 then
  begin
    case event^.keysym.scancode of
      SDL_SCANCODE_UP: app.up := false;
      SDL_SCANCODE_DOWN: app.down := false;
      SDL_SCANCODE_LEFT: app.left := false;
      SDL_SCANCODE_RIGHT: app.right := false;
      SDL_SCANCODE_SPACE: app.fire := false;
    end;
  end;
end;

// 
procedure doKeyDown(event: PSDL_KeyboardEvent);
begin
  if event^.repeat_ = 0 then
  begin
    case event^.keysym.scancode of
      SDL_SCANCODE_UP: app.up := true;
      SDL_SCANCODE_DOWN: app.down := true;
      SDL_SCANCODE_LEFT: app.left := true;
      SDL_SCANCODE_RIGHT: app.right := true;
      SDL_SCANCODE_SPACE: app.fire := true;
    end;
  end;
end;

// 
function doInput: Boolean;
var
  event: TSDL_Event;
begin
  while SDL_PollEvent(@event) = 1 do
  begin
    case event.Type_ of
      SDL_QUITEV: Result := false;
      SDL_KEYDOWN: doKeyDown(@event);
      SDL_KEYUP: doKeyUp(@event);
    end;
    Exit;
  end;
end;

end.
