class Addon {
  final String id;
  final String name;
  final String nameAr;
  final bool isRequired;
  final bool isMultiChoice;
  final int minSelection;
  final int maxSelection;
  final List<AddonOption> options;

  Addon({
    required this.id,
    required this.name,
    required this.nameAr,
    this.isRequired = false,
    this.isMultiChoice = false,
    this.minSelection = 0,
    this.maxSelection = 0,
    this.options = const [],
  });
}

class AddonOption {
  final String label;
  final String labelAr;
  final double price;
  final bool selectedByDefault;
  final bool required;

  AddonOption({
    required this.label,
    required this.labelAr,
    this.price = 0.0,
    this.selectedByDefault = false,
    this.required = false,
  });
}
