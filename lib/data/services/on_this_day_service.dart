import '../models/historical_event.dart';

class MockOnThisDayService {
  MockOnThisDayService();

  final List<_HistoricalEventSeed> _seeds = [
    _HistoricalEventSeed(
      id: 'hist-accord',
      title: 'Landmark peace accord signed',
      description:
          'Negotiators finalized a sweeping accord that reshaped diplomacy in the region and ushered in a new framework for cooperation.',
      country: 'Norway',
      type: HistoricalEventType.political,
      year: 1993,
      month: 9,
      day: 13,
      imageUrl: 'https://images.unsplash.com/photo-1520607162513-77705c0f0d4a',
      highlights: [
        'Leaders sign multi-track agreement',
        'Regional security council established',
        'Observers hail breakthrough for peace talks',
      ],
      source: 'Global Diplomatic Archives',
      tags: ['accord', 'peace', 'diplomacy'],
    ),
    _HistoricalEventSeed(
      id: 'hist-louvre',
      title: 'Grand museum opens new modern wing',
      description:
          'Curators in Paris unveiled a daring architectural expansion, blending glass and tradition to house contemporary masterpieces.',
      country: 'France',
      type: HistoricalEventType.artistic,
      year: 1989,
      month: 7,
      day: 15,
      imageUrl: 'https://images.unsplash.com/photo-1529429617124-aee711a83b51',
      highlights: [
        'Architectural marvel debuts to crowds',
        'Interactive galleries celebrate new media',
        'Local artists commission immersive lightworks',
      ],
      source: 'La Gazette Culturelle',
      tags: ['art', 'architecture', 'museum'],
    ),
    _HistoricalEventSeed(
      id: 'hist-everest',
      title: 'First summit team charts new alpine route',
      description:
          'A multinational climbing crew scaled an uncharted ridge to reach the summit, mapping safer passages for future expeditions.',
      country: 'Nepal',
      type: HistoricalEventType.geographic,
      year: 1978,
      month: 5,
      day: 29,
      imageUrl: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
      highlights: [
        'New altitude shelters installed',
        'Glacial data logged for researchers',
        'Local Sherpa guides honored at base camp',
      ],
      source: 'Everest Alpine Journal',
      tags: ['mountain', 'exploration', 'mapping'],
    ),
    _HistoricalEventSeed(
      id: 'hist-resilience',
      title: 'Coastal city rebuilds after seismic shock',
      description:
          'Communities along the Pacific coast launched an ambitious recovery plan pairing eco-infrastructure with early warning systems.',
      country: 'Japan',
      type: HistoricalEventType.naturalDisaster,
      year: 2011,
      month: 3,
      day: 11,
      imageUrl: 'https://images.unsplash.com/photo-1528825871115-3581a5387919',
      highlights: [
        'Resilient seawalls reinforced',
        'Local volunteers coordinate relief hubs',
        'Smart sensors deployed for rapid alerts',
      ],
      source: 'Pacific Resilience Review',
      tags: ['recovery', 'tsunami', 'innovation'],
    ),
    _HistoricalEventSeed(
      id: 'hist-holiday',
      title: 'Nation proclaims unity holiday',
      description:
          'Citizens gathered for the first official celebration honoring the charter that united regions under one flag.',
      country: 'United Arab Emirates',
      type: HistoricalEventType.holiday,
      year: 1971,
      month: 12,
      day: 2,
      imageUrl: 'https://images.unsplash.com/photo-1496307042754-b4aa456c4a2d',
      highlights: [
        'Air shows and cultural parades fill the capital',
        'Traditional poetry recitals broadcast nationwide',
        'Landmarks illuminated in vibrant colors',
      ],
      source: 'Gulf Heritage Chronicle',
      tags: ['holiday', 'celebration', 'unity'],
    ),
    _HistoricalEventSeed(
      id: 'hist-democracy',
      title: 'Historic election ushers inclusive government',
      description:
          'Long lines formed before dawn as citizens cast ballots in the first fully representative vote of the nation\'s history.',
      country: 'South Africa',
      type: HistoricalEventType.social,
      year: 1994,
      month: 4,
      day: 27,
      imageUrl: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
      highlights: [
        'Record voter turnout',
        'International observers applaud transparency',
        'Unity concerts held in major cities',
      ],
      source: 'Ubuntu Civic Forum',
      tags: ['democracy', 'vote', 'rights'],
    ),
    _HistoricalEventSeed(
      id: 'hist-moon',
      title: 'Lunar research base reports breakthrough discovery',
      description:
          'Scientists transmitted confirmation of subsurface ice deposits, paving the way for longer human-led missions.',
      country: 'Global',
      type: HistoricalEventType.scientific,
      year: 1971,
      month: 7,
      day: 21,
      imageUrl: 'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa',
      highlights: [
        'Modular habitats sustain 30-day stay',
        'Robotic drills analyze polar craters',
        'Mission inspires wave of STEM enrollments',
      ],
      source: 'Orbital Science Network',
      tags: ['space', 'discovery', 'research'],
    ),
    _HistoricalEventSeed(
      id: 'hist-euro',
      title: 'Common currency enters circulation',
      description:
          'Financial districts across Europe rang in the new year by introducing a shared currency, harmonizing markets overnight.',
      country: 'European Union',
      type: HistoricalEventType.economic,
      year: 1999,
      month: 1,
      day: 1,
      imageUrl: 'https://images.unsplash.com/photo-1520607162513-77705c0f0d4a',
      highlights: [
        'ATMs swapped to new banknotes',
        'Cross-border trade fees eliminated',
        'Citizens attend workshops on new pricing',
      ],
      source: 'European Economic Review',
      tags: ['finance', 'integration', 'currency'],
    ),
    _HistoricalEventSeed(
      id: 'hist-festival',
      title: 'Global arts festival spotlights street performance',
      description:
          'A Mediterranean town transformed into a stage, welcoming performers and storytellers from over fifty nations.',
      country: 'Spain',
      type: HistoricalEventType.cultural,
      year: 1987,
      month: 8,
      day: 29,
      imageUrl: 'https://images.unsplash.com/photo-1496307042754-b4aa456c4a2d',
      highlights: [
        'Midnight lantern parade',
        'Workshops on heritage crafts',
        'Interactive mural along the harbor',
      ],
      source: 'Festival Archive Europe',
      tags: ['festival', 'culture', 'music'],
    ),
    _HistoricalEventSeed(
      id: 'hist-innovation',
      title: 'City unveils climate-smart transit grid',
      description:
          'Urban planners debuted a driverless tram network powered entirely by renewable energy, reducing commute emissions overnight.',
      country: 'Singapore',
      type: HistoricalEventType.scientific,
      year: 2015,
      month: 10,
      day: 5,
      imageUrl: 'https://images.unsplash.com/photo-1498050108023-c5249f4df085',
      highlights: [
        'Solar canopies shade pedestrian hubs',
        'Adaptive scheduling learns rider flows',
        'Green corridors link downtown districts',
      ],
      source: 'Urban Futures Digest',
      tags: ['mobility', 'climate', 'innovation'],
    ),
    _HistoricalEventSeed(
      id: 'hist-solidarity',
      title: 'Grassroots coalition launches global relief drive',
      description:
          'Community organizations synchronized donation hubs across continents to provide rapid aid after a sweeping storm season.',
      country: 'Global',
      type: HistoricalEventType.social,
      year: 2007,
      month: 11,
      day: 18,
      imageUrl: 'https://images.unsplash.com/photo-1469474968028-56623f02e42e',
      highlights: [
        'Mobile clinics reach remote villages',
        'Crowd-sourced maps steer volunteers',
        'Transparency dashboards build trust',
      ],
      source: 'Worldwide Relief Collective',
      tags: ['solidarity', 'relief', 'community'],
    ),
    _HistoricalEventSeed(
      id: 'hist-heritage',
      title: 'Ancient ruins gain world heritage status',
      description:
          'Archaeologists celebrated the inscription of a desert citadel, unlocking preservation funds and responsible tourism programs.',
      country: 'Egypt',
      type: HistoricalEventType.cultural,
      year: 1979,
      month: 6,
      day: 19,
      imageUrl: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
      highlights: [
        'Virtual tours document fragile murals',
        'Local artisans restore sandstone reliefs',
        'Heritage academies train new guides',
      ],
      source: 'Heritage Watch',
      tags: ['heritage', 'archaeology', 'tourism'],
    ),
  ];

