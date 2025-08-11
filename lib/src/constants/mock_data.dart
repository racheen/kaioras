import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/app_user.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/block.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/booking.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/membership.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/block.dart'
    hide Block, Host;

enum MembershipStatus { active, expired, cancelled }

enum BookingStatus { booked, cancelled, attended }

enum BlockStatus { active, cancelled, completed }

enum VisibilityStatus { public, private }

/// Clientele Module Data Models
///
/// AppUser
///   - Memberships
///   - Bookings
///
/// Blocks
///
final mockAppUser = AppUser(
  name: 'Test User',
  email: 'test@email.com',
  createdAt: '',
  lastBusinessId: null,
  platformRole: null,
  notifications: true,
  memberships: [
    Membership(
      membershipId: '1',
      businessId: '1',
      offerId: '1',
      name: 'Yoga Center',
      credits: 1000,
      creditsUsed: 100,
      expiration: '',
      status: MembershipStatus.active.name,
      createdAt: '',

      // embedded snapshot
      bookings: [
        Booking(
          title: 'Pilates Class',
          startTime: '12:00 PM',
          status: BookingStatus.booked.name,
        ),
        Booking(
          title: 'Dance Class',
          startTime: '12:00 PM',
          status: BookingStatus.attended.name,
        ),
        Booking(
          title: 'Dance Class',
          startTime: '12:00 PM',
          status: BookingStatus.attended.name,
        ),
      ],
    ),
    Membership(
      membershipId: '2',
      businessId: '2',
      offerId: '1',
      name: 'Pilates Studio',
      credits: 1000,
      creditsUsed: 100,
      expiration: '',
      status: MembershipStatus.active.name,
      createdAt: '',

      // embedded snapshot
      bookings: [
        Booking(
          title: 'Pilates Class',
          startTime: '12:00 PM',
          status: BookingStatus.booked.name,
        ),
        Booking(
          title: 'Pilates Class',
          startTime: '12:00 PM',
          status: BookingStatus.attended.name,
        ),
      ],
    ),
    Membership(
      membershipId: '3',
      businessId: '3',
      offerId: '1',
      name: 'Dance Acedemy',
      credits: 1000,
      creditsUsed: 100,
      expiration: '',
      status: MembershipStatus.active.name,
      createdAt: '',

      // embedded snapshot
      bookings: [
        Booking(
          title: 'Pilates Class',
          startTime: '12:00 PM',
          status: BookingStatus.booked.name,
        ),
        Booking(
          title: 'Pilates Class',
          startTime: '12:00 PM',
          status: BookingStatus.attended.name,
        ),
      ],
    ),
  ],
  bookings: [
    Booking(
      bookingId: '1',
      blockId: '1',
      title: 'Pilates Class',
      startTime: 'Jul 26, 2025 3:00 PM * 55 mins',
      status: BookingStatus.booked.name,
      block: Block(
        blockId: '1',
        businessDetails: BusinessDetails(
          businessId: 'business001',
          name: 'Pilates Studio',
          picture: 'https://example.com/logos/pilates.png',
        ),
        title: 'Pilates Class',
        type: '',
        startTime: 'Jul 26, 2025 3:00 PM * 55 mins',
        duration: 55,
        location: 'Studio A, Street Name, City, Country',
        capacity: 100,
        visibility: VisibilityStatus.public.name,
        status: BlockStatus.active.name,
        createdAt: 'createdAt',
        tags: ['Beginner', 'Pilates'],
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        attendees: [],
        host: Host(uid: '1', name: 'Emily Tresk', details: ''),
      ),
    ),
    Booking(
      bookingId: '1',
      blockId: '2',
      title: 'Dance Class',
      startTime: 'Jul 26, 2025 3:00 PM * 55 mins',
      status: BookingStatus.attended.name,
      block: Block(
        blockId: '2',
        businessDetails: BusinessDetails(
          businessId: 'business001',
          name: 'Pilates Studio',
          picture: 'https://example.com/logos/pilates.png',
        ),
        title: 'Dance Class',
        type: 'Class',
        startTime: 'Jul 26, 2025 3:00 PM * 55 mins',
        duration: 30,
        location: 'Studio A, Street Name, City, Country',
        capacity: 10,
        visibility: VisibilityStatus.public.name,
        status: BlockStatus.active.name,
        createdAt: 'createdAt',
        tags: ['Beginner', 'Pilates'],
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        attendees: [],
        host: Host(uid: '1', name: 'Emily Tresk', details: ''),
      ),
    ),
    Booking(
      bookingId: '1',
      blockId: '3',
      title: 'Studio A - Core',
      startTime: 'Jul 26, 2025 3:00 PM * 55 mins',
      status: BookingStatus.attended.name,
      block: Block(
        blockId: '3',
        businessDetails: BusinessDetails(
          businessId: 'business001',
          name: 'Pilates Studio',
          picture: 'https://example.com/logos/pilates.png',
        ),
        title: 'Studio A - Core',
        type: 'Class',
        startTime: 'Jul 26, 2025 3:00 PM * 55 mins',
        duration: 30,
        location: 'Studio A, Street Name, City, Country',
        capacity: 10,
        visibility: VisibilityStatus.public.name,
        status: BlockStatus.active.name,
        createdAt: 'createdAt',
        tags: ['Beginner', 'Pilates'],
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        attendees: [],
        host: Host(uid: '1', name: 'Emily Tresk', details: 'Instructor'),
      ),
    ),
  ],
);

