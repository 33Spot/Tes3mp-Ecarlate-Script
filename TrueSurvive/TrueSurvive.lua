--TrueSurvive.lua

--TrueSurvive v 0.0.1
--tes3mp v 0.7.0
--openmw v 0.44

--A script that simulates the primary need for survival( sleep, drink, eat)
--When the player has tired at the tier, he can not jump anymore and loses his attack maimum
--the next version will include the weather


tableHelper = require("tableHelper")
inventoryHelper = require("inventoryHelper")

local list_survive_fatigue = {"true_survive_fatigue"}
local list_survive_hunger = {"true_survive_hunger"}
local list_survive_thirsth = {"true_survive_thirsth"}


local config = {}

config.timerCheck = 60 --seconds
config.sleepTime = 30 --minutes
config.eatTime = 20 --minutes
config.drinkTime = 20 --minutes

local TrueSurvive = {}


local TimerStartStats = tes3mp.CreateTimer("StartCheckStats", time.seconds(config.timerCheck))

local listactivabledrinkingobjects = {"potion_skooma_01", "potion_local_liquor_01", "Potion_Local_Brew_01", "Potion_Cyro_Whiskey_01", "potion_cyro_brandy_01", "potion_comberry_wine_01", "potion_comberry_brandy_01", "misc_com_bottle_01", "misc_com_bottle_02", "misc_com_bottle_04", "misc_com_bottle_05", "misc_com_bottle_06", "misc_com_bottle_08", "misc_com_bottle_09", "misc_com_bottle_11", "misc_com_bottle_13", "misc_com_bottle_14", "ex_vivec_waterfall_01", "Ex_waterfall_mist_s_01" }
local listactivatablediningobjects = {"ingred_willow_anther_01", "ingred_black_anther_01", "ingred_comberry_01", "ingred_kwama_cuttle_01", "ingred_heather_01", "ingred_roobrush_01", "ingred_bc_spore_pod", "ingred_crab_meat_01", "ingred_coprinus_01", "ingred_scuttle_01", "ingred_chokeweed_01", "ingred_kresh_fiber_01", "ingred_bc_coda_flower", "ingred_scrib_jelly_01", "food_kwama_egg_02", "ingred_scathecraw_01", "ingred_bc_hypha_facia", "ingred_ash_yam_01", "ingred_gold_kanet_01", "ingred_black_lichen_01", "ingred_red_lichen_01", "ingred_green_lichen_01", "ingred_bread_01_UNI3", "ingred_bread_01", "ingred_bread_01_UNI2", "food_kwama_egg_01", "ingred_marshmerrow_01", "ingred_bittergreen_petals_01", "ingred_stoneflower_petals_01", "ingred_corkbulb_root_01", "ingred_saltrice_01", "ingred_moon_sugar_01", "ingred_hound_meat_01", "ingred_rat_meat_01", "ingred_scrib_jerky_01", "ingred_wickwheat_01"}
local listactivatablesleepingobjects = {"active_de_bed_29", "active_de_bed_30", "active_de_bedroll", "active_de_p_bed_03", "active_de_p_bed_04", "active_de_p_bed_05", "active_de_p_bed_09", "active_de_p_bed_10", "active_de_p_bed_11", "active_de_p_bed_12", "active_de_p_bed_13", "active_de_p_bed_14", "active_de_p_bed_15", "active_de_p_bed_16", "active_de_p_bed_28", "active_de_pr_bed_07", "active_de_pr_bed_08", "active_de_pr_bed_21", "active_de_pr_bed_22", "active_de_pr_bed_23", "active_de_pr_bed_24", "active_de_pr_bed_25", "active_de_pr_bed_26", "active_de_pr_bed_27", "active_de_r_bed_01", "active_de_r_bed_02", "active_de_r_bed_06", "active_de_r_bed_17", "active_de_r_bed_18", "active_de_r_bed_19", "active_de_r_bed_20"}

-- ===========
-- CHECK STATE
-- ===========

TrueSurvive.TimerStartCheck = function()
	tes3mp.StartTimer(TimerStartStats)
	tes3mp.LogAppend(enumerations.log.INFO, "....START TIMER CHECK SURVIVE....")			
end

