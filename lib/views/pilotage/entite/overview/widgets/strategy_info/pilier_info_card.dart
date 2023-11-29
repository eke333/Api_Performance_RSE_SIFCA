import 'package:flutter/material.dart';
import '../../../../../../constants/constant_colors.dart';
import '../../../../../../constants/constant_double.dart';
import 'pilier_model.dart';

class PilierInfoCard extends StatefulWidget {
  final PilierInfoModel info;
  const PilierInfoCard({super.key, required this.info});

  @override
  State<PilierInfoCard> createState() => _PilierInfoCardState();
}

class _PilierInfoCardState extends State<PilierInfoCard> {
  double isHovering = 3;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: (){},
      onHover: (value){
        if(value){
          setState(() {
            isHovering = 10;
          });
        }else {
          setState(() {
            isHovering =3;
          });
        }
      },
      child: Card(
        elevation: isHovering,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(defaultPadding * 0.25),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: widget.info.color!.withOpacity(0.1),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Image.asset(
                      widget.info.svgSrc!,
                    ),
                  ),
                  Text("${widget.info.percentage} %",style: TextStyle(
                      color: widget.info.percentage! < 30 ?  Colors.red :
                      widget.info.percentage! < 60 ? Colors.yellow : widget.info.percentage! < 75 ?
                      Colors.green : Colors.blue,fontWeight: FontWeight.bold
                  ),)
                ],
              ),
              Text(
                widget.info.title!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              ProgressLine(
                color: widget.info.color,
                percentage: widget.info.percentage,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${widget.info.numOfFiles} indicateurs sur",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black87),
                  ),
                  Text(
                    widget.info.totalStorage!,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}



class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color? color;
  final int? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
