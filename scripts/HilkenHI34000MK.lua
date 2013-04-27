--
-- HilkenHI34000MK
-- 
-- used to set 'control-variables' in cylinderd2
--
--
-- @author:		fruktor (wwww.modding-society.de)
-- @version:	v0.1
-- @date:		08/12/10
-- @history:	v0.1 - inital implementation
--
-- Copyright (C) 
--

HilkenHI34000MK = {};

function HilkenHI34000MK.prerequisitesPresent(specializations)
    return true;
end;

function HilkenHI34000MK:load(xmlFile)
	self.doJointSearchCylindered = false;
	self.origMouseControlsAxes = self.mouseControlsAxes;
	self.disaMouseControlsAxes = {};
end;	
	

function HilkenHI34000MK:delete()
end;

function HilkenHI34000MK:mouseEvent(posX, posY, isDown, isUp, button)
end;

function HilkenHI34000MK:keyEvent(unicode, sym, modifier, isDown)
end;

function HilkenHI34000MK:update(dt)
end;

function HilkenHI34000MK:updateTick(dt)

	if self.varTip ~= nil then
		if self.varTip.activeTrailerIdx ~= self.varTip.trailerNr then
			self.mouseControlsAxes = self.disaMouseControlsAxes;
			return;
		else
			self.mouseControlsAxes = self.origMouseControlsAxes;
		end;
	end;

	-- ####
	if self.doJointSearchCylindered then
		if self.attacherVehicle ~= nil then
			for k,v in pairs(self.attacherVehicle.attachedImplements) do
				if v.object == self then
					local joint = self.attacherVehicle.attacherJoints[v.jointDescIndex];
					self.vehicleJoint = joint;
					self.doJointSearchCylindered = false;
					break;
				end;
			end;
		end;
		self.doJointSearchCylindered = false;
	end;
	
	-- #### update the attacherJoint!     
    if self.vehicleJoint ~= nil then
        setJointFrame(self.vehicleJoint.jointIndex, 1, self.attacherJoint.node);
	end;
	
	-- ### update PowerShaft!
	--[[
	if self.attacherVehiclePowerShaft ~= nil then
		self.doJointSearch = true;
	end;
	]]--	
end;

function HilkenHI34000MK:draw()
end;

function HilkenHI34000MK:onAttach()
	self.doJointSearchCylindered = true;
end;

function HilkenHI34000MK:onDetach()
	self.vehicleJoint = nil;
	
	local rX, rY, rZ = getRotation( Utils.indexToObject(self.components, "0|0") );
	
	if rX > Utils.degToRad(3) then
		self.attacherJoint.jointType = Vehicle.JOINTTYPE_IMPLEMENT;
	else
		self.attacherJoint.jointType = Vehicle.JOINTTYPE_IMPLEMENT;
	end;
end;

function HilkenHI34000MK:onLeave()
end;

function HilkenHI34000MK:onDeactivate()
end;

function HilkenHI34000MK:onDeactivateSounds()
end;


