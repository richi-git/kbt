// Enum untuk membedakan tipe isi kotak
enum NodeType { number, operator, empty }

class NodeModel {
  final int id; // Index posisi kotak di dalam grid (0, 1, 2...)
  final String value; // Nilainya, misal "9", "+", atau ""
  final NodeType type; // Tipenya: number, operator, atau empty
  bool isSelected; // Status apakah kotak sedang di-swipe/dipilih

  NodeModel({
    required this.id,
    required this.value,
    required this.type,
    this.isSelected = false,
  });

  // Fungsi helper (opsional) untuk mempermudah copy object saat update state
  NodeModel copyWith({
    int? id,
    String? value,
    NodeType? type,
    bool? isSelected,
  }) {
    return NodeModel(
      id: id ?? this.id,
      value: value ?? this.value,
      type: type ?? this.type,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
