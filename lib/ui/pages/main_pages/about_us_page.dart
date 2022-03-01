import 'package:flutter/material.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/ui/widgets/header_color.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildHeaderColor(context),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 10),
              children: [
                buildHeader("The Vision Of The Center:"),
                buildParagraph(
                    "The center offers all the services of bicycles to all regions of the country with the appropriate amount of staff and initiatives that feed into the vision of the center, which aims to increase the number of users of bicycles by 2030, corresponding to the vision of the State of Qatar."),
                buildHeader("The Message Of The Center:"),
                buildParagraph(
                    "In line with the Ministry of Culture and Sport We are expanding the culture of bicycles in Qatari society, which makes us unique in this area and distinguishes us from others."),
                buildHeader("Institutional Values:"),
                buildParagraph(
                    "Raising awareness: achieving a lasting progress for young people in their surroundings and their rights and obligations towards their society, because if the mind is sought in reforming the body, we will achieve the principle of proper body in the proper mind."),
                buildParagraph(
                    "Raise the level of capacity: by giving young people the knowledge and technical skills they need to practice their hobbies and develop their technical and physical abilities that benefit them."),
                buildParagraph(
                    "Level of Practice: the center strives to achieve the right environment in order to exercise activity while maintaining technical and moral support, venues, time, tools and spaces for practice. Participation: by embedding the concept of team spirit among its members."),
                buildParagraph(
                    "Professionalism: providing the highest levels of professionalism to perform the desired role."),
                buildHeader("Strategic Objectives:"),
                buildParagraph(
                    "Expand the scope to increase the number of practitioners of this sport from all age groups. Promote the concept of health and eliminate the diseases of our time by regular practice as well as reduce spending on health-related issues. Raise the level of physical competence of practitioners."),
                buildParagraph(
                    "Raising the capacity of young people in leadership, taking responsibility and community responsibility."),
              ],
            ),
          ),
        ],
      ),
    );
  }

  HeaderColor buildHeaderColor(context) {
    final locale = AppLocalizations.of(context);

    return HeaderColor(
      hasTitle: true,
      hasBack: true,
      title: locale.get('About Us') ?? 'About Us',
    );
  }

  buildHeader(text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  buildParagraph(text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        text,
      ),
    );
  }
}
