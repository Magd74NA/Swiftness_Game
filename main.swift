import Raylib

let gravity: Float32 = 2000
let playerSpeed: Float32 = 400
let jumpForce: Float32 = -600
let playerScale: Float32 = 4
let playerHeight: Float32 = 64

let MAX_BUILDINGS = 100

let left: Int32 = 263
let right: Int32 = 262
let jump: Int32 = 32  // Space
let jumpAlt: Int32 = 265
let down: Int32 = 264

struct screenDimensions {
  let screenName: String = "Swiftness"
  let screenWidth: Int32 = 1280
  let screenHeight: Int32 = 720
  let targetFPS: Int32 = 144
  init() {
    InitWindow(screenWidth, screenHeight, screenName)
    SetTargetFPS(targetFPS)
    print("window start")
  }
}

//START HERE
//playing around with structs and inits probably not a good use but now I can initialize wherever I want with this one line
_ = screenDimensions()

//Memory ordered smallest to largest members for optimization?
struct playerProperties {
  var player_grounded = false
  var player_stationary = false
  var player_flip = false

  var player_run_current_frame: Int = 0
  let player_run_num_frames = 4

  var player_run_frame_timer: Float32 = 0
  var player_run_frame_length: Float32 = 0.1

  var player_pos: Vector2 = Vector2(x: 640, y: 320)
  var player_vel: Vector2 = Vector2(x: 0, y: 0)

  let player_run_texture: Texture = LoadTexture("cat_run.png")
}

var player = playerProperties()

  var player_camera = Camera2D(
    offset : Vector2(x: Float32(GetScreenWidth())/2.0, y: Float32(GetScreenHeight())/2.0),
    target : Vector2(x: 0 , y: Float32(GetScreenHeight())/2.0),
    rotation : 0,
    zoom : 1,
  )

var buildColors: [Color] = []
var buildings: [Rectangle] = []
var spacing = 0

    for i in 0...100 
    {
      let h = Float32(GetRandomValue(100, 800))

      buildings.append(
        Rectangle(
          x : -6000.0 + Float32(spacing),
          y : Float32(GetScreenHeight()) - 130.0 - h,
          width : Float32(GetRandomValue(50, 200)),
          height : h,
          )
        )

        spacing += Int(buildings[i].width);

        buildColors.append(Color(
            r : CUnsignedChar(GetRandomValue(200, 240)),
            g : CUnsignedChar(GetRandomValue(200, 240)),
            b : CUnsignedChar(GetRandomValue(200, 250)),
            a : 255))
    }

while !WindowShouldClose() {

  BeginMode2D(player_camera)
  DrawRectangle(-6000, 320, 13000, 8000, Color(r:200, g:200, b:200, a:255))

  for i in 0 ..< MAX_BUILDINGS {
    DrawRectangleRec(buildings[i], buildColors[i])
  }
  player_camera.target.x = player.player_pos.x
  ClearBackground(Color(r: 110, g: 184, b: 168, a: 255))
  player.player_vel.y += gravity * GetFrameTime()

  if IsKeyDown(left) {
    player.player_vel.x = -playerSpeed
    player.player_flip = true
    player.player_stationary = false
  } else if IsKeyDown(right) {
    player.player_vel.x = playerSpeed
    player.player_flip = false
    player.player_stationary = false
  } else {
    player.player_vel.x = 0
    player.player_stationary = true
  }
  if player.player_grounded && (IsKeyPressed(jump) || IsKeyPressed(jumpAlt)) {
    player.player_vel.y = jumpForce
    player.player_grounded = false
  }

  player.player_pos.x = player.player_pos.x + (player.player_vel.x * GetFrameTime())
  player.player_pos.y = player.player_pos.y + (player.player_vel.y * GetFrameTime())

  if player.player_pos.y > Float32(GetScreenHeight()) - playerHeight {

    player.player_pos.y = Float32(GetScreenHeight()) - playerHeight
    player.player_grounded = true
    player.player_vel.y = 0
  }

  let player_run_width = Float32(player.player_run_texture.width)
  let player_run_height = Float32(player.player_run_texture.height)

  if !player.player_stationary {
    player.player_run_frame_timer += GetFrameTime()
  } else {
    player.player_run_current_frame = 3
  }
  if player.player_run_frame_timer > player.player_run_frame_length {
    player.player_run_current_frame += 1
    player.player_run_frame_timer = 0
    if player.player_run_current_frame == player.player_run_num_frames {
      player.player_run_current_frame = 0
    }
  }

  var draw_player_source = Rectangle(
    x: Float32(player.player_run_current_frame) * player_run_width
      / Float32(player.player_run_num_frames),
    y: 0,
    width: player_run_width / Float32(player.player_run_num_frames),
    height: player_run_height)

  if player.player_flip {
    draw_player_source.width = -draw_player_source.width
  }

  let draw_player_dest = Rectangle(
    x: player.player_pos.x,
    y: player.player_pos.y,
    width: player_run_width * playerScale / Float32(player.player_run_num_frames),
    height: player_run_height * playerScale
  )

  
  
  DrawTexturePro(
    player.player_run_texture, draw_player_source, draw_player_dest, Vector2(x: 0, y: 0), 0,
    Color(r: 245, g: 245, b: 245, a: 255))
  EndDrawing()
}
UnloadTexture(player.player_run_texture) 
CloseWindow()
