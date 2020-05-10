include("shared.lua")

if CLIENT then
	function tablelength(T)
		local count = 0

		for _ in pairs(T) do
			count = count + 1
		end

		return count
	end

	function ENT:Initialize()
		hook.Add("PlayerBindPress", "v_vulnus_ima_medkit" .. self:GetCreationTime(), function(ply, bind)
			if ply.v_vulnus_looking == self then
				if bind == "invprev" && ply.v_vulnus_selected > 1 then
					ply.v_vulnus_selected = ply.v_vulnus_selected - 0.5
				elseif bind == "invnext" && ply.v_vulnus_selected < tablelength(util.JSONToTable(self:GetContent())) then
					ply.v_vulnus_selected = ply.v_vulnus_selected + 0.5
				end

				if bind == "invprev" || bind == "invnext" then
					net.Start("v_vulnus_select")
					net.WriteFloat(ply.v_vulnus_selected)
					net.SendToServer()

					return true
				end
			end
		end)
	end

	function ENT:OnRemove()
		hook.Remove("v_vulnus_ima_medkit" .. self:GetCreationTime())
	end

	function ENT:Draw()
		self:DrawModel()
		local ply = LocalPlayer()
		local tr = ply:GetEyeTraceNoCursor()

		if tr.Entity == self then
			ply.v_vulnus_looking = tr.Entity
			local pos = self:GetPos()
			local eang = (pos - ply:GetPos()):Angle()
			eang:RotateAroundAxis(eang:Up(), -90)
			eang.r = 90
			//
			cam.Start3D2D(pos + Vector(0, 0, 20), eang, 0.15)
			draw.WordBox(2, -27, 0, self.PrintName, "ChatFont", Color(0, 0, 0, 200), Color(255, 255, 255, 255))
			//
			local unselectedColor = Color(0, 50, 0, 100)
			local selectedColor = Color(0, 150, 0, 100)
			v_vulnus_content = util.JSONToTable(self:GetContent())
			for supply, values in pairs(v_vulnus_content) do
				local isSelected = ply.v_vulnus_selected == values[2] && selectedColor || unselectedColor
				draw.WordBox(2, -50, 25 * values[2], supply .. " " .. values[1] .. "x", "ChatFont", isSelected, Color(255, 255, 255, 255))
			end

			cam.End3D2D()
		elseif tr.Entity.Category != self.Category then
			ply.v_vulnus_looking = tr.Entity
			ply.v_vulnus_selected = 1
			net.Start("v_vulnus_select")
			net.WriteFloat(ply.v_vulnus_selected)
			net.SendToServer()
		end
	end
end