import '../../repository/shipping_repository/ship_track_repo.dart';

class ShipTrackService{
  final ShipTrackRepository repository;

  ShipTrackService({required this.repository}) : assert(repository != null);

  Future getUserProfileService(String awbNumber) async{
    return await repository.getTrackingDetailsRepo(awbNumber);
  }
}