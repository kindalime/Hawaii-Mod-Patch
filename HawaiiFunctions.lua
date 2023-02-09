--==========================================================================================================================
-- UTILITY FUNCTIONS
--==========================================================================================================================
--HasCivilizationTrait
----------------------------------------------------------------------------------------------------------------------------
function HasCivilizationTrait(civType, traitType)
	for _, row in ipairs(DB.Query("SELECT * FROM CivilizationTraits WHERE CivilizationType = '" .. civType .. "' AND TraitType = '" .. traitType .. "'")) do 
		return true
	end
	return false
end
----------------------------------------------------------------------------------------------------------------------------
--HasLeaderTrait
----------------------------------------------------------------------------------------------------------------------------
function HasLeaderTrait(leaderType, traitType)
	for _, row in ipairs(DB.Query("SELECT * FROM LeaderTraits WHERE LeaderType = '" .. leaderType .. "' AND TraitType = '" .. traitType .. "'")) do 
		return true
	end
	return false
end
--==========================================================================================================================
-- CORE FUNCTIONS
--==========================================================================================================================
local projectKapuKuialua = GameInfo.Projects["PROJECT_ENIGMA_KAPU_KUIALUA"].Index
local traitHawaii = "TRAIT_CIVILIZATION_ENIGMA_KAHUNA"
local traitKamehameha = "TRAIT_LEADER_ENIGMA_SPLINTERED_PADDLE"

local scientificTrait = "LEADER_MINOR_CIV_SCIENTIFIC"
local religiousTrait = "LEADER_MINOR_CIV_RELIGIOUS"
local economicTrait = "LEADER_MINOR_CIV_TRADE"
local culturalTrait = "LEADER_MINOR_CIV_CULTURAL"
local militaristicTrait = "LEADER_MINOR_CIV_MILITARISTIC"
local industrialTrait = "LEADER_MINOR_CIV_INDUSTRIAL"

local unitGreatPersonClassScientistID = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_SCIENTIST"].Index
local unitGreatPersonClassWriterID = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_WRITER"].Index
local unitGreatPersonClassArtistID = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_ARTIST"].Index
local unitGreatPersonClassMusicianID = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_MUSICIAN"].Index
local unitGreatPersonClassProphetID = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_PROPHET"].Index
local unitGreatPersonClassEngineerID = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_ENGINEER"].Index
local unitGreatPersonClassMerchantID = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_MERCHANT"].Index
local unitGreatPersonClassAdmiralID = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_ADMIRAL"].Index
local unitGreatPersonClassGeneralID = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_GENERAL"].Index

