import 'package:doctor/Widgets/container.dart';
import 'package:doctor/Widgets/text_form.dart';
import 'package:doctor/model/visits_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Widgets/text.dart';
import 'bloc/home_bloc.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late DateTime dateTime1;
  late DateTime dateTime2;
  String? name;
  List<Visits> visits = [];
  TextEditingController namec = TextEditingController();

  @override
  void initState() {
    dateTime1 = DateTime.now();
    dateTime2 = DateTime.now();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: h(70),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 1),
            child: Column(
              children: [
                Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.blue)),
                  child: ListTile(
                      title: Text(
                        "From    ${dateTime1.year}-${dateTime1.month}-${dateTime1.day}",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_down),
                      onTap: () {
                        _pickeddate();
                      }),
                ),
                Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.blue)),
                  child: ListTile(
                    title: Text(
                      "To         ${dateTime2.year}-${dateTime2.month}-${dateTime2.day}",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_down),
                    onTap: () {
                      _pickeddate2();
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: h(30),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              container(
                  hight: h(60),
                  width: w(200),
                  bordercolor: Colors.blue,
                  child: textform(
                      padding: EdgeInsets.all(h(10)),
                      controller: namec,
                      function: (val) {
                        name = val;
                      },
                      hintsize: 16.sp,
                      hint: "Enter name"),
                  borderRadius: 10),
              Builder(builder: (context) {
                return GestureDetector(
                  onTap: () {
                    context.read<HomeBloc>().add(SearchEvent(
                        "${dateTime1.year}-${dateTime1.month}-${dateTime1.day}",
                        name ?? "empty",
                        "${dateTime2.year}-${dateTime2.month}-${dateTime2.day}"));
                  },
                  child: container(
                      hight: h(60),
                      width: w(100),
                      bordercolor: Colors.blue,
                      color: Colors.blue,
                      child: text(
                          text: "Search",
                          color: Colors.white,
                          fontsize: 16.sp,
                          fontWeight: FontWeight.bold),
                      borderRadius: 10),
                );
              }),
            ],
          ),
          SizedBox(
            height: h(30),
          ),
          container(
              color: Colors.blue,
              hight: h(500),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    text(
                        text: "Name",
                        fontsize: 18.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    text(
                        text: "Visits",
                        fontsize: 20.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ],
                ),
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    // if (state is Loading) {
                    //   return const Center(child: LinearProgressIndicator());
                    // }
                    if (state is SearchState) {
                      visits = state.visits;
                    }
                    return container(
                      hight: h(460),
                      child: ListView.builder(
                        itemCount: visits.length,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.symmetric(vertical: h(20)),
                          child: container(
                            hight: h(50),
                            bordercolor: Colors.blue[200],
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: w(180),
                                  child: text(
                                      fontWeight: FontWeight.bold,
                                      text: visits[index].name,
                                      fontsize: 20.sp),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: w(140),
                                  child: text(
                                      fontWeight: FontWeight.bold,
                                      text: visits[index].date,
                                      fontsize: 20.sp),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              ]))
        ]),
      )),
    );
  }

  _pickeddate() async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: dateTime1,
    );
    if (date != null) {
      setState(() {
        dateTime1 = date;
      });
    }
  }

  _pickeddate2() async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: dateTime2,
    );
    if (date != null) {
      setState(() {
        dateTime2 = date;
      });
    }
  }
}
