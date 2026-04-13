.DEFAULT_GOAL := help

IMAGE_NAME := openid-plugin-builder
CONTAINER_NAME := openid-plugin-temp
BUILD_DIR := _build
.SILENT:

help: ## Show this help message
	@echo "MULTIX-API - Available Commands"
	@echo "================================="
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'


build: ## Build the OpenID plugin using Docker export output to build directory
	@mkdir -p $(BUILD_DIR)
	@docker buildx build --target artifact --output type=local,dest=$(BUILD_DIR) .
	@echo "OK: Build complete. Plugin artifact is in $(BUILD_DIR)"
	
	@SITE_URL=http://xnat1.localtest.me:8080 $(MAKE) -C oidc-providers build
	@cp oidc-providers/_build/google-provider.properties $(BUILD_DIR)/xnat1-google-provider.properties
	@SITE_URL=http://xnat2.localtest.me:8081 $(MAKE) -C oidc-providers build
	@cp oidc-providers/_build/google-provider.properties $(BUILD_DIR)/xnat2-google-provider.properties

rebuild: clean build ## Clean everything and build from scratch

clean: ## Remove build artifacts and docker temp resources
	@rm -rf $(BUILD_DIR)
	@$(MAKE) -C oidc-providers clean
