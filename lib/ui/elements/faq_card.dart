import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';

class FAQCard extends StatelessWidget {
  final List<String> _faqHeaders;
  final List<String> _faqResponses;

  FAQCard(this._faqHeaders, this._faqResponses);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 16, horizontal: SizeConfig.blockSizeHorizontal * 5),
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 0,
            color: Color(0xffD7B56D).withOpacity(0.3),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "FAQs",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _faqHeaders.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (ctx, i) {
              return FAQCardItems(
                idx: i,
                itemHeader: _faqHeaders[i],
                itemResponse: _faqResponses[i],
              );
            },
          )
        ],
      ),
    );
  }
}

class FAQCardItems extends StatefulWidget {
  final int idx;
  final String itemHeader;
  final String itemResponse;

  FAQCardItems(
      {@required this.idx,
      @required this.itemHeader,
      @required this.itemResponse});

  @override
  _FAQCardItemsState createState() => _FAQCardItemsState();
}

class _FAQCardItemsState extends State<FAQCardItems> {
  bool open = false;

  void toggleContainerHeight() {
    if (!open) {
      setState(() {
        open = true;
      });
    } else {
      setState(() {
        open = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: toggleContainerHeight,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.itemHeader,
                  softWrap: true,
                  maxLines: 2,
                  style: TextStyle(
                      fontWeight: !open ? FontWeight.w300 : FontWeight.w700),
                ),
              ),
              IconButton(
                onPressed: toggleContainerHeight,
                icon: Icon(
                  !open ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                ),
              ),
            ],
          ),
          AnimatedContainer(
            curve: Curves.fastOutSlowIn,
            duration: Duration(milliseconds: 500),
            height: open ? MediaQuery.of(context).size.height * 0.15 : 0,
            padding: EdgeInsets.only(
              right: 30,
            ),
            width: double.infinity,
            child: Text(
              widget.itemResponse,
              style: TextStyle(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
