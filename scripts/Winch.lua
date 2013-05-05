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
	self.WinchProactiveOn = Winch.WinchProactiveOn  ;
	self.WinchProactiveOff = Winch.WinchProactiveOff  ;
	self.Winch_Wind = Winch.Winch_Wind  ;
	self.Winch_Unwind = Winch.Winch_Unwind  ;
	self.Winch_Increase = Winch.Winch_Increase  ;
	self.Winch_Decrease = Winch.Winch_Decrease  ;
end;	
	
function Winch:delete()
end;

function Winch:mouseEvent(posX, posY, isDown, isUp, button)
end;

function Winch:keyEvent(unicode, sym, modifier, isDown)
end;

function Winch:update(dt)
	if self:getIsActiveForInput() then
		-- Winch_Proactive_On
		if InputBinding.hasEvent(InputBinding.Winch_Proactive_On) then					
			self.WinchProactiveOn();
		end;
		-- Winch_Proactive_Off
		if InputBinding.hasEvent(InputBinding.Winch_Proactive_Off) then					
			self.WinchProactiveOff();
		end;
		-- Winch_Wind
		if InputBinding.hasEvent(InputBinding.Winch_Wind) then					
			self.Winch_Wind();
		end;
		-- Winch_Unwind
		if InputBinding.hasEvent(InputBinding.Winch_Unwind) then					
			self.Winch_Unwind();
		end;
		-- Winch_Increase
		if InputBinding.hasEvent(InputBinding.Winch_Increase) then					
			self.Winch_Increase();
		end;
		-- Winch_Decrease
		if InputBinding.hasEvent(InputBinding.Winch_Decrease) then					
			self.Winch_Decrease();
		end;
		
	end;
end;

function Winch:updateTick(dt)

	
end;

function Winch:draw()
	if self:getIsActiveForInput() then
		g_currentMission:addExtraPrintText(InputBinding.getKeyNamesOfDigitalAction(InputBinding.Winch_Proactive_On).."/"..InputBinding.getKeyNamesOfDigitalAction(InputBinding.Winch_Proactive_Off)..":"..g_i18n:getText("Winch_Proactive"));
		g_currentMission:addExtraPrintText(InputBinding.getKeyNamesOfDigitalAction(InputBinding.Winch_Wind).."/"..InputBinding.getKeyNamesOfDigitalAction(InputBinding.Winch_Unwind)..":"..g_i18n:getText("Winch_Winding"));
		g_currentMission:addExtraPrintText(InputBinding.getKeyNamesOfDigitalAction(InputBinding.Winch_Increase).."/"..InputBinding.getKeyNamesOfDigitalAction(InputBinding.Winch_Decrease)..":"..g_i18n:getText("Winch_Torque"));
	end;
end;

function Winch:onAttach()
	self.doJointSearchCylindered = true;
end;

function Winch:onDetach()
	self.vehicleJoint = nil;
end;

function Winch:WinchProactiveOn()
	print("WinchProactiveOn") ; 
end;

function Winch:WinchProactiveOff()
	print("WinchProactiveOff") ; 
end;

function Winch:Winch_Wind()
	print("Winch_Wind") ; 
end;

function Winch:Winch_Unwind()
	print("Winch_Unwind") ; 
end;

function Winch:Winch_Increase()
	print("Winch_Increase") ; 
	--local Joints = self.vehicle.joints ;
	--for i,v in ipairs(Joints) do 
	--	print(i,v) 
	--end
end;

function Winch:Winch_Decrease()
	print("Winch_Decrease") ; 
end;

function Winch:onLeave()
end;

function Winch:onDeactivate()
end;

function Winch:onDeactivateSounds()
end;


