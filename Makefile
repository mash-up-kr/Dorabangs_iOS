MISE=$(HOME)/.local/bin/mise
TUIST=$(MISE) exec tuist -- tuist

generate:
	$(TUIST) generate

install:
	$(TUIST) install
