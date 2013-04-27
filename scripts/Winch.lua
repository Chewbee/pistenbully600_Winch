--
-- Winch
-- 
-- 
--
--
-- @author:		Chewbee
-- @version:	v0.1
-- @date:		25/4/2013
-- @history:	v0.1 - inital implementation
--
-- Copyright (C) 
--

Winch = {};

function Winch.prerequisitesPresent(specializations)
    return true;
end;

function Winch:load(xmlFile)
	
end;	
	

function Winch:delete()
end;

function Winch:mouseEvent(posX, posY, isDown, isUp, button)
end;

function Winch:keyEvent(unicode, sym, modifier, isDown)
end;

function Winch:update(dt)
end;

function Winch:updateTick(dt)

	
end;

function Winch:draw()
	if self.isUsed then
		g_currentMission:addExtraPrintText(InputBinding.getKeyNamesOfDigitalAction(InputBinding.Winch_Proactive_On).." / "..InputBinding.getKeyNamesOfDigitalAction(InputBinding.Winch_Proactive_Off)..g_i18n:getText("Winch_Proactive"));
		g_currentMission:addExtraPrintText(InputBinding.getKeyNamesOfDigitalAction(InputBinding.Winch_Wind).." / "..InputBinding.getKeyNamesOfDigitalAction(InputBinding.Winch_Unwind)..g_i18n:getText("Winch_Winding"));
		g_currentMission:addExtraPrintText(InputBinding.getKeyNamesOfDigitalAction(InputBinding.Winch_Increase).." / "..InputBinding.getKeyNamesOfDigitalAction(InputBinding.Winch_Decrease)..g_i18n:getText("Winch_Torque"));
	end;
end;

function Winch:onAttach()
	self.doJointSearchCylindered = true;
end;

function Winch:onDetach()
	self.vehicleJoint = nil;
end;

function Winch:onLeave()
end;

function Winch:onDeactivate()
end;

function Winch:onDeactivateSounds()
end;


