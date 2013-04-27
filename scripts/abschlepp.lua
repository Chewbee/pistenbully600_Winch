--
-- abschlepp
-- Specialization for abschlepp mod
--
-- @author  Stefan Geiger
-- @date  10/01/09
--
-- Copyright (C) GIANTS Software GmbH, Confidential, All Rights Reserved.

abschlepp = {};

function abschlepp.prerequisitesPresent(specializations)
    return true;
end;
function abschlepp:load(xmlFile)
	self.detachObject = abschlepp.detachObject;
	self.attachObject = abschlepp.attachObject;
	self.attachPoint = Utils.indexToObject(self.components, getXMLString(xmlFile,"vehicle.attacherPoint#index"));
	self.attachPointColli = Utils.indexToObject(self.components, getXMLString(xmlFile,"vehicle.attacherPoint#rootNode"));
	self.isUsed = false;
	self.Joint = {};
	self.lastVehicle = nil;
end;
function abschlepp:delete()
   
end;
function abschlepp:mouseEvent(posX, posY, isDown, isUp, button)
end;
function abschlepp:keyEvent(unicode, sym, modifier, isDown)
end;
function abschlepp:readStream(streamId, connection)
	local isUsed = streamReadBool(streamId);
	if isUsed then
		local jointId = streamReadInt32(streamId);
		local vehicleId = streamReadInt32(streamId);
		
		vehicleId = networkGetObject(vehicleId);
		self:attachObject(vehicleId,jointId,true);
	end;
end;
function abschlepp:writeStream(streamId, connection)
	streamWriteBool(streamId, self.isUsed);
	if self.isUsed then
		streamWriteInt32(streamId, self.Joint.attacherJointId);
		streamWriteInt32(streamId, networkGetObjectId(self.Joint.vehicle));
	end;
end;
function abschlepp:update(dt)
	if self:getIsActiveForInput() then
		if self.lastVehicle ~= nil then 
			if not self.isUsed then
				if InputBinding.hasEvent(InputBinding.ABSCHLEPPSTANGE_ATTACH) then					
					self:attachObject(self.lastVehicle[1],self.lastVehicle[2],nil);
				end;
			end;
		else
			if self.isUsed then
				if InputBinding.hasEvent(InputBinding.ABSCHLEPPSTANGE_ATTACH) then	
					self:detachObject();
				end;
			end;
		end;
	end;
end;
function abschlepp:updateTick(dt)
	if self:getIsActiveForInput() then
		if not self.isUsed then
			self.lastVehicle = nil;
			local x,y,z = getWorldTranslation(self.attachPoint);
			for k,v in pairs(g_currentMission.vehicles) do
				for index,joint in pairs(v.attacherJoints) do
					local x1,y1,z1 = getWorldTranslation(joint.jointTransform);
					local distance = Utils.vector3Length(x-x1,y-y1,z-z1);
					if distance <= 1.5 then						
						self.lastVehicle = {};
						self.lastVehicle[1] = v;
						self.lastVehicle[2] = index;
						break;
					end;
				end;
				if v.attacherJoint ~= nil and self.lastVehicle == nil then
					local x1,y1,z1 = getWorldTranslation(v.attacherJoint.node);
					local distance = Utils.vector3Length(x-x1,y-y1,z-z1);
					if distance <= 1.5 then						
						self.lastVehicle = {};
						self.lastVehicle[1] = v;
						--self.lastVehicle[2] = v.attacherJoint;
						self.lastVehicle[2] = 0;
						break;
					end;
				end;
			end;
		end;
	end;
end;
function abschlepp:attachObject(vehicleId,jointId,noEventSend,vehicle)
	setAttachEvent.sendEvent(self,vehicleId,jointId,noEventSend);
	local joint = self.Joint;
	joint.vehicle = vehicleId;
	local jointFA = nil;
	if jointId == 0 then
		jointFA = vehicleId.attacherJoint;
	else
		jointFA = vehicleId.attacherJoints[jointId];
	end;
	
	if vehicleId.isBroken == true then
		vehicleId.isBroken = false;
	end;
	if self.isServer then
		local colli = jointFA.rootNode; 
		local colli2 = self.attachPointColli;
		local jointTransform = Utils.getNoNil(jointFA.jointTransform, jointFA.node);
		local jointTransform2 = self.attachPoint;
	
		local constr = JointConstructor:new();					
		constr:setActors(colli2, colli);
		constr:setJointTransforms(jointTransform2,  jointTransform);
		for i=1, 3 do
			constr:setTranslationLimit(i-1, true, 0, 0);
			--constr:setRotationLimit(i-1,0,0);
		end;
		joint.index = constr:finalize();
		if not self.Joint.vehicle.isControlled and self.Joint.vehicle.motor ~= nil and self.Joint.vehicle.wheels~= nil then
			for k,wheel in pairs(vehicleId.wheels) do
				--setWheelShapeProps(wheel.node, wheel.wheelShape, 0, vehicleId.motor.brakeForce, 0);
				setWheelShapeProps(wheel.node, wheel.wheelShape, 0, 0, 0);
			end;
		end;
	end;
	self.isUsed = true;
	self.lastVehicle = nil;
end;
function abschlepp:detachObject(noEventSend)
	setDetachEvent.sendEvent(self,noEventSend);
	if self.isServer then
		removeJoint(self.Joint.index);	
		if not self.Joint.vehicle.isControlled and self.Joint.vehicle.motor ~= nil and self.Joint.vehicle.wheels~= nil then
			for k,wheel in pairs(self.Joint.vehicle.wheels) do
				setWheelShapeProps(wheel.node, wheel.wheelShape, 0, self.Joint.vehicle.motor.brakeForce, 0);
				--setWheelShapeProps(wheel.node, wheel.wheelShape, 0, 0, 0);
			end;
		end;
	end;
	self.Joint = nil;
	self.Joint = {};
	self.isUsed = false;
end;
function abschlepp:draw()
	if self.lastVehicle ~= nil then
		g_currentMission:addHelpButtonText(g_i18n:getText("ABSCHLEPPSTANGE_AttachObject"), InputBinding.ABSCHLEPPSTANGE_ATTACH);
	elseif self.lastVehicle == nil and self.isUsed then
		g_currentMission:addHelpButtonText(g_i18n:getText("ABSCHLEPPSTANGE_DetachObject"), InputBinding.ABSCHLEPPSTANGE_ATTACH);
	end;
end;
