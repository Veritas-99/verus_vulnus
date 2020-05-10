AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/carlsmei/escapefromtarkov/medical/morphine.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()

	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:Use(actor, caller, useType, value)
	newHealth = actor:Health() + 50

	if newHealth > actor:GetMaxHealth() then
		actor:SetHealth(actor:GetMaxHealth())
	else
		actor:SetHealth(newHealth)
	end

	self:Remove()
end