import 'package:doctor/Widgets/container.dart';
import 'package:doctor/Widgets/text.dart';
import 'package:doctor/Widgets/text_form.dart';
import 'package:doctor/bloc/home_bloc.dart';
import 'package:doctor/model/notes.dart';
import 'package:doctor/model/visits_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserVisits extends StatefulWidget {
  final int id;
  final String name;
  final Note note;
  Function function;
  UserVisits(
      {Key? key,
      required this.id,
      required this.name,
      required this.note,
      required this.function})
      : super(key: key);

  @override
  _UserVisitsState createState() => _UserVisitsState();
}

class _UserVisitsState extends State<UserVisits> {
  TextEditingController controller = TextEditingController();
  List<Visits> visits = [];
  String totalvisits = "";
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.function();

        Navigator.of(context).pop();
        return true;
      },
      child: BlocProvider(
        create: (context) => HomeBloc()..add(GetVisitsForUserEvent(widget.id)),
        child: Scaffold(
            key: scaffoldkey,
            body: ListView(
              children: [
                SizedBox(
                  height: h(50),
                ),
                SizedBox(
                  height: h(50),
                ),
                Container(
                  height: h(40),
                  color: Colors.blue[400],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      text(
                        fontWeight: FontWeight.bold,
                        text: "Name",
                        fontsize: 18.sp,
                        color: Colors.white,
                      ),
                      text(
                          fontWeight: FontWeight.bold,
                          text: "Dates",
                          fontsize: 18.sp,
                          color: Colors.white),
                    ],
                  ),
                ),
                SizedBox(
                  height: h(30),
                ),
                BlocConsumer<HomeBloc, HomeState>(
                  listener: (context, state) {
                    if (state is GetUserVisitsState) {
                      visits = state.visits;
                      totalvisits = state.visits.length.toString();
                    }
                  },
                  builder: (context, state) {
                    if (state is Loading) {
                      return const Center(child: LinearProgressIndicator());
                    }
                    return Column(
                      children: [
                        text(
                            text: "Total Visits $totalvisits",
                            fontsize: 16.sp,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                        SizedBox(
                          height: h(600),
                          child: ListView.builder(
                              itemCount: visits.length,
                              itemBuilder: (context, index) => Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: h(20)),
                                    child: container(
                                      hight: h(50),
                                      color: Colors.white,
                                      bordercolor: Colors.blue[200],
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              context.read<HomeBloc>().add(
                                                  DeleteVisit(
                                                      visits[index].visitid!,
                                                      widget.id,
                                                      int.parse(totalvisits),
                                                      widget.note));
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
                                          Container(
                                              alignment: Alignment.center,
                                              width: w(100),
                                              child: text(
                                                  fontWeight: FontWeight.bold,
                                                  fontsize: 18.sp,
                                                  text: visits[index].name)),
                                          Container(
                                            alignment: Alignment.center,
                                            width: w(100),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                text(
                                                    fontsize: 18.sp,
                                                    fontWeight: FontWeight.bold,
                                                    text: visits[index]
                                                        .date
                                                        .toString()),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                        ),
                      ],
                    );
                  },
                )
              ],
            )),
      ),
    );
  }
}
