--
-- winch
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

winch = {};

function winch.prerequisitesPresent(specializations)
    return true;
end;

function winch:load(xmlFile)
	self.toggleProactive		= winch.toggleProactive;
	self.winch_Increase			= winch.winch_Increase  ;
	self.winch_Decrease			= winch.winch_Decrease  ;
	
	self.proActiveMode = false ; 
	self.tractionForce = 0 ;
	self.tractionStep = 1 ;
end;	
	
function winch:delete()
end;

function winch:mouseEvent(posX, posY, isDown, isUp, button)
end;

function winch:keyEvent(unicode, sym, modifier, isDown)
end;

function winch:update(dt)
	--if self:getIsActiveForInput() then
		-- winch_Proactive_Toggle
		if InputBinding.hasEvent(InputBinding.winch_Proactive_Toggle) then					
			self:toggleProactive(not self.proActiveMode);
		end;
		-- winch_Increase
		if InputBinding.hasEvent(InputBinding.winch_Increase) then					
			self:winch_Increase();
		end;
		-- winch_Decrease
		if InputBinding.hasEvent(InputBinding.winch_Decrease) then					
			self:winch_Decrease();
		end;
		
	--end;
end;

function winch:updateTick(dt)

	
end;

function winch:draw()
	--if self:getIsActiveForInput() then
		g_currentMission:addExtraPrintText(InputBinding.getKeyNamesOfDigitalAction(InputBinding.winch_Proactive_Toggle)..":"..g_i18n:getText("winch_Proactive_Toggle"));
		g_currentMission:addExtraPrintText(InputBinding.getKeyNamesOfDigitalAction(InputBinding.winch_Increase).." / "..InputBinding.getKeyNamesOfDigitalAction(InputBinding.winch_Decrease)..":"..g_i18n:getText("winch_Torque"));
	--end;
end;

function winch:onAttach()
	self.doJointSearchCylindered = true;
end;

function winch:onDetach()
	self.vehicleJoint = nil;
end;

function winch:toggleProactive(mode)
	self.proActiveMode = mode ; 
	print("proActivetoggled : ", tostring(mode));
end;

function winch:winch_Increase()
	if (self.tractionForce + self.tractionStep) < 46 then
		self.tractionForce = self.tractionForce + self.tractionStep 
		print("winch traction force Increased : ",tostring(self.tractionForce) ) ; 
	else 
		print("Maximum winch traction force reached");
	end;
end;

function winch:winch_Decrease()
	if self.tractionForce - self.tractionStep >= 0 then
		self.tractionForce = self.tractionForce - self.tractionStep 
		print("winch traction force Decreased : ",tostring(self.tractionForce) ) ; 
	else
		print("Minimum winch traction force reached");
	end ;
end;

function winch:onLeave()
end;

function winch:onDeactivate()
end;

function winch:onDeactivateSounds()
end;


