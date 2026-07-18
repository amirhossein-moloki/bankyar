import sys
import re

REQUIRED_DELIVERABLES = [
    "Layout Philosophy",
    "Spatial Design Principles",
    "Grid Architecture",
    "Baseline Grid Strategy",
    "Responsive Grid System",
    "Layout Zones",
    "Safe Area Strategy",
    "Screen Margins",
    "Internal Padding Strategy",
    "External Spacing Strategy",
    "Vertical Rhythm",
    "Horizontal Rhythm",
    "Content Width Rules",
    "Container Rules",
    "Card Layout Rules",
    "List Layout Rules",
    "Detail Screen Layout",
    "Form Layout Rules",
    "Dialog Layout Rules",
    "Bottom Sheet Layout",
    "Navigation Layout",
    "App Bar Layout",
    "FAB Placement Rules",
    "Search Layout",
    "Statistics Layout",
    "Chart Layout",
    "Empty State Layout",
    "Loading Layout",
    "Error Layout",
    "Keyboard-safe Layout",
    "Foldable Device Strategy",
    "Tablet Strategy",
    "Landscape Strategy",
    "Split-screen Strategy",
    "RTL Layout Strategy",
    "Layout Token Mapping",
    "Governance Rules",
    "Validation Rules",
    "Anti-pattern Catalog",
    "Future Evolution Strategy"
]

FORBIDDEN_PATTERNS = [
    r"TODO",
    r"FIXME",
    r"\[Insert[^\]]*\]",
    r"placeholder",
    r"#[0-9a-fA-F]{6}\b",  # HEX colors like #FFFFFF
    r"\b[0-9]+\s*px\b",   # pixels
    r"\b[0-9]+\s*sp\b",   # sp typography
    r"\b[0-9]+\s*dp\b",   # dp spacing
    r"Widget\b",          # Flutter Widget references
    r"StatefulWidget",
    r"StatelessWidget",
    r"Container\s*\(",
    r"SizedBox",
    r"Padding\s*\(",
    r"TextStyle\s*\("
]

def validate_layout_system(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
    except FileNotFoundError:
        print(f"Error: {filepath} not found.")
        sys.exit(1)

    issues = []

    # Check for forbidden patterns
    for pattern in FORBIDDEN_PATTERNS:
        matches = re.findall(pattern, content, re.IGNORECASE)
        if matches:
            issues.append(f"Forbidden pattern '{pattern}' matched: {set(matches)}")

    # Check for required deliverables as headings
    for deliverable in REQUIRED_DELIVERABLES:
        # Match markdown headings containing the deliverable name (case insensitive)
        pattern = rf"^#+\s+.*{re.escape(deliverable)}.*$"
        if not any(re.match(pattern, line, re.IGNORECASE) for line in content.split('\n')):
            issues.append(f"Missing Section/Heading for Deliverable: '{deliverable}'")

    if issues:
        print("Validation FAILED with the following issues:")
        for issue in issues:
            print(f" - {issue}")
        sys.exit(1)
    else:
        print("Validation PASSED successfully for LAYOUT_SPACING_SYSTEM.md!")
        sys.exit(0)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python layout_validator.py <filepath>")
        sys.exit(1)
    validate_layout_system(sys.argv[1])
