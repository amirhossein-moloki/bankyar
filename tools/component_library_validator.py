import sys
import re

COMPONENTS = [
    "Buttons", "Icon Buttons", "FAB", "Text Fields", "Search Bar", "PIN Input", "OTP Input",
    "Cards", "Transaction Card", "Statistic Card", "Bank Card", "List Tile", "Section Header",
    "Top App Bar", "Bottom Navigation", "Navigation Rail", "Drawer", "Tabs", "Segmented Control",
    "Chip", "Filter Chip", "Dialog", "Bottom Sheet", "Snackbar", "Toast", "Tooltip", "Menu",
    "Dropdown", "Date Picker", "Charts", "Progress Indicator", "Loading Skeleton", "Badge",
    "Avatar", "Divider", "Switch", "Checkbox", "Radio Button", "Slider", "Empty State",
    "Error State", "Permission Card", "Notification Banner", "Search Result Item", "Backup Card",
    "Restore Card", "Security Card"
]

FORBIDDEN_PATTERNS = [
    (r"TODO", "Contains TODO placeholder"),
    (r"FIXME", "Contains FIXME placeholder"),
    (r"placeholder", "Contains placeholder text"),
    (r"#[0-9a-fA-F]{6}\b", "Contains raw HEX color codes"),
    (r"\b[0-9]+\s*px\b", "Contains pixel spacing values"),
    (r"\b[0-9]+\s*sp\b", "Contains sp typography values"),
    (r"\b[0-9]+\s*dp\b", "Contains dp layout/sizing values"),
    (r"widget\b", "Contains forbidden framework term 'widget'"),
    (r"widgets\b", "Contains forbidden framework term 'widgets'"),
    (r"StatefulWidget", "Contains Flutter widget references"),
    (r"StatelessWidget", "Contains Flutter widget references"),
    (r"Container\s*\(", "Contains Flutter widget code references"),
    (r"SizedBox", "Contains Flutter widget code references"),
    (r"Padding\s*\(", "Contains Flutter widget code references"),
    (r"TextStyle\s*\(", "Contains Flutter widget code references")
]

def validate_library(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
    except FileNotFoundError:
        print(f"Error: {filepath} not found.")
        sys.exit(1)

    issues = []

    # Check forbidden patterns case-insensitively
    for pattern, desc in FORBIDDEN_PATTERNS:
        matches = re.findall(pattern, content, re.IGNORECASE)
        if matches:
            issues.append(f"{desc}: matched {set(matches)}")

    # Check if all 47 components are defined as sections/points
    for comp in COMPONENTS:
        # Match component names in headings or bold items
        pattern = rf"(?:#+\s+.*{re.escape(comp)}|###\s+{re.escape(comp)}|\*\s+\*{re.escape(comp)}\*)"
        if not any(re.search(pattern, line, re.IGNORECASE) for line in content.split('\n')):
            issues.append(f"Missing definition for component: '{comp}'")

    if issues:
        print("Component Library Validation FAILED with the following issues:")
        for issue in issues:
            print(f" - {issue}")
        sys.exit(1)
    else:
        print("Component Library Validation PASSED successfully!")
        sys.exit(0)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python component_library_validator.py <filepath>")
        sys.exit(1)
    validate_library(sys.argv[1])
