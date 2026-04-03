/// All UI text constants - single source of truth for strings
class AppStrings {
  // App name & branding
  static const String appName = 'UCHAT';
  static const String appTagline = 'Secure Messaging App';

  // Splash screen
  static const String splashLoading = 'Loading...';

  // Auth - Login
  static const String loginTitle = 'Sign In';
  static const String loginSubtitle = 'Welcome back to UCHAT';
  static const String emailLabel = 'Email Address';
  static const String emailHint = 'Enter your email';
  static const String passwordLabel = 'Password';
  static const String passwordHint = 'Enter your password';
  static const String signInButton = 'Sign In';
  static const String signInWithGoogle = 'Continue with Google';
  static const String forgotPassword = 'Forgot password?';
  static const String dontHaveAccount = 'Don\'t have an account? ';
  static const String register = 'Register';

  // Auth - Register
  static const String registerTitle = 'Create Account';
  static const String registerSubtitle = 'Join UCHAT today';
  static const String fullNameLabel = 'Full Name';
  static const String fullNameHint = 'Enter your full name';
  static const String confirmPasswordLabel = 'Confirm Password';
  static const String confirmPasswordHint = 'Re-enter your password';
  static const String passwordStrengthWeak = 'Weak';
  static const String passwordStrengthFair = 'Fair';
  static const String passwordStrengthStrong = 'Strong';
  static const String passwordStrengthVeryStrong = 'Very Strong';
  static const String termsCheckbox = 'I agree to the Terms & Conditions';
  static const String createAccountButton = 'Create Account';
  static const String alreadyHaveAccount = 'Already have an account? ';

  // Auth - Forgot Password
  static const String forgotPasswordTitle = 'Reset Password';
  static const String sendResetLink = 'Send Reset Link';
  static const String resetEmailSent = 'Check your email for reset instructions';

  // Validation errors
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Enter a valid email address';
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort = 'Password must be at least 8 characters';
  static const String passwordWeak = 'Password must contain uppercase, number, and special character';
  static const String passwordsNoMatch = 'Passwords do not match';
  static const String nameRequired = 'Name is required';
  static const String nameInvalid = 'Name must be at least 2 characters';

  // Home screen
  static const String homeTitle = 'Chats';
  static const String noConversations = 'No conversations yet';
  static const String startOne = 'Start one?';
  static const String searchChats = 'Search chats...';
  static const String deleteChat = 'Delete chat?';
  static const String confirm = 'Confirm';
  static const String cancel = 'Cancel';

  // Chat screen
  static const String messageHint = 'Type a message...';
  static const String sendMessage = 'Send';
  static const String typing = 'is typing...';
  static const String messageSent = '✓ Sent';
  static const String messageDelivered = '✓✓ Delivered';
  static const String messageRead = '✓✓ Read';
  static const String messageDeleted = 'This message was deleted';
  static const String replyingTo = 'Replying to';
  static const String messageInfo = 'Message Info';
  static const String copy = 'Copy';
  static const String reply = 'Reply';
  static const String forward = 'Forward';
  static const String delete = 'Delete';
  static const String deleteForEveryone = 'Delete for everyone';
  static const String deleteForMe = 'Delete for me';
  static const String today = 'Today';
  static const String yesterday = 'Yesterday';

  // Group chat
  static const String createGroup = 'Create Group';
  static const String groupName = 'Group Name';
  static const String addMembers = 'Add Members';
  static const String createGroupButton = 'Create Group';
  static const String groupMembers = 'Members';
  static const String groupInfo = 'Group Info';
  static const String leaveGroup = 'Leave Group';
  static const String deleteGroup = 'Delete Group';
  static const String addMoreMembers = 'Add Members';
  static const String removeMember = 'Remove Member';

  // Search screen
  static const String searchUsers = 'Search Users';
  static const String searchGroups = 'Search Groups';
  static const String noResults = 'No results found';
  static const String messageButton = 'Message';
  static const String joinButton = 'Join';

  // Profile screen
  static const String profileTitle = 'Profile';
  static const String editProfile = 'Edit Profile';
  static const String status = 'Status';
  static const String customStatus = 'What\'s on your mind?';
  static const String stats = 'Statistics';
  static const String chats = 'Chats';
  static const String groups = 'Groups';
  static const String mediaShared = 'Media';
  static const String signOut = 'Sign Out';

  // Settings screen
  static const String settingsTitle = 'Settings';
  static const String darkMode = 'Dark Mode';
  static const String notificationsEnabled = 'Message Notifications';
  static const String readReceipts = 'Read Receipts';
  static const String lastSeenVisibility = 'Show Last Seen';
  static const String biometricLock = 'Biometric Lock';
  static const String changePassword = 'Change Password';
  static const String clearAllChats = 'Clear All Chats';
  static const String about = 'About';
  static const String appVersion = 'App Version';
  static const String termsOfService = 'Terms of Service';
  static const String privacyPolicy = 'Privacy Policy';

  // Errors
  static const String errorOccurred = 'An error occurred';
  static const String networkError = 'Network error. Please check your connection';
  static const String authError = 'Authentication failed';
  static const String firebaseError = 'Firebase error';
  static const String unknownError = 'Unknown error occurred';
  static const String tryAgain = 'Try Again';
  static const String loading = 'Loading...';
  static const String emptyState = 'Nothing to see here';

  // Notifications
  static const String newMessage = 'New Message';
  static const String notification = 'Notification';
  static const String permitNotifications = 'Enable Notifications';
  static const String notificationDescription = 'Never miss a message';

  // Lock screen
  static const String unlockWithBiometric = 'Unlock with Biometric';
  static const String unlockWithPin = 'Unlock with PIN';
  static const String unlockButton = 'Unlock';
  static const String pinLabel = 'Enter PIN';

  // Time labels
  static const String justNow = 'Just now';
  static const String minutesAgo = 'm ago';
  static const String hoursAgo = 'h ago';
  static const String daysAgo = 'd ago';
  static const String online = 'Online';
  static const String offline = 'Offline';
}

