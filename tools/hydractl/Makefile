BINARY = hydractl
BINDIR ?= $(HOME)/.local/bin

build:
	go build -o $(BINARY) ./hydractl.go

install: build
	mkdir -p $(BINDIR)
	install -m 0755 $(BINARY) $(BINDIR)/$(BINARY)
	@echo "Installed $(BINDIR)/$(BINARY)"

clean:
	rm -f $(BINARY)