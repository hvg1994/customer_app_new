
class ChildNotificationModel {

  int? id;
  String? user_id;
  String? type;
  String? subject;
  String? message;
  String? request_id;
  String? notification_type;
  String? is_read;
  String? added_by;
  String? created_at;
  String? updated_at;

	ChildNotificationModel.fromJsonMap(Map<String, dynamic> map):
		id = map["id"],
		user_id = map["user_id"],
		type = map["type"],
		subject = map["subject"],
		message = map["message"],
		request_id = map["request_id"],
		notification_type = map["notification_type"],
		is_read = map["is_read"],
		added_by = map["added_by"],
		created_at = map["created_at"],
		updated_at = map["updated_at"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = id;
		data['user_id'] = user_id;
		data['type'] = type;
		data['subject'] = subject;
		data['message'] = message;
		data['request_id'] = request_id;
		data['notification_type'] = notification_type;
		data['is_read'] = is_read;
		data['added_by'] = added_by;
		data['created_at'] = created_at;
		data['updated_at'] = updated_at;
		return data;
	}
}
