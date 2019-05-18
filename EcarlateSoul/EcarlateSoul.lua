---------------------------
-- EcarlateSoul by Rickoff inspired by RageFire
--
--
---------------------------
jsonInterface = require("jsonInterface")

-- ===========
--MAIN CONFIG
-- ===========
-------------------------
local EcarlateSoul = {}

EcarlateSoul.OnPlayerKillCreature = function(killerPid, refId)
	
	local creatureTable = jsonInterface.load("EcarlateCreatures.json")
	local soulLoc = Players[killerPid].data.customVariables.soul
	local levelSoul = Players[killerPid].data.customVariables.levelSoul	
	local capSoul = Players[killerPid].data.customVariables.capSoul
	local pointSoul = Players[killerPid].data.customVariables.pointSoul
	
	if soulLoc == nil then
		Players[killerPid].data.customVariables.soul = 0
	end
	if levelSoul == nil then
		Players[killerPid].data.customVariables.levelSoul = 1
	end	
	if capSoul ~= nil then
		Players[killerPid].data.customVariables.capSoul = 20000
	else 
		Players[killerPid].data.customVariables.capSoul = 20000
	end	
	if pointSoul == nil then
		Players[killerPid].data.customVariables.pointSoul = 0
	end	

	local creatureRefId
	local creaturename
	local creatureSoul
	rando1 = math.random(0, 25)
	
	if levelSoul ~= nil then
		for slot, creature in pairs(creatureTable.creatures) do
			creatureRefId = creature.Refid
			if creatureRefId == refId then
				creaturename = creature.name
				creatureSoul = creature.Soul
				local totalGain = creatureSoul + rando1	
				if Players[killerPid] ~= nil then	
					if soulLoc == nil then
						Players[killerPid].data.customVariables.soul = totalGain	
					else
						Players[killerPid].data.customVariables.soul = Players[killerPid].data.customVariables.soul + totalGain
					end
					tes3mp.MessageBox(killerPid, -1, color.Default.. "Vous avez gagné : "..color.Green.. totalGain ..color.Default.. " points d'" ..color.Yellow.. "exp.")								
				end	
			end
		end
	
		if soulLoc ~= nil and capSoul ~= nil and soulLoc >= capSoul then
			Players[killerPid].data.customVariables.levelSoul = Players[killerPid].data.customVariables.levelSoul + 1
			Players[killerPid].data.customVariables.soul = 0
			Players[killerPid].data.customVariables.capSoul = 20000
			Players[killerPid].data.customVariables.pointSoul = Players[killerPid].data.customVariables.pointSoul + 5
			tes3mp.MessageBox(killerPid, -1, color.Default.. "Vous avez gagné un niveau félicitation : "..color.Green.. "/menu>joueur>compétences" ..color.Default.. " pour dépenser vos points d'" ..color.Yellow.. "exp.")		
		end	
	end
	Players[killerPid]:Save()
	Players[killerPid]:Load()	
end	 

