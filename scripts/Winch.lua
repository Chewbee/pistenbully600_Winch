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
	-- the winch functions
	self.toggleProactive		= winch.toggleProactive;
	self.winch_Increase			= winch.winch_Increase  ;
	self.winch_Decrease			= winch.winch_Decrease  ;
	-- the winch variables
	self.proActiveMode = false ; 
	self.tractionForce = 0 ;
	self.tractionStep = 1 ;
	self.tipPoint = Utils.indexToObject(self.components, getXMLString(xmlFile,"vehicle.tipPoint#index"));
	self.winchBase = Utils.indexToObject(self.components, getXMLString(xmlFile,"vehicle.winchBase#index"));
	self.noPhysicWinch = false ; 
	-- the skeleton parts
	self.groomer	= self.components[1].node; 
	self.winchArm	= self.components[2].node;
	self.cable		= Utils.indexToObject(self.components, getXMLString(xmlFile,"vehicle.movingPart#index")); --self.components[3].node;
	self.hook		= self.components[4].node;
	-- the cable objet (not physics) to scale)
	cableUnit = loadI3DFile("resources/cableUnit.i3d");
end;	
	
function winch:delete()
end;

function winch:mouseEvent(posX, posY, isDown, isUp, button)
end;

function winch:keyEvent(unicode, sym, modifier, isDown)
end;

function winch:update(dt)
	if self:getIsActive() then
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
	end;
	
	--setJointFrame(self.winchArm,1, self.winchBase);
	local x,y,z = getWorldTranslation(self.winchBase);
	local a,b,c = getWorldRotation(self.winchBase);
	if self.noPhysicWinch then
		setTranslation(self.winchArm,x,y,z);
		setRotation(self.winchArm,a,b,c);
	end ; 
end;

function winch:updateTick(dt)
	-- winch:drawDebugLinefor(self.groomer, self.winchArm); 
	-- winch:drawDebugLinefor(self.winchArm, self.cable);
	-- winch:drawDebugLinefor(self.winchArm, self.tipPoint);
	-- winch:drawDebugLinefor(self.winchArm, self.hook);
	
end;

function winch:drawDebugLinefor(startComponent, endComponent)
	local x,y,z = getWorldTranslation(startComponent); 
	local dx,dy,dz = getWorldTranslation(endComponent); 
	drawDebugLine( x,y,z, 1, 0, 0, dx,dy,dz, 0, 1, 0);
end;

function winch:draw()
	g_currentMission:addHelpButtonText(g_i18n:getText("winch_Proactive_Toggle"), InputBinding.winch_Proactive_Toggle);
	--g_currentMission:addHelpButtonText(g_i18n:getText("winch_Torque"),string.format("%s / %s",InputBinding.getKeyNamesOfDigitalAction(InputBinding.winch_Increase),InputBinding.getKeyNamesOfDigitalAction(InputBinding.winch_Decrease)));
	g_currentMission:addExtraPrintText(InputBinding.getKeyNamesOfDigitalAction(InputBinding.winch_Increase).." / "..InputBinding.getKeyNamesOfDigitalAction(InputBinding.winch_Decrease)..":"..g_i18n:getText("winch_Torque").."("..self.tractionForce..")");
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
	if mode == false then 
		local gx, gy, gz, px, py, pz, cosPhi = 0,0,0,0,0,0,0 ;
		
		gx, gy, gz = localDirectionToWorld(self.groomer, 0, 0, 1);
		px, py, pz = localDirectionToWorld(self.winchArm, 0, 0, 1);
		print(string.format("Groomer   GX %.2f GY %.2f GZ%.2f %s", math.deg(gx),math.deg(gy),math.deg(gz),getRigidBodyType(self.groomer)));
		print(string.format("Winch Arm PX %.2f PY %.2f PZ%.2f %s", math.deg(px),math.deg(py),math.deg(pz),getRigidBodyType(self.winchArm)));
		cosPhi = Utils.dotProduct(gx, gy, gz, px, py, pz);
		print(string.format("Phi %f",math.deg(math.acos(cosPhi)))) ; 
		
		-- link(g_currentMission:getRootNode(), self.winchArm) ;
		setJointFrame(self.winchArm,0, self.winchBase);
		addToPhysics(self.winchArm) ;
		self.noPhysicWinch = false ; 
	else
		-- setJointFrame(self.winchArm,1, self.winchBase);
		--to remove it and place it at starup condition
		removeFromPhysics(self.winchArm); 
		self.noPhysicWinch = true ; 
		
		-- to add a force to the wincharm joint BUT at position defined by the last three digits, three first one being force vector
		-- addForce(self.winchArm, self.tractionForce, 0, 0, 0, 0.87628, 4.71148, true);
		-- addImpulse(self.winchArm, self.tractionForce, 0, 0, 0, 0.87628, 4.71148, true);
	end ; 
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

