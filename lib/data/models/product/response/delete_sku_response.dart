class DeleteSkuResponse {
  const DeleteSkuResponse({required this.uid});

  final String uid;

  factory DeleteSkuResponse.fromJson(Map<String, dynamic> json) {
    return DeleteSkuResponse(uid: json['uid'] as String? ?? '');
  }
}