----------------------------------------------------------------------------------------------------------------------------
--KAHUNA
----------------------------------------------------------------------------------------------------------------------------
function Enigma_HawaiiEnvoyBonus(majorID, minorID, iAmount, suzerainID, bLeviedUnits)
	local player = Players[majorID]
	local playerConfig = PlayerConfigurations[majorID]
	local civilizationType = playerConfig:GetCivilizationTypeName()
	if (HasCivilizationTrait(civilizationType, traitHawaii)) then
		local GPPoints = ((player:GetEra()+3)*2)
		local CS = Players[minorID]
		local CSConfig = PlayerConfigurations[minorID]
		local CSType = GameInfo.Leaders[CSConfig:GetLeaderTypeName()].InheritFrom
		local cities = CS:GetCities()
		local capital = CS:GetCities():GetCapitalCity()
		local city = cities:FindID(capital)
		local X, Y = city:GetX(), city:GetY()
		if (CSType == scientificTrait) then
			player:GetGreatPeoplePoints():ChangePointsTotal(unitGreatPersonClassScientistID, GPPoints)
			if player:IsHuman() then
				Game.AddWorldViewText(majorID, Locale.Lookup("[COLOR_FLOAT_SCIENCE]+{1_Num} [ICON_GreatScientist][ENDCOLOR]", GPPoints), X, Y, 0)
			end
		end
		if (CSType == religiousTrait) then
			player:GetGreatPeoplePoints():ChangePointsTotal(unitGreatPersonClassProphetID, GPPoints)
			if player:IsHuman() then
				Game.AddWorldViewText(majorID, Locale.Lookup("[COLOR_FLOAT_FAITH]+{1_Num} [ICON_GreatProphet][ENDCOLOR]", iGPPoints), X, Y, 0)
			end
		end
		if (CSType == economicTrait) then
			player:GetGreatPeoplePoints():ChangePointsTotal(unitGreatPersonClassMerchantID, GPPoints * (2/3))
			player:GetGreatPeoplePoints():ChangePointsTotal(unitGreatPersonClassAdmiralID, GPPoints * (2/3))
			if player:IsHuman() then
				Game.AddWorldViewText(majorID, Locale.Lookup("[COLOR_FLOAT_GOLD]+{1_Num} [ICON_GreatMerchant][ENDCOLOR]", GPPoints * (2/3)), X, Y, 0)
				Game.AddWorldViewText(majorID, Locale.Lookup("[COLOR_FLOAT_GOLD]+{1_Num} [ICON_GreatMerchant][ENDCOLOR]", GPPoints * (2/3)), X, Y, 0)
			end
		end
		if (CSType == culturalTrait) then
			player:GetGreatPeoplePoints():ChangePointsTotal(unitGreatPersonClassWriterID, GPPoints * (1/2))
			player:GetGreatPeoplePoints():ChangePointsTotal(unitGreatPersonClassArtistID, GPPoints * (1/2))
			player:GetGreatPeoplePoints():ChangePointsTotal(unitGreatPersonClassMusicianID, GPPoints * (1/2))
			if player:IsHuman() then
				Game.AddWorldViewText(majorID, Locale.Lookup("[COLOR_FLOAT_CULTURE]+{1_Num} [ICON_GreatWriter][ENDCOLOR]", GPPoints * (1/2)), X, Y, 0)
				Game.AddWorldViewText(majorID, Locale.Lookup("[COLOR_FLOAT_CULTURE]+{1_Num} [ICON_GreatArtist][ENDCOLOR]", GPPoints * (1/2)), X, Y, 0)
				Game.AddWorldViewText(majorID, Locale.Lookup("[COLOR_FLOAT_CULTURE]+{1_Num} [ICON_GreatMusician][ENDCOLOR]", GPPoints * (1/2)), X, Y, 0)
			end
		end
		if (CSType == militaristicTrait) then
			player:GetGreatPeoplePoints():ChangePointsTotal(unitGreatPersonClassGeneralID, GPPoints)
			if player:IsHuman() then
				Game.AddWorldViewText(majorID, Locale.Lookup("+{1_Num} [ICON_GreatGeneral]", GPPoints), X, Y, 0)
			end
		end
		if (CSType == industrialTrait) then
			player:GetGreatPeoplePoints():ChangePointsTotal(unitGreatPersonClassEngineerID, GPPoints)
			if player:IsHuman() then
				Game.AddWorldViewText(majorID, Locale.Lookup("[COLOR_FLOAT_PRODUCTION]+{1_Num} [ICON_GreatEngineer][ENDCOLOR]", GPPoints), X, Y, 0)
			end
		end
	end
end

