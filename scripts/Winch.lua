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
	self.winchProactiveOn	= winch.winchProactiveOn  ;
	self.winchProactiveOff	= winch.winchProactiveOff  ;
	self.winch_Wind			= winch.winch_Wind  ;
	self.winch_Unwind		= winch.winch_Unwind  ;
	self.winch_Increase		= winch.winch_Increase  ;
	self.winch_Decrease		= winch.winch_Decrease  ;
end;	
	
function winch:delete()
end;

function winch:mouseEvent(posX, posY, isDown, isUp, button)
end;

function winch:keyEvent(unicode, sym, modifier, isDown)
end;

function winch:update(dt)
	if self:getIsActiveForInput() then
		-- winch_Proactive_On
		if InputBinding.hasEvent(InputBinding.winch_Proactive_On) then					
			self:winchProactiveOn();
		end;
		-- winch_Proactive_Off
		if InputBinding.hasEvent(InputBinding.winch_Proactive_Off) then					
			self:winchProactiveOff();
		end;
		-- winch_Wind
		if InputBinding.hasEvent(InputBinding.winch_Wind) then					
			self:winch_Wind();
		end;
		-- winch_Unwind
		if InputBinding.hasEvent(InputBinding.winch_Unwind) then					
			self:winch_Unwind();
		end;
		-- winch_Increase
		if InputBinding.hasEvent(InputBinding.winch_Increase) then					
			self:winch_Increase();
		end;
		-- winch_Decrease
		if InputBinding.hasEvent(InputBinding.winch_Decrease) then					
			self:winch_Decrease();
		end;
		
	end;
end;

function winch:updateTick(dt)

	
end;

function winch:draw()
	if self:getIsActiveForInput() then
		g_currentMission:addExtraPrintText(InputBinding.getKeyNamesOfDigitalAction(InputBinding.winch_Proactive_On).." / "..InputBinding.getKeyNamesOfDigitalAction(InputBinding.winch_Proactive_Off)..":"..g_i18n:getText("winch_Proactive"));
		g_currentMission:addExtraPrintText(InputBinding.getKeyNamesOfDigitalAction(InputBinding.winch_Wind).." / "..InputBinding.getKeyNamesOfDigitalAction(InputBinding.winch_Unwind)..":"..g_i18n:getText("winch_Winding"));
		g_currentMission:addExtraPrintText(InputBinding.getKeyNamesOfDigitalAction(InputBinding.winch_Increase).." / "..InputBinding.getKeyNamesOfDigitalAction(InputBinding.winch_Decrease)..":"..g_i18n:getText("winch_Torque"));
	end;
end;

function winch:onAttach()
	self.doJointSearchCylindered = true;
end;

function winch:onDetach()
	self.vehicleJoint = nil;
end;

function winch:winchProactiveOn()
	print("winchProactiveOn") ; 
end;

function winch:winchProactiveOff()
	print("winchProactiveOff") ; 
	if self.vehicle ~= nil then
		self.vehicle:setBeaconLightsVisibility(not self.vehicle.beaconLightsActive);
	else
		print("self.vehicle is NIL");
	end;
end;

function winch:winch_Wind()
	print("winch_Wind") ; 
end;

function winch:winch_Unwind()
	print("winch_Unwind") ; 
end;

function winch:winch_Increase()
	print("winch_Increase") ; 
	if self.vehicle ~= nil then
		for i,v in ipairs(self.vehicle.joints) do 
			print(i,v) 
		end
	else
		print("self.vehicle is NIL");
	end ;
end;

function winch:winch_Decrease()
	print("winch_Decrease") ; 
end;

function winch:onLeave()
end;

function winch:onDeactivate()
end;

function winch:onDeactivateSounds()
end;


