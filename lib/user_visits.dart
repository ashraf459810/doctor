import 'package:doctor/Widgets/container.dart';
import 'package:doctor/Widgets/text.dart';
import 'package:doctor/Widgets/text_form.dart';
import 'package:doctor/bloc/home_bloc.dart';
import 'package:doctor/model/visits_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserVisits extends StatefulWidget {
  final int id;
  const UserVisits({Key? key, required this.id}) : super(key: key);

  @override
  _UserVisitsState createState() => _UserVisitsState();
}

class _UserVisitsState extends State<UserVisits> {
  TextEditingController controller = TextEditingController();
  List<Visits> visits = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(GetVisitsForUserEvent(widget.id)),
      child: Scaffold(
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
              }
            },
            builder: (context, state) {
              if (state is Loading) {
                return const Center(child: LinearProgressIndicator());
              }
              return SizedBox(
                height: h(600),
                child: ListView.builder(
                    itemCount: visits.length,
                    itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.symmetric(vertical: h(20)),
                          child: container(
                            hight: h(50),
                            color: Colors.white,
                            bordercolor: Colors.blue[200],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    alignment: Alignment.center,
                                    width: w(100),
                                    child: text(
                                        fontWeight: FontWeight.bold,
                                        fontsize: 18.sp,
                                        text: visits[index].id.toString())),
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
                                          text: visits[index].date.toString()),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
              );
            },
          )
        ],
      )),
    );
  }
}