EcarlateSoul.OnPlayerCompetence = function(Pid, Comp)

	local levelSoul = Players[Pid].data.customVariables.levelSoul	
	local LifeCount = Players[Pid].data.customVariables.life
	local PeauCount = Players[Pid].data.customVariables.peau	
	local GuexpCount = Players[Pid].data.customVariables.guexp		
	local PointCount = Players[Pid].data.customVariables.pointSoul
	local HungerCount = Players[Pid].data.customVariables.hungerCount
	local ThirstCount = Players[Pid].data.customVariables.thirstCount
	local SleepCount = Players[Pid].data.customVariables.sleepCount	
	if PointCount == nil then
		Players[Pid].data.customVariables.pointSoul = 0
		PointCount = Players[Pid].data.customVariables.pointSoul			
	end		
	if levelSoul == nil then
		Players[Pid].data.customVariables.levelSoul = 1
		levelSoul = Players[Pid].data.customVariables.levelSoul	
	elseif levelSoul ~= nil then	
		if Comp == "Guerrier" and PointCount >= 3 then
			local attrId = tes3mp.GetAttributeId("Strength")
			local attrId2 = tes3mp.GetAttributeId("Endurance")	
			local valueS = Players[Pid].data.attributes.Strength.base + 4
			local valueS2 = Players[Pid].data.attributes.Endurance.base + 4				
			tes3mp.SetAttributeBase(Pid, attrId, valueS)
			tes3mp.SetAttributeBase(Pid, attrId2, valueS2)
			if Players[Pid].data.customVariables.guerrier == nil then
				Players[Pid].data.customVariables.guerrier = 1
				Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3				
			else
				Players[Pid].data.customVariables.guerrier = Players[Pid].data.customVariables.guerrier + 1
				Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3
			end
		elseif Comp == "Guerrier" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")					
		end
		if Comp == "Voleur" and PointCount >= 3 then
			local attrId = tes3mp.GetAttributeId("Agility")
			local attrId2 = tes3mp.GetAttributeId("Speed")		
			local valueS = Players[Pid].data.attributes.Agility.base + 4
			local valueS2 = Players[Pid].data.attributes.Speed.base + 4			
			tes3mp.SetAttributeBase(Pid, attrId, valueS)
			tes3mp.SetAttributeBase(Pid, attrId2, valueS2)	
			if Players[Pid].data.customVariables.voleur == nil then			
				Players[Pid].data.customVariables.voleur = 1
				Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3
			else
				Players[Pid].data.customVariables.voleur = Players[Pid].data.customVariables.voleur + 1
				Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3
			end
		elseif Comp == "Voleur" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Mage" and PointCount >= 3 then
			local attrId = tes3mp.GetAttributeId("Intelligence")
			local attrId2 = tes3mp.GetAttributeId("Willpower")		
			local valueS = Players[Pid].data.attributes.Intelligence.base + 4
			local valueS2 = Players[Pid].data.attributes.Willpower.base + 4			
			tes3mp.SetAttributeBase(Pid, attrId, valueS)
			tes3mp.SetAttributeBase(Pid, attrId2, valueS2)	
			if Players[Pid].data.customVariables.mage == nil then				
				Players[Pid].data.customVariables.mage = 1
				Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3
			else
				Players[Pid].data.customVariables.mage = Players[Pid].data.customVariables.mage + 1
				Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3
			end
		elseif Comp == "Mage" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if HungerCount == nil then
			Players[Pid].data.customVariables.hungerCount = 0
			HungerCount = Players[Pid].data.customVariables.hungerCount			
		else
			if Comp == "Hunger" and HungerCount < 5 and PointCount >= 3 then
				Players[Pid].data.customVariables.HungerTimeMax = Players[Pid].data.customVariables.HungerTimeMax + 60
				Players[Pid].data.customVariables.hungerCount = Players[Pid].data.customVariables.hungerCount + 1
				Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3	
			elseif Comp == "Hunger" and HungerCount ~= nil and PointCount < 3 then
				tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
			end
		end
		if ThirstCount == nil then
			Players[Pid].data.customVariables.thirstCount = 0
			ThirstCount = Players[Pid].data.customVariables.thirstCount			
		else
			if Comp == "Thirst" and ThirstCount < 5 and PointCount >= 3 then
				Players[Pid].data.customVariables.ThirsthTimeMax = Players[Pid].data.customVariables.ThirsthTimeMax + 60			
				Players[Pid].data.customVariables.thirstCount = Players[Pid].data.customVariables.thirstCount + 1
				Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3	
			elseif Comp == "Thirst" and ThirstCount ~= nil and PointCount < 3 then
				tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
			end
		end
		if SleepCount == nil then
			Players[Pid].data.customVariables.sleepCount = 0
			SleepCount = Players[Pid].data.customVariables.sleepCount			
		else
			if Comp == "Sleep" and SleepCount < 5 and PointCount >= 3 then
				Players[Pid].data.customVariables.SleepTimeMax = Players[Pid].data.customVariables.SleepTimeMax + 120
				Players[Pid].data.customVariables.sleepCount = Players[Pid].data.customVariables.sleepCount + 1
				Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3	
			elseif Comp == "Sleep" and SleepCount ~= nil and PointCount < 3 then
				tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
			end
		end			
		if RoublardCount == nil then
			Players[Pid].data.customVariables.roublard = 0
			RoublardCount = Players[Pid].data.customVariables.roublard			
		else
			if Comp == "Roublard" and RoublardCount < 5 and PointCount >= 3 then
				local attrId = tes3mp.GetAttributeId("Personality")
				local attrId2 = tes3mp.GetAttributeId("Luck")		
				local valueS = Players[Pid].data.attributes.Personality.base + 4
				local valueS2 = Players[Pid].data.attributes.Luck.base + 4			
				tes3mp.SetAttributeBase(Pid, attrId, valueS)
				tes3mp.SetAttributeBase(Pid, attrId2, valueS2)		
				Players[Pid].data.customVariables.roublard = Players[Pid].data.customVariables.roublard + 1
				Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3	
			elseif Comp == "Roublard" and RoublardCount ~= nil and PointCount < 3 then
				tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
			end
		end			
		if LifeCount == nil then
			Players[Pid].data.customVariables.life = 0
			LifeCount = Players[Pid].data.customVariables.life		
		else
			if Comp == "Life" and LifeCount < 5 and PointCount >= 3 then -- guerrier
				local valueS = Players[Pid].data.stats.healthBase + 10		
				tes3mp.SetHealthBase(Pid, valueS)
				Players[Pid].data.customVariables.life = Players[Pid].data.customVariables.life + 1
				Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3	
			elseif Comp == "Life" and LifeCount ~= nil and PointCount < 3 then
				tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
			end
		end	
		if PeauCount == nil then
			Players[Pid].data.customVariables.peau = 0
			PeauCount = Players[Pid].data.customVariables.peau			
		else
			if Comp == "Peau" and PeauCount < 5 and PointCount >= 3 then	-- mage
				local valueS = Players[Pid].data.stats.magickaBase + 10	
				tes3mp.SetMagickaBase(Pid, valueS)	
				Players[Pid].data.customVariables.peau = Players[Pid].data.customVariables.peau + 1
				Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3	
			elseif Comp == "Peau" and PeauCount ~= nil and PointCount < 3 then
				tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
			end
		end	
		if GuexpCount == nil then
			Players[Pid].data.customVariables.guexp = 0
			GuexpCount = Players[Pid].data.customVariables.guexp		
		else
			if Comp == "Guexp" and GuexpCount < 5 and PointCount >= 3 then -- voleur	
				local valueS2 = Players[Pid].data.stats.fatigueBase + 10
				tes3mp.SetFatigueBase(Pid, valueS2)					
				Players[Pid].data.customVariables.guexp = Players[Pid].data.customVariables.guexp + 1
				Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3	
			elseif Comp == "Guexp" and GuexpCount ~= nil and PointCount < 3 then
				tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
			end
		end	
		if Comp == "Block" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Block")
			local valueC = Players[Pid].data.skills.Block.base + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Block" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Alchemy" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Alchemy")
			local valueC = Players[Pid].data.skills.Alchemy.base + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Alchemy" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end	
		if Comp == "Handtohand" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Handtohand")
			local valueC = Players[Pid].data.skills.Handtohand.base + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Handtohand" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Conjuration" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Conjuration")
			local valueC = Players[Pid].data.skills.Conjuration.base + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Conjuration" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Shortblade" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Shortblade")
			local valueC = Players[Pid].data.skills.Shortblade.base + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Shortblade" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Alteration" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Alteration")
			local valueC = Players[Pid].data.skills.Alteration.base + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Alteration" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Mediumarmor" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Mediumarmor")
			local valueC = Players[Pid].data.skills.Mediumarmor.base + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Mediumarmor" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Heavyarmor" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Heavyarmor")
			local valueC = Players[Pid].data.skills.Heavyarmor.base + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Heavyarmor" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Bluntweapon" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Bluntweapon")
			local valueC = Players[Pid].data.skills.Bluntweapon.base + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Bluntweapon" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Marksman" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Marksman")
			local valueC = Players[Pid].data.skills.Marksman.base + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Marksman" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Acrobatics" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Acrobatics")
			local valueC = Players[Pid].data.skills.Acrobatics.base + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Acrobatics" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Sneak" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Sneak")
			local valueC = Players[Pid].data.skills.Sneak.base + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Sneak" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Lightarmor" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Lightarmor")
			local valueC = Players[Pid].data.skills.Lightarmor.base + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Lightarmor" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Longblade" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Longblade")
			local valueC = Players[Pid].data.skills.Longblade.base + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Longblade" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Armorer" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Armorer")
			local valueC = Players[Pid].data.skills.Armorer.base + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Armorer" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Speechcraft" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Speechcraft")
			local valueC = Players[Pid].data.skills.Speechcraft.base + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Speechcraft" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Axe" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Axe")
			local valueC = Players[Pid].data.skills.Axe.base + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Axe" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Security" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Security")
			local valueC = Players[Pid].data.skills.Security.base + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Security" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Enchant" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Enchant")
			local valueC = Players[Pid].data.skills.Enchant.base + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Enchant" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Destruction" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Destruction")
			local valueC = Players[Pid].data.skills.Destruction.base + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Destruction" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Athletics" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Athletics")
			local valueC = Players[Pid].data.skills.Athletics.base + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Athletics" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Illusion" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Illusion")
			local valueC = Players[Pid].data.skills.Illusion.base + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Illusion" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Mysticism" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Mysticism")
			local valueC = Players[Pid].data.skills.Mysticism.base + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Mysticism" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Spear" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Spear")
			local valueC = Players[Pid].data.skills.Spear.base + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Spear" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Mercantile" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Mercantile")
			local valueC = Players[Pid].data.skills.Mercantile.base + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Mercantile" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Restoration" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Restoration")
			local valueC = Players[Pid].data.skills.Restoration.base + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Restoration" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end
		if Comp == "Unarmored" and PointCount >= 3 then
			local skillId = tes3mp.GetSkillId("Unarmored")
			local valueC = Players[Pid].data.skills.Unarmored.base + 10
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.pointSoul = Players[Pid].data.customVariables.pointSoul - 3		
		elseif Comp == "Unarmored" and PointCount < 3 then
			tes3mp.MessageBox(Pid, -1, color.Default.. "Vous n'avez pas assez de points de compétences, actuel : "..color.Green.. PointCount ..color.Default.. " requis : " ..color.Yellow.. "3.")								
		end	
        	Players[Pid]:SaveStatsDynamic()		
		Players[Pid]:SaveAttributes()	
		Players[Pid]:SaveSkills()			
		tes3mp.SendAttributes(Pid)
		tes3mp.SendSkills(Pid)	
		tes3mp.SendStatsDynamic(Pid)
	else
		tes3mp.MessageBox(Pid, -1, color.Default.. "Vous avez atteint le niveau maximum : "..color.Green.. "50" ..color.Default.. " en points de" ..color.Yellow.. "compétences.")		
	end
