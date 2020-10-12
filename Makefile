
QUAY_SOURCE ?= 971-setup-cfg
CONFIG_TOOL_SOURCE ?= master
JWTPROXY_SOURCE ?= v0.0.4

setup:
	-mkdir source

quay-source:
	-rm -Rf source/quay
	git clone https://github.com/thomasmckay/quay.git source/quay && \
		cd source/quay && \
		git checkout $(QUAY_SOURCE) && \
		rm -Rf .git .github .gitignore
	curl -fsSL https://ip-ranges.amazonaws.com/ip-ranges.json -o source/quay/util/ipresolver/aws-ip-ranges.json
	-mkdir -p source/quay/static/webfonts
	-mkdir -p source/quay/static/fonts
	-mkdir -p source/quay/static/ldn
	cd source/quay && \
		PYTHONPATH=. python -m external_libraries

config-tool-source:
	-rm -Rf source/config-tool
	git clone https://github.com/quay/config-tool.git source/config-tool && \
		cd source/config-tool && \
		git checkout $(CONFIG_TOOL_SOURCE) && \
		rm -Rf .git .github .gitignore

jwtproxy-source:
	-rm -Rf source/jwtproxy
	git clone https://github.com/quay/jwtproxy.git source/jwtproxy && \
		cd source/jwtproxy && \
		git checkout $(JWTPROXY_SOURCE) && \
		rm -Rf .git .github .gitignore

all: setup quay-source config-tool-source jwtproxy-source
	git ls-remote
