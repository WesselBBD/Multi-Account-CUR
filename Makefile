MEMBERPROFILES=./memberprofiles.yaml
LOGPROFILE=./logprofile.yaml
GENERALCONFIG=./generalconfig.yaml

build: clean
	@gomplate --config ./.gomplate.yaml
	@terraform fmt ./output > /dev/null

clean:
	@cp ./output/terraform.tfstate ./backup.tfstate
	@find ./output -maxdepth 1 -name '*.tfvars' -delete -name '*.tf' -delete


run:
	@cd ./output && \
	  terraform init && \
	  terraform apply -var-file="values.tfvars"
	
init:
	@mkdir ./output
	@yq -n '.memberprofiles[0] ="memberacount1" | .memberprofiles[1] = "memberacount2" ' > $(MEMBERPROFILES)
	@yq -n '.profile = "logprofile" | .accountid[1] = "000000000000"' > $(LOGPROFILE)
	@yq -n '.createdByTag = "someone" | region = "eu-west-1" | logBucket = "cur-central-1234" | spillBucket = "athena-spill-1234" | curMemberPostfix = "-1234"' > $(GENERALCONFIG)