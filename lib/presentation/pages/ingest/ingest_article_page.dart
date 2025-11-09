import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../core/i18n/app_localizations.dart';
import '../../../data/models/event.dart';
import '../../../data/services/local_article_parser.dart';
import '../../controllers/events_controller.dart';
import '../../widgets/event_tile.dart';

class IngestArticlePage extends StatefulWidget {
  const IngestArticlePage({super.key, required this.parser, required this.eventsController});

  final LocalArticleParser parser;
  final EventsController eventsController;

  @override
  State<IngestArticlePage> createState() => _IngestArticlePageState();
}

class _IngestArticlePageState extends State<IngestArticlePage> {
  final _controller = TextEditingController();
  List<Event> _parsed = const [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.translate('ingest_article'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _controller,
            maxLines: 10,
            decoration: InputDecoration(
              hintText: l10n.translate('paste_article'),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              final results = widget.parser.parse(_controller.text);
              setState(() => _parsed = results);
            },
            icon: const Icon(IconlyLight.analysis),
            label: Text(l10n.translate('analyze_article')),
          ),
          const SizedBox(height: 16),
          ..._parsed.map(
            (event) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: EventTile(
                event: event,
                palette: [Theme.of(context).colorScheme.primary.withOpacity(0.2)],
                onTap: () {},
              ),
            ),
          ),
          if (_parsed.isNotEmpty)
            FilledButton(
              onPressed: () async {
                await widget.eventsController.refresh(article: _controller.text);
                if (context.mounted) Navigator.of(context).pop();
              },
              child: Text(l10n.translate('accept')),
            ),
        ],
      ),
    );
  }
}
