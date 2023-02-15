SCRATCH_ORG=test-gr01du71j1zs@example.com

push:
	sfdx force:source:push --forceoverwrite -u $(SCRATCH_ORG)

test:
	sfdx force:apex:test:run --synchronous -u $(SCRATCH_ORG)

orgdelete:
	sfdx force:org:delete -u $(SCRATCH_ORG)

orgcreate:
	sfdx force:org:create -f config/project-scratch-def.json -a $(SCRATCH_ORG) --setdefaultusername

open:
	sfdx force:org:open
