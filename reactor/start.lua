local component = require "component"
local term = require "term"
local event = require "event"
local process = require "process"
local coroutine = require "coroutine"

package.loaded["block"] = nil
block = require("block")

local colors = { blue = 0x4286F4, purple = 0xB673d6, red = 0xC14141, green = 0xDA841, black = 0x000000, white = 0xFFFFFF, grey = 0x47494C, lightGrey = 0xBBBBBB}

local gpu_list = {}
for k,v in pairs( component.list("gpu")) do
    table.insert(gpu_list, k)
end

local screen_list = {}
for k,v in pairs(component.list("screen")) do
    table.insert(screen_list, k)
end

function lengthOf(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

if lengthOf(gpu_list) < lengthOf(screen_list) then
    print("Not enough gpu")
else
    for i,v in ipairs(screen_list) do
        local gpu = component.proxy(gpu_list[i])
        gpu.bind(v)

        term.bind(gpu)
        term.clear()

        local w_max,h_max = gpu.maxResolution()
        local w = w_max/2
        local h = h_max/2

        gpu.setResolution(w,h)

        local text = {}
        text.x = (w-6)/2
        text.y = (h-1)/2
        text.length = 6

        term.setCursor(text.x,text.y)

        term.drawText("GLOBAL")
        block.frame(gpu, colors.white, text.x, text.y, text.length, 3)

    end
    local _,address,x,y,button,player = event.pull("touch")
    for i,v in ipairs(screen_list) do
        if v==address then
            global_process = process.load("global")
            coroutine.resume(global_process, gpu_list[i])
        end
    end
end