import '../../domain/entities/addon.dart';

class AddonResponseModel {
  final ProductBasicModel product;
  final List<AddonBlockModel> blocks;

  AddonResponseModel({required this.product, required this.blocks});

  factory AddonResponseModel.fromJson(Map<String, dynamic> json) {
    List<AddonBlockModel> blocks = [];
    if (json['blocks'] != null && json['blocks'] is List) {
      blocks = (json['blocks'] as List)
          .map((block) => AddonBlockModel.fromJson(block))
          .toList();
    }

    return AddonResponseModel(
      product: ProductBasicModel.fromJson(json['product'] ?? {}),
      blocks: blocks,
    );
  }

  List<AddonModel> getAllAddons() {
    List<AddonModel> allAddons = [];
    for (var block in blocks) {
      allAddons.addAll(block.addons);
    }
    return allAddons;
  }
}

class ProductBasicModel {
  final int id;
  final String name;
  final String nameAr;
  final String price;
  final String type;

  ProductBasicModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.price,
    required this.type,
  });

  factory ProductBasicModel.fromJson(Map<String, dynamic> json) {
    return ProductBasicModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      nameAr: json['name_ar'] ?? '',
      price: json['price']?.toString() ?? '0',
      type: json['type'] ?? 'simple',
    );
  }
}

class AddonBlockModel {
  final String id;
  final String name;
  final List<AddonModel> addons;

  AddonBlockModel({required this.id, required this.name, required this.addons});

  factory AddonBlockModel.fromJson(Map<String, dynamic> json) {
    List<AddonModel> addons = [];
    if (json['addons'] != null && json['addons'] is List) {
      addons = (json['addons'] as List)
          .map((addon) => AddonModel.fromJson(addon))
          .toList();
    }

    return AddonBlockModel(
      id: json['id']?.toString() ?? '0',
      name: json['name'] ?? '',
      addons: addons,
    );
  }
}

class AddonModel extends Addon {
  AddonModel({
    required super.id,
    required super.name,
    required super.nameAr,
    super.isRequired,
    super.isMultiChoice,
    super.minSelection,
    super.maxSelection,
    required List<AddonOptionModel> options,
  }) : super(options: options);

  factory AddonModel.fromJson(Map<String, dynamic> json) {
    List<AddonOptionModel> options = [];
    if (json['options'] != null && json['options'] is List) {
      options = (json['options'] as List)
          .map((option) => AddonOptionModel.fromJson(option))
          .toList();
    }

    int minSelection = 0;
    int maxSelection = 0;
    if (json['min_max_rules'] != null) {
      minSelection = json['min_max_rules']['min'] ?? 0;
      maxSelection = json['min_max_rules']['max'] ?? 0;
    }

    return AddonModel(
      id: json['id']?.toString() ?? '0',
      name: json['title'] ?? '',
      nameAr: json['title_ar'] ?? json['title'] ?? '',
      isRequired: json['required'] == true || json['required'] == '1',
      isMultiChoice:
          json['IsMultiChoise'] == true || json['IsMultiChoise'] == '1',
      minSelection: minSelection,
      maxSelection: maxSelection,
      options: options,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
      'title_ar': nameAr,
      'required': isRequired,
      'IsMultiChoise': isMultiChoice,
      'min_max_rules': {'min': minSelection, 'max': maxSelection},
      'options': (options as List<AddonOptionModel>)
          .map((o) => o.toJson())
          .toList(),
    };
  }
}

class AddonOptionModel extends AddonOption {
  AddonOptionModel({
    required super.label,
    required super.labelAr,
    super.price,
    super.selectedByDefault,
    super.required,
  });

  factory AddonOptionModel.fromJson(Map<String, dynamic> json) {
    double price = 0.0;
    if (json['price'] != null && json['price'].toString().isNotEmpty) {
      price = double.tryParse(json['price'].toString()) ?? 0.0;
    }

    return AddonOptionModel(
      label: json['label'] ?? '',
      labelAr: json['label_ar'] ?? json['label'] ?? '',
      price: price,
      selectedByDefault:
          json['selected_by_default'] == true ||
          json['selected_by_default'] == '1',
      required: json['required'] == true || json['required'] == '1',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'label_ar': labelAr,
      'price': price.toString(),
      'selected_by_default': selectedByDefault,
      'required': required,
    };
  }
}
