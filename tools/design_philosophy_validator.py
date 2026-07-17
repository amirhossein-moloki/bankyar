import sys
import re

REQUIRED_DELIVERABLES = [
    "Product Vision",
    "Design Vision",
    "Product Personality",
    "Brand Personality",
    "Emotional Design Goals",
    "User Experience Philosophy",
    "Design Language",
    "Visual Philosophy",
    "Financial Product Design Principles",
    "Privacy-first Design Principles",
    "Offline-first UX Principles",
    "Cognitive Load Reduction Strategy",
    "Progressive Disclosure Strategy",
    "Information Hierarchy",
    "Reading Experience Philosophy",
    "Content-first Design",
    "One-hand Mobile Usage Philosophy",
    "Mobile-first Principles",
    "RTL-first Design Principles",
    "Accessibility Philosophy",
    "Trust-building Principles",
    "Error Prevention Philosophy",
    "User Control Philosophy",
    "Feedback Philosophy",
    "Interaction Consistency",
    "Navigation Philosophy",
    "Motion Philosophy",
    "Performance Perception Philosophy",
    "Notification Experience",
    "Empty State Philosophy",
    "Loading Experience Philosophy",
    "Success Feedback Philosophy",
    "Financial Dashboard Philosophy",
    "Security UX Guidelines",
    "Future Evolution Principles"
]

REQUIRED_STRUCTURES = [
    "Executive Summary",
    "Design Principles Matrix",
    "Design Laws",
    "UX Decision Matrix",
    "Anti-pattern Catalog",
    "Governance Rules",
    "Trade-off Analysis",
    "Future Evolution Strategy",
    "Review Checklist",
    "Architecture Alignment"
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

def validate_design_philosophy(filepath):
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
        print("Validation PASSED successfully!")
        sys.exit(0)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python design_philosophy_validator.py <filepath>")
        sys.exit(1)
    validate_design_philosophy(sys.argv[1])
