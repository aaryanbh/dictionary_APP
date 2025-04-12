import 'package:dictionary/dictionary_model.dart';
import 'package:dictionary/services.dart';
import 'package:flutter/material.dart';

class DictionaryHomePage extends StatefulWidget {
  const DictionaryHomePage({super.key});

  @override
  State<DictionaryHomePage> createState() => _DictionaryHomePageState();
}

class _DictionaryHomePageState extends State<DictionaryHomePage> {
  DictionaryModel? myDictionaryModel;
  bool isLoading = false;
  String noDataFound = "Now you can search";

  searchContain(String word) async {
    setState(() {
      isLoading = true;
    });
    try {
      myDictionaryModel = await APIservices.fetchData(word);
      if (myDictionaryModel == null) {
        noDataFound = "Meaning can't be found";
      }
    } catch (e) {
      myDictionaryModel = null;
      noDataFound = "Meaning can't be found";
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dictionary"),
        elevation: 10,
        titleTextStyle: const TextStyle(color: Colors.blueGrey, fontSize: 24),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            // Search bar
            SearchBar(
              hintText: "Search the word here",
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  searchContain(value);
                }
              },
            ),
            const SizedBox(height: 15),
            if (isLoading)
              const LinearProgressIndicator()
            else if (myDictionaryModel != null)
              Expanded(

                child: ListView(
                  children: [
                    const SizedBox(height: 15),
                    Text(
                      myDictionaryModel!.word,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      myDictionaryModel!.phonetics.isNotEmpty
                          ? myDictionaryModel!.phonetics[0].text ?? ""
                          : "",
                    ),
                    const SizedBox(height: 15),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: myDictionaryModel!.meanings.length,
                      itemBuilder: (context, index) {
                        return showMeaning(
                          myDictionaryModel!.meanings[index],
                        );
                      },
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: Center(
                  child: Text(
                    noDataFound,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget showMeaning(Meaning meaning) {
    String wordDefinition = "";
    for (var element in meaning.definitions) {
      int index = meaning.definitions.indexOf(element);
      wordDefinition += "\n${index + 1}. ${element.definition}\n";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(//IT The Material widget is the core visual representation of the Material Design "sheet" in Flutter. It gives your widget the look and feel of a card, dialog, button, etc., with elevation, shape, shadows, and ripple effects.
        elevation: 2,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meaning.partOfSpeech,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Definitions:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              Text(
                wordDefinition,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
