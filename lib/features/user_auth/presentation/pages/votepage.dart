import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VotingPage extends StatefulWidget {
 @override
 _VotingPageState createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {
 bool userFound = false;
 bool casted = false;

 @override
 Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String? myUid = user?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Voting Page'),
        actions: <Widget>[
          Center(
            child: Text('User ID: $myUid'), // Display the actual user ID
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: TextButton(
                 onPressed: () {
                    Navigator.pushNamed(context, "/login");
                 },
                 child: Text('Logout', style: TextStyle(color: Colors.white)),
                 style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                 ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          votingOption('Ali', 'assets/1.jpg'),
          votingOption('Ahmed', 'assets/2.jpg'),
          votingOption('Umer', 'assets/3.jpg'),
        ],
      ),
    );
 }

 Widget votingOption(String name, String imagePath) {
    String candidateId = name.toLowerCase();

    CollectionReference pti = FirebaseFirestore.instance.collection('Pti');
    CollectionReference pmln = FirebaseFirestore.instance.collection('Pmln');
    CollectionReference ppp = FirebaseFirestore.instance.collection('PPP');
    CollectionReference voter = FirebaseFirestore.instance.collection('voters');

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String? myUid = user?.uid;

    Future<void> addVoter(String myUid) {
      return voter
          .add({'userId': myUid})
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    Future<void> updateUser(String candidateId) {
      if (candidateId == 'pti') {
        return pti
            .doc('Co5TWdAsc6TMhTgTgIGe') // Use the specified document ID
            .update({
              'Votes':
                  FieldValue.increment(1), // Increment the Votes attribute by 1
            })
            .then((value) => print("User Updated"))
            .catchError((error) => print("Failed to update user: $error"));
      } else if (candidateId == 'pmln') {
        return pmln
            .doc('G5goUDPjlQGaJQsp5lxn') // Use the specified document ID
            .update({
              'votes':
                  FieldValue.increment(1), // Increment the Votes attribute by 1
            })
            .then((value) => print("User Updated"))
            .catchError((error) => print("Failed to update user: $error"));
      } else {
        return ppp
            .doc('IX4VRHrvQq3NDQVhG7XZ') // Use the specified document ID
            .update({
              'Votes':
                  FieldValue.increment(1), // Increment the Votes attribute by 1
            })
            .then((value) => print("User Updated"))
            .catchError((error) => print("Failed to update user: $error"));
      }
    }

    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: <Widget>[
          Text(name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Image.asset(imagePath, height: 300, width: 700),
          SizedBox(height: 10),
          FutureBuilder<QuerySnapshot>(
            future: voter.where('userId', isEqualTo: myUid).get(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.done) {
                userFound = snapshot.data!.docs.isNotEmpty;
                return ElevatedButton(
                 onPressed: userFound
                      ? () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('ERROR:This user has already cast a vote!'),
                                content: Text('Thank You.'),
                                actions: <Widget>[
                                 TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                 ),
                                ],
                              );
                            },
                          );
                      }
                      : () {
                          updateUser(candidateId);
                          addVoter(myUid!);
                          casted = true;
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Vote Casted!'),
                                content: Text('Thank You.'),
                                actions: <Widget>[
                                 TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                 ),
                                ],
                              );
                            },
                          );
                        },
                 child: Text('Vote'),
                 style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                 ),
                );
              }

              return Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
 }
}