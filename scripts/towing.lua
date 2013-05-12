--
-- towing
-- Specialization for towing mod
--
-- @author  Stefan Geiger  / Chewbee just translated that in English 
-- @date  10/01/09
--
-- Copyright (C) GIANTS Software GmbH, Confidential, All Rights Reserved.

towing = {};

function towing.prerequisitesPresent(specializations)
    return true;
	-- No prerequisites
end;
function towing:load(xmlFile)
	self.detachObject = towing.detachObject;
	self.attachObject = towing.attachObject;
	self.attachPoint = Utils.indexToObject(self.components, getXMLString(xmlFile,"vehicle.attacherPoint#index"));
	self.attachPointColli = Utils.indexToObject(self.components, getXMLString(xmlFile,"vehicle.attacherPoint#rootNode"));
	self.isUsed = false;
	self.Joint = {};
	self.lastVehicle = nil;
end;
function towing:delete()
   
end;
function towing:mouseEvent(posX, posY, isDown, isUp, button)
end;
function towing:keyEvent(unicode, sym, modifier, isDown)
end;
function towing:readStream(streamId, connection)
	local isUsed = streamReadBool(streamId);
	if isUsed then
		local jointId = streamReadInt32(streamId);
		local vehicleId = streamReadInt32(streamId);
		
		vehicleId = networkGetObject(vehicleId);
		self:attachObject(vehicleId,jointId,true);
	end;
end;
function towing:writeStream(streamId, connection)
	streamWriteBool(streamId, self.isUsed);
	if self.isUsed then
		streamWriteInt32(streamId, self.Joint.attacherJointId);
		streamWriteInt32(streamId, networkGetObjectId(self.Joint.vehicle));
	end;
end;
function towing:update(dt)
	if self.lastVehicle ~= nil then 
		if not self.isUsed then
			if InputBinding.hasEvent(InputBinding.TOWING_AttachObject) then					
				self:attachObject(self.lastVehicle[1],self.lastVehicle[2],nil);
			end;
		end;
	else
		if self.isUsed then
			if InputBinding.hasEvent(InputBinding.TOWING_AttachObject) then	
				self:detachObject();
			end;
		end;
	end;
end;
function towing:updateTick(dt)
	if not self.isUsed then
		self.lastVehicle = nil;
		local x,y,z = getWorldTranslation(self.attachPoint);
		-- boucle sur les vehicules à etendre afin de pouvoir detecter autre chose
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
					-- le commentaire ci dessous vient du fichier original de S Geiger 
					--self.lastVehicle[2] = v.attacherJoint;
					self.lastVehicle[2] = 0;
					break;
				end;
			end;
		end;
	end;
end;
function towing:attachObject(vehicleId,jointId,noEventSend,vehicle)
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
			-- le commentaire ci dessous vient du fichier original de S Geiger
			--constr:setRotationLimit(i-1,0,0);
		end;
		joint.index = constr:finalize();
		if not self.Joint.vehicle.isControlled and self.Joint.vehicle.motor ~= nil and self.Joint.vehicle.wheels~= nil then
			for k,wheel in pairs(vehicleId.wheels) do
				-- le commentaire ci dessous vient du fichier original de S Geiger
				--setWheelShapeProps(wheel.node, wheel.wheelShape, 0, vehicleId.motor.brakeForce, 0);
				setWheelShapeProps(wheel.node, wheel.wheelShape, 0, 0, 0);
			end;
		end;
	end;
	self.isUsed = true;
	self.lastVehicle = nil;
end;
function towing:detachObject(noEventSend)
	setDetachEvent.sendEvent(self,noEventSend);
	if self.isServer then
		removeJoint(self.Joint.index);	
		if not self.Joint.vehicle.isControlled and self.Joint.vehicle.motor ~= nil and self.Joint.vehicle.wheels~= nil then
			for k,wheel in pairs(self.Joint.vehicle.wheels) do
				setWheelShapeProps(wheel.node, wheel.wheelShape, 0, self.Joint.vehicle.motor.brakeForce, 0);
				-- le commentaire ci dessous vient du fichier original de S Geiger
				--setWheelShapeProps(wheel.node, wheel.wheelShape, 0, 0, 0);
			end;
		end;
	end;
	self.Joint = nil;
	self.Joint = {};
	self.isUsed = false;
end;
function towing:draw()
	if self.lastVehicle ~= nil then
		g_currentMission:addHelpButtonText(g_i18n:getText("TOWING_AttachObject"), InputBinding.TOWING_AttachObject);
	elseif self.lastVehicle == nil and self.isUsed then
		g_currentMission:addHelpButtonText(g_i18n:getText("TOWING_DetachObject"), InputBinding.TOWING_AttachObject);
	end;
end;
