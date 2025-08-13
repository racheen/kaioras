import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/common/async_value_widget.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/app_colors.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/block.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/block_detail/block_controller.dart';
import 'package:go_router/go_router.dart';

class BlockDetail extends ConsumerStatefulWidget {
  final String blockId;
  final Block? blockDetails;
  final String? businessId;

  const BlockDetail({
    super.key,
    required this.blockId,
    this.blockDetails,
    this.businessId,
  });

  @override
  ConsumerState<BlockDetail> createState() => _BlockDetailState();
}

class _BlockDetailState extends ConsumerState<BlockDetail> {
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;

  final String avatarImage = 'assets/avatar_placeholder3.jpg';

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      double currentScrollPosition = _scrollController.position.pixels;
      if (currentScrollPosition >= 230) {
        setState(() {
          _showTitle = true;
        });
      } else {
        setState(() {
          _showTitle = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // todo: fetch block data using blockId of blockDetails is null
    final asyncValue = ref.watch(blockControllerProvider(widget.blockId));

    Size screenSize = MediaQuery.of(context).size;
    double titleWidth = screenSize.width * 0.5;

    return Scaffold(
      body: AsyncValueWidget(
        value: asyncValue,
        data: (block) => CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              leading: IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: Icon(Icons.arrow_back),
              ),
              automaticallyImplyLeading: false,
              pinned: true,
              expandedHeight: 400.0,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: AnimatedOpacity(
                  opacity: _showTitle ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.ease,
                  child: SizedBox(
                    width: titleWidth,
                    child: Text(block?.title ?? 'No title'),
                  ),
                ),
                background: Image.asset(avatarImage, fit: BoxFit.cover),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 15.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            block?.title ?? 'No title',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(avatarImage),
                              backgroundColor: Colors.transparent,
                            ),
                            title: Text(block?.host?.name ?? 'No name'),
                            subtitle: Text('Host'),
                            trailing: IconButton(
                              onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Image.asset(
                                          avatarImage,
                                          width: 400,
                                          height: 250,
                                          fit: BoxFit.cover,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 16),
                                            Text(
                                              block?.host?.name ?? 'No name',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Host',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w100,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(block?.host?.title ?? ''),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              icon: Icon(Icons.info_outline),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      color: AppColors.violetC2,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10.0,
                                      ),
                                      child: Text(block!.startTime.toString()),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.access_time_filled,
                                      color: AppColors.violetC2,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10.0,
                                      ),
                                      child: Text(
                                        '${block.duration.toString()} minutes',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.place,
                                      color: AppColors.violetC2,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10.0,
                                      ),
                                      child: Text(block.location.toString()),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  'About',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(block.description ?? ''),
                            ],
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            width: 400,
                            height: 200,
                            decoration: BoxDecoration(border: Border.all()),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tags',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Wrap(
                              children: block.tags != null
                                  ? block.tags!
                                        .map(
                                          (tag) => Container(
                                            margin: const EdgeInsets.all(8.0),
                                            padding: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: AppColors.violetF6,
                                            ),
                                            child: Text(
                                              tag,
                                              style: TextStyle(
                                                color: AppColors.violet99,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList()
                                  : [Text('No tags')],
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 30),
                              child: ElevatedButton(
                                onPressed: () {
                                  // todo: implement booking functionality
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.violetC2,
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.grey,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  minimumSize: Size(double.infinity, 50),
                                ),
                                child: Text('Book'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
