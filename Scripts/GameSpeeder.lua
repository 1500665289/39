print("this is GameSpeederMod")
local GameSpeederMod = GameMain:GetMod("GameSpeederMod")

function GameSpeederMod:OnRender(_)
	if self.bGameMainInit == true then
		return
	end

	local UIInfo = CS.Wnd_GameMain.Instance.UIInfo
	if UIInfo == nil then
		return
	end

	local GamePlay = CS.Wnd_GameMain.Instance.UIInfo.m_gameplay
	if GamePlay == nil then
		return
	end

	self.bGameMainInit = true
	local ElementBtn = CS.Wnd_GameMain.Instance.UIInfo.m_ShowElement
	ElementBtn.x = GamePlay.x + GamePlay.width + 25
	ElementBtn.y = GamePlay.y - 6.5
	local Speed10Btn = GamePlay:AddItemFromPool()
	Speed10Btn.name = "speed10"
	Speed10Btn.tooltips = XT("10倍速\n[keycode]SpeedP[/keycode]  降低速度\n[keycode]SpeedN[/keycode]  提升速度")
	local Speed20Btn = GamePlay:AddItemFromPool()
	Speed20Btn.name = "speed20"
	Speed20Btn.tooltips = XT("20倍速\n[keycode]SpeedP[/keycode]  降低速度\n[keycode]SpeedN[/keycode]  提升速度")
	GamePlay.onClickItem:Set(self.OnGamePlayMenuClick)
	local EventMod = GameMain:GetMod("_Event")
	EventMod:RegisterEvent(g_emEvent.GameSpeedChange, self.OnGameSpeedChange, self)
end

function GameSpeederMod:OnGameSpeedChange(_, ParamArray)
	local fGameSpeed = ParamArray[0]
	if fGameSpeed == 10 then
		CS.Wnd_GameMain.Instance.UIInfo.m_gameplay.selectedIndex = 4
	elseif fGameSpeed == 20 then
		CS.Wnd_GameMain.Instance.UIInfo.m_gameplay.selectedIndex = 5
	end
end

function GameSpeederMod.OnGamePlayMenuClick(Event)
	local PlayBtn = Event.data

	if PlayBtn.name == "fast2" then
		if InputMgr:GetInputKeyDown("SpeedN") then
			if GameSpeederMod.strLastClickBtnName == "fast2" then
				GameSpeederMod.strLastClickBtnName = "speed10"
				CS.XiaWorld.MainManager.Instance:Play(10, false)
				return
			elseif GameSpeederMod.strLastClickBtnName == "speed10" or GameSpeederMod.strLastClickBtnName == "speed20" then
				GameSpeederMod.strLastClickBtnName = "speed20"
				CS.XiaWorld.MainManager.Instance:Play(20, false)
				return
			end
		elseif InputMgr:GetInputKeyDown("SpeedP") then
			if GameSpeederMod.strLastClickBtnName == "speed20" then
				GameSpeederMod.strLastClickBtnName = "speed10"
				CS.XiaWorld.MainManager.Instance:Play(10, false)
				return
			end
		end

		GameSpeederMod.strLastClickBtnName = PlayBtn.name
		CS.XiaWorld.MainManager.Instance:Play(CS.XiaWorld.GlobleDataMgr.Instance:GetInt("MaxSpeed", 0) + 3, false)
	end

	GameSpeederMod.strLastClickBtnName = PlayBtn.name

	if PlayBtn.name == "pause" then
		if CS.XiaWorld.MainManager.Instance.Runing then
			CS.XiaWorld.MainManager.Instance:Pause(false);
		end
		return
	end

	if PlayBtn.name == "play" then
		CS.XiaWorld.MainManager.Instance:Play(1, false)
		return
	end

	if PlayBtn.name == "fast1" then
		CS.XiaWorld.MainManager.Instance:Play(2, false)
		return
	end

	if PlayBtn.name == "speed10" then
		CS.XiaWorld.MainManager.Instance:Play(10, false)
		return
	end

	if PlayBtn.name == "speed20" then
		CS.XiaWorld.MainManager.Instance:Play(20, false)
		return
	end
end
