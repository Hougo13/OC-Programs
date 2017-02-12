local args = {...}
local component = require "component"
local term = require "term"

block = require "block"

gpu = component.proxy(args[1])
term.bind(gpu)
term.clear()

tankD = component.proxy(component.get("963b3380"))
tankT = component.proxy(component.get("f784de03"))
battery = component.induction_matrix

w,h = gpu.getResolution()

local colors = { blue = 0x4286F4, purple = 0xB673d6, red = 0xC14141, green = 0xDA841, black = 0x000000, white = 0xFFFFFF, grey = 0x47494C, lightGrey = 0xBBBBBB}

function getFuelLevels()
    local lD = math.floor(tankD.getInput(2)*100/15)
    local lT = math.floor(tankT.getInput(3)*100/15)
    return lD, lT
end

function getEnergyLevels()
    local current = battery.getEnergy()
    local max = battery.getMaxEnergy()
    local output = battery.getOutput()*0.4
    local e = math.floor(current*100/max)
    return e, current, output
end

local _, e_prev = getEnergyLevels()

while true do
    term.clear()

    local lD, lT = getFuelLevels()
    local e, e_current, e_out = getEnergyLevels()

    local hD = (100-lD)*(h-8)/100
    block.fill(gpu, colors.red, 3, 3, 15, h-6)
    block.fill(gpu, colors.black, 4, 4, 13, hD)
    term.setCursor(9, h-2)
    term.write(lD)
    term.write("%")

    local hT = (100-lT)*(h-8)/100
    block.fill(gpu, colors.blue, w-16, 3, 15, h-6)
    block.fill(gpu, colors.black, w-15, 4, 13, hT)
    term.setCursor(w-10, h-2)
    term.write(lT)
    term.write("%")

    local hE = (100-e)*(h-8)/100
    block.fill(gpu, colors.green, 25, 3, 32, h-6)
    block.fill(gpu, colors.black, 26, 4, 30, hE)
    term.setCursor(40,h-2)
    term.write(e)
    term.write("%")

    if e_current<e_prev then
        term.setCursor(35,h-2)
        term.write("down")
    elseif e_current>e_prev then
        term.setCursor(37,h-2)
        term.write("up")
    end
    e_prev = e_current
    --term.setCursor(27,h-2)
    --term.write(e_out)
    --term.write("RF/t")

    os.sleep(0.5)
end