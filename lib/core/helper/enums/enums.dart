enum ProductFilter { categories, brands, tags, prices, colors }

enum TransactionTypeFilter { all, deposit, payment, reward, refund }

enum MethodFilter { all, creditCard, giftCard, bankTransfer }

enum PeriodFilter { days7, days30, days90, allTime }

enum GenderType { male, female }

enum LoadingStatus { loading, complete }

enum AuthMethod { email, google, apple }

enum SportsType { weightlifting, football, basketball, boxing, mma, americanFootball }

enum UserGoal { gainMuscles, loseWeight, improveCardio }

enum UserLevel { beginner, intermediate, expert }

enum UserActivity { none, light, moderate, heavy }

enum WeightUnit { kg, lbs }

enum HeightUnit { cm, feet }

enum ChatMode { video, text }

enum ChatUser { user, athlete }

enum Sports { general, football, boxing, basketball, fitness, tennis }

enum RoutesToNoteDetails {
  notesByCoach,
  notesByCategory,
  notesByContent,
  notesByCategoryAndContent,
  notesByCoachAndContent
}
