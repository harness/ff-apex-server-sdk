#!/bin/bash
sfdx auth:web:login -d -a DevHub
sfdx force:org:create -f config/project-scratch-def.json -a MyScratchOrg --setdefaultusername -u chris.barbour@hexlabs.io
sfdx force:org:open