final mockBlocks = [
  Block(
    blockId: '1',
    businessDetails: BusinessDetails(
      businessId: 'business001',
      name: 'Pilates Studio',
      picture: 'https://example.com/logos/pilates.png',
    ),
    tenant: 'Yoga Center',
    title: 'Pilates Class',
    type: '',
    startTime: 'Jul 26, 2025 3:00 PM * 55 mins',
    duration: 55,
    location: 'Studio A, Street Name, City, Country',
    capacity: 100,
    visibility: VisibilityStatus.public.name,
    status: BlockStatus.active.name,
    createdAt: 'createdAt',
    tags: ['Beginner', 'Pilates'],
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean facilisis sem in commodo viverra. Donec rutrum ac lacus vestibulum venenatis. Morbi commodo dolor ac elit convallis venenatis nec et mauris. Sed id nisi tristique, rhoncus velit et, congue odio. Nunc ut tellus sed nulla lacinia feugiat. Aliquam quis pharetra diam. Morbi nec pulvinar nunc. Sed arcu dui, tincidunt a libero vitae, tincidunt convallis urna. Nunc bibendum, erat eu tempor semper, lorem justo mattis neque, non auctor urna ipsum et massa. Fusce facilisis libero ut ullamcorper venenatis. Mauris et placerat risus. Sed sem mauris, commodo ac lorem sed, faucibus interdum odio. Aliquam erat volutpat. Donec malesuada magna vel neque laoreet, nec sagittis lacus scelerisque. Nam imperdiet volutpat tristique. Morbi volutpat laoreet purus id bibendum. Vivamus odio purus, rhoncus non erat et, porttitor malesuada urna. Donec dapibus massa a erat suscipit condimentum. Proin efficitur pretium nunc, nec eleifend nisl laoreet quis. Fusce bibendum nisi sollicitudin nunc faucibus lacinia. Aliquam lacinia sollicitudin leo, a suscipit lorem porta vitae. Suspendisse quam ex, pulvinar eu odio at, varius venenatis nunc. Cras imperdiet, lacus et mollis blandit, dolor urna mollis purus, sed pulvinar felis dolor ut eros. Quisque sed velit sit amet leo malesuada luctus. Sed tincidunt lacus ac augue porttitor vulputate. Duis convallis lectus tincidunt consectetur varius.',
    attendees: [],
    host: Host(uid: '1', name: 'Emily Davis', details: 'Hello'),
  ),
  Block(
    blockId: '2',
    businessDetails: BusinessDetails(
      businessId: 'business001',
      name: 'Pilates Studio',
      picture: 'https://example.com/logos/pilates.png',
    ),
    tenant: 'Yoga Center',
    title: 'Dance Class',
    type: 'Class',
    startTime: 'Jul 26, 2025 3:00 PM * 55 mins',
    duration: 30,
    location: 'Studio A, Street Name, City, Country',
    capacity: 10,
    visibility: VisibilityStatus.public.name,
    status: BlockStatus.active.name,
    createdAt: 'createdAt',
    tags: ['Beginner', 'Pilates'],
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    attendees: [],
    host: Host(
      uid: '1',
      name: 'Emily Tresk',
      details:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    ),
  ),
  Block(
    blockId: '3',
    businessDetails: BusinessDetails(
      businessId: 'business001',
      name: 'Pilates Studio',
      picture: 'https://example.com/logos/pilates.png',
    ),
    tenant: 'Yoga Center',
    title: 'Studio A - Core',
    type: 'Class',
    startTime: 'Jul 26, 2025 3:00 PM * 55 mins',
    duration: 30,
    location: 'Studio A, Street Name, City, Country',
    capacity: 10,
    visibility: VisibilityStatus.public.name,
    status: BlockStatus.active.name,
    createdAt: 'createdAt',
    tags: ['Beginner', 'Pilates'],
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    attendees: [],
    host: Host(
      uid: '1',
      name: 'Emily Tresk',
      details:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    ),
  ),
  Block(
    blockId: '4',
    businessDetails: BusinessDetails(
      businessId: 'business001',
      name: 'Pilates Studio',
      picture: 'https://example.com/logos/pilates.png',
    ),
    tenant: 'Pilates Studio',
    title: 'Studio A - Core',
    type: 'Class',
    startTime: 'Jul 26, 2025 3:00 PM * 55 mins',
    duration: 30,
    location: 'Studio A, Street Name, City, Country',
    capacity: 10,
    visibility: VisibilityStatus.public.name,
    status: BlockStatus.active.name,
    createdAt: 'createdAt',
    tags: ['Beginner', 'Pilates'],
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    attendees: [],
    host: Host(
      uid: '1',
      name: 'Emily Tresk',
      details:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    ),
  ),
  Block(
    blockId: '5',
    businessDetails: BusinessDetails(
      businessId: 'business001',
      name: 'Pilates Studio',
      picture: 'https://example.com/logos/pilates.png',
    ),
    tenant: 'Dance Academy',
    title: 'Studio A - Core',
    type: 'Class',
    startTime: 'Jul 26, 2025 3:00 PM * 55 mins',
    duration: 30,
    location: 'Studio A, Street Name, City, Country',
    capacity: 10,
    visibility: VisibilityStatus.public.name,
    status: BlockStatus.active.name,
    createdAt: 'createdAt',
    tags: ['Beginner', 'Pilates'],
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    attendees: [],
    host: Host(
      uid: '1',
      name: 'Emily Tresk',
      details:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    ),
  ),
];
