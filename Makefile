.DEFAULT: all

all: build_go build_node

GOPATH=         /root/go
.export GOPATH

GRAFANA=        github.com/grafana/grafana


install_go:
	pkg info -q go || pkg install -y go

build_go: install_go
	mkdir -p ${GOPATH}
	echo GOPATH is $$GOPATH
	- go get ${GRAFANA}
	( cd $$GOPATH/src/${GRAFANA} ; \
	go run build.go setup ; \
	go run build.go build \
	)

install_node:
	pkg info -q node || pkg install -y node
	pkg info -q www/npm || pkg install -y www/npm
	pkg info -q libsass || pkg install -y libsass	
	pkg info -q phantomjs || pkg install -y phantomjs	
	npm install -g yarn
	npm install -g grunt-cli

build_node: install_node
	( cd $$GOPATH/src/${GRAFANA} ; \
	npm install phantomjs-prebuilt ; \
	npm install node-sass ; \
	yarn install --pure-lockfile ; \
	grunt \
	)

# static root with js files is at : root/go/src/github.com/grafana/grafana/public
