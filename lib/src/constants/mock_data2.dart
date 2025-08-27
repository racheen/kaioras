import 'package:flutter_riverpod_boilerplate/src/feature/authentication/domain/app_user.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/block.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/app_user.dart'
    hide AppUser, UserRole;
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/block.dart'
    hide Host, Block;

enum MembershipStatus { active, expired, cancelled }

enum BookingStatus { booked, cancelled, attended }

enum BlockStatus { active, cancelled, completed }

enum VisibilityStatus { public, private }

enum OfferType { recurring, oneTime }

enum RoleType { tenant, admin, customer }

enum BlockType { group, individual }

final Map<String, AppUser> mockUsers = {
  'user001': AppUser(
    uid: 'user001',
    email: 'customer1@example.com',
    name: 'Jane Doe',
    createdAt: DateTime.now(),
    image: 'https://example.com/profile_pics/user009.jpg',
    lastBusinessId: '',
    platformRole: null,
    notifications: false,
    roles: {
      'business001': UserRole(
        role: RoleType.tenant.name,
        status: 'active',
        createdAt: DateTime.now(),
      ),
    },
  ),
  'user002': AppUser(
    uid: 'user002',
    email: 'customer2@example.com',
    name: 'Janine Smith',
    createdAt: DateTime.now(),
    image: 'https://example.com/profile_pics/user009.jpg',
    lastBusinessId: 'business001',
    platformRole: null,
    notifications: false,
    roles: {
      'business001': UserRole(
        role: RoleType.customer.name,
        status: 'active',
        createdAt: DateTime.now(),
      ),
      'business003': UserRole(
        role: RoleType.tenant.name,
        status: 'active',
        createdAt: DateTime.now(),
      ),
    },
    memberships: {
      'membership001': Membership(
        membershipId: 'membership001',
        businessDetails: BusinessDetails(
          businessId: 'business001',
          name: 'Pilates Studio',
          image: 'https://example.com/logos/pilates.png',
        ),
        offerSnapshot: OfferSnapshot(
          name: 'Monthly Unlimited',
          type: OfferType.recurring.name,
          description: 'Unlimited classes for one month',
        ),
        status: MembershipStatus.active.name,
        name: 'Monthly Unlimited',
        credits: 999999,
        creditsUsed: 0,
        expiration: DateTime(2025, 6, 2, 9, 0).toString(),
        createdAt: DateTime(2025, 6, 1, 9, 0).toString(),
        bookings: {
          'booking001': BookingSnapshot(
            blockId: 'block001',
            title: 'Morning Pilates',
            startTime: DateTime(2025, 6, 1, 9, 0),
            status: BookingStatus.booked.name,
          ),
        },
      ),
    },
    bookings: {
      'booking001': Booking(
        bookingId: 'booking001',
        membershipId: 'membership001',
        businessDetails: BusinessDetails(
          businessId: 'business001',
          name: 'Pilates Studio',
          image: 'https://example.com/logos/pilates.png',
        ),
        status: BookingStatus.booked.name,
        bookedAt: DateTime.now(),
        notes: "first booking",
        blockDetails: BlockDetails(
          title: 'Morning Pilates',
          startTime: DateTime(2025, 6, 1, 9, 0),
          location: 'Main Studio',
          hostName: 'Emily Trusk',
          hostDetails:
              'Experienced instructor specializing in beginner and intermediate Pilates',
        ),
      ),
    },
  ),
  'user003': AppUser(
    uid: 'user003',
    email: 'customer3@example.com',
    name: 'Agatha Minis',
    createdAt: DateTime.now(),
    image: 'https://example.com/profile_pics/user009.jpg',
    lastBusinessId: 'business001',
    platformRole: null,
    notifications: false,
    roles: {
      'business001': UserRole(
        role: RoleType.customer.name,
        status: 'active',
        createdAt: DateTime.now(),
      ),
    },
    memberships: {
      'membership001': Membership(
        membershipId: 'membership001',
        businessDetails: BusinessDetails(
          businessId: 'business001',
          name: 'Pilates Studio',
          image: 'https://example.com/logos/pilates.png',
        ),
        offerSnapshot: OfferSnapshot(
          name: 'Monthly Unlimited',
          type: OfferType.recurring.name,
          description: 'Unlimited classes for one month',
        ),
        status: MembershipStatus.active.name,
        name: 'Monthly Unlimited',
        credits: 999999,
        creditsUsed: 0,
        expiration: DateTime(2025, 6, 2, 9, 0).toString(),
        createdAt: DateTime(2025, 6, 1, 9, 0).toString(),
        bookings: {
          'booking001': BookingSnapshot(
            blockId: 'block001',
            title: 'Morning Pilates',
            startTime: DateTime(2025, 6, 1, 9, 0),
            status: BookingStatus.booked.name,
          ),
        },
      ),
    },
    bookings: {
      'booking001': Booking(
        bookingId: 'booking001',
        membershipId: 'membership001',
        businessDetails: BusinessDetails(
          businessId: 'business001',
          name: 'Pilates Studio',
          image: 'https://example.com/logos/pilates.png',
        ),
        status: BookingStatus.booked.name,
        bookedAt: DateTime.now(),
        notes: "first booking",
        blockDetails: BlockDetails(
          title: 'Morning Pilates',
          startTime: DateTime(2025, 6, 1, 9, 0),
          location: 'Main Studio',
          hostName: 'Emily Trusk',
          hostDetails:
              'Experienced instructor specializing in beginner and intermediate Pilates',
        ),
      ),
    },
  ),
};

