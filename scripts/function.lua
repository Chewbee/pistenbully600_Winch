
-- Function
Function = {};

function Function.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AnimatedVehicle, specializations);
end;

function Function:load(xmlFile)

	self.updateSendEvent = SpecializationUtil.callSpecializationsFunction("updateSendEvent");

	local deichsel = {};
    deichsel.name = getXMLString(xmlFile, "vehicle.deichsel#name");
    deichsel.openSpeedScale = Utils.getNoNil(getXMLFloat(xmlFile, "vehicle.deichsel#upSpeedScale"), 1);
    deichsel.closeSpeedScale = Utils.getNoNil(getXMLFloat(xmlFile, "vehicle.deichsel#downSpeedScale"), -deichsel.openSpeedScale);
    if deichsel.name ~= nil then
        self.deichsel = deichsel;
    end;
	self.deichsel.active = false;
	
	local klappe = {};
    klappe.name = getXMLString(xmlFile, "vehicle.klappe#name");
    klappe.openSpeedScale = Utils.getNoNil(getXMLFloat(xmlFile, "vehicle.klappe#upSpeedScale"), 1);
    klappe.closeSpeedScale = Utils.getNoNil(getXMLFloat(xmlFile, "vehicle.klappe#downSpeedScale"), -klappe.openSpeedScale);
    if klappe.name ~= nil then
        self.klappe = klappe;
    end;
	self.klappe.active = false;
	
		local stuetze = {};
    stuetze.name = getXMLString(xmlFile, "vehicle.stuetze#name");
    stuetze.openSpeedScale = Utils.getNoNil(getXMLFloat(xmlFile, "vehicle.stuetze#upSpeedScale"), 1);
    stuetze.closeSpeedScale = Utils.getNoNil(getXMLFloat(xmlFile, "vehicle.stuetze#downSpeedScale"), -stuetze.openSpeedScale);
    if stuetze.name ~= nil then
        self.stuetze = stuetze;
    end;
	self.stuetze.active = false;
	
	local i=0;
    while true do
        local key = string.format("vehicle.animations.animation(%d)", i);
        if not hasXMLProperty(xmlFile, key) then
            break;
        end;
        local name = getXMLString(xmlFile, key.."#name");
        if name ~= nil then		
			if name == "klappe" then			
				local partKey = key..string.format(".part(%d)", 0);
				local loadTime = getXMLFloat(xmlFile, partKey.."#loadTime");
				local endTime = getXMLFloat(xmlFile, partKey.."#endTime");
				
				local currentTime = self:getAnimationTime(self.klappe.name);
				local speed = 1;
				if currentTime > loadTime/endTime then
					speed = -1;
				end;
				self:playAnimation(self.klappe.name, speed, currentTime, true);
				self:setAnimationStopTime(self.klappe.name, loadTime/endTime);
				AnimatedVehicle.updateAnimations(self, 99999999);				
			end;
        end;
        i = i+1;
    end;
	
	self.jointmove = false;

	local i=0;
    while true do
        local key = string.format("vehicle.animations.animation(%d)", i);
        if not hasXMLProperty(xmlFile, key) then
            break;
        end;
        local name = getXMLString(xmlFile, key.."#name");
        if name ~= nil then		
			if name == "stuetze" then			
				local partKey = key..string.format(".part(%d)", 0);
				local loadTime = getXMLFloat(xmlFile, partKey.."#loadTime");
				local endTime = getXMLFloat(xmlFile, partKey.."#endTime");
				
				local currentTime = self:getAnimationTime(self.stuetze.name);
				local speed = 1;
				if currentTime > loadTime/endTime then
					speed = -1;
				end;
				self:playAnimation(self.stuetze.name, speed, currentTime, true);
				self:setAnimationStopTime(self.stuetze.name, loadTime/endTime);
				AnimatedVehicle.updateAnimations(self, 99999999);				
			end;
        end;
        i = i+1;
    end;
	
	self.jointmove = false;	
end;

function Function:delete()
end;

function Function:mouseEvent(posX, posY, isDown, isUp, button)
end;

function Function:keyEvent(unicode, sym, modifier, isDown)
end;

function Function:readStream(streamId, connection)
	-- update animation on synchroninzation --
	local deichselAnimTime = streamReadFloat32(streamId);
	local klappeAnimTime = streamReadFloat32(streamId);
	local stuetzeAnimTime = streamReadFloat32(streamId);
	
	if deichselAnimTime ~= nil then
		local currentTime = self:getAnimationTime(self.deichsel.name);
		local speed = 1;
		if currentTime > deichselAnimTime then
			speed = -1;
		end;
		self:playAnimation(self.deichsel.name, speed, currentTime, true);
		self:setAnimationStopTime(self.deichsel.name, deichselAnimTime);
	end;
	
	if klappeAnimTime ~= nil then
		local currentTime = self:getAnimationTime(self.klappe.name);
		local speed = 1;
		if currentTime > klappeAnimTime then
			speed = -1;
		end;
		self:playAnimation(self.klappe.name, speed, currentTime, true);
		self:setAnimationStopTime(self.klappe.name, klappeAnimTime);	
	end;
	
	if stuetzeAnimTime ~= nil then
		local currentTime = self:getAnimationTime(self.stuetze.name);
		local speed = 1;
		if currentTime > stuetzeAnimTime then
			speed = -1;
		end;
		self:playAnimation(self.stuetze.name, speed, currentTime, true);
		self:setAnimationStopTime(self.stuetze.name, stuetzeAnimTime);	
	end;
	AnimatedVehicle.updateAnimations(self, 50);		

end;

