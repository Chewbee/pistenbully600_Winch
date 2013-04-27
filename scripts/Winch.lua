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
	g_currentMission:addExtraPrintText(InputBinding.getKeyNamesOfDigitalAction(InputBinding.Chewbee_AUTOORIENT_ON).." / "..InputBinding.getKeyNamesOfDigitalAction(InputBinding.Chewbee_AUTOORIENT_OFF));
	g_currentMission:addExtraPrintText(InputBinding.getKeyNamesOfDigitalAction(InputBinding.Chewbee_WIND).." / "..InputBinding.getKeyNamesOfDigitalAction(InputBinding.Chewbee_UNWIND));
	g_currentMission:addExtraPrintText(InputBinding.getKeyNamesOfDigitalAction(InputBinding.Chewbee_INCREASE).." / "..InputBinding.getKeyNamesOfDigitalAction(InputBinding.Chewbee_DECREASE));
	
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


