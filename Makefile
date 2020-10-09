
QUAY_SOURCE ?= 971-setup-cfg
CONFIG_TOOL_SOURCE ?= master

clean-source:
	-rm -Rf source
	mkdir source

download: clean-source
	git clone https://github.com/thomasmckay/quay.git source/quay && \
		cd source/quay && \
		git checkout $(QUAY_SOURCE) && \
		rm -Rf .git .github
	git clone https://github.com/quay/config-tool.git source/config-tool && \
		cd source/config-tool && \
		git checkout $(CONFIG_TOOL_SOURCE) && \
		rm -Rf .git .github
