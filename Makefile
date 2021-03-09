# TODO: obsolete all this! https://projects.engineering.redhat.com/browse/CLOUDBLD-2838
RELEASE ?= v3.5.0-tomckay

setup:
	-mkdir source
	-rm -f source.sha

QUAY_SOURCE ?= master
quay-source:
	-rm -Rf source/quay
	git clone https://github.com/quay/quay.git source/quay && \
		cd source/quay && \
		git checkout $(QUAY_SOURCE) && \
		echo github.com/quay/quay `git rev-parse HEAD` >> ../../source.sha && \
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" && \
		git cherry-pick -x 6045964aaaca449fbdf3de3048b8dcb6d2ff8ea4 && \
		git cherry-pick -x d4f7c7318aa24d8b177d5d0ca3a93ae4ff9ca074 && \
		git cherry-pick -x 4c8d849050646ce3f9e38f002f16f2fed87498c8 && \
		git cherry-pick -x 8fe8582c533d3a1b3c4aaf4d35fb11f22ac01f1b && \
		echo "!!!!!!!!!!! rm -Rf .git .github .gitignore !!!!!!!!!!" && \
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	curl -fsSL https://ip-ranges.amazonaws.com/ip-ranges.json -o source/quay/util/ipresolver/aws-ip-ranges.json
	-mkdir -p source/quay/static/webfonts
	-mkdir -p source/quay/static/fonts
	-mkdir -p source/quay/static/ldn
	cd source/quay && \
		PYTHONPATH=. python -m external_libraries
	echo -e "[metadata]\nname: quay\nversion: $(RELEASE)\n" > source/quay/setup.cfg

quay-clear-git:
	cd source/quay && \
		rm -Rf .git .github .gitignore

CONFIG_TOOL_SOURCE ?= master
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
	-git commit -a -m "updated"
	git push origin private-tomckay-quay-3.5-rhel-8

all: setup quay-source config-tool-source jwtproxy-source pushgateway-source
	sed -i "s/### master/### v3.5.0-preview-`git rev-parse --short HEAD`/" source/quay/CHANGELOG.md
	git status
	echo "Don't forget to git commit & push"
