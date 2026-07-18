import sys
import re

REQUIRED_DELIVERABLES = [
    "Navigation Philosophy",
    "Information Architecture Principles",
    "Content Hierarchy",
    "Application Sitemap",
    "User Journey Mapping",
    "Navigation Hierarchy",
    "Primary Navigation",
    "Secondary Navigation",
    "Contextual Navigation",
    "Bottom Navigation Strategy",
    "Top App Bar Navigation",
    "Search-first Navigation",
    "Filter Navigation",
    "Statistics Navigation",
    "Settings Navigation",
    "Detail Page Navigation",
    "Dialog Navigation",
    "Bottom Sheet Navigation",
    "Modal Navigation",
    "Deep Link Strategy",
    "Notification Entry Points",
    "Shortcut Entry Points",
    "Widget Entry Points",
    "Back Navigation Rules",
    "Up Navigation Rules",
    "Navigation History Rules",
    "State Restoration",
    "Multi-window Strategy",
    "Foldable Navigation",
    "Tablet Navigation",
    "Landscape Navigation",
    "RTL Navigation Rules",
    "Accessibility Navigation",
    "Focus Navigation",
    "Keyboard Navigation",
    "Empty Navigation States",
    "Error Navigation Recovery",
    "Navigation Analytics Events",
    "Navigation Token Mapping",
    "Governance Rules",
    "Validation Checklist",
    "Anti-pattern Catalog",
    "Future Evolution Strategy"
]

FORBIDDEN_PATTERNS = [
    r"TODO",
    r"FIXME",
    r"\[Insert[^\]]*\]",
    r"placeholder",
    r"#[0-9a-fA-F]{6}\b",                                    # HEX colors like #FFFFFF
    r"\b[0-9]+\s*px\b",                                     # pixels
    r"\b[0-9]+\s*sp\b",                                     # sp typography
    r"\b[0-9]+\s*dp\b",                                     # dp spacing
    r"Navigator\.push",                                     # Imperative Navigator calls
    r"GoRoute\s*\(",                                        # Router configuration patterns
    r"class\s+\w+\s+extends\s+(StatelessWidget|StatefulWidget)", # Flutter widget class definitions
    r"Widget\s+build\s*\(",                                  # Flutter build method signatures
    r"BuildContext\s+\w+",                                   # Flutter BuildContext references
    r"Container\s*\(",                                      # Raw Container calls
    r"SizedBox",                                            # SizedBox calls
    r"Padding\s*\(",                                        # Padding calls
    r"TextStyle\s*\("                                       # TextStyle calls
]

def validate_navigation_system(filepath):
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
        print(f"Validation PASSED successfully for {filepath}!")
        sys.exit(0)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python navigation_validator.py <filepath>")
        sys.exit(1)
    validate_navigation_system(sys.argv[1])
