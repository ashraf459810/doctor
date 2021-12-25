import 'dart:developer';

import 'package:doctor/Widgets/container.dart';
import 'package:doctor/Widgets/nav.dart';
import 'package:doctor/Widgets/text.dart';
import 'package:doctor/Widgets/text_form.dart';
import 'package:doctor/model/notes.dart';
import 'package:doctor/search.dart';
import 'package:doctor/user_visits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'bloc/home_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Note> notes = [];
  HomeBloc homeBloc = HomeBloc();
  TextEditingController controller = TextEditingController();
  String? name;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(GetDataBaseEvent()),
      child: Scaffold(
          backgroundColor: Colors.grey[50],
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: h(120),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    container(
                        color: Colors.white,
                        borderRadius: 5,
                        hight: h(50),
                        width: w(200),
                        child: textform(
                            controller: controller,
                            hint: "Enter Name",
                            hintColor: Colors.black,
                            maxlines: 1,
                            hintsize: 12,
                            function: (val) {
                              name = val;
                            })),
                    Builder(builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          if (name != null) {
                            controller.clear();

                            int count = 1;

                            Note note = Note(name!, getCurrentDate(), count);
                            context.read<HomeBloc>().add(InserNoteEvent(note));
                          }
                        },
                        child: container(
                            color: Colors.blue,
                            borderRadius: 20,
                            hight: h(40),
                            width: w(50),
                            child: text(
                                fontWeight: FontWeight.bold,
                                fontsize: 12.sp,
                                text: "Add",
                                color: Colors.white)),
                      );
                    }),
                    GestureDetector(
                      onTap: () {
                        nav(context, const Search());
                      },
                      child: container(
                          color: Colors.blue,
                          borderRadius: 20,
                          hight: h(40),
                          width: w(50),
                          child: text(
                              fontWeight: FontWeight.bold,
                              fontsize: 12.sp,
                              text: "Search",
                              color: Colors.white)),
                    ),
                  ],
                ),
                SizedBox(
                  height: h(20),
                ),
                Container(
                  height: h(40),
                  color: Colors.blue[400],
                  child: Row(
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
                ),
                SizedBox(
                  height: h(30),
                ),
                BlocConsumer<HomeBloc, HomeState>(
                  listener: (context, state) {
                    if (state is Error) {
                      Fluttertoast.showToast(
                          msg: state.error,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                    if (state is GetDataBaseState) {
                      notes = state.notes;
                    }
                  },
                  builder: (context, state) {
                    if (state is Loading) {
                      // return const Center(child: LinearProgressIndicator());
                    }
                    return SizedBox(
                        height: h(530),
                        child: ListView.builder(
                          padding: EdgeInsets.only(bottom: 10),
                          itemCount: notes.length,
                          itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.symmetric(vertical: h(20)),
                            child: container(
                              hight: h(50),
                              bordercolor: Colors.blue[200],
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          context.read<HomeBloc>().add(
                                              DeleteUser(notes[index].id!));
                                        },
                                        child: Container(
                                          color: Colors.blue[400],
                                          width: w(30),
                                          height: h(35),
                                          child: const Center(
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                          onTap: () {
                                            nav(
                                                context,
                                                UserVisits(
                                                    id: notes[index].id!,
                                                    name: notes[index].name,
                                                    note: notes[index],
                                                    function: () {
                                                      context
                                                          .read<HomeBloc>()
                                                          .add(
                                                              GetDataBaseEvent());
                                                    }));
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: w(180),
                                            child: text(
                                                fontWeight: FontWeight.bold,
                                                text: notes[index].name,
                                                fontsize: 20.sp),
                                          )),
                                    ],
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: w(100),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        text(
                                            fontWeight: FontWeight.bold,
                                            text: notes[index]
                                                .visitNumber
                                                .toString(),
                                            fontsize: 20.sp),
                                        InkWell(
                                          onTap: () {
                                            log(notes[index].id.toString());
                                            context.read<HomeBloc>().add(
                                                AddVisitEvent(
                                                    getCurrentDate(),
                                                    // getCurrentDate(),
                                                    notes[index].id!,
                                                    notes[index].name,
                                                    notes[index].visitNumber +
                                                        1));
                                          },
                                          child: Container(
                                            height: h(35),
                                            width: w(30),
                                            color: Colors.blue[400],
                                            child: const Center(
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ));
                  },
                )
              ],
            ),
          )),
    );
  }

  String getCurrentDate() {
    DateTime dateToday =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    String currentDate =
        "${dateToday.year.toString()}-${dateToday.month.toString()}-${dateToday.day.toString()}";

    log(currentDate);

    return currentDate;
  }
}
