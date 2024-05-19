# Sports Events iOS Application

## Overview
This iOS application showcases upcoming sporting events, allowing users to view events categorized by sport type, filter events based on favorites, and see a real-time countdown timer for each event. The application fetches event data from a mock API and presents it in a user-friendly interface.

## Implementation Details

### Favorites Feature
- The application allows users to mark events as favorites. Given the requirement that favorited events do not need to persist across app sessions, the favoriting functionality is implemented directly within the UI layer rather than the ViewModel layer. This decision simplifies the architecture and focuses on the user interaction within a single session.
- Favoriting is handled through user interaction with the event entries. Initially, the `didSelectRow` method was used to toggle an event's favorite status, enhancing the user experience by providing immediate visual feedback.

### UI Implementation
- The main view displaying the sports list is implemented using `UITableView`. This choice was made to better understand the project's requirements and to provide a straightforward, scrollable list of events. While the provided sample UI suggested the use of different UI components, using `UITableView` allowed for a more focused approach on the app's functionality.
- Collapsible sections for each sport type are implemented to allow users to expand or collapse the list of events, making the app more navigable and user-friendly.

### Countdown Timer
- Each event entry includes a countdown timer indicating the time remaining until the event starts. The implementation of the countdown timer focuses on real-time updates; however, due to time constraints, the user experience around this feature may not be fully optimized. Future improvements could address this by refining the timer's performance and display.

### Architectural Choices
- The application's architecture is designed with a focus on readability, maintainability, and adherence to iOS development best practices. The separation of concerns is achieved through distinct layers for networking, data repository, and view models.
- The choice of architecture and the implementation of each layer were guided by the goal of creating a well-engineered application. The decision to use `UITableView` and the approach to the favorites feature reflect a prioritization of core functionalities and user experience.

### Testing
- Comprehensive testing covers the network, repository, and ViewModel layers. Each scenario, including data fetching, error handling, and state changes, is thoroughly tested to ensure the application's reliability and stability.
- The absence of persistence for favorited events means that this feature is not included in the ViewModel layer tests. However, the application's core functionalities are rigorously validated through unit tests.

## Future Improvements
- **Favorites Persistence:** Implementing persistence for favorited events would enhance the user experience by allowing preferences to be retained across app sessions.
- **Countdown Timer Optimization:** Further optimization of the countdown timer could improve the user experience by ensuring smooth and accurate countdowns.
- **UI Enhancements:** Additional UI improvements, such as animations and icons for sport groups, could further enrich the user interface and engagement.

## Conclusion
This iOS application demonstrates a focused approach to presenting upcoming sporting events, with an emphasis on user interaction and core functionalities. While certain aspects, such as the countdown timer's user experience, may require further refinement, the application successfully meets the project's requirements and provides a solid foundation for future enhancements.
