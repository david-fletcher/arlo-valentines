-- MIT License

-- Copyright (c) 2023 David Fletcher

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

local font = nil
local arloHeartImage = nil
local arloTitleTextImage = nil

local GAME_STATE = nil

local frameNum = 0
local button = {}
local takingScreenshot = false

local GAME_DATA = {
    from = "",
    to = ""
}

local blue = {0.114, 0.169, 0.325}

-- lifecycle methods
function love.load(arg, unfilteredArg)
    love.filesystem.setIdentity("arlo_valentine")

    -- asset loading
    font = love.graphics.newFont("assets/Double_Bubble_shadow.otf", 60)
    arloTitleTextImage = love.graphics.newImage("assets/arlo-valentines.png")
    arloHeartImage = love.graphics.newImage("assets/arlo-heart.png")

    -- variable init
    GAME_STATE = "MENU"
end

function love.update(dt)
    frameNum = frameNum + 1
    local mouseX, mouseY = love.mouse.getPosition()

    if (GAME_STATE == "MENU") then
        button = {}
        button.x = (love.graphics.getWidth() / 2) - 100
        button.y = love.graphics.getHeight() - 100
        button.w = 200
        button.h = 75
        button.text = "play"

        if (mouseX > button.x and mouseX < button.x + button.w and
            mouseY > button.y and mouseY < button.y + button.h) then
                button.mode = "fill"
                button.textColor = blue
        else
                button.mode = "line"
                button.textColor = {1, 1, 1}
        end
    elseif (GAME_STATE == "FROM" or GAME_STATE == "TO") then
        button = {}
        button.x = (love.graphics.getWidth() / 2) - 100
        button.y = love.graphics.getHeight() - 100
        button.w = 200
        button.h = 75
        button.text = "next"

        if (mouseX > button.x and mouseX < button.x + button.w and
            mouseY > button.y and mouseY < button.y + button.h) then
                button.mode = "fill"
                button.textColor = blue
        else
                button.mode = "line"
                button.textColor = {1, 1, 1}
        end
    elseif (GAME_STATE == "FINAL") then
        button = {}
        button.x = (love.graphics.getWidth() / 2) - 100
        button.y = love.graphics.getHeight() - 100
        button.w = 200
        button.h = 75
        button.text = "save"

        if (mouseX > button.x and mouseX < button.x + button.w and
            mouseY > button.y and mouseY < button.y + button.h) then
                button.mode = "fill"
                button.textColor = blue
        else
                button.mode = "line"
                button.textColor = {1, 1, 1}
        end
    end
end

function love.draw()
    love.graphics.clear(blue)

    if (GAME_STATE == "MENU") then
        drawMenuState()
    elseif (GAME_STATE == "FROM") then
        drawFromState()
    elseif (GAME_STATE == "TO") then
        drawToState()
    elseif (GAME_STATE == "FINAL") then
        drawFinalState()
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if (button == 1) then
        handleButtonClick(x, y)
    end
end

function love.keypressed(key, scancode, isrepeat)
    if (scancode == "return" or
        scancode == "escape" or
        scancode == "tab" or 
        scancode == "capslock" or 
        scancode == "lctrl" or 
        scancode == "lshift" or 
        scancode == "lalt" or 
        scancode == "rctrl" or 
        scancode == "rshift" or 
        scancode == "ralt" or
        scancode == "right" or
        scancode == "left" or 
        scancode == "up" or 
        scancode == "down" or
        scancode == ".") then 
        return 
    end
    if (scancode == "space") then key = " " end

    if (GAME_STATE == "FROM") then
        if (scancode == "backspace") then
            GAME_DATA.from = GAME_DATA.from:sub(1, -2)
        else
            GAME_DATA.from = GAME_DATA.from..key
        end
    elseif (GAME_STATE == "TO") then
        if (scancode == "backspace") then
            GAME_DATA.to = GAME_DATA.to:sub(1, -2)
        else
            GAME_DATA.to = GAME_DATA.to..key
        end
    end
end

-- HELPER METHODS
function handleButtonClick(mouseX, mouseY)
    if (mouseX > button.x and mouseX < button.x + button.w and
        mouseY > button.y and mouseY < button.y + button.h) then
            -- switch to the next game mode
            if (GAME_STATE == "MENU") then
                GAME_STATE = "FROM"
            elseif (GAME_STATE == "FROM") then
                GAME_STATE = "TO"
            elseif (GAME_STATE == "TO") then
                GAME_STATE = "FINAL"
            elseif (GAME_STATE == "FINAL") then
                takingScreenshot = true
            end
    end
end

