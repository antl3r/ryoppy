local RainModule = {}
RainModule.RainBox = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UtilModule = require(ReplicatedStorage.Shared:WaitForChild("Util"))

local Player = game:GetService("Players").LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera

RainModule.LastRainBox = nil

function RainModule.RainBox:New()
    --The "Part" returned by this function is actually a proprietary object; a RainBox.
    local NewEmitterPart = UtilModule:SetInstanceProperties(Instance.new("Part"),
        {
            Name = "RainBox",
            Size = Vector3.new(20,1,20),
            Transparency = 1,
            Anchored = true,
            CanCollide = false,
        }
    )

    local NewParticleEmitter = UtilModule:SetInstanceProperties(Instance.new("ParticleEmitter"),
        {
            Name = "RainEmitter",
            Texture = "http://www.roblox.com/asset/?id=3806148993",
            Orientation = Enum.ParticleOrientation.FacingCameraWorldUp,
            EmissionDirection = Enum.NormalId.Bottom,
            Speed = NumberRange.new(150,150),
            Rate = 400,
            Lifetime = NumberRange.new(0.5,0.5),
            Enabled = true,
            Parent = NewEmitterPart
        }
    )

    local OutdoorRainSound = UtilModule:SetInstanceProperties(Instance.new("Sound"),
        {
            Name = "RainSound",
            SoundId = "rbxassetid://9112858174",
            Looped = true,
            Parent = Player.PlayerGui
        }
    )

    local IndoorRainSound = UtilModule:SetInstanceProperties(Instance.new("Sound"),
        {
            Name = "RainSound",
            SoundId = "rbxassetid://9112857056",
            Looped = true,
            Parent = Player.PlayerGui
        }
    )

    NewEmitterPart.Parent = game.Workspace

    local NewRainBox = {
        EmitterPart = NewEmitterPart, --The RainBox
        Emitter = NewParticleEmitter,
        OutdoorSound = OutdoorRainSound,
        IndoorSound = IndoorRainSound,

        RainTweenInfo = TweenInfo.new(
            1.5,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        
        EmitterTweenIndoors = function(self)
            return TweenService:Create(self.Emitter, self.RainTweenInfo, {Rate = 0})
        end,
        
        EmitterTweenOutdoors = function(self)
            return TweenService:Create(self.Emitter, self.RainTweenInfo, {Rate = 400})
        end,

        Toggle = function(self, Status)
            if(Status == true)then
                self.Emitter.Enabled = true
            else
                self.Emitter.Enabled = false
            end
        end,

        ToggleOutdoors = function(self, Outdoors)
            if(Outdoors == true)then
                self:EmitterTweenOutdoors():Play()
                self.OutdoorSound:Play()
                self.IndoorSound:Pause()
            else
                self:EmitterTweenIndoors():Play()
                self.OutdoorSound:Pause()
                self.IndoorSound:Play()
            end
        end,

        SetEmitterPartCFrame = function(self, CFrame)
            self.EmitterPart.CFrame = CFrame
        end,

        AttachToCamera = function(self)
            RunService:BindToRenderStep("UpdateRainPosition", Enum.RenderPriority.Camera.Value + 1,
            function()
                self:SetEmitterPartCFrame(CFrame.new((Camera.CFrame * CFrame.new(0,10,0)).Position))
            end)
        end,

        UnAttachFromCamera = function(self)
            RunService:UnbindFromRenderStep("UpdateRainPosition")
        end,
    }
    RainModule.LastRainBox = NewRainBox
    return NewRainBox
end

return RainModule