import 'package:car_wash/models/announcement.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Announcement', () {
    test('isDuplicate returns true for duplicate announcement', () {
      Announcement existingAnnouncement = Announcement(
        message: 'Announcement1',
        date: 'data1',
      );
      List<Announcement> announcements = [
        Announcement(
          message: 'Announcement1',
          date: 'data1',
        ),
        Announcement(
          message: 'Announcement2',
          date: 'data2',
        ),
      ];

      bool result = existingAnnouncement.isDuplicate(announcements);

      expect(result, true);
    });

    test('isDuplicate returns false for non-duplicate announcement', () {
      Announcement existingAnnouncement = Announcement(
        message: 'Announcement1',
        date: 'data1',
      );
      List<Announcement> announcements = [
        Announcement(
          message: 'Announcement2',
          date: 'data2',
        ),
        Announcement(
          message: 'Announcement3',
          date: 'data3',
        ),
      ];

      bool result = existingAnnouncement.isDuplicate(announcements);

      expect(result, false);
    });
  });
}
