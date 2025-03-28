local ui = require "ui"
require "canvas"

-- create a simple Canvas 
local win = ui.Window("Canvas.point sample", 320, 240)
local Canvas = ui.Canvas(win)
Canvas.align = "all"
Canvas.bgcolor = 0x000000FF

 
function Canvas:onPaint()
  local width = math.floor(Canvas.width*ui.dpi)
  local height = math.floor(Canvas.height*ui.dpi)
  local pixels = {}
  for x = 0, width do
    for y = 0, height do
      local rgb = math.random(0xFF)
      pixels[#pixels+1] = string.pack("BBBB", rgb, rgb, rgb, 0xFF)
    end
  end
  Canvas:map(table.concat(pixels))
end

ui.run(win):wait()