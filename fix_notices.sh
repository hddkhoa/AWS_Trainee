#!/bin/bash

# Fix all notice shortcodes in content files
find content/ -name "*.md" -type f -exec sed -i 's/{{% notice tip %}}/💡 **Tip:** /g' {} \;
find content/ -name "*.md" -type f -exec sed -i 's/{{% notice info %}}/ℹ️ **Info:** /g' {} \;
find content/ -name "*.md" -type f -exec sed -i 's/{{% notice warning %}}/⚠️ **Warning:** /g' {} \;
find content/ -name "*.md" -type f -exec sed -i 's/{{% \/notice %}}//g' {} \;

echo "Fixed all notice shortcodes!"
