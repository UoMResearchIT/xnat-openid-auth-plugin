.DEFAULT_GOAL := help

IMAGE_NAME := openid-plugin-builder
CONTAINER_NAME := openid-plugin-temp
BUILD_DIR := _build

help: ## Show this help message
	@echo "MULTIX-API - Available Commands"
	@echo "================================="
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'


build: ## Build the OpenID plugin using Docker export output to build directory
	@mkdir -p $(BUILD_DIR)
	@docker buildx build --target artifact --output type=local,dest=$(BUILD_DIR) .
	@echo "Plugin built at $(CURDIR)/$(BUILD_DIR)"

rebuild: clean build ## Clean everything and build from scratch

clean: ## Remove build artifacts and docker temp resources
	rm -rf $(BUILD_DIR)