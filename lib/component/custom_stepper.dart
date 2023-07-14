import 'package:client/component/dotted_line.dart';
import 'package:client/screens/booking/book_service_screen.dart';
import 'package:client/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

PageController customStepperController = PageController(initialPage: 0);

class CustomStepper extends StatefulWidget {
  final List<CustomStep> stepsList;

  CustomStepper({required this.stepsList});

  @override
  _CustomStepperState createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  Widget buildStepDivider(int index) {
    return DottedLine(
      dashColor: index < currentPage ? Theme.of(context).primaryColor : primaryColor.withOpacity(0.3),
      lineThickness: 1.5,
    ).withWidth(50);
  }

  Widget buildStep(int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index <= currentPage ? Theme.of(context).primaryColor : Colors.transparent,
                border: Border.all(color: index <= currentPage ? Colors.transparent : context.dividerColor),
              ),
              padding: EdgeInsets.all(20),
              child: Text("${(index + 1)}", style: boldTextStyle(color: index <= currentPage ? Colors.transparent : Colors.grey), maxLines: 1),
            ),
            Icon(Icons.done, color: index <= currentPage ? Colors.white : Colors.transparent),
          ],
        ),
        8.height,
        Marquee(child: Text(widget.stepsList[index].title, textAlign: TextAlign.center, style: boldTextStyle(color: index <= currentPage ? textPrimaryColorGlobal : Colors.grey))).expand()
      ],
    );
  }

  Widget _buildStepper(int currentStep) {
    return Container(
      height: 100,
      width: context.width() * 0.8,
      child: Row(
        children: List.generate(
          widget.stepsList.length,
          (index) {
            if (index < widget.stepsList.length - 1)
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildStep(index),
                  Offstage(),
                  buildStepDivider(index).paddingBottom(16),
                ],
              ).expand(flex: widget.stepsList.length);
            else
              return buildStep(index).expand();
          },
        ),
      ),
    ).center();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildStepper(currentPage).paddingOnly(left: 16, top: 16, right: 16, bottom: 16),
        Expanded(
          child: PageView.builder(
            controller: customStepperController,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(
                () {
                  currentPage = index;
                },
              );
            },
            itemCount: widget.stepsList.length,
            itemBuilder: (ctx, index) => widget.stepsList[index].page,
          ),
        ),
      ],
    );
  }
}
