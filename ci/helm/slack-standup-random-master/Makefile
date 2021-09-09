## By default make will take your current namespace and context for namespace and values file
## If you want to override those values, pass env=<your-env>: make env=patate install
## This will use the value of "env" as the namespace and "env"."current-namespace".yaml for values file

THIS_FILE := $(lastword $(MAKEFILE_LIST))

context = $(shell kubectl config current-context)
helm_bin = $(shell command -v helm3 2> /dev/null || command -v helm)
ns = $(shell kubectl config view --minify --output 'jsonpath={..namespace}')
values_file = $(env).$(context)

ifndef env
override env = $(ns)
override values_file = $(ns).$(context)
endif

export CONTEXT=$(context)
dry-run: deps dry-run-chart
install: deps install-chart

deps:
	$(helm_bin) dep update

dry-run-chart:
	$(helm_bin) deploy --name slack-standup-random-master -n $(env) --kube-context $(context) -f values.yaml . --debug

install-chart: dry-run-chart validate-install
	$(helm_bin) deploy --name slack-standup-random-master -n $(env) --kube-context $(context) -f values.yaml . --wet

validate-install:
	@echo -n "Are you sure you want to deploy on $(env) with values file: values/$(values_file)? [y/N] " && read ans && [ $${ans:-N} = y ]

delete:
	$(helm_bin) delete slack-standup-random-master -n $(env)

validate-delete:
	@echo -n "Are you sure you want to delete release on $(env)? [y/N] " && read ans && [ $${ans:-N} = y ]

template-chart: deps
	$(helm_bin) template ./ -f values.yaml 

deprecation-test:
	@$(MAKE) --no-print-directory -f $(THIS_FILE) template-chart | docker run --rm -i eu.gcr.io/swade1987/deprek8ion:1.1.33 -