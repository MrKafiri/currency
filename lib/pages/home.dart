import 'package:currency/models/currency.dart';
import 'package:currency/models/get_data.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future? currency;

  _fetchData() async {
    return await getData();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      currency = _fetchData();
    });
  }

  Future<void> _pullRefresh() async {
    setState(() {
      currency = _fetchData();
      _showSnakBar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          const SizedBox(width: 12),
          Image.asset('assets/images/icon.png'),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'قیمت طلا و ارز',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
          ),
          const Icon(
            Icons.menu,
            color: Colors.black,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset('assets/images/ic_quiz.png'),
                const SizedBox(width: 5),
                Text('قیمت بروز ارز چیست ؟',
                    style: Theme.of(context).textTheme.headline2)
              ],
            ),
            Text(
              ' نرخ ارزها در معاملات نقدی و رایج روزانه است معاملات نقدی معاملاتی هستند که خریدار و فروشنده به محض انجام معامله، ارز و ریال را با هم تبادل می نمایند.',
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.justify,
            ),
            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: Colors.grey[600]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'نام ازاد ارز',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Text(
                    'قیمت',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Text(
                    'تغییرات',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: currency,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return RefreshIndicator(
                        onRefresh: _pullRefresh,
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            Currency data = snapshot.data![index];
                            return _buildItemCurrency(data);
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error'));
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItemCurrency(Currency data) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(360),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            data.title.toString(),
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            data.price.toString(),
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            data.changes.toString(),
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: data.status == 'p' ? Colors.green : Colors.red,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  _showSnakBar() => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'بروزرسانی با موفقیت انجام شد.',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        backgroundColor: Colors.grey[600],
      ));
}