  List<HistoricalEvent> getEventsFor(
    DateTime date, {
    String? country,
    Set<HistoricalEventType>? types,
  }) {
    final seeds = _matchingSeeds(date);
    final filtered = <HistoricalEvent>[];
    for (final seed in seeds) {
      if (country != null && country.isNotEmpty && country != seed.country) {
        continue;
      }
      if (types != null && types.isNotEmpty && !types.contains(seed.type)) {
        continue;
      }
      final isExact = seed.month == date.month && seed.day == date.day;
      final eventDate = isExact
          ? DateTime(seed.year, seed.month, seed.day)
          : DateTime(seed.year, date.month, date.day);
      filtered.add(seed.toEvent(eventDate));
    }
    filtered.sort((a, b) => a.date.year.compareTo(b.date.year));
    return filtered;
  }

  List<String> getCountries() {
    final countries = _seeds.map((seed) => seed.country).toSet().toList()
      ..sort();
    if (countries.remove('Global')) {
      countries.insert(0, 'Global');
    }
    return countries;
  }

  List<HistoricalEventType> getTypes() {
    return HistoricalEventType.values;
  }

  List<_HistoricalEventSeed> _matchingSeeds(DateTime date) {
    final exact = _seeds
        .where((seed) => seed.month == date.month && seed.day == date.day)
        .toList();
    if (exact.isNotEmpty) {
      return exact;
    }
    final dayMatch =
        _seeds.where((seed) => seed.day == date.day).toList(growable: false);
    if (dayMatch.isNotEmpty) {
      return dayMatch;
    }
    final monthMatch =
        _seeds.where((seed) => seed.month == date.month).toList(growable: false);
    if (monthMatch.isNotEmpty) {
      return monthMatch;
    }
    return _seeds;
  }
}

class _HistoricalEventSeed {
  const _HistoricalEventSeed({
    required this.id,
    required this.title,
    required this.description,
    required this.country,
    required this.type,
    required this.year,
    required this.month,
    required this.day,
    required this.imageUrl,
    required this.highlights,
    required this.source,
    required this.tags,
  });

  final String id;
  final String title;
  final String description;
  final String country;
  final HistoricalEventType type;
  final int year;
  final int month;
  final int day;
  final String imageUrl;
  final List<String> highlights;
  final String source;
  final List<String> tags;

  HistoricalEvent toEvent(DateTime date) {
    return HistoricalEvent(
      id: '${id}_${date.month}_${date.day}',
      title: title,
      description: description,
      country: country,
      type: type,
      date: date,
      imageUrl: imageUrl,
      highlights: highlights,
      source: source,
      tags: tags,
    );
  }
}
