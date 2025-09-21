BINARY = hydractl
BINDIR ?= $(HOME)/.local/bin

build:
	go build -o $(BINARY) ./

install: build
	mkdir -p $(BINDIR)
	install -m 0755 $(BINARY) $(BINDIR)/$(BINARY)
	@echo "Installed $(BINDIR)/$(BINARY)"
	cp hydractl ~/.local/bin/

clean:
	rm -f $(BINARY)