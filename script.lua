local M = {}

-- Универсальная функция поиска элементов интерфейса
local function findChessUI(playerGui)
    -- Проверка различных вариантов интерфейса
    local uiVariants = {
        "MainMenu", "GameUI", "ChessUI", "BoardUI", "ChessBoard"
    }
    
    for _, name in ipairs(uiVariants) do
        local ui = playerGui:FindFirstChild(name)
        if ui then
            -- Поиск боковой панели в разных вариантах
            local sidePanel = ui:FindFirstChild("SideFrame") 
                or ui:FindFirstChild("MenuContainer")
                or ui:FindFirstChild("SidePanel")
                or ui:FindFirstChild("MenuFrame")
                or ui:FindFirstChild("RightPanel")
            
            if sidePanel then
                return ui, sidePanel
            end
        end
    end
    
    -- Расширенный поиск по всем элементам GUI
    for _, screenGui in ipairs(playerGui:GetChildren()) do
        if screenGui:IsA("ScreenGui") then
            -- Поиск по характерным элементам шахмат
            local timerFrame = screenGui:FindFirstChild("TimerFrame", true)
            local chessBoard = screenGui:FindFirstChild("ChessBoard", true)
            
            if timerFrame or chessBoard then
                -- Поиск подходящего контейнера для кнопки
                local possibleContainers = {
                    screenGui:FindFirstChild("SideFrame"),
                    screenGui:FindFirstChild("RightPanel"),
                    screenGui:FindFirstChild("MenuContainer"),
                    screenGui:FindFirstChild("ButtonContainer")
                }
                
                for _, container in ipairs(possibleContainers) do
                    if container then
                        return screenGui, container
                    end
                end
                
                -- Если контейнер не найден, но есть шахматная доска
                return screenGui, screenGui
            end
        end
    end
    
    return nil, nil
end

function M.init(modules)
    local config = modules.config
    local state = modules.state
    local ai = modules.ai

    -- Увеличиваем время ожидания для медленных загрузок
    task.wait(5)

    local player = game:GetService("Players").LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Универсальный поиск интерфейса
    local mainUI, sideFrame = findChessUI(playerGui)
    
    -- Если интерфейс не найден
    if not sideFrame then
        warn("Chess UI not found. Possible solutions:")
        warn("1. Join a chess game first")
        warn("2. Try again in 10 seconds")
        warn("3. Contact script support with current GUI structure")
        
        -- Автоматический перезапуск через 10 секунд
        task.wait(10)
        return M.init(modules)
    end

    -- Проверка на дубликаты
    if sideFrame:FindFirstChild("aiFrame") then
        return
    end
    
    -- Создаем фрейм для кнопки AI
    local aiFrame = Instance.new("Frame")
    aiFrame.Name = "aiFrame"
    aiFrame.Size = UDim2.new(1, 0, 0.045, 0)
    aiFrame.BackgroundColor3 = config.COLORS.off.background
    aiFrame.LayoutOrder = 99
    aiFrame.Parent = sideFrame
    
    -- ... (остальной код создания UI без изменений) ...
    
    print("[SUCCESS] AI interface injected successfully!")
end

return M
