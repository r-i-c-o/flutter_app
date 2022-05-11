class UserAction {
  const UserAction._();
  static const String obviousNavigation =
      "navigate_from_{current_page}_to_{destination_page}";
  static const String navigateUp = "navigate_up";
  static const String buttonClick = "button_click_{sub_action}";
  static const String chooseEvent = "choose_{object_of_choose}";
}

class EventPathParam {
  const EventPathParam._();
  static const String currentPage = "{current_page}";
  static const String destinationPage = "{destination_page}";
  static const String subAction = "{sub_action}";
  static const String objectOfChoose = "{object_of_choose}";
}

class EventQueryParam {
  const EventQueryParam._();
  static const String viewName = "view_name";
}

const userSubAction = UserSubAction._();

class UserSubAction {
  const UserSubAction._();
  static const String addNotification = "add_notification";
  static const String removeNotification = "remove_notification";
}

class UserChoose {
  const UserChoose._();
  static const String reminderTime = "reminder_time";
  static const String textSize = "text_size";
}

class CommonParams {
  const CommonParams._();
  static const String screenName = "screen_name";
}
