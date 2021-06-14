import 'package:education_assistant/cubit/auth/auth_cubit.dart';
import 'package:education_assistant/cubit/subjects/groups_cubit.dart';
import 'package:education_assistant/cubit/users/users_cubit.dart';
import 'package:education_assistant/models/user_model.dart';
import 'package:education_assistant/screens/auth_screen/auth_screen.dart';
import 'package:education_assistant/cubit/subjects/subjects_cubit.dart';
import 'package:education_assistant/screens/home_screen/screens/groups/groups_screen.dart';
import 'package:education_assistant/screens/home_screen/screens/subjects/subjects_screen.dart';
import 'package:education_assistant/screens/home_screen/screens/teachers_list/teachers_screen.dart';
import 'package:education_assistant/screens/home_screen/tabs/Marks_tab.dart';
import 'package:education_assistant/screens/home_screen/tabs/endTime_tab.dart';
import 'package:education_assistant/screens/home_screen/tabs/homeWork_tab.dart';
import 'package:education_assistant/screens/home_screen/tabs/rings_tab.dart';
import 'package:education_assistant/screens/home_screen/tabs/schedule_tab.dart';
import 'package:education_assistant/utils/navigation_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  AuthCubit authCubit;
  UsersCubit usersCubit;
  SubjectsCubit subjectsCubit;
  UserModel currentUser;
  GroupsCubit groupsCubit;



  List<String> titles = <String>['Розклад', 'Оцінки', 'Час', 'Дзвінки', 'Д/З'];
  int currentIndex = 0;
  int appBarIndex = 0;

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'ПН'),
    Tab(text: 'ВТ'),
    Tab(text: 'СР'),
    Tab(text: 'ЧТ'),
    Tab(text: 'ПТ'),
    Tab(text: 'СБ'),
    Tab(text: 'НД'),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    authCubit = BlocProvider.of<AuthCubit>(context);
    usersCubit = BlocProvider.of<UsersCubit>(context);
    groupsCubit = BlocProvider.of<GroupsCubit>(context);
    subjectsCubit = BlocProvider.of<SubjectsCubit>(context);
    groupsCubit.loadInitialData();
    usersCubit.loadInitialData();
    subjectsCubit.loadInitialData();
    currentUser = authCubit.state.currentUser;
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var bottomNavBarTabs = <Widget>[
      ScheduleTab(dayIndex: appBarIndex),
      MarkTab(),
      EndTimeTab(),
      RingsTab(),
      HomeWorkTab(),
    ];

    return Scaffold(
      appBar: getAppBar(),
      body: bottomNavBarTabs[currentIndex],
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(currentUser.name),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text('ПЗПІ-19-7'),
                  ),
                ],
              ),
              accountEmail: Text(currentUser.email),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(currentUser.imageUrl),
                radius: 30,
              ),
            ),
            ListTile(
              leading: Icon(Icons.library_books_sharp),
              title: Text('Список предметів'),
              onTap: () {
                NavigationUtils.toScreen(context, screen: SubjectsScreen());
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Викладачі'),
              onTap: () {
                NavigationUtils.toScreen(context,
                    screen: const TeachersScreen());
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Групи'),
              onTap: () {
                NavigationUtils.toScreen(context,
                    screen: const GroupsScreen());
              },
            ),
            ListTile(
              leading: Icon(Icons.apps),
              title: Text('Мої предмети'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.text_snippet_outlined),
              title: Text('Нотатки'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Налаштування'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Про додаток'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app_sharp),
              title: Text('Вийти'),
              onTap: () async {
                await authCubit.googleLogOut();
                await NavigationUtils.toScreenRemoveUntil(context,
                    screen: AuthScreen());
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 28,
        fixedColor: Colors.white,
        backgroundColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Розклад',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_rate),
            label: 'Оцінки',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Час',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            label: 'Дзвінки',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Д/З',
          ),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  Widget getAppBar() {
    var appBarTabs = <Widget>[
      AppBar(
        centerTitle: true,
        title: Text(titles[currentIndex]),
        bottom: TabBar(
          onTap: (index) {
            setState(() {
              appBarIndex = index;
            });
          },
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      AppBar(
        centerTitle: true,
        title: Text(titles[currentIndex]),
      ),
      AppBar(
        centerTitle: true,
        title: Text(titles[currentIndex]),
      ),
      AppBar(
        centerTitle: true,
        title: Text(titles[currentIndex]),
      ),
      AppBar(
        centerTitle: true,
        title: Text(titles[currentIndex]),
      ),
    ];

    return appBarTabs[currentIndex];
  }
}
