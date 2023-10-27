import 'package:felloapp/core/model/ui_config_models/instant_save_card.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class InstantSaveCard extends StatefulWidget {
  const InstantSaveCard({
    super.key,
  });

  @override
  State<InstantSaveCard> createState() => _InstantSaveCardState();
}

class _InstantSaveCardState extends State<InstantSaveCard> {
  InstantSaveCardConfig? config;
  GetterRepository? repository;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    repository = locator<GetterRepository>();
    repository?.getInstantSaveCardConfig().then((value) {
      isLoading = false;
      if (value.isSuccess()) {
        config = value.model?.data;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    repository = null; // For better GC.
    config = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const CircularProgressIndicator();
    }

    if (config == null) {
      return const SizedBox.square();
    }

    return const SizedBox(
      child: Text('Some content can be displayed here'),
    );
  }
}
