-- configure love
function love.conf( t )
    -- https://loveref.github.io/#love.conf
    -- game identity
    t.identity = "arlo-valentines"
    t.window.title = "Arlo's Valentines"
    t.window.icon = "assets/arlo-heart.png"

    -- window settings
    t.window.width = 1024
    t.window.height = 576
    t.window.borderless = false
    t.window.resizable = false
    t.window.fullscreen = false
    t.window.fullscreentype = "desktop"
    t.window.vsync = true -- / 1

    -- disable unnecessary packages
    t.accelerometerjoystick = false
    t.modules.joystick = false
    t.modules.physics = false
    t.modules.touch = false
    t.modules.video = false
    t.modules.thread = false
end