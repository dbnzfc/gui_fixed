local M = {}

function M.init(modules)
    local config = modules.config
    local state = modules.state
    local ai = modules.ai

    -- Увеличиваем время ожидания до 15 секунд
    print("Ожидание загрузки интерфейса...")
    task.wait(15)

    local player = game:GetService("Players").LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Специальная функция для поиска шахматного интерфейса
    local function findChessBoard()
        -- Вариант 1: Поиск по характерным элементам
        local chessMarkers = {
            "ChessBoard", "Board", "GameBoard", "TimerFrame",
            "CapturedPieces", "PromotionFrame", "GameResult"
        }
        
        for _, marker in ipairs(chessMarkers) do
            local found = playerGui:FindFirstChild(marker, true)
            if found then
                print("Найден маркер шахмат:", marker)
                return found.Parent
            end
        end
        
        -- Вариант 2: Поиск по всем ScreenGui
        for _, screenGui in ipairs(playerGui:GetChildren()) do
            if screenGui:IsA("ScreenGui") then
                for _, child in ipairs(screenGui:GetDescendants()) do
                    if child:IsA("TextLabel") and child.Text:match("шахмат") then
                        print("Найден текстовый элемент:", child.Text)
                        return screenGui
                    end
                end
            end
        end
        
        return nil
    end

    -- Поиск интерфейса
    local chessUI = findChessBoard()
    
    if not chessUI then
        -- Расширенная диагностика
        print("=== ДИАГНОСТИКА ИНТЕРФЕЙСА ===")
        print("PlayerGui содержит:")
        for _, child in ipairs(playerGui:GetChildren()) do
            print("- "..child.Name.." ("..child.ClassName..")")
            if child:IsA("ScreenGui") then
                print("  Элементы:")
                for _, elem in ipairs(child:GetChildren()) do
                    print("  - "..elem.Name)
                end
            end
        end
        
        warn("Шахматный интерфейс не найден. Запустите скрипт ПОСЛЕ начала игры!")
        return
    end

    -- Автоматическое определение контейнера
    local container = chessUI:FindFirstChild("SideFrame") 
        or chessUI:FindFirstChild("MenuContainer")
        or chessUI:FindFirstChild("RightPanel")
        or chessUI:FindFirstChild("ButtonFrame")
        or chessUI -- Используем сам UI как контейнер
    
    -- Проверка на дубликаты
    if container:FindFirstChild("aiFrame") then
        return
    end
    
    -- Создаем фрейм для кнопки AI
    local aiFrame = Instance.new("Frame")
    aiFrame.Name = "aiFrame"
    aiFrame.Size = UDim2.new(0.2, 0, 0.05, 0)
    aiFrame.Position = UDim2.new(0.78, 0, 0.02, 0) -- Позиция в правом верхнем углу
    aiFrame.BackgroundColor3 = config.COLORS.off.background
    aiFrame.ZIndex = 100
    aiFrame.Parent = container
    
    -- ... (остальной код создания кнопки) ...
    
    print("Интерфейс AI успешно добавлен!")
end

return M
