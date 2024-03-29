
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

unit Shooter.Stage;

{$Mode objfpc}
{$H+}

// ******************** interface ********************
interface

uses
  {shooter}
  Shooter.Core,
  Shooter.App,
  Shooter.Structs;

type
  TStage = class(TCoreInterfacedObject, ILogicAndRender)
    public
      fighterHead: TEntity;
      bulletHead: TEntity;
      fighterTail: PEntity;
      bulletTail: PEntity;

      constructor create;
      destructor destroy; override;

    private
      // ILogicAndRender
      procedure logic;
      procedure draw;
  end;

// ******************** var ********************
var
  stage: TStage;

procedure initStage;

// ******************** implementation ********************
implementation

uses
  {sdl2}
  sdl2,
  {shooter}
  Shooter.Defs,
  Shooter.Draw;

var
  player: TEntity;

  fighterTexture: PSDL_Texture;
  bulletTexture: PSDL_Texture;

// 
constructor TStage.create;
begin
  inherited;
  fighterTail := @fighterHead;
  bulletTail := @bulletHead;
end;

// 
destructor TStage.destroy;
begin
  inherited destroy;
end;

// 
procedure fireBullet;
var
  bullet: PEntity;
begin
  bullet := createEntity;

  stage.bulletTail^.next := bullet;
  stage.bulletTail := bullet;

  bullet^.x := player.x;
  bullet^.y := player.y;
  bullet^.dx := PLAYER_BULLET_SPEED;
  bullet^.health := true;

  bullet^.texture := bulletTexture;
  SDL_QueryTexture(bullet^.texture, Nil, Nil, @bullet^.w, @bullet^.h);

  bullet^.y += (player.h Div 2) - (bullet^.h Div 2);
  player.reload := 8;
end;

// 
procedure doPlayer;
begin
  player.dx := 0;
  player.dy := 0;

  if player.reload > 0 then
    Dec(player.reload);

  if app.keyboard[SDL_SCANCODE_UP] = 1 then
    player.dy := (-1 * PLAYER_SPEED);

  if app.keyboard[SDL_SCANCODE_DOWN] = 1 then
    player.dy := PLAYER_SPEED;

  if app.keyboard[SDL_SCANCODE_LEFT] = 1 then
    player.dx := (-1 * PLAYER_SPEED);

  if app.keyboard[SDL_SCANCODE_RIGHT] = 1 then
    player.dx := PLAYER_SPEED;

  if (app.keyboard[SDL_SCANCODE_SPACE] = 1) and (player.reload = 0) then
    fireBullet;

    player.x += player.dx;
    player.y += player.dy;
end;

// 
procedure doBullets;
var
  b: PEntity;
  prev: PEntity;
begin
  prev := @stage.bulletHead;

  b := stage.bulletHead.next;
  while b <> Nil do
  begin
    b^.x += b^.dx;
    b^.y += b^.dy;

    if b^.x > SCREEN_WIDTH then
    begin
      if b = stage.bulletTail then
        stage.bulletTail := prev;

      prev^.next := b^.next;
      
      Dispose(b);
      b := prev;
    end;

    prev := b;
    b := b^.next;
  end;
end;

// 
procedure drawPlayer;
begin
  blit(player.texture, player.x, player.y);
end;

// 
procedure drawBullets;
var
  b: PEntity;
begin
  b := stage.bulletHead.next;
  while b <> Nil do
  begin
    blit(b^.texture, b^.x, b^.y);
    b := b^.next;
  end;
end;

// 
procedure TStage.logic;
begin
  doPlayer;
  doBullets;
end;

// 
procedure TStage.draw;
begin
  drawPlayer;
  drawBullets;
end;

// 
procedure initPlayer;
begin
  stage.fighterTail^.next := @player;
  stage.fighterTail := @player;

  player.x := 100;
  player.y := 100;
  player.texture := fighterTexture;
  SDL_QueryTexture(player.texture, Nil, Nil, @player.w, @player.h);
end;

// 
procedure initStage;
begin
  stage := TStage.create;

  fighterTexture := loadTexture('gfx/player.png');
  bulletTexture := loadTexture('gfx/playerBullet.png');

  initPlayer;
end;

end.
