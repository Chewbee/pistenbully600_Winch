--
-- DynamicExhaustingSystem
-- Specialization for a dynamic exhausting system
--
-- @author  	Manuel Leithner (SFM-Modding)
-- @version 	v2.0
-- @date  		15/10/10
-- @history:	v1.0 - Initial version
--				v2.0 - converted to 2011 and some bugfixes
--


DynamicExhaustingSystem = {};

function DynamicExhaustingSystem.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(Motorized, specializations);
end;

function DynamicExhaustingSystem:load(xmlFile)

	self.exhaustingSystem = {};	
	self.exhaustingSystem.cap = Utils.indexToObject(self.components, getXMLString(xmlFile, "vehicle.dynamicExhaustingSystem#cap"));
	self.exhaustingSystem.maxRot = Utils.degToRad(Utils.getNoNil(getXMLFloat(xmlFile, "vehicle.dynamicExhaustingSystem#maxRot"),0));
	self.exhaustingSystem.maxRpm = self.motor:getMaxRpm();
	
	local startSequence = AnimCurve:new(linearInterpolator4);
	local i=0;
	while true do
		local path = string.format("vehicle.dynamicExhaustingSystem.startSequence.key(%d)", i);
		local timeStamp = getXMLFloat(xmlFile, path .. "#time");
		if timeStamp == nil then
			break;
		end;
		local r,g,b,alpha = Utils.getVectorFromString(getXMLString(xmlFile, path .. "#value"));
		startSequence:addKeyframe({x=r, y=g, z=b, w=alpha, time=timeStamp})		
		i = i + 1;
	end;
	self.exhaustingSystem.minAlpha = math.min(math.abs(Utils.getNoNil(getXMLFloat(xmlFile, "vehicle.dynamicExhaustingSystem#minAlpha"),0)),1);
	self.exhaustingSystem.maxAlpha = math.min(math.abs(Utils.getNoNil(getXMLFloat(xmlFile, "vehicle.dynamicExhaustingSystem#maxAlpha"),1)),1);
	local x1,y1,z1,w1 = startSequence:get(1.0);
	self.exhaustingSystem.startSequence = startSequence;
	self.exhaustingSystem.lastValue = {x=x1,y=y1,z=z1,w=w1};
	self.exhaustingSystem.param = getXMLString(xmlFile, "vehicle.dynamicExhaustingSystem#param");
	self.exhaustingSystem.offset = 0;
	self.exhaustingSystem.deltaTime = 0;
	
end;

function DynamicExhaustingSystem:delete()
end;

function DynamicExhaustingSystem:mouseEvent(posX, posY, isDown, isUp, button)
end;

function DynamicExhaustingSystem:keyEvent(unicode, sym, modifier, isDown)
end;

function DynamicExhaustingSystem:update(dt)

	if self:getIsActive() then
		if self.exhaustingSystem.cap ~= nil then
			local angle = math.rad(math.random(-20,5)) + self.exhaustingSystem.maxRot * self.motor.lastMotorRpm / self.exhaustingSystem.maxRpm;	
			angle = math.max(math.min(angle, 0), self.exhaustingSystem.maxRot);		
			setRotation(self.exhaustingSystem.cap, 0,0,angle);
		end;
		
		if self.time <= self.playMotorSoundTime then
			local time = (self.exhaustingSystem.deltaTime - (self.playMotorSoundTime - self.time)) / self.exhaustingSystem.deltaTime;
			local x1,y1,z1,w1 = self.exhaustingSystem.startSequence:get(time);
			local values = self.exhaustingSystem.lastValue;
			if math.abs(values.x - x1) > 0.01 or math.abs(values.y - y1) > 0.01 or math.abs(values.z - z1) > 0.01 or math.abs(values.w - w1) > 0.01 then
				setShaderParameter(self.exhaustParticleSystems[1].shape, self.exhaustingSystem.param, x1, y1, z1, w1, false);
				self.exhaustingSystem.lastValue = {x=x1, y=y1, z=z1, w=w1};
			end;
		else
			local alpha = ((self.exhaustingSystem.maxAlpha-self.exhaustingSystem.minAlpha) * self.motor.lastMotorRpm / self.exhaustingSystem.maxRpm)+self.exhaustingSystem.minAlpha;
			if math.abs(self.exhaustingSystem.lastValue.w - alpha) > 0.01 then
				local values = self.exhaustingSystem.lastValue;
				setShaderParameter(self.exhaustParticleSystems[1].shape, self.exhaustingSystem.param, values.x, values.y, values.z, alpha, false);
				self.exhaustingSystem.lastValue.w = alpha;
			end;
		end;
	end;
end;

function DynamicExhaustingSystem:draw()
end;

function DynamicExhaustingSystem:startMotor()
	self.exhaustingSystem.deltaTime = self.playMotorSoundTime - self.time - self.exhaustingSystem.offset;
end;

function DynamicExhaustingSystem:onLeave()
	if self.exhaustingSystem.cap ~= nil then
		setRotation(self.exhaustingSystem.cap, 0,0,0);
	end;
end;