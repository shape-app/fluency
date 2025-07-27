#!/usr/bin/env python3
"""
Script to automatically install Fluency-specific Xcode templates.

How it works:
• Copies templates to ~/Library/Developer/Xcode/Templates/File Templates/Fluency
• Uses Version key in TemplateInfo.plist to determine if updates are needed
• Only installs/updates when source version > destination version

To add new templates:
• Add template path to TEMPLATES list below
• Ensure template has Version key in TemplateInfo.plist

To update an existing template:
• Make changes to the relevant .xctemplate directory
• Bump the Version key in TemplateInfo.plist
"""

import plistlib
import shutil
from pathlib import Path

# List of templates to install
TEMPLATES = [
    "scripts/templates/Swift File.xctemplate",
    # Add future templates here:
    # "scripts/templates/MVVM.xctemplate",
]


def get_template_version(template_path):
    """Extract version from TemplateInfo.plist, return None if not found"""
    plist_path = template_path / "TemplateInfo.plist"
    if not plist_path.exists():
        return None

    try:
        with open(plist_path, "rb") as f:
            plist_data = plistlib.load(f)
            return plist_data.get("Version")
    except Exception:
        return None


def should_copy_template(source_path, dest_path):
    """Check if template should be copied based on version comparison"""
    if not dest_path.exists():
        return True

    source_version = get_template_version(source_path)
    dest_version = get_template_version(dest_path)

    # If source doesn't have a version, skip updates
    if source_version is None:
        return not dest_path.exists()  # Only install if doesn't exist

    # If dest doesn't have a version but source does, update to get versioned template
    if dest_version is None:
        return True

    # Both have versions - compare them
    return source_version > dest_version


def main():
    base_dest = Path.home() / "Library/Developer/Xcode/Templates/File Templates/Fluency"

    # Ensure destination directory exists
    base_dest.mkdir(parents=True, exist_ok=True)

    for source_rel_path in TEMPLATES:
        source_path = Path(source_rel_path)
        dest_path = base_dest / source_path.name

        if not source_path.exists():
            print(f"Warning: Template source not found: {source_path}")
            continue

        if should_copy_template(source_path, dest_path):
            source_version = get_template_version(source_path)
            print(f"Installing Xcode template: {source_path.name} v{source_version or 'unknown'}")

            # Remove existing template if it exists
            if dest_path.exists():
                shutil.rmtree(dest_path)
            shutil.copytree(source_path, dest_path)
        # else: template is up-to-date, skip silently


if __name__ == "__main__":
    main()