end	

EcarlateSoul.OnPlayerDeath = function(Pid)
	local soulLoc = Players[Pid].data.customVariables.soul
	local levelSoul = Players[Pid].data.customVariables.levelSoul	
	local capSoul = Players[Pid].data.customVariables.capSoul
	local pointSoul = Players[Pid].data.customVariables.pointSoul
	local totalPerte 
	if levelSoul == nil then
		Players[Pid].data.customVariables.levelSoul = 1
	end	
	if capSoul ~= nil then
		Players[Pid].data.customVariables.capSoul = 20000
	else 
		Players[Pid].data.customVariables.capSoul = 20000
	end	
	if pointSoul == nil then
		Players[Pid].data.customVariables.pointSoul = 0
	end	
	if soulLoc == nil then
		Players[Pid].data.customVariables.soul = 0	
		soulLoc = Players[Pid].data.customVariables.soul
		totalPerte = 0
	else
		totalPerte = math.floor((soulLoc * 25) / 100)	
		Players[Pid].data.customVariables.soul = Players[Pid].data.customVariables.soul - totalPerte
	end	
	tes3mp.MessageBox(Pid, -1, color.Default.. "Vous avez perdu : "..color.Green.. totalPerte ..color.Default.. " points d'" ..color.Yellow.. "exp.")		
end

return EcarlateSoul
