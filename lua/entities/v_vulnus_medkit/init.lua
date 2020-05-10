AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

if SERVER then
	util.AddNetworkString("v_vulnus_select")

	net.Receive("v_vulnus_select", function(len, ply)
		ply.v_vulnus_selected = net.ReadFloat()
	end)

	function ENT:Initialize()
		self:SetModel("models/carlsmei/escapefromtarkov/medical/automedkit.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetAngles(Angle(0, 0, 90))
		local phys = self:GetPhysicsObject()

		if phys:IsValid() then
			phys:Wake()
		end
	end

	function tablelength(T)
		local count = 0

		for _ in pairs(T) do
			count = count + 1
		end

		return count
	end

	function ENT:Use(actor, caller, useType, value)
		local cd = "v_vulnus_ima_medkit" .. self:GetCreationTime()

		if !timer.Exists(cd) then
			v_vulnus_content = util.JSONToTable(self:GetContent())

			for supply, values in pairs(v_vulnus_content) do
				if actor.v_vulnus_selected == values[2] then
					if supply == "Bandages" && actor.v_vulnus_bleeding then
						actor:EmitSound("bandage_apply.mp3", 75, 100, 1)
						actor.v_vulnus_bleeding = false
						v_vulnus_content[supply][1] = v_vulnus_content[supply][1] - 1

						if v_vulnus_content[supply][1] == 0 then
							v_vulnus_content[supply] = nil
						end
					elseif supply == "Morphine" then
						newHealth = actor:Health() + 50

						if newHealth > actor:GetMaxHealth() then
							actor:SetHealth(actor:GetMaxHealth())
						else
							actor:SetHealth(newHealth)
						end

						v_vulnus_content[supply][1] = v_vulnus_content[supply][1] - 1

						if v_vulnus_content[supply][1] == 0 then
							v_vulnus_content[supply] = nil
						end
					end
				end
			end

			timer.Create(cd, 1, 1, function() end)
			self:SetContent(util.TableToJSON(v_vulnus_content))

			if tablelength(v_vulnus_content) == 0 then
				self:Remove()
			end
		end
	end
end