#!/bin/bash

echo "🔍 Detecting changed services..."

# Get list of changed files between last commit and current
CHANGED_FILES=$(git diff --name-only HEAD~1)

echo "Changed files:"
echo "$CHANGED_FILES"
echo "----------------------------"

# Initialize flags
PRODUCT_CHANGED=false
INVENTORY_CHANGED=false
PAYMENT_CHANGED=false
FRONTEND_CHANGED=false

# Loop through changed files
for file in $CHANGED_FILES; do
  if [[ $file == product-service/* ]]; then
    PRODUCT_CHANGED=true
  fi

  if [[ $file == inventory-service/* ]]; then
    INVENTORY_CHANGED=true
  fi

  if [[ $file == payment-service/* ]]; then
    PAYMENT_CHANGED=true
  fi

  if [[ $file == frontend/* ]]; then
    FRONTEND_CHANGED=true
  fi
done

# Print results
echo "🔔 Change summary:"
echo "Product Service changed   : $PRODUCT_CHANGED"
echo "Inventory Service changed : $INVENTORY_CHANGED"
echo "Payment Service changed   : $PAYMENT_CHANGED"
echo "Frontend changed          : $FRONTEND_CHANGED"

# Export for Jenkins
export PRODUCT_CHANGED
export INVENTORY_CHANGED
export PAYMENT_CHANGED
export FRONTEND_CHANGED
