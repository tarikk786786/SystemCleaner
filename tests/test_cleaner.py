import os
import re
import pytest

APP_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DOCS_DIR = os.path.join(APP_DIR, "docs")

REQUIRED_BLUEPRINTS = [
    "PRD.md",
    "DESIGN_SYSTEM.md",
    "ARCHITECTURE.md",
    "DATABASE.md",
    "SECURITY.md",
    "CODE_STYLE.md",
    "TESTING.md",
    "AGENTS.md",
    "UX_FLOWS.md",
    "API.md",
]

PROTECTED_TOOLS = [
    "Antigravity",
    "Cursor",
    "Visual Studio Code",
    "Docker Desktop",
    "Git",
    "Python",
    "Node.js",
    "Go Programming",
    "Rustup",
]

def test_vibe_coding_blueprint_files_exist():
    """Verify all 10 Vibe Coding Blueprint documents are present and non-empty."""
    for doc in REQUIRED_BLUEPRINTS:
        doc_path = os.path.join(DOCS_DIR, doc)
        assert os.path.isfile(doc_path), f"Missing required blueprint: {doc}"
        assert os.path.getsize(doc_path) > 100, f"Blueprint {doc} is too short or empty."

def test_root_readme_exists():
    """Verify README.md exists and is documented."""
    readme_path = os.path.join(APP_DIR, "README.md")
    assert os.path.isfile(readme_path), "Missing root README.md"
    assert os.path.getsize(readme_path) > 200, "README.md is too short."

def test_powershell_script_exists_and_contains_logic():
    """Verify clean_unwanted_apps.ps1 exists and has target definitions."""
    ps1_path = os.path.join(APP_DIR, "clean_unwanted_apps.ps1")
    assert os.path.isfile(ps1_path), "Missing clean_unwanted_apps.ps1"
    
    with open(ps1_path, "r", encoding="utf-8") as f:
        content = f.read()

    assert "AuditOnly" in content
    assert "Execute" in content
    assert "msiTargets" in content
    assert "appleTargets" in content
    assert "uwpTargets" in content

def test_disk_cache_cleaner_exists():
    """Verify clean_disk_caches.ps1 exists and includes core cleanup targets."""
    cache_script = os.path.join(APP_DIR, "clean_disk_caches.ps1")
    assert os.path.isfile(cache_script), "Missing clean_disk_caches.ps1"
    with open(cache_script, "r", encoding="utf-8") as f:
        content = f.read()
    assert "npm cache clean" in content
    assert "pip cache purge" in content
    assert "go clean -cache" in content

def test_msi_guid_syntax_validity():
    """Verify that all targeted MSI GUIDs in the PowerShell script match standard GUID pattern."""
    ps1_path = os.path.join(APP_DIR, "clean_unwanted_apps.ps1")
    with open(ps1_path, "r", encoding="utf-8") as f:
        content = f.read()

    guid_pattern = re.compile(r'\{[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}\}')
    guids = guid_pattern.findall(content)
    assert len(guids) >= 10, f"Expected at least 10 targeted MSI GUIDs, found {len(guids)}"
    for g in guids:
        assert guid_pattern.match(g), f"Invalid GUID format: {g}"

def test_protected_tools_not_in_targets():
    """Verify that core developer tools are never targeted for removal."""
    ps1_path = os.path.join(APP_DIR, "clean_unwanted_apps.ps1")
    with open(ps1_path, "r", encoding="utf-8") as f:
        content = f.read()

    for tool in PROTECTED_TOOLS:
        assert f'Name = "{tool}"' not in content, f"Protected developer tool {tool} found in removal targets!"

def test_launcher_bat_exists():
    """Verify RunAsAdmin.bat exists and includes UAC elevation."""
    bat_path = os.path.join(APP_DIR, "RunAsAdmin.bat")
    assert os.path.isfile(bat_path), "Missing RunAsAdmin.bat"
    with open(bat_path, "r", encoding="utf-8") as f:
        content = f.read()
    assert "RunAs" in content
    assert "clean_unwanted_apps.ps1" in content