final Map<String, dynamic> mockBusinesses = {
  'business001': {
    'businessId': 'business001',
    'name': 'Pilates Studio',
    'ownerUid': 'user001',
    'createdAt': DateTime.now().toIso8601String(),
    'industry': 'pilates',
    'branding': {
      'primaryColor': '#4A90E2',
      'logoUrl': 'https://example.com/logos/pilates.png',
    },
    'plan': 'pro',
    'stripeAccountId': 'acct_123456',
    'offers': [
      {
        'name': 'Monthly Unlimited',
        'type': 'recurring',
        'credits': 999999,
        'price': 9900,
        'currency': 'USD',
        'durationInDays': 30,
        'description': 'Unlimited classes for one month',
        'active': true,
        'createdAt': DateTime.now().toIso8601String(),
      },
    ],

    'roles': {
      'user001': {
        'uid': 'user001',
        'role': RoleType.tenant.name,
        'status': 'active',
        'createdAt': DateTime.now().toIso8601String(),
        'displayName': 'Jane Doe',
      },
      'user002': {
        'uid': 'user002',
        'role': RoleType.customer.name,
        'status': 'active',
        'createdAt': DateTime.now().toIso8601String(),
        'displayName': 'Janine Smith',
      },
    },
    'settings': {
      'availability': {
        'defaultHours': [
          {'day': 'monday', 'start': '08:00', 'end': '18:00'},
          {'day': 'tuesday', 'start': '08:00', 'end': '18:00'},
          {'day': 'wednesday', 'start': '08:00', 'end': '18:00'},
          {'day': 'thursday', 'start': '08:00', 'end': '18:00'},
          {'day': 'friday', 'start': '08:00', 'end': '18:00'},
        ],
        'timeZone': 'America/New_York',
      },
      'holidays': [
        {
          'date': DateTime(2023, 12, 25).toIso8601String(),
          'reason': 'Christmas',
        },
      ],
      'closedDays': ['sunday', 'saturday'],
    },
  },
  'business002': {
    'businessId': 'business002',
    'name': 'Yoga Center Studio',
    'ownerUid': 'user001',
    'createdAt': DateTime.now().toIso8601String(),
    'industry': 'pilates',
    'branding': {
      'primaryColor': '#4A90E2',
      'logoUrl': 'https://example.com/logos/pilates.png',
    },
    'plan': 'pro',
    'stripeAccountId': 'acct_123456',
    'offers': [
      {
        'name': 'Monthly Unlimited',
        'type': 'recurring',
        'credits': 999999,
        'price': 9900,
        'currency': 'USD',
        'durationInDays': 30,
        'description': 'Unlimited classes for one month',
        'active': true,
        'createdAt': DateTime.now().toIso8601String(),
      },
    ],

    'roles': {
      'user001': {
        'uid': 'user001',
        'role': RoleType.tenant.name,
        'status': 'active',
        'createdAt': DateTime.now().toIso8601String(),
        'displayName': 'Jane Doe',
      },
      'user002': {
        'uid': 'user002',
        'role': RoleType.customer.name,
        'status': 'active',
        'createdAt': DateTime.now().toIso8601String(),
        'displayName': 'Janine Smith',
      },
    },
    'settings': {
      'availability': {
        'defaultHours': [
          {'day': 'monday', 'start': '08:00', 'end': '18:00'},
          {'day': 'tuesday', 'start': '08:00', 'end': '18:00'},
          {'day': 'wednesday', 'start': '08:00', 'end': '18:00'},
          {'day': 'thursday', 'start': '08:00', 'end': '18:00'},
          {'day': 'friday', 'start': '08:00', 'end': '18:00'},
        ],
        'timeZone': 'America/New_York',
      },
      'holidays': [
        {
          'date': DateTime(2023, 12, 25).toIso8601String(),
          'reason': 'Christmas',
        },
      ],
      'closedDays': ['sunday', 'saturday'],
    },
  },
  'business003': {
    'businessId': 'business003',
    'name': 'Gym Studio',
    'ownerUid': 'user001',
    'createdAt': DateTime.now().toIso8601String(),
    'industry': 'pilates',
    'branding': {
      'primaryColor': '#4A90E2',
      'logoUrl': 'https://example.com/logos/pilates.png',
    },
    'plan': 'pro',
    'stripeAccountId': 'acct_123456',
    'offers': [
      {
        'name': 'Monthly Unlimited',
        'type': 'recurring',
        'credits': 999999,
        'price': 9900,
        'currency': 'USD',
        'durationInDays': 30,
        'description': 'Unlimited classes for one month',
        'active': true,
        'createdAt': DateTime.now().toIso8601String(),
      },
    ],

    'roles': {
      'user001': {
        'uid': 'user001',
        'role': RoleType.tenant.name,
        'status': 'active',
        'createdAt': DateTime.now().toIso8601String(),
        'displayName': 'Jane Doe',
      },
      'user002': {
        'uid': 'user002',
        'role': RoleType.customer.name,
        'status': 'active',
        'createdAt': DateTime.now().toIso8601String(),
        'displayName': 'Janine Smith',
      },
    },
    'settings': {
      'availability': {
        'defaultHours': [
          {'day': 'monday', 'start': '08:00', 'end': '18:00'},
          {'day': 'tuesday', 'start': '08:00', 'end': '18:00'},
          {'day': 'wednesday', 'start': '08:00', 'end': '18:00'},
          {'day': 'thursday', 'start': '08:00', 'end': '18:00'},
          {'day': 'friday', 'start': '08:00', 'end': '18:00'},
        ],
        'timeZone': 'America/New_York',
      },
      'holidays': [
        {
          'date': DateTime(2023, 12, 25).toIso8601String(),
          'reason': 'Christmas',
        },
      ],
      'closedDays': ['sunday', 'saturday'],
    },
  },
};

