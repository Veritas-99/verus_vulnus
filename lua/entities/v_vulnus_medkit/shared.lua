ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Medkit"
ENT.Spawnable = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Category = "Verus Vulnus"

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Content")

	if SERVER then
		self:SetContent(util.TableToJSON({
			Bandages = {6, 1},
			Morphine = {4, 2}
		}))
	end
end