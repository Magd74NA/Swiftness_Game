// The Swift Programming Language
// https://docs.swift.org/swift-book
import Raylib

let screenWidth: Int32 = 1280
let screenHeight: Int32 = 720

Raylib.initWindow(screenWidth, screenHeight, "Swiftness")
Raylib.setTargetFPS(144)

var player_pos: Vector2 = Vector2(x: 640, y: 320)
var player_vel : Vector2 = Vector2(x:0, y:0)
var player_grounded = false
var player_flip = false
var player_stationary = false

let player_run_texture : Texture = Raylib.loadTexture("cat_run.png")
let player_run_num_frames = 4
var player_run_frame_timer: Float32 = 0
var player_run_current_frame : Int = 0
var player_run_frame_length : Float32 = 0.1

print("window start")

while Raylib.windowShouldClose == false {
    Raylib.beginDrawing()
    Raylib.clearBackground(Color(r: 110, g: 184, b: 168, a: 255))

    player_vel.y += 2000 * Raylib.getFrameTime()
   	if Raylib.isKeyDown(.left) {
     player_vel.x = -400
     player_flip = true
     player_stationary = false
   	}else if Raylib.isKeyDown(.right) {
     player_vel.x = 400
     player_flip = false
     player_stationary = false
   	}else {
     player_vel.x = 0
     player_stationary = true
   	}
   if player_grounded && (Raylib.isKeyPressed(.space) || Raylib.isKeyPressed(.up)) {
     player_vel.y = -600 
     player_grounded = false
   }
   if Raylib.isKeyPressed(.down) {
     player_vel.y = 800 
   }

   player_pos.x =  player_pos.x + (player_vel.x * Raylib.getFrameTime()) 
   player_pos.y = player_pos.y + (player_vel.y * Raylib.getFrameTime())

   if player_pos.y > Float32(Raylib.getScreenHeight() - 64) {
     player_pos.y = Float32(Raylib.getScreenHeight() - 64)
     player_grounded = true
   }

   let player_run_width = Float32(player_run_texture.width)
   let player_run_height = Float32(player_run_texture.height)

   if(!player_stationary){
   player_run_frame_timer += Raylib.getFrameTime()
	}
	
   if player_run_frame_timer > player_run_frame_length {
    player_run_current_frame += 1
    player_run_frame_timer = 0

    if player_run_current_frame == player_run_num_frames {
        player_run_current_frame = 0
        }
    }

    var draw_player_source = Rectangle(
   	x: Float32(player_run_current_frame) * player_run_width / Float32(player_run_num_frames), 
   	y: 0 , 
   	width: player_run_width / Float32(player_run_num_frames) , 
   	height: player_run_height) 

   if player_flip {
   	draw_player_source.width = -draw_player_source.width
   }

   let draw_player_dest = Rectangle (
    	x : player_pos.x,
    	y : player_pos.y,
    	width : player_run_width * 4 / Float32(player_run_num_frames),
    	height : player_run_height * 4
	)

   Raylib.drawTexturePro(player_run_texture, draw_player_source, draw_player_dest, Vector2(x:0,y:0), 0, .rayWhite)
   Raylib.endDrawing()
  }
  Raylib.closeWindow()
