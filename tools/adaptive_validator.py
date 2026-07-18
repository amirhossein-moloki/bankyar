import sys
import re

REQUIRED_DELIVERABLES = [
    "Adaptive Design Philosophy",
    "Device Classification Strategy",
    "Breakpoint Philosophy",
    "Responsive Principles",
    "Adaptive Layout Rules",
    "Phone Experience",
    "Large Phone Experience",
    "Tablet Experience",
    "Foldable Experience",
    "Desktop Readiness",
    "External Display Strategy",
    "Landscape Behavior",
    "Portrait Behavior",
    "Split Screen Strategy",
    "Multi-window Support",
    "Resizable Window Rules",
    "Adaptive Navigation",
    "Adaptive Forms",
    "Adaptive Charts",
    "Adaptive Tables",
    "Adaptive Statistics",
    "Adaptive Search",
    "Adaptive Dialogs",
    "Adaptive Bottom Sheets",
    "Adaptive Cards",
    "Adaptive Lists",
    "Adaptive Empty States",
    "Adaptive Error States",
    "Adaptive Loading States",
    "RTL Adaptive Rules",
    "Accessibility Across Devices",
    "Performance Considerations",
    "Memory Considerations",
    "Offline-first Considerations",
    "Design Token Adaptation",
    "Component Adaptation Rules",
    "Governance Rules",
    "Validation Checklist",
    "Anti-pattern Catalog",
    "Migration & Future Evolution Strategy"
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

def validate_adaptive_system(filepath):
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
        print("Validation PASSED successfully for ADAPTIVE_SYSTEM.md!")
        sys.exit(0)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python adaptive_validator.py <filepath>")
        sys.exit(1)
    validate_adaptive_system(sys.argv[1])