function Function:writeStream(streamId, connection)
	streamWriteFloat32(streamId, self:getAnimationTime(self.deichsel.name));
	streamWriteFloat32(streamId, self:getAnimationTime(self.klappe.name));
	streamWriteFloat32(streamId, self:getAnimationTime(self.stuetze.name));
end;

function Function:update(dt)
	
	local movejoint = self.jointmove;

	if self:getIsActiveForInput() then	
		
		local isDeichselActive = false;
		if InputBinding.isPressed(InputBinding.Chewbee_DEICHSELUP) then
			self.jointmove = true;		
			isDeichselActive = true;
			if InputBinding.hasEvent(InputBinding.Chewbee_DEICHSELUP) then
				self:playAnimation(self.deichsel.name, self.deichsel.openSpeedScale, self:getAnimationTime(self.deichsel.name)); 
			end;
		elseif InputBinding.isPressed(InputBinding.Chewbee_DEICHSELDOWN) then
			self.jointmove = true;	
			isDeichselActive = true;	
			if InputBinding.hasEvent(InputBinding.Chewbee_DEICHSELDOWN) then
				self:playAnimation(self.deichsel.name, self.deichsel.closeSpeedScale, self:getAnimationTime(self.deichsel.name)); 
			end;			
		end;
			
		if self.deichsel.active and not isDeichselActive then
			self:stopAnimation(self.deichsel.name);	
			self.jointmove = false;
		end;
		self.deichsel.active = isDeichselActive;
		
		
		local isKlappeActive = false;
		if InputBinding.isPressed(InputBinding.Chewbee_KLAPPEDOWN) then
		    self:playAnimation(self.klappe.name, self.klappe.openSpeedScale, self:getAnimationTime(self.klappe.name)); 
			isKlappeActive = true;	
			if InputBinding.hasEvent(InputBinding.Chewbee_KLAPPEDOWN) then
				self:playAnimation(self.klappe.name, self.klappe.openSpeedScale, self:getAnimationTime(self.klappe.name)); 
			end;			
		elseif InputBinding.isPressed(InputBinding.Chewbee_KLAPPEUP) then
			self:playAnimation(self.klappe.name, self.klappe.closeSpeedScale, self:getAnimationTime(self.klappe.name));
			isKlappeActive = true;
			if InputBinding.hasEvent(InputBinding.Chewbee_KLAPPEUP) then
				self:playAnimation(self.klappe.name, self.klappe.closeSpeedScale, self:getAnimationTime(self.klappe.name));
			end;
		end
		if self.klappe.active and not isKlappeActive then
      		self:stopAnimation(self.klappe.name);	
		end;
		self.klappe.active = isKlappeActive;
		
		local isstuetzeActive = false;
		if InputBinding.isPressed(InputBinding.Chewbee_DOWN) then
		    self:playAnimation(self.stuetze.name, self.stuetze.openSpeedScale, self:getAnimationTime(self.stuetze.name)); 
			isstuetzeActive = true;	
			if InputBinding.hasEvent(InputBinding.Chewbee_DOWN) then
				self:playAnimation(self.stuetze.name, self.stuetze.openSpeedScale, self:getAnimationTime(self.stuetze.name)); 
			end;			
		elseif InputBinding.isPressed(InputBinding.Chewbee_UP) then
			self:playAnimation(self.stuetze.name, self.stuetze.closeSpeedScale, self:getAnimationTime(self.stuetze.name));
			isstuetzeActive = true;
			if InputBinding.hasEvent(InputBinding.Chewbee_UP) then
				self:playAnimation(self.stuetze.name, self.stuetze.closeSpeedScale, self:getAnimationTime(self.stuetze.name));
			end;
		end
		if self.stuetze.active and not isstuetzeActive then
      		self:stopAnimation(self.stuetze.name);	
		end;
		self.stuetze.active = isstuetzeActive;
	end;
	
	if movejoint ~= self.jointmove then -- wenn geändert dann sende an server/client (minimierung der übertragungsrate) --
		self:updateSendEvent();
	end;
	
	if self:getIsActive() then
	
		if self.isServer then
			if self.attacherVehicle ~= nil and self.jointmove then
				for k, implement in pairs(self.attacherVehicle.attachedImplements) do
					local jointDesc = self.attacherVehicle.attacherJoints[implement.jointDescIndex];
					if k == self.attacherVehicle.selectedImplement  then
						setJointFrame(jointDesc.jointIndex, 1, self.attacherJoint.node);
					end;
				end;
			end;
		end;
		
	end;

end;

function Function:updateTick(dt)
	if self:getIsActive() then
		for _, part in pairs(self.movingParts) do
			part.isDirty = true;
		end;	
	end;
end;

function Function:draw()	

	g_currentMission:addExtraPrintText(InputBinding.getKeyNamesOfDigitalAction(InputBinding.Chewbee_DEICHSELUP).." / "..InputBinding.getKeyNamesOfDigitalAction(InputBinding.Chewbee_DEICHSELDOWN)..": Oberlenker vor/zur.");
	g_currentMission:addExtraPrintText(InputBinding.getKeyNamesOfDigitalAction(InputBinding.Chewbee_KLAPPEDOWN).." / "..InputBinding.getKeyNamesOfDigitalAction(InputBinding.Chewbee_KLAPPEUP)..": Haken links/rechts");
	g_currentMission:addExtraPrintText(InputBinding.getKeyNamesOfDigitalAction(InputBinding.Chewbee_DOWN).." / "..InputBinding.getKeyNamesOfDigitalAction(InputBinding.Chewbee_UP)..": Seil raus/rein");
	

end;

function Function:updateSendEvent()	

	if g_server ~= nil then
		g_server:broadcastEvent(MPEvent:new(self));
	else
		g_client:getServerConnection():sendEvent(MPEvent:new(self));
	end;

end;


