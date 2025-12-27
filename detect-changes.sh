#!/bin/bash

set -e

echo "🔍 Detecting changed services..."

CHANGED_FILES=$(git diff --name-only HEAD~1 2>/dev/null || git diff --name-only)

SERVICES=("product-service" "inventory-service" "payment-service" "frontend")

mkdir -p .versions
> changed-services.txt

for service in "${SERVICES[@]}"; do
  if echo "$CHANGED_FILES" | grep -q "^$service/"; then

    VERSION_FILE=".versions/${service/-service/}.version"

    # Initialize if missing
    if [ ! -f "$VERSION_FILE" ]; then
      echo 1 > "$VERSION_FILE"
    fi

    CURRENT_VERSION=$(cat "$VERSION_FILE")
    NEW_VERSION=$((CURRENT_VERSION + 1))

    echo "$NEW_VERSION" > "$VERSION_FILE"

    IMAGE_NAME="${service/-service/}:v${NEW_VERSION}"

    echo "$service $IMAGE_NAME" >> changed-services.txt

    echo "✅ $service changed → version v${NEW_VERSION}"
  else
    echo "ℹ️ $service not changed"
  fi
done

if [ ! -s changed-services.txt ]; then
  echo "⚠️ No services changed"
fi