function StartCheckStats()

	for pid, player in pairs(Players) do
		if Players[pid] ~= nil and player:IsLoggedIn() then	
			TrueSurvive.OnCheckTimePlayers(pid)
			tes3mp.LogAppend(enumerations.log.INFO, "....START CHECK TIME PLAYERS....")	
		end
	end

    tes3mp.RestartTimer(TimerStartStats, time.seconds(config.timerCheck))
    tes3mp.LogAppend(enumerations.log.INFO, "....RESTART TIMER CHECK....")
end



TrueSurvive.OnCheckTimePlayers = function(pid)

	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
	
		local SleepTime = Players[pid].data.customVariables.SleepTime
		local HungerTime = Players[pid].data.customVariables.HungerTime
		local ThirsthTime = Players[pid].data.customVariables.ThirsthTime
		
		if SleepTime ~= nil then
			SleepTime = SleepTime + 1
		else
			SleepTime = 0
		end
		
		if HungerTime ~= nil then
			HungerTime = HungerTime + 1
		else
			HungerTime = 0
		end

		if ThirsthTime ~= nil then
			ThirsthTime = ThirsthTime + 1
		else
			ThirsthTime = 0
		end
		
		Players[pid].data.customVariables.SleepTime = SleepTime	
		Players[pid].data.customVariables.HungerTime = HungerTime				
		Players[pid].data.customVariables.ThirsthTime = ThirsthTime				

		TrueSurvive.OnCheckStatePlayer(pid)
		tes3mp.LogAppend(enumerations.log.INFO, "....CHECK STATE PLAYER....")
		
	end

end

TrueSurvive.OnCheckStatePlayer = function(pid)

	local PlayerHealth = tes3mp.GetHealthCurrent(pid)
	local PlayerHealthBase = tes3mp.GetHealthBase(pid)	
	local PlayerMagicka = tes3mp.GetMagickaCurrent(pid)
	local PlayerMagickaBase = tes3mp.GetMagickaBase(pid)		
	local PlayerFatigue = tes3mp.GetFatigueCurrent(pid)
	local PlayerFatigueBase = tes3mp.GetFatigueBase(pid)
    local SleepTime = Players[pid].data.customVariables.SleepTime
    local HungerTime = Players[pid].data.customVariables.HungerTime
    local ThirsthTime = Players[pid].data.customVariables.ThirsthTime
	
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
	
		local spellid
		local spellid2
		local spellid3
		
		if SleepTime >= config.sleepTime then
		
			for slot, k in pairs(Players[pid].data.spellbook) do
				if Players[pid].data.spellbook[slot] == "true_survive_fatigue" then
					spellid = Players[pid].data.spellbook[slot]
				end
			end		
			
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_rests")
			
			if tableHelper.containsValue(list_survive_fatigue, spellid) then
			
				tes3mp.MessageBox(pid, -1, "You are tired, you should go to sleep !")
				logicHandler.RunConsoleCommandOnPlayer(pid, "FadeOut, 2")
				logicHandler.RunConsoleCommandOnPlayer(pid, "Fadein, 2")
				
			else

				tes3mp.MessageBox(pid, -1, "You are tired, you should go to sleep !")
				logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_survive_fatigue")
				logicHandler.RunConsoleCommandOnPlayer(pid, "FadeOut, 2")
				logicHandler.RunConsoleCommandOnPlayer(pid, "Fadein, 2")			

			end

		end
		
		if HungerTime >= config.eatTime then	

			for slot, k in pairs(Players[pid].data.spellbook) do
				if Players[pid].data.spellbook[slot] == "true_survive_hunger" then
					spellid2 = Players[pid].data.spellbook[slot]
				end
			end			
		
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_digestion")
			
			if tableHelper.containsValue(list_survive_hunger, spellid2) then

				tes3mp.MessageBox(pid, -1, "you are hungry, you should go eat !")
				
			else

				tes3mp.MessageBox(pid, -1, "you are hungry, you should go eat !")					
				logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_survive_hunger")

			end

		end
		
		if ThirsthTime >= config.drinkTime then

			for slot, k in pairs(Players[pid].data.spellbook) do
				if Players[pid].data.spellbook[slot] == "true_survive_thirsth" then
					spellid3 = Players[pid].data.spellbook[slot]
				end
			end	
		
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_hydrated")
			
			if tableHelper.containsValue(list_survive_thirsth, spellid3) then			
				
				tes3mp.MessageBox(pid, -1, "you are thirsty, go drink !")
				
			else				
				
				tes3mp.MessageBox(pid, -1, "you are thirsty, go drink !")
				logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_survive_thirsth")											

			end

		end			
		
		if PlayerFatigue <= (PlayerFatigueBase/3) then

			logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_attack")
			logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerJumping")
			
		else
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_survive_attack")
			logicHandler.RunConsoleCommandOnPlayer(pid, "EnablePlayerJumping")				
		end

	end
	tes3mp.RestartTimer(TimerStartStats, time.seconds(config.timerCheck))
	tes3mp.LogAppend(enumerations.log.INFO, "....RESTART TIMER CHECK....")	
