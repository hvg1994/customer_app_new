import '../api_service.dart';

class ShipTrackRepository{
  ApiClient apiClient;

  ShipTrackRepository({required this.apiClient}) : assert(apiClient != null);

  Future getShiprockeTokenRepo(String email, String password) async{
    return await apiClient.getShippingTokenApi(email, password);
  }

  Future getTrackingDetailsRepo(String awbNumber) async{
    return await apiClient.serverShippingTrackerApi(awbNumber);
  }
}