-- Switch-specific input lives here so desktop and mod gameplay retain their existing paths.
local Switch = {}
local mouse_buttons = {rightstick = 1, leftshoulder = 2}
local held = {}
local cursor_time = 0

function Switch.enabled()
    return love.system.getOS() == "NX"
end

function Switch.defaults(config)
    if Switch.enabled() then
        config.fullscreen = true
        config.vSync = true
        config.systemCursor = false
    end
    return config
end

function Switch.bindings(bindings)
    if Switch.enabled() then
        bindings.debug_menu = {"gamepad:start"}
        bindings.console = {"gamepad:back"}
    end
    return bindings
end

function Switch.update(dt)
    if not Switch.enabled() then return end
    cursor_time = math.max(0, cursor_time - dt)
    local pad = Input.connected_gamepad
    if not pad or not pad:isConnected() then return end
    local x, y = pad:getGamepadAxis("rightx"), pad:getGamepadAxis("righty")
    local length = math.sqrt(x * x + y * y)
    local deadzone = math.max(0, math.min(0.95, Kristal.Config.rightStickDeadzone or 0.2))
    if length <= deadzone then return end
    cursor_time = 2
    local magnitude = math.min(1, (length - deadzone) / (1 - deadzone))
    local speed = 600 * dt * Kristal.getGameScale()
    local mx, my = love.mouse.getPosition()
    mx = math.max(0, math.min(love.graphics.getWidth() - 1, mx + x / length * magnitude * speed))
    my = math.max(0, math.min(love.graphics.getHeight() - 1, my + y / length * magnitude * speed))
    love.mouse.setPosition(mx, my)
    Input.gamepad_cursor_x = mx / Kristal.getGameScale()
    Input.gamepad_cursor_y = my / Kristal.getGameScale()
end

function Switch.cursorVisible()
    return Switch.enabled() and cursor_time > 0
end

function Switch.pressed(pad, button)
    local mouse = mouse_buttons[button]
    if not Switch.enabled() or not mouse then return false end
    held[button] = pad
    cursor_time = 2
    local x, y = love.mouse.getPosition()
    love.mousepressed(x, y, mouse, false, 1)
    Input.active_gamepad = pad
    return true
end

function Switch.released(pad, button)
    local mouse = mouse_buttons[button]
    if not Switch.enabled() or not mouse or held[button] ~= pad then return false end
    held[button] = nil
    local x, y = love.mouse.getPosition()
    love.mousereleased(x, y, mouse, false, 1)
    return true
end

function Switch.removed(pad)
    for button, owner in pairs(held) do
        if owner == pad then Switch.released(pad, button) end
    end
end

return Switch