end

TrueSurvive.OnActivatedObject = function(objectRefId, pid)

	
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then

		if tableHelper.containsValue(listactivabledrinkingobjects, objectRefId) then	-- drink
			Players[pid].currentCustomMenu = "survive drink"--Menu drink
			menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
			tes3mp.LogAppend(enumerations.log.INFO, objectRefId)	
			return true
		end
		
		if tableHelper.containsValue(listactivatablediningobjects, objectRefId) then	-- eat
			Players[pid].currentCustomMenu = "survive hunger"--Menu Hunger
			menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
			tes3mp.LogAppend(enumerations.log.INFO, objectRefId)
			return true
		end		
		
		if tableHelper.containsValue(listactivatablesleepingobjects, objectRefId) then -- sleep	
			Players[pid].currentCustomMenu = "survive sleep"--Menu Sleep
			menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
			tes3mp.LogAppend(enumerations.log.INFO, objectRefId)
			return true
		end	
		
	end
	return false
end

TrueSurvive.OnHungerObject = function(pid)

	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_hunger")
		logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_survive_digestion")
		Players[pid].data.customVariables.HungerTime = 0	
	end
	
end

TrueSurvive.OnDrinkObject = function(pid)

	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_thirsth")
		logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_survive_hydrated")
		Players[pid].data.customVariables.ThirsthTime = 0	
	end
	
end

TrueSurvive.OnSleepObject = function(pid)

	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		logicHandler.RunConsoleCommandOnPlayer(pid, "player->removespell true_survive_fatigue")	
		logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell true_survive_rests")
		Players[pid].data.customVariables.SleepTime = 0
	end
	
end

return TrueSurvive

---------
--SETUP--
---------

--add in Menu.lua
--[[
Menus["survive hunger"] = {
    text = color.Gold .. "Do you want\n" .. color.LightGreen ..
    "eat\n" .. color.Gold .. "this food ?\n" ..
        color.White .. "...",
    buttons = {						
        { caption = "yes",
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TrueSurvive", "OnHungerObject", 
					{menuHelper.variables.currentPid()})
                })
            }
        },			
        { caption = "no",
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
                menuHelper.effects.runGlobalFunction("logicHandler", "ActivateObjectForPlayer",
                    {
                        menuHelper.variables.currentPid(), menuHelper.variables.currentPlayerDataVariable("targetCellDescription"),
                        menuHelper.variables.currentPlayerDataVariable("targetUniqueIndex")
                    })
                })
            }
        }
    }
}

Menus["survive drink"] = {
    text = color.Gold .. "Do you want\n" .. color.LightGreen ..
    "drink\n" .. color.Gold .. "this drink ?\n" ..
        color.White .. "...",
    buttons = {						
        { caption = "yes",
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TrueSurvive", "OnDrinkObject", 
					{menuHelper.variables.currentPid()})
                })
            }
        },			
        { caption = "no",
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
                menuHelper.effects.runGlobalFunction("logicHandler", "ActivateObjectForPlayer",
                    {
                        menuHelper.variables.currentPid(), menuHelper.variables.currentPlayerDataVariable("targetCellDescription"),
                        menuHelper.variables.currentPlayerDataVariable("targetUniqueIndex")
                    })
                })
            }
        }
    }
}

