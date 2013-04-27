
Ressort = {};


function Ressort.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(Winch, specializations);
end;

function Ressort:load(xmlFile)
	
	self.springs = {};
	local part1 = Utils.indexToObject(self.components, getXMLString(xmlFile, "vehicle.springs#movingPart1"));
	for _, part in pairs(self.movingParts) do
		if part.node == part1 then
			self.springs.part1 = part;
			break;
		end;
	end;
	self.updateSprings = 200;
end;

function Ressort:delete()
	
end;

function Ressort:readStream(streamId, connection)
	
end;

function Ressort:writeStream(streamId, connection)
	
end;

function Ressort:mouseEvent(posX, posY, isDown, isUp, button)
end;

function Ressort:keyEvent(unicode, sym, modifier, isDown)
end;

function Ressort:update(dt)

	if self:getIsActive() then
		self.updateSprings = 200;		
	end;
	
	if self.updateSprings > 0 then
		Cylindered.updateMovingPart(self, self.springs.part1);	
		self.updateSprings = self.updateSprings - 1;
	end;
end;

function Ressort:updateTick(dt)
	
end;

function Ressort:draw()
	
end;

function Ressort:onAttach(attacherVehicle)
	
end;

function Ressort:onDetach()
	
end;



