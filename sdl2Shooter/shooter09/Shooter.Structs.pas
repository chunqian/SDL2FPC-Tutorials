
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

unit Shooter.Structs;

{$Mode objfpc}
{$H+}

// ******************** interface ********************
interface

uses
  {sdl2}
  sdl2;

// ******************** type ********************
type
  PEntity = ^TEntity;
  TEntity = record
    x: Double;
    y: Double;
    w: Integer;
    h: Integer;
    dx: Double;
    dy: Double;
    health: Integer;
    reload: Integer;
    side: Integer;
    texture: PSDL_Texture;
    next: PEntity;
  end;

  PExplosion = ^TExplosion;
  TExplosion = record
    x: Double;
    y: Double;
    dx: Double;
    dy: Double;
    r: Integer;
    g: Integer;
    b: Integer;
    a: Integer;
    next: PExplosion;
  end;

  PDebris = ^TDebris;
  TDebris = record
    x: Double;
    y: Double;
    dx: Double;
    dy: Double;
    rect: TSDL_Rect;
    texture: PSDL_Texture;
    life: Integer;
    next: PDebris;
  end;

  TStar = record
    x: Integer;
    y: Integer;
    speed: Integer;
  end;

procedure disposeEntityAndNext(t: PEntity);
procedure disposeExplosionAndNext(t: PExplosion);
procedure disposeDebrisAndNext(t: PDebris);

function createEntity: PEntity;
function createExplosion: PExplosion;
function createDebris: PDebris;

// ******************** implementation ********************
implementation

// 
function createEntity: PEntity;
var
  e: PEntity;
begin
  New(e);
  with e^ do
  begin
    x := 0.0;
    y := 0.0;
    dx := 0.0;
    dy := 0.0;
    h := 0;
    w := 0;
    health := 0;
    reload := 0;
    side := 0;
    Texture := Nil;
    next := Nil;
  end;
  Result := e;
end;

// 
function createExplosion: PExplosion;
var
  e: PExplosion;
begin
  New(e);
  with e^ do
  begin
    x := 0.0;
    y := 0.0;
    dx := 0.0;
    dy := 0.0;
    r := 0;
    g := 0;
    b := 0;
    a := 0;
    next := Nil;
  end;
  Result := e;
end;

// 
function createDebris: PDebris;
var
  e: PDebris;
begin
  New(e);
  with e^ do
  begin
    x := 0.0;
    y := 0.0;
    dx := 0.0;
    dy := 0.0;
    rect.x := 0;
    rect.y := 0;
    rect.w := 0;
    rect.h := 0;
    texture := nil;
    life := 0;
    next := Nil;
  end;
  Result := e;
end;

// 
procedure disposeEntityAndNext(t: PEntity);
var
  e: PEntity;
  prev: PEntity;
begin
  prev := t;
  e := t^.next;
  while e <> Nil do
  begin
    prev^.next := e^.next;
    Dispose(e);
    e := prev;

    e := e^.next;
  end;
end;

// 
procedure disposeExplosionAndNext(t: PExplosion);
var
  e: PExplosion;
  prev: PExplosion;
begin
  prev := t;
  e := t^.next;
  while e <> Nil do
  begin
    prev^.next := e^.next;
    Dispose(e);
    e := prev;

    e := e^.next;
  end;
end;

// 
procedure disposeDebrisAndNext(t: PDebris);
var
  e: PDebris;
  prev: PDebris;
begin
  prev := t;
  e := t^.next;
  while e <> Nil do
  begin
    prev^.next := e^.next;
    Dispose(e);
    e := prev;

    e := e^.next;
  end;
end;

end.
