local M = {}

function M.init(modules)
    local config = modules.config
    local state = modules.state
    local ai = modules.ai

    local aiRunning = false

    -- Добавляем задержку перед поиском интерфейса
    task.wait(3)

    local player = game:GetService("Players").LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Улучшенный поиск элементов интерфейса
    local mainMenu
    local sideFrame
    
    -- Вариант 1: Новый интерфейс (Standalone)
    if playerGui:FindFirstChild("GameUI") then
        mainMenu = playerGui.GameUI
        sideFrame = mainMenu:FindFirstChild("MenuContainer") or mainMenu:FindFirstChild("SidePanel")
    
    -- Вариант 2: Стандартный интерфейс
    else
        mainMenu = playerGui:WaitForChild("MainMenu", 5)
        sideFrame = mainMenu and (mainMenu:FindFirstChild("SideFrame") or mainMenu:FindFirstChild("MenuFrame"))
    end

    -- Если не нашли - пробуем альтернативные варианты
    if not sideFrame then
        -- Поиск по всем дочерним объектам
        for _, child in ipairs(playerGui:GetChildren()) do
            if child:IsA("ScreenGui") and child.Name == "ChessUI" then
                sideFrame = child:FindFirstChild("Sidebar")
                break
            end
        end
    end

    -- Если всё ещё не найден - ошибка
    if not sideFrame then
        warn("Chess UI elements not found. Possible causes:")
        warn("1. Game UI has been updated")
        warn("2. You're in a different game mode")
        warn("3. Slow loading (try increasing wait time)")
        return
    end

    -- Проверка дублирования
    if sideFrame:FindFirstChild("aiFrame") then
        return
    end
    sideFrame.AnchorPoint = Vector2.new(0, 0.45)

    -- Остальной код без изменений (создание фрейма, кнопки и т.д.)
    -- ... (ваш текущий код создания UI) ...

    print("[LOG]: GUI успешно загружен!")
end

return M
