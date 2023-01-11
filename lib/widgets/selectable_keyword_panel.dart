import 'package:flutter/material.dart';


import '../theme/text_theme.dart';

class SelectableKeywordPanel extends StatefulWidget {
  const SelectableKeywordPanel({super.key});

  @override
  State<SelectableKeywordPanel> createState() => _SelectableKeywordPanelState();
}

class _SelectableKeywordPanelState extends State<SelectableKeywordPanel> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          const Text(
            'Styles',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.pink,
                fontFamily: 'JuliusSansOne',
                fontSize: 20,
                fontWeight: FontWeight.normal,
                height: 1),
          ),
          const SizedBox(
            height: 25,
          ),
          const Text('Sketch',
              textAlign: TextAlign.left, style: TextStyles.chipTextStyle),
          const SizedBox(
            height: 13,
          ),
          const TokenBlock(),
          const SizedBox(
            height: 25,
          ),
          const Text('Effect',
              textAlign: TextAlign.left, style: TextStyles.chipTextStyle),
          const SizedBox(
            height: 13,
          ),
          const TokenBlock(),
          const SizedBox(
            height: 25,
          ),
          const Text('Color',
              textAlign: TextAlign.left, style: TextStyles.chipTextStyle),
          const SizedBox(
            height: 13,
          ),
          const TokenBlock(),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Counter(),
              CreateButton(width: 100, height: 58, txt: "CREATE")
            ],
          )
        ],
      ),
    );
  }
}

//Token
class ChipToken extends StatefulWidget {
  final String tokenname;
  final double width;
  final double height;
  const ChipToken(
      {super.key,
      required this.tokenname,
      required this.width,
      required this.height});

  @override
  State<ChipToken> createState() => _ChipTokenState();
}

class _ChipTokenState extends State<ChipToken> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() {}),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: const Color(0xFFF76691),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                color: Colors.black12),
          ),
          Opacity(
            opacity: 0.85,
            child: Container(
                width: widget.width,
                height: widget.height,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  image: DecorationImage(
                      image: AssetImage('assets/images/rectangle.png'),
                      fit: BoxFit.fitWidth),
                )),
          ),
          Text(
            widget.tokenname,
            textAlign: TextAlign.left,
            style: const TextStyle(
                color: Colors.pink,
                fontFamily: 'Jost',
                fontSize: 16,
                fontWeight: FontWeight.normal,
                height: 1),
          )
        ],
      ),
    );
  }
}

//one row of tokens
class TokenBlock extends StatefulWidget {
  const TokenBlock({super.key});

  @override
  State<TokenBlock> createState() => _TokenBlockState();
}

class _TokenBlockState extends State<TokenBlock> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        ChipToken(
          tokenname: "blur",
          width: 75,
          height: 29,
        ),
        ChipToken(
          tokenname: "blur",
          width: 75,
          height: 29,
        ),
        ChipToken(
          tokenname: "blur",
          width: 75,
          height: 29,
        ),
        ChipToken(
          tokenname: "blur",
          width: 75,
          height: 29,
        ),
      ],
    );
  }
}

//counter widget
class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 1;
  void increment() {
    setState(() {
      count++;
    });
  }

  void decrement() {
    setState(() {
      count--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      InkWell(
        child: Stack(alignment: Alignment.center, children: [
          Opacity(
            opacity: 0.25,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFFF76691),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
              ),
            ),
          ),
          const Icon(
            Icons.remove,
            color: Color(0xFFF76691),
          )
        ]),
        onTap: () {
          if (count != 1) decrement();
        },
      ),
      SizedBox(
        width: 32,
        height: 32,
        child: Center(
          child: Text(
            "$count",
            style: const TextStyle(color: Colors.pink),
          ),
        ),
      ),
      InkWell(
        child: Stack(alignment: Alignment.center, children: [
          Opacity(
            opacity: 0.25,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFFF76691),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
            ),
          ),
          const Icon(
            Icons.add,
            color: Color(0xFFF76691),
          )
        ]),
        onTap: () {
          if (count < 10) increment();
        },
      ),
    ]);
  }
}

class CreateButton extends StatefulWidget {
  final double width;
  final double height;
  final String txt;
  const CreateButton(
      {super.key,
      required this.width,
      required this.height,
      required this.txt});
  @override
  State<CreateButton> createState() => _CreateButtonState();
}

class _CreateButtonState extends State<CreateButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() {
        
      }),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: const Color(0xFFF76691),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              color: Colors.black12,
            ),
          ),
          Opacity(
            opacity: 0.75,
            child: Container(
                width: widget.width,
                height: widget.height,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  image: DecorationImage(
                      image: AssetImage('assets/images/create_button.png'),
                      fit: BoxFit.fitWidth),
                )),
          ),
          const Text(
            'CREATE',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Color(0xFFF76691),
                fontFamily: 'Jost',
                fontSize: 20,
                fontWeight: FontWeight.normal,
                height: 1),
          )
        ],
      ),
    );
  }
}
