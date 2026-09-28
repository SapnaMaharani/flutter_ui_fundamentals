import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


const studentId = '2415051024';
const studentName = 'Ni Putu Sapna Maharani';


void main() => runApp(const MyApp());



Future<Map<String, dynamic>> loadData() async {

  final json = await rootBundle.loadString(
    'assets/data/student_data.json'
  );

  return jsonDecode(json);

}



class MyApp extends StatelessWidget {

  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Dashboard(),
    );

  }

}




class Dashboard extends StatelessWidget {

  const Dashboard({super.key});


  Widget profileCard(Map s){

    return Card(

      elevation: 3,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),

      child: ListTile(

        leading: const CircleAvatar(

          radius: 25,

          child: Icon(Icons.person),

        ),


        title: Text(

          studentName,

          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),

        ),


        subtitle: Text(

          '$studentId\n${s['class']}'

        ),

      ),

    );

  }





  Widget summaryCard(String title, String value){

    return Card(

      child: Padding(

        padding: const EdgeInsets.all(12),

        child: Column(

          children: [

            Text(title),

            Text(

              value,

              style: const TextStyle(

                fontSize: 22,

                fontWeight: FontWeight.bold,

              ),

            ),

          ],

        ),

      ),

    );

  }





  Widget courseCard(Map c){

    bool selesai = c['status'] == 'Selesai';


    return Card(

      elevation: 2,


      child: ListTile(


        leading: Icon(

          selesai
          ? Icons.check_circle
          : Icons.access_time,


          color: selesai
          ? Colors.green
          : Colors.orange,

        ),



        title: Text(

          c['title'],

          style: const TextStyle(

            fontWeight: FontWeight.bold,

          ),

        ),



        subtitle: Text(

          '${c['code']} | ${c['credits']} SKS',

        ),



        trailing: Text(

          c['status'],

          style: TextStyle(

            color: selesai
            ? Colors.green
            : Colors.orange,

          ),

        ),

      ),

    );

  }





  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(

        title: const Text(
          'Learning Dashboard'
        ),

        backgroundColor: Colors.blue,

      ),




      body: FutureBuilder(

        future: loadData(),


        builder: (context, snapshot) {



          if(snapshot.hasError){

            return const Center(

              child: Text(
                'Gagal memuat data JSON'
              ),

            );

          }




          if(!snapshot.hasData){

            return const Center(

              child: CircularProgressIndicator(),

            );

          }




          final data = snapshot.data!;


          final student = data['student'];

          final summary = data['summary'];

          final courses = data['courses'];





          return SingleChildScrollView(


            padding: const EdgeInsets.all(15),



            child: Column(


              crossAxisAlignment:
              CrossAxisAlignment.start,



              children: [



                profileCard(student),




                const SizedBox(
                  height: 15,
                ),




                Row(

                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,


                  children: [


                    summaryCard(

                      'Topik',

                      '${summary['total']}',

                    ),



                    summaryCard(

                      'SKS',

                      '${summary['credit']}',

                    ),



                  ],

                ),





                const SizedBox(
                  height: 15,
                ),




                const Text(

                  'Daftar Materi',

                  style: TextStyle(

                    fontSize: 18,

                    fontWeight: FontWeight.bold,

                  ),

                ),




                const SizedBox(
                  height: 10,
                ),





                ...courses.map(

                  (c)=>courseCard(c)

                ),




              ],

            ),


          );

        },

      ),

    );

  }

}