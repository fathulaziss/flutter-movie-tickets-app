part of 'pages.dart';

class TopUpPage extends StatefulWidget {
  final PageEvent pageEvent;

  TopUpPage(this.pageEvent);

  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  TextEditingController amountController = TextEditingController(text: 'IDR 0');
  int selectedAmount = 0;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ThemeBloc>(context).add(
        ChangeTheme(ThemeData().copyWith(primaryColor: Color(0xFFE4E4E4))));

    double cardWidth =
        (MediaQuery.of(context).size.width - 2 * defaultMargin - 2 * 20) / 3;

    return WillPopScope(
      onWillPop: () async {
        context.read<PageBloc>().add(widget.pageEvent);
        return;
      },
      child: Scaffold(
          backgroundColor: Color(0xFF2C1F63),
          body: SafeArea(
            child: Container(
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      //note: BUTTON BACK
                      SafeArea(
                        child: Container(
                            margin:
                                EdgeInsets.only(top: 20, left: defaultMargin),
                            child: GestureDetector(
                              onTap: () {
                                context.read<PageBloc>().add(widget.pageEvent);
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                            )),
                      ),
                      //note: CONTENT
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: defaultMargin),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Top Up",
                              style: blackTextFont.copyWith(fontSize: 20),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextField(
                              onChanged: (text) {
                                String temp = '';

                                for (int i = 0; i < text.length; i++) {
                                  temp += text.isDigit(i) ? text[i] : '';
                                }

                                setState(() {
                                  selectedAmount = int.tryParse(temp) ?? 0;
                                });

                                amountController.text = NumberFormat.currency(
                                        locale: 'id_ID',
                                        symbol: 'IDR ',
                                        decimalDigits: 0)
                                    .format(selectedAmount);

                                amountController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: amountController.text.length));
                              },
                              controller: amountController,
                              decoration: InputDecoration(
                                  labelStyle: greyTextFont,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  labelText: "Amount"),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(top: 20, bottom: 20),
                              child: Text("Choose by Template",
                                  style: blackTextFont.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                            Wrap(
                              spacing: 20,
                              runSpacing: 14,
                              children: <MoneyCard>[
                                makeMoneyCard(amount: 50000, width: cardWidth),
                                makeMoneyCard(amount: 100000, width: cardWidth),
                                makeMoneyCard(amount: 150000, width: cardWidth),
                                makeMoneyCard(amount: 200000, width: cardWidth),
                                makeMoneyCard(amount: 250000, width: cardWidth),
                                makeMoneyCard(amount: 500000, width: cardWidth),
                                makeMoneyCard(
                                    amount: 1000000, width: cardWidth),
                                makeMoneyCard(
                                    amount: 2500000, width: cardWidth),
                                makeMoneyCard(
                                    amount: 5000000, width: cardWidth),
                              ],
                            ),
                            SizedBox(
                              height: 100,
                            ),
                            SizedBox(
                              width: 250,
                              height: 46,
                              child: BlocBuilder<UserBloc, UserState>(
                                  builder: (_, userState) => RaisedButton(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Text(
                                        "Top Up Now",
                                        style: whiteTextFont.copyWith(
                                            fontSize: 16,
                                            color: (selectedAmount > 0)
                                                ? Colors.white
                                                : Color(0xFFBEBEBE)),
                                      ),
                                      disabledColor: Color(0xFFE4E4E4),
                                      color: Color(0xFF3E9D9D),
                                      onPressed: (selectedAmount > 0)
                                          ? () {
                                              context.read<PageBloc>().add(
                                                  GoToSuccessPage(
                                                      null,
                                                      FlutixTransaction(
                                                          userID:
                                                              (userState
                                                                      as UserLoaded)
                                                                  .user
                                                                  .id,
                                                          title:
                                                              "Top Up Wallet",
                                                          amount:
                                                              selectedAmount,
                                                          subtitle:
                                                              "${DateTime.now().dayName}, ${DateTime.now().day} ${DateTime.now().monthName} ${DateTime.now().year}",
                                                          time:
                                                              DateTime.now())));
                                            }
                                          : null)),
                            ),
                            SizedBox(
                              height: 100,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  MoneyCard makeMoneyCard({int amount, double width}) {
    return MoneyCard(
      amount: amount,
      width: width,
      isSelected: amount == selectedAmount,
      onTap: () {
        setState(() {
          if (selectedAmount != amount) {
            selectedAmount = amount;
          } else {
            selectedAmount = 0;
          }

          amountController.text = NumberFormat.currency(
                  locale: 'id_ID', decimalDigits: 0, symbol: 'IDR ')
              .format(selectedAmount);

          amountController.selection = TextSelection.fromPosition(
              TextPosition(offset: amountController.text.length));
        });
      },
    );
  }
}
