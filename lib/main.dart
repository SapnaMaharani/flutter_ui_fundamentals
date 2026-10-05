import 'package:flutter/material.dart';

const nim = '2415051024';
const nama = 'Ni Putu Sapna Maharani';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CourseExplorer(),
    ),
  );
}


class CourseExplorer extends StatefulWidget {
  const CourseExplorer({super.key});

  @override
  State<CourseExplorer> createState() => _CourseExplorerState();
}


class _CourseExplorerState extends State<CourseExplorer> {

  int index = 0;


  final pages = const [
    CoursePage(),
    ProfilePage(),
  ];


  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(

      builder: (context, size){

        bool wide = size.maxWidth >= 800;


        return Scaffold(

          backgroundColor: const Color(0xffF8F5FF),


          appBar: AppBar(

            elevation:0,

            backgroundColor:
            Colors.transparent,

            title: const Text(

              "Course Explorer",

              style: TextStyle(
                color:Colors.deepPurple,
                fontWeight:FontWeight.bold,
              ),

            ),

          ),



          body: Row(

            children: [


              if(wide)

                NavigationRail(

                  selectedIndex:index,

                  onDestinationSelected:(i){

                    setState(() {
                      index=i;
                    });

                  },


                  destinations: const [

                    NavigationRailDestination(

                      icon:Icon(Icons.book),

                      label:Text("Courses"),

                    ),


                    NavigationRailDestination(

                      icon:Icon(Icons.person),

                      label:Text("Profile"),

                    ),

                  ],

                ),



              Expanded(

                child: pages[index],

              )

            ],

          ),




          bottomNavigationBar:

          wide

          ? null

          :

          NavigationBar(

            selectedIndex:index,


            onDestinationSelected:(i){

              setState(() {
                index=i;
              });

            },


            destinations: const [

              NavigationDestination(

                icon:Icon(Icons.book),

                label:"Courses",

              ),


              NavigationDestination(

                icon:Icon(Icons.person),

                label:"Profile",

              ),

            ],

          ),

        );

      },

    );

  }

}



// ================= COURSE PAGE =================


class CoursePage extends StatelessWidget {

  const CoursePage({super.key});


  final courses = const [

    "Responsive Layout",
    "Navigation",
    "Interaction",
    "Database",
    "Mobile Development",

  ];



  @override
  Widget build(BuildContext context) {


    return LayoutBuilder(

      builder:(context,size){


        bool grid = size.maxWidth >= 800;


        return SingleChildScrollView(

          padding:
          const EdgeInsets.all(20),


          child: Column(

            children: [


              StudentCard(),


              const SizedBox(height:20),



              grid

              ?

              GridView.count(

                shrinkWrap:true,

                physics:
                const NeverScrollableScrollPhysics(),

                crossAxisCount:2,

                children:

                courses.map(

                  (e)=>CourseCard(
                    title:e,
                  ),

                ).toList(),

              )


              :

              Column(

                children:

                courses.map(

                  (e)=>CourseCard(
                    title:e,
                  ),

                ).toList(),

              )

            ],

          ),

        );

      },

    );

  }

}



// ================= STUDENT CARD =================


class StudentCard extends StatelessWidget {

  const StudentCard({super.key});


  @override
  Widget build(BuildContext context){

    return Card(

      elevation:4,

      shape:RoundedRectangleBorder(

        borderRadius:
        BorderRadius.circular(20),

      ),


      child:ListTile(

        leading:
        const CircleAvatar(

          child:
          Icon(Icons.person),

        ),


        title:
        const Text(

          nim,

          style:TextStyle(
            fontWeight:FontWeight.bold,
          ),

        ),


        subtitle:
        const Text(nama),

      ),

    );

  }

}



// ================= COURSE CARD =================


class CourseCard extends StatefulWidget {

  final String title;


  const CourseCard({

    super.key,

    required this.title,

  });



  @override

  State<CourseCard> createState()
  => _CourseCardState();

}



class _CourseCardState extends State<CourseCard>{


  bool fav=false;



  @override

  Widget build(BuildContext context){


    return Card(

      margin:
      const EdgeInsets.all(8),


      elevation:4,


      shape:
      RoundedRectangleBorder(

        borderRadius:
        BorderRadius.circular(20),

      ),



      child:ListTile(


        leading:
        const CircleAvatar(

          backgroundColor:
          Color(0xffE5DBFF),

          child:
          Icon(
            Icons.computer,
            color:Colors.deepPurple,
          ),

        ),



        title:
        Text(

          widget.title,

          style:
          const TextStyle(
            fontWeight:FontWeight.bold,
          ),

        ),



        subtitle:
        const Text(
          "MOB Course",
        ),



        trailing:
        IconButton(

          icon:Icon(

            fav
            ?Icons.favorite
            :Icons.favorite_border,


            color:
            fav
            ?Colors.red
            :Colors.grey,

          ),


          onPressed:(){


            setState(() {

              fav=!fav;

            });


            ScaffoldMessenger.of(context)
            .showSnackBar(

              SnackBar(

                content:
                Text(

                  fav

                  ?"Added Favorite"

                  :"Removed Favorite",

                ),

              ),

            );


          },

        ),



        onTap:(){


          Navigator.push(

            context,

            MaterialPageRoute(

              builder:(context)

              =>DetailPage(

                course:
                widget.title,

              ),

            ),

          );

        },

      ),

    );

  }

}




// ================= DETAIL =================


class DetailPage extends StatelessWidget {

  final String course;


  const DetailPage({

    super.key,

    required this.course,

  });



  @override

  Widget build(BuildContext context){


    return Scaffold(


      appBar:
      AppBar(

        title:
        Text(course),

      ),


      body:
      Center(

        child:
        Text(

          "$course\n\n$nim\n$nama",

          textAlign:
          TextAlign.center,

          style:
          const TextStyle(
            fontSize:20,
          ),

        ),

      ),

    );

  }

}



// ================= PROFILE =================


class ProfilePage extends StatefulWidget {

  const ProfilePage({super.key});


  @override

  State<ProfilePage> createState()
  =>_ProfilePageState();

}



class _ProfilePageState extends State<ProfilePage>{


  final form =
  GlobalKey<FormState>();


  final comment =
  TextEditingController();



  @override
  Widget build(BuildContext context){


    return Center(

      child:
      SingleChildScrollView(

        padding:
        const EdgeInsets.all(20),


        child:
        Column(

          children:[


            const CircleAvatar(

              radius:65,

              backgroundImage:
              AssetImage(
                "assets/images/profile.png",
              ),

            ),



            const SizedBox(height:15),



            Text(

              nama,

              style:
              const TextStyle(

                fontSize:22,

                fontWeight:
                FontWeight.bold,

              ),

            ),


            Text(nim),



            const SizedBox(height:20),



            Form(

              key:form,


              child:
              Column(

                children:[


                  TextFormField(

                    controller:comment,

                    decoration:
                    const InputDecoration(

                      labelText:
                      "Feedback",

                    ),


                    validator:(v){

                      if(v==null ||
                      v.length<5){

                        return
                        "Minimal 5 karakter";

                      }

                      return null;

                    },

                  ),



                  ElevatedButton(

                    child:
                    const Text(
                      "Kirim",
                    ),


                    onPressed:(){


                      if(form.currentState!
                      .validate()){


                        ScaffoldMessenger.of(context)
                        .showSnackBar(

                          const SnackBar(

                            content:
                            Text(
                              "Feedback berhasil dikirim",
                            ),

                          ),

                        );

                      }


                    },

                  )

                ],

              ),

            )

          ],

        ),

      ),

    );

  }

}