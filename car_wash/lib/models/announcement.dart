class Announcement {
  final String message;
  final String date;

  Announcement({required this.message, required this.date});

  bool isDuplicate(List<Announcement> announcements) {
    for (Announcement announcement in announcements) {
      if (announcement.message == this.message &&
          announcement.date == this.date) {
        return true;
      }
    }
    return false;
  }
}
