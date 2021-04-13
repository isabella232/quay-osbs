RELEASE ?= v3.4.4

setup:
	-mkdir source
	-rm -f source.sha

QUAY_SOURCE ?= redhat-3.4
quay-source:
	-rm -Rf source/quay
	git clone https://github.com/quay/quay.git source/quay && \
		cd source/quay && \
		git checkout $(QUAY_SOURCE) && \
		echo github.com/quay/quay `git rev-parse HEAD` >> ../../source.sha && \
		rm -Rf .git .github .gitignore
	curl -fsSL https://ip-ranges.amazonaws.com/ip-ranges.json -o source/quay/util/ipresolver/aws-ip-ranges.json
	-mkdir -p source/quay/static/webfonts
	-mkdir -p source/quay/static/fonts
	-mkdir -p source/quay/static/ldn
	cd source/quay && \
		PYTHONPATH=. python -m external_libraries
	echo -e "[metadata]\nname: quay\nversion: $(RELEASE)\n" > source/quay/setup.cfg

CONFIG_TOOL_SOURCE ?= redhat-3.4
config-tool-source:
	-rm -Rf source/config-tool
	git clone https://github.com/quay/config-tool.git source/config-tool && \
		cd source/config-tool && \
		git checkout $(CONFIG_TOOL_SOURCE) && \
		go mod vendor && \
		echo github.com/quay/config-tool `git rev-parse HEAD` >> ../../source.sha && \
		rm -Rf .git .github .gitignore

JWTPROXY_SOURCE ?= v0.0.4
jwtproxy-source:
	-rm -Rf source/jwtproxy
	git clone https://github.com/quay/jwtproxy.git source/jwtproxy && \
		cd source/jwtproxy && \
		git checkout $(JWTPROXY_SOURCE) && \
		go mod init github.com/quay/jwtproxy/v2 && \
		go mod vendor && \
		echo github.com/quay/jwtproxy `git rev-parse HEAD` >> ../../source.sha && \
		rm -Rf .git .github .gitignore

PUSHGATEWAY_SOURCE ?= v1.3.0
pushgateway-source:
	-rm -Rf source/pushgateway
	git clone https://github.com/prometheus/pushgateway.git source/pushgateway && \
		cd source/pushgateway && \
		git checkout $(PUSHGATEWAY_SOURCE) && \
		go mod vendor && \
		echo github.com/prometheus/pushgateay `git rev-parse HEAD` >> ../../source.sha && \
		rm -Rf .git .github .gitignore

commit:
	-git commit -a -m "updated $(RELEASE)"
	git push origin quay-3.4-rhel-8

all: setup quay-source config-tool-source jwtproxy-source pushgateway-source
	git status
	echo "Don't forget to git commit & push"