-- DRAWING METHODS
function drawMenuState()
    local centerX = (love.graphics.getWidth() / 2) - (arloTitleTextImage:getWidth() / 4)
    local centerY = (love.graphics.getHeight() / 2) - (arloTitleTextImage:getHeight() / 4)

    -- draw the graphic
    love.graphics.push("all")
        love.graphics.translate(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
        love.graphics.rotate(math.sin(frameNum / 75) / 6)
        love.graphics.translate(-(love.graphics.getWidth() / 2), -(love.graphics.getHeight() / 2))

        love.graphics.draw(arloTitleTextImage, centerX, centerY - 60, 0, 0.5, 0.5)
    love.graphics.pop()

    -- draw the button
    love.graphics.push("all")
        love.graphics.setLineWidth(5)
        love.graphics.rectangle(button.mode, button.x, button.y, button.w, button.h, 10, 10)
        
        love.graphics.setFont(font)
        love.graphics.setColor(button.textColor)
        love.graphics.printf(button.text, button.x, button.y - 5, button.w, "center")
    love.graphics.pop()
end

function drawFromState()
    love.graphics.push("all")
        local labelText = "who is this card from?"
        local labelTextX = (love.graphics.getWidth() / 2) - (font:getWidth(labelText) / 2)
        local labelTextY = 50

        local inputTextX = (love.graphics.getWidth() / 2) - (font:getWidth(GAME_DATA.from) / 2)
        local inputTextY = 125

        local cursorOffset = inputTextX + font:getWidth(GAME_DATA.from) + 10

        -- draw the label
        love.graphics.setFont(font)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(labelText, labelTextX, labelTextY, font:getWidth(labelText))

        -- display what the user has typed
        love.graphics.printf(GAME_DATA.from, inputTextX, inputTextY, font:getWidth(GAME_DATA.from))

        --  show a cursor
        love.graphics.setLineWidth(3)
        love.graphics.line(cursorOffset, 140, cursorOffset, 190)

        -- draw the button
        love.graphics.setLineWidth(5)
        love.graphics.rectangle(button.mode, button.x, button.y, button.w, button.h, 10, 10)
        
        love.graphics.setFont(font)
        love.graphics.setColor(button.textColor)
        love.graphics.printf(button.text, button.x, button.y - 5, button.w, "center")
    love.graphics.pop()
end

function drawToState()
    love.graphics.push("all")
        local labelText = "who is this card to?"
        local labelTextX = (love.graphics.getWidth() / 2) - (font:getWidth(labelText) / 2)
        local labelTextY = 50

        local inputTextX = (love.graphics.getWidth() / 2) - (font:getWidth(GAME_DATA.to) / 2)
        local inputTextY = 125

        local cursorOffset = inputTextX + font:getWidth(GAME_DATA.to) + 10

        -- draw the label
        love.graphics.setFont(font)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(labelText, labelTextX, labelTextY, font:getWidth(labelText))

        -- display what the user has typed
        love.graphics.printf(GAME_DATA.to, inputTextX, inputTextY, font:getWidth(GAME_DATA.to))

        --  show a cursor
        love.graphics.setLineWidth(3)
        love.graphics.line(cursorOffset, 140, cursorOffset, 190)

        -- draw the button
        love.graphics.setLineWidth(5)
        love.graphics.rectangle(button.mode, button.x, button.y, button.w, button.h, 10, 10)
        
        love.graphics.setFont(font)
        love.graphics.setColor(button.textColor)
        love.graphics.printf(button.text, button.x, button.y - 5, button.w, "center")
    love.graphics.pop()
end

function drawFinalState()
    love.graphics.push("all")
        local labelText = "arlo loves you and so do i!"
        local labelTextX = (love.graphics.getWidth() / 2) - (font:getWidth(labelText) / 2)
        local labelTextY = 50

        -- draw the label
        love.graphics.setFont(font)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(labelText, labelTextX, labelTextY, font:getWidth(labelText))
        
        -- draw arlo
        love.graphics.setDefaultFilter("nearest", "nearest", 1)
        love.graphics.draw(arloHeartImage, 600, 200, 0, 2, 2)

        -- draw the from text
        love.graphics.printf("from: "..GAME_DATA.from, 180, 200, font:getWidth("from: "..GAME_DATA.from))

        -- draw the to text
        love.graphics.printf("to: "..GAME_DATA.to, 180, 275, font:getWidth("to: "..GAME_DATA.to))

        -- draw the button
        if (not takingScreenshot) then
            love.graphics.setLineWidth(5)
            love.graphics.rectangle(button.mode, button.x, button.y, button.w, button.h, 10, 10)
            
            love.graphics.setFont(font)
            love.graphics.setColor(button.textColor)
            love.graphics.printf(button.text, button.x, button.y - 5, button.w, "center")
        end

    love.graphics.pop()

    if (takingScreenshot) then
        love.graphics.captureScreenshot(os.time()..".png")
        takingScreenshot = false
    end
end