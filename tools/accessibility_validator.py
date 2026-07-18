import sys
import re

REQUIRED_DELIVERABLES = [
    "Accessibility Philosophy",
    "Inclusive Design Principles",
    "Accessibility Goals",
    "User Personas with Disabilities",
    "Vision Accessibility",
    "Low Vision Strategy",
    "Color Blind Strategy",
    "High Contrast Strategy",
    "Large Text Strategy",
    "Dynamic Text Scaling",
    "Screen Reader Support",
    "Semantic Labels Strategy",
    "Reading Order Rules",
    "Focus Order Rules",
    "Keyboard Navigation",
    "Switch Access Support",
    "Voice Access Support",
    "Touch Target Guidelines",
    "Gesture Alternatives",
    "Motion Sensitivity",
    "Reduced Motion Rules",
    "Cognitive Accessibility",
    "Memory Load Reduction",
    "Error Prevention",
    "Error Recovery",
    "Financial Data Readability",
    "Number Accessibility",
    "Chart Accessibility",
    "Form Accessibility",
    "Search Accessibility",
    "Notification Accessibility",
    "Dialog Accessibility",
    "Navigation Accessibility",
    "RTL Accessibility",
    "Localization Accessibility",
    "Accessibility Token Mapping",
    "Accessibility Testing Strategy",
    "Manual Testing Checklist",
    "Automated Testing Strategy",
    "Accessibility Governance",
    "Accessibility Review Process",
    "Anti-pattern Catalog",
    "Compliance Matrix",
    "Future Evolution Strategy"
]

REQUIRED_STRUCTURES = [
    "Accessibility Architecture",
    "Inclusive Personas",
    "WCAG Mapping",
    "Testing Matrix",
    "Governance Rules",
    "Accessibility Checklist",
    "Review Workflow"
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

def validate_accessibility_system(filepath):
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

    # Check for required structures
    for structure in REQUIRED_STRUCTURES:
        pattern = rf"^#+\s+.*{re.escape(structure)}.*$"
        if not any(re.match(pattern, line, re.IGNORECASE) for line in content.split('\n')):
            issues.append(f"Missing Heading for Structure: '{structure}'")

    if issues:
        print("Validation FAILED with the following issues:")
        for issue in issues:
            print(f" - {issue}")
        sys.exit(1)
    else:
        print("Validation PASSED successfully for ACCESSIBILITY_INCLUSIVE_SYSTEM.md!")
        sys.exit(0)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python accessibility_validator.py <filepath>")
        sys.exit(1)
    validate_accessibility_system(sys.argv[1])