Menus["survive sleep"] = {
    text = color.Gold .. "Do you want\n" .. color.LightGreen ..
    "sleep\n" .. color.Gold .. "here ?\n" ..
        color.White .. "...",
    buttons = {						
        { caption = "oui",
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TrueSurvive", "OnSleepObject", 
					{menuHelper.variables.currentPid()})
                })
            }
        },			
        { caption = "non",
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
                menuHelper.effects.runGlobalFunction("logicHandler", "ActivateObjectForPlayer",
                    {
                        menuHelper.variables.currentPid(), menuHelper.variables.currentPlayerDataVariable("targetCellDescription"),
                        menuHelper.variables.currentPlayerDataVariable("targetUniqueIndex")
                    })
                })
            }
        }
    }
}

--add in eventHandler.lua find eventHandler.OnObjectActivate = function(pid, cellDescription)

                if doesObjectHaveActivatingPlayer then
                    activatingPid = tes3mp.GetObjectActivatingPid(index)
                    
                    if isObjectPlayer then
                        Players[activatingPid].data.targetPid = objectPid
                        ActivePlayer.OnCheckStatePlayer(objectPid, activatingPid)
                    else
                        Players[activatingPid].data.targetRefId = objectRefId
                        Players[activatingPid].data.targetUniqueIndex = objectUniqueIndex
                        Players[activatingPid].data.targetCellDescription = cellDescription
                        isValid = not TrueSurvive.OnActivatedObject(objectRefId, activatingPid)                     
                    end

--add in logicHandler.lua

logicHandler.ActivateObjectForPlayer = function(pid, objectCellDescription, objectUniqueIndex)

    tes3mp.ClearObjectList()
    tes3mp.SetObjectListPid(pid)
    tes3mp.SetObjectListCell(objectCellDescription)

    local splitIndex = objectUniqueIndex:split("-")
    tes3mp.SetObjectRefNum(splitIndex[1])
    tes3mp.SetObjectMpNum(splitIndex[2])
    tes3mp.SetObjectActivatingPid(pid)

    tes3mp.AddObject()
    tes3mp.SendObjectActivate()
end
	
--add custom spell permanent records

  "permanentRecords":{
    "true_survive_digestion":{
      "name":"Digestion",
      "subtype":3,
      "cost":1,
      "flags":0,
      "effects":[{
          "id":77,
          "attribute":-1,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":1,
          "magnitudeMax":1,
          "magnitudeMin":1
        }]
    },
    "true_survive_fatigue":{
      "name":"Fatigue",
      "subtype":3,
      "cost":1,
      "flags":0,
      "effects":[{
          "id":20,
          "attribute":-1,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":1,
          "magnitudeMax":2,
          "magnitudeMin":2
        }]
    },
    "true_survive_thirsth":{
      "name":"Thirsth",
      "subtype":3,
      "cost":1,
      "flags":0,
      "effects":[{
          "id":19,
          "attribute":-1,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":1,
          "magnitudeMax":1,
          "magnitudeMin":1
        }]
    },
    "true_survive_hunger":{
      "name":"Hunger",
      "subtype":3,
      "cost":1,
      "flags":0,
      "effects":[{
          "id":20,
          "attribute":-1,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":1,
          "magnitudeMax":1,
          "magnitudeMin":1
        }]
    },
    "true_survive_hydrated":{
      "name":"Hydrated",
      "subtype":3,
      "cost":1,
      "flags":0,
      "effects":[{
          "id":76,
          "attribute":-1,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":1,
          "magnitudeMax":1,
          "magnitudeMin":1
        }]
    },
    "true_survive_attack":{
      "name":"Maximus Attack",
      "subtype":3,
      "cost":1,
      "flags":0,
      "effects":[{
          "id":117,
          "attribute":-1,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":1,
          "magnitudeMax":1000,
          "magnitudeMin":1000
        }]
    },
    "true_survive_rests":{
      "name":"Rests",
      "subtype":3,
      "cost":1,
      "flags":0,
      "effects":[{
          "id":77,
          "attribute":-1,
          "skill":-1,
          "rangeType":0,
          "area":0,
          "duration":1,
          "magnitudeMax":1,
          "magnitudeMin":1
        }]
    }
  },
  
]]--


