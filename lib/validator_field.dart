final emailRegex = RegExp(r'^[\w-.]+@([\w-]+.)+[\w-]{2,4}$');
final checkPhoneRegex = RegExp(r'^(09|08|07|06)\d{8}$');
final checkTextRegex = RegExp(r'^[a-zA-Zก-๙\s]+$');
final checkNumberRegex = RegExp(r'^[0-9]+$');
final checkAllTextRegex = RegExp(r'^[\s\S]*$');

final checkDecimalNumberRegex = RegExp(r'^\d+(.\d+)?$');