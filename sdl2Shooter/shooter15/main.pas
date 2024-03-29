
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

program main;

{$Mode objfpc}
{$H+}

uses
  {sdl2}
  sdl2,
  {shooter}
  Shooter.App,
  Shooter.Draw,
  Shooter.Input,
  Shooter.Audio,
  Shooter.Text,
  Shooter.Background,
  Shooter.Highscores,
  Shooter.Title,
  Shooter.Stage;

procedure atExit; FORWARD;
procedure capFrameRate(var then_: Integer; var remainder: Double); FORWARD;

// 
procedure atExit;
begin
  app.delegate := Nil;

  if stage <> Nil then
    stage.destroy;

  if highscores <> Nil then
    highscores.destroy;

  title.destroy;
  background.destroy;
  audio.destroy;
  app.destroy;

  if ExitCode <> 0 then
    WriteLn(SDL_GetError)
  else
    WriteLn('Successful done.');
end;

// 
procedure capFrameRate(var then_: Integer; var remainder: Double);
var
  wait: Integer;
  frameTime: Integer;
begin
  wait := 16 + Trunc(remainder);
  remainder -= Trunc(remainder);

  frameTime := SDL_GetTicks - then_;
  wait -= frameTime;

  if wait < 1 then
    wait := 1;

  SDL_Delay(wait);
  remainder += 0.667;
  then_ := SDL_GetTicks;
end;

// ******************** var ********************
var
  then_: Integer;
  remainder: Double;
begin
  initApp;

  initTitle;

  initHighscores;

  initBackground;

  initAudio;

  initFonts;

  AddExitProc(@atExit);

  then_ := SDL_GetTicks;
  remainder := 0;

  app.delegate := title;

  while true do
  begin
    prepareScene;

    doInput;

    if app.delegate <> Nil then
    begin
      app.delegate.logic;

      app.delegate.draw;
    end;

    presentScene;

    capFrameRate(then_, remainder);
  end;

end.
