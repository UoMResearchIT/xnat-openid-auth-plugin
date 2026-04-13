OUT_DIR  := _build
SECRET_FILE := .secret

GOOGLE_PROP_SRC_FILE := google-template-provider.properties
GOOGLE_PROP_OUT_FILE := $(OUT_DIR)/google-provider.properties

# allow auto-create .secret if missing
-include $(SECRET_FILE)

export SITE_URL GOOGLE_CLIENT_ID GOOGLE_CLIENT_SECRET

.PHONY: build_google clean check FORCE
.SILENT:
build: build_google

clean:
	@rm -rf $(OUT_DIR)

build_google: check $(GOOGLE_PROP_OUT_FILE)
	@echo "OK: Generated $(GOOGLE_PROP_OUT_FILE)"

# FORCE target: always considered out-of-date
FORCE:
	@:

# Create .secret if not exist (no values)
$(SECRET_FILE):
	@echo "Creating empty $(SECRET_FILE)..."
	@echo "SITE_URL ?=" > "$(SECRET_FILE)"
	@echo "GOOGLE_CLIENT_ID ?=" >> "$(SECRET_FILE)"
	@echo "GOOGLE_CLIENT_SECRET ?=" >> "$(SECRET_FILE)"

check: $(SECRET_FILE)
	@test -n "$(SITE_URL)" || (echo "ERROR: SITE_URL is not set"; exit 1)
	@test -n "$(GOOGLE_CLIENT_ID)" || (echo "ERROR: GOOGLE_CLIENT_ID is not set"; exit 1)
	@test -n "$(GOOGLE_CLIENT_SECRET)" || (echo "ERROR: GOOGLE_CLIENT_SECRET is not set"; exit 1)
	@test -f "$(GOOGLE_PROP_SRC_FILE)" || (echo "ERROR: missing template: $(GOOGLE_PROP_SRC_FILE)"; exit 1)
	@command -v envsubst >/dev/null 2>&1 || (echo "ERROR: envsubst not found"; exit 1)
	@command -v mktemp >/dev/null 2>&1 || (echo "ERROR: mktemp not found"; exit 1)

# Always rebuild because FORCE is a prerequisite
$(GOOGLE_PROP_OUT_FILE): FORCE $(GOOGLE_PROP_SRC_FILE) $(SECRET_FILE)
	@set -e; \
	tmpdir="$$(mktemp -d)"; \
	trap 'rm -rf "$$tmpdir"' EXIT INT TERM; \
	envsubst '$$SITE_URL $$GOOGLE_CLIENT_ID $$GOOGLE_CLIENT_SECRET' \
		< "$(GOOGLE_PROP_SRC_FILE)" > "$$tmpdir/google-provider.properties"; \
	test -s "$$tmpdir/google-provider.properties"; \
	mkdir -p "$(OUT_DIR)"; \
	mv -f "$$tmpdir/google-provider.properties" "$(GOOGLE_PROP_OUT_FILE)"