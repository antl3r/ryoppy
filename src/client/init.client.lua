local PlayerService = game:GetService("Players")
local Camera = game.Workspace.CurrentCamera

local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local RainModule = require(Shared:WaitForChild("Rain"))

PlayerService.LocalPlayer.CharacterAdded:Connect(function(Character)
    local RainBox = RainModule.RainBox:New()
    RainBox:ToggleOutdoors(true)
    RainBox:AttachToCamera()
end)
