AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/carlsmei/escapefromtarkov/medical/bandage.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()

	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:Use(actor, caller, useType, value)
	if actor.v_vulnus_bleeding then
		actor:EmitSound("bandage_apply.mp3", 75, 100, 1)
		actor.v_vulnus_bleeding = false
		self:Remove()
	end
end