if SERVER then
	hook.Add("EntityTakeDamage", "v_vulnus_etd_bleed", function(ent, dmgInfo)
		if IsValid(ent) && ent:IsPlayer() && dmgInfo:IsBulletDamage() then
			local rand = math.random(1, 4)

			if !ent.v_vulnus_bleeding && rand == 1 then
				ent.v_vulnus_bleeding = true
			end
		end
	end)

	hook.Add("PlayerPostThink", "v_vulnus_ppt_bleed", function(ply)
		local bleedCoolDown = ply:AccountID() && ply:AccountID() .. "vvbcd" || "vvbcd"
		local bleedEffectCoolDown = ply:AccountID() && ply:AccountID() .. "vvbecd" || "vvbecd"

		if !ply:Alive() then
			ply.v_vulnus_bleeding = false
		end

		if ply.v_vulnus_bleeding && !timer.Exists(bleedCoolDown) then
			ply:TakeDamage(1, nil, nil)
			createBleedCoolDown(bleedCoolDown)
		end

		if ply.v_vulnus_bleeding && !timer.Exists(bleedEffectCoolDown) then
			ParticleEffectAttach("blood_advisor_pierce_spray_c", PATTACH_POINT_FOLLOW, ply, ply:LookupAttachment("chest"))
			createBleedEffectCoolDown(bleedEffectCoolDown)
		end
	end)

	function createBleedCoolDown(coolDown)
		timer.Create(coolDown, 1, 1, function() end)
	end

	function createBleedEffectCoolDown(coolDown)
		timer.Create(coolDown, 2, 1, function() end)
	end
end