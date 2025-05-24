import Raylib

struct screenDimensions{
  let screenName : String = "Swiftness"
  let screenWidth: Int32 = 1280
  let screenHeight: Int32 = 720
  let targetFPS: Int32 = 144
  init() {
    InitWindow(screenWidth, screenHeight, screenName)
    SetTargetFPS(targetFPS)
    print("window start")
  }
}
 //playing around with structs and inits probably not a good use but now I can initialize wherever I want with this one line
_ = screenDimensions()

//Memory ordered smallest to largest members for optimization?
struct playerProperties {
  var player_grounded = false
  var player_stationary = false
  var player_flip = false

  var player_run_current_frame : Int = 0
  let player_run_num_frames = 4
  
  var player_run_frame_timer : Float32 = 0
  var player_run_frame_length : Float32 = 0.1

  var player_pos : Vector2 = Vector2(x : 640, y : 320)
  var player_vel : Vector2 = Vector2(x : 0, y : 0)
  
  let player_run_texture : Texture = LoadTexture("cat_run.png")
}

var player = playerProperties()
while !WindowShouldClose() {

    BeginDrawing()
    ClearBackground(Color(r: 110, g: 184, b: 168, a: 255))
    player.player_vel.y += 2000 * GetFrameTime()

    if IsKeyDown(263) {
     player.player_vel.x = -400
     player.player_flip = true
     player.player_stationary = false
    }else if IsKeyDown(262) {
     player.player_vel.x = 400
     player.player_flip = false
     player.player_stationary = false
    }else {
     player.player_vel.x = 0
     player.player_stationary = true
    }
   if player.player_grounded && (IsKeyPressed(32) || IsKeyPressed(265)) {
     player.player_vel.y = -600 
     player.player_grounded = false
   }
   if IsKeyPressed(264) {
     player.player_vel.y = 800 
   }

   player.player_pos.x =  player.player_pos.x + (player.player_vel.x * GetFrameTime()) 
   player.player_pos.y = player.player_pos.y + (player.player_vel.y * GetFrameTime())

   if player.player_pos.y > Float32(GetScreenHeight() - 64) {
     player.player_pos.y = Float32(GetScreenHeight() - 64)
     player.player_grounded = true
   }

   let player_run_width = Float32(player.player_run_texture.width)
   let player_run_height = Float32(player.player_run_texture.height)

   if(!player.player_stationary){
   player.player_run_frame_timer += GetFrameTime()
  }else{
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
    x: Float32(player.player_run_current_frame) * player_run_width / Float32(player.player_run_num_frames), 
    y: 0 , 
    width: player_run_width / Float32(player.player_run_num_frames) , 
    height: player_run_height) 

   if player.player_flip {
    draw_player_source.width = -draw_player_source.width
   }

   let draw_player_dest = Rectangle (
      x : player.player_pos.x,
      y : player.player_pos.y,
      width : player_run_width * 4 / Float32(player.player_run_num_frames),
      height : player_run_height * 4
  )

   DrawTexturePro(player.player_run_texture, draw_player_source, draw_player_dest, Vector2(x:0,y:0), 0, Color(r: 245, g: 245, b: 245, a: 255))
   EndDrawing()
  }
  CloseWindow()

