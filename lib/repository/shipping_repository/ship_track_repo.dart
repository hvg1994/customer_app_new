import '../api_service.dart';

class ShipTrackRepository{
  ApiClient apiClient;

  ShipTrackRepository({required this.apiClient}) : assert(apiClient != null);

  Future getTrackingDetailsRepo(String awbNumber) async{
    return await apiClient.serverShippingTrackerApi(awbNumber);
  }
}