GameEvents.OnPlayerGaveInfluenceToken.Add(Enigma_HawaiiEnvoyBonus)
----------------------------------------------------------------------------------------------------------------------------
--KAPU KU'IALUA
----------------------------------------------------------------------------------------------------------------------------
function Enigma_Hawaii_KapuKuialuaCompleted(playerID, cityID, orderType, itemType)
	local player = Players[playerID]
	local playerConfig = PlayerConfigurations[playerID]
	local civilizationType = playerConfig:GetCivilizationTypeName()
	local city = player:GetCities():FindID(cityID)
	if (not city) then return end
	if orderType ~= 3 then return end 
	local project = GameInfo.Projects[itemType]
	if (project.Index ~= projectKapuKuialua) then return end
	local plotX, plotY = player:GetCities():GetCapitalCity():GetX(), player:GetCities():GetCapitalCity():GetY()
	local era = player:GetEras():GetEra()
	local numGPPoints = math.ceil(GameInfo.Eras[era].ChronologyIndex*3)
	local playerIsLocal = Player_IsLocalPlayer(playerID)
	local districtRadius = 1
	local plot = Map.GetPlot(plotX, plotY)
	for dx = (districtRadius * -1), districtRadius do
		for dy = (districtRadius * -1), districtRadius do
			local newPlot = Map.GetPlotXYWithRangeCheck(plot:GetX(), plot:GetY(), dx, dy, districtRadius);
			if newPlot ~= nil then
				if newPlot:GetDistrictType() == GameInfo.Districts["DISTRICT_CAMPUS"].Index then
					player:GetGreatPeoplePoints():ChangePointsTotal(unitGreatPersonClassScientistID, numGPPoints)
				elseif newPlot:GetDistrictType() == GameInfo.Districts["DISTRICT_THEATER"].Index then
					player:GetGreatPeoplePoints():ChangePointsTotal(unitGreatPersonClassWriterID, numGPPoints)
					player:GetGreatPeoplePoints():ChangePointsTotal(unitGreatPersonClassArtistID, numGPPoints)
					player:GetGreatPeoplePoints():ChangePointsTotal(unitGreatPersonClassMusicianID, numGPPoints)
				elseif newPlot:GetDistrictType() == GameInfo.Districts["DISTRICT_COMMERCIAL_HUB"].Index then
					player:GetGreatPeoplePoints():ChangePointsTotal(unitGreatPersonClassMerchantID, numGPPoints)
				elseif newPlot:GetDistrictType() == GameInfo.Districts["DISTRICT_HARBOR"].Index then
					player:GetGreatPeoplePoints():ChangePointsTotal(unitGreatPersonClassAdmiralID, numGPPoints)
				elseif newPlot:GetDistrictType() == GameInfo.Districts["DISTRICT_INDUSTRIAL_ZONE"].Index then
					player:GetGreatPeoplePoints():ChangePointsTotal(unitGreatPersonClassEngineerID, numGPPoints)
				elseif newPlot:GetDistrictType() == GameInfo.Districts["DISTRICT_ENCAMPMENT"].Index then
					player:GetGreatPeoplePoints():ChangePointsTotal(unitGreatPersonClassGeneralID, numGPPoints)
				end
			end
		end
	end
end
Events.CityProductionCompleted.Add(Enigma_Hawaii_KapuKuialuaCompleted)
----------------------------------------------------------------------------------------------------------------------------
--KAMEHAMEHA
----------------------------------------------------------------------------------------------------------------------------
function Enigma_Kamehameha_EraScoreFromGeneral(playerID, unitID, unitGreatPersonClassID, unitGreatPersonID)
    local player = Players[playerID]
	local playerConfig = PlayerConfigurations[playerID]
	local leaderType = playerConfig:GetLeaderTypeName()
	if (not HasLeaderTrait(leaderType, traitKamehameha)) then return end
	if unitGreatPersonClassID == unitGreatPersonClassGeneralID then 
		Game.ChangePlayerEraScore(playerID, 1) 
		if (not player:GetDiplomacy():IsAtWarWithHumans()) then
			Game.ChangePlayerEraScore(playerID, 1) 
			if player:IsHuman() then
				local unit = player:GetUnits():FindID(unitID)
				Game.AddWorldViewText(playerID, Locale.Lookup("[COLOR_FLOAT_GOLD]+{1_Num} [ICON_GLORY_GOLDENAGE][ENDCOLOR]"), unit:GetX(), unit:GetY(), 0)
			end
		end
	end
end
Events.UnitGreatPersonCreated.Add(Enigma_Kamehameha_EraScoreFromGeneral);