final mockBlocks = {
  'block001': Block(
    blockId: 'block001',
    origin: Origin(
      businessId: 'business001',
      name: 'Pilates Studio',
      image: 'https://example.com/logos/pilates.png',
    ),
    title: 'Morning Pilates',
    type: BlockType.group.name,
    startTime: DateTime(2025, 8, 1, 9, 0),
    duration: 60,
    location: 'Main Studio',
    capacity: 15,
    visibility: VisibilityStatus.public.name,
    status: BlockStatus.active.name,
    createdAt: DateTime.now().toString(),
    tags: ['morning', 'beginner'],
    description: 'Start your day with an energizing Pilates session',

    host: Host(
      uid: 'user001',
      name: 'Pilates Instructor',
      title: 'Senior Instructor',
      about: 'Certified Pilates instructor with 5 years of experience',
      image: 'https://example.com/instructor.jpg',
    ),
  ),
  'block002': Block(
    blockId: 'block002',
    title: 'Morning Pilates',
    type: BlockType.group.name,
    startTime: DateTime(2025, 8, 22, 9, 0),
    duration: 60,
    location: 'Main Studio',
    capacity: 15,
    visibility: VisibilityStatus.public.name,
    status: BlockStatus.active.name,
    createdAt: DateTime.now().toString(),
    tags: ['morning', 'beginner'],
    description: 'Start your day with an energizing Pilates session',
    origin: Origin(
      businessId: 'business002',
      name: 'Pilates Studio',
      image: 'https://example.com/logos/pilates.png',
    ),
    host: Host(uid: 'user001', name: 'Jane Doe'),
  ),
  'block003': Block(
    blockId: 'block003',
    origin: Origin(
      businessId: 'business003',
      name: 'Pilates Studio',
      image: 'https://example.com/logos/pilates.png',
    ),
    title: 'Morning Pilates',
    type: BlockType.group.name,
    startTime: DateTime(2025, 8, 24, 9, 0),
    duration: 60,
    location: 'Main Studio',
    capacity: 15,
    visibility: VisibilityStatus.public.name,
    status: BlockStatus.active.name,
    createdAt: DateTime.now().toString(),
    tags: ['morning', 'beginner'],
    description: 'Start your day with an energizing Pilates session',

    host: Host(
      uid: 'user001',
      name: 'Pilates Instructor',
      title: 'Senior Instructor',
      about: 'Certified Pilates instructor with 5 years of experience',
      image: 'https://example.com/instructor.jpg',
    ),
  ),
};
