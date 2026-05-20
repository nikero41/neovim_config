.PHONY: all
all: format lint

.PHONY: install
install:
	@echo "Installing dependencies..."
	@brew bundle

.PHONY: lint
lint:
	@echo "Running lint checks..."
	@selene .

.PHONY: check-format
check-format:
	@echo "Check if code needs formatting..."
	@stylua --check .

.PHONY: format
format:
	@echo "Formatting code..."
	@stylua .
