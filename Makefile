
QUAY_SOURCE ?= 971-setup-cfg
CONFIG_TOOL_SOURCE ?= master
JWTPROXY_SOURCE ?= v0.0.4

clean-source:
	-rm -Rf source
	mkdir source

download: clean-source
	git clone https://github.com/thomasmckay/quay.git source/quay && \
		cd source/quay && \
		git checkout $(QUAY_SOURCE) && \
		rm -Rf .git .github .gitignore
	git clone https://github.com/quay/config-tool.git source/config-tool && \
		cd source/config-tool && \
		git checkout $(CONFIG_TOOL_SOURCE) && \
		rm -Rf .git .github .gitignore
	git clone https://github.com/quay/jwtproxy.git source/jwtproxy && \
		cd source/jwtproxy && \
		git checkout $(JWTPROXY_SOURCE) && \
		rm -Rf .git .github .gitignore

artifacts:
	curl -fsSL https://ip-ranges.amazonaws.com/ip-ranges.json -o source/quay/util/ipresolver/aws-ip-ranges.json
	-mkdir -p source/quay/static/webfonts
	-mkdir -p source/quay/static/fonts
	-mkdir -p source/quay/static/ldn
	cd source/quay && \
		PYTHONPATH=. python -m external_libraries
