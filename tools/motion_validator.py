import sys
import re

REQUIRED_DELIVERABLES = [
    "Motion Philosophy",
    "Motion Principles",
    "Animation Hierarchy",
    "Motion Categories",
    "Screen Transition Strategy",
    "Navigation Animation Rules",
    "Dialog Animation Rules",
    "Bottom Sheet Animation Rules",
    "Snackbar Animation Rules",
    "Notification Animation Rules",
    "FAB Motion Rules",
    "Card Interaction Motion",
    "List Animation Rules",
    "Search Animation Rules",
    "Filter Animation Rules",
    "Expand / Collapse Rules",
    "Loading Motion",
    "Progress Motion",
    "Success Feedback Motion",
    "Error Feedback Motion",
    "Empty State Motion",
    "Gesture Feedback",
    "Press States",
    "Hover States",
    "Focus States",
    "Scroll Behavior",
    "Refresh Behavior",
    "Drag & Drop Guidelines",
    "Motion Token Mapping",
    "Performance Budget",
    "Accessibility Strategy",
    "Reduced Motion Strategy",
    "Dark Mode Considerations",
    "Haptic Feedback Strategy",
    "Governance Rules",
    "Validation Rules",
    "Anti-pattern Catalog",
    "Motion Review Checklist",
    "Migration Strategy",
    "Future Evolution Strategy"
]

FORBIDDEN_PATTERNS = [
    r"TODO",
    r"FIXME",
    r"\[Insert[^\]]*\]",
    r"placeholder",
    r"#[0-9a-fA-F]{6}\b",              # HEX colors like #FFFFFF
    r"\b[0-9]+\s*px\b",               # pixels
    r"\b[0-9]+\s*sp\b",               # sp typography
    r"\b[0-9]+\s*dp\b",               # dp spacing
    r"\b[0-9]+\s*ms\b",               # ms durations
    r"\b[0-9.]+\s*seconds?\b",        # seconds durations
    r"\b[0-9.]+\s*s\b",               # s durations (excluding s-based words via word boundaries)
    r"cubic-bezier",                  # Raw cubic bezier coordinates
    r"Widget\b",                      # Flutter Widget references
    r"StatefulWidget",
    r"StatelessWidget",
    r"Container\s*\(",
    r"SizedBox",
    r"Padding\s*\(",
    r"TextStyle\s*\("
]

def validate_motion_system(filepath):
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
        # Filter false positives for milliseconds or seconds if needed, but we used boundaries
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
        print("Validation PASSED successfully for MOTION_SYSTEM.md!")
        sys.exit(0)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python motion_validator.py <filepath>")
        sys.exit(1)
    validate_motion_system(sys.argv[1])
