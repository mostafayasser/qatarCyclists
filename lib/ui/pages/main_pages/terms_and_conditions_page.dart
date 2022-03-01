import 'package:flutter/material.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';

import 'package:qatarcyclists/ui/widgets/header_color.dart';

class TermsAndConditionsPage extends StatelessWidget {
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
                buildHeader("Terms and Conditions of Qatar Cyclists"),
                buildParagraph(
                    "The following terms and conditions (collectively, these \"Terms and Conditions\") apply to your use of Qatar Cyclists, including any content, functionality and services offered on or via Qatar Cyclists (the \"Website\" or the \"Application\")."),
                buildParagraph(
                    "Please read the Terms and Conditions carefully before you start using Qatar Cyclists, because by using the Website/Application you accept and agree to be bound and abide by these Terms and Conditions."),
                buildParagraph(
                    "These Terms and Conditions are effective as of October 14, 2018. We expressly reserve the right to change these Terms and Conditions from time to time without notice to you. You acknowledge and agree that it is your responsibility to review this Website/Application and these Terms and Conditions from time to time and to familiarize yourself with any modifications. Your continued use of this Website/Application after such modifications will constitute acknowledgement of the modified Terms and Conditions and agreement to abide and be bound by the modified Terms and Conditions."),
                buildHeader("Conduct on Website/Application"),
                buildParagraph(
                    "Your use of the Website is subject to all applicable laws and regulations, and you are solely responsible for the substance of your communications through the Website."),
                buildParagraph(
                    "By posting information in or otherwise using any communications service, chat room, message board, newsgroup, software library, or other interactive service that may be available to you on or through this Website, you agree that you will not upload, share, post, or otherwise distribute or facilitate distribution of any content \n — including text, communications, software, images, sounds, data, or other information —that:"),
                buildParagraph(
                    "- Is unlawful, threatening, abusive, harassing, defamatory, libelous, deceptive, fraudulent, invasive of another's privacy, tortious, contains explicit or graphic descriptions or accounts of sexual acts (including but not limited to sexual language of a violent or threatening nature directed at another individual or group of individuals), or otherwise violates our rules or policies"),
                buildParagraph(
                    "- Victimizes, harasses, degrades, or intimidates an individual or group of individuals on the basis of religion, gender, sexual orientation, race, ethnicity, age, or disability"),
                buildParagraph(
                    "- Infringes on any patent, trademark, trade secret, copyright, right of publicity, or other proprietary right of any party"),
                buildParagraph(
                    "- Constitutes unauthorized or unsolicited advertising, junk or bulk email (also known as \"spamming\"), chain letters, any other form of unauthorized solicitation, or any form of lottery or gambling"),
                buildParagraph(
                    "- Contains software viruses or any other computer code, files, or programs that are designed or intended to disrupt, damage, or limit the functioning of any software, hardware, or telecommunications equipment or to damage or obtain unauthorized access to any data or other information of any third party"),
                buildParagraph(
                    "- Impersonates any person or entity, including any of our employees or representatives."),
                buildParagraph(
                    "We neither endorse nor assume any liability for the contents of any material uploaded or submitted by third party users of the Website.We generally do not pre-screen, monitor, or edit the content posted by users of communications services, chat rooms, message boards, newsgroups, software libraries, or other interactive services that may be available on or through this Website."),
                buildParagraph(
                    "However, we and our agents have the right at their sole discretion to remove any content that, in our judgment, does not comply with these Terms of Use and any other rules of user conduct for our Website, or is otherwise harmful, objectionable, or inaccurate. We are not responsible for any failure or delay in removing such content. You hereby consent to such removal and waive any claim against us arising out of such removal of content."),
                buildParagraph(
                    "You agree that we may at any time, and at our sole discretion, terminate your membership, account, or other affiliation with our site without prior notice to you for violating any of the above provisions. In addition, you acknowledge that we will cooperate fully with investigations of violations of systems or network security at other sites, including cooperating with law enforcement authorities in investigating suspected criminal violations."),
                buildHeader("Intellectual Property"),
                buildParagraph(
                    "By accepting these Terms and Conditions, you acknowledge and agree that all content presented to you on this Website is protected by copyrights, trademarks, service marks, patents or other proprietary rights and laws, and is the sole property of Qatar Cyclists."),
                buildParagraph(
                    "You are only permitted to use the content as expressly authorized by us or the specific content provider. Except for a single copy made for personal use only, you may not copy, reproduce, modify, republish, upload, post, transmit, or distribute any documents or information from this Website in any form or by any means without prior written permission from us or the specific content provider, and you are solely responsible for obtaining permission before reusing any copyrighted material that is available on this Website."),
                buildHeader("Third Party Websites"),
                buildParagraph(
                    "This Website may link you to other sites on the Internet or otherwise include references to information, documents, software, materials and/or services provided by other parties. These websites may contain information or material that some people may find inappropriate or offensive."),
                buildParagraph(
                    "These other websites and parties are not under our control, and you acknowledge that we are not responsible for the accuracy, copyright compliance, legality, decency, or any other aspect of the content of such sites, nor are we responsible for errors or omissions in any references to other parties or their products and services. The inclusion of such a link or reference is provided merely as a convenience and does not imply endorsement of, or association with, the Website or party by us, or any warranty of any kind, either express or implied."),
                buildHeader(
                    "Disclaimer of Warranties, Limitations of Liability and Indemnification"),
                buildParagraph(
                    "Your use of Qatar Cyclists is at your sole risk. The Website is provided \"as is\" and \"as available\". We disclaim all warranties of any kind, express or implied, including, without limitation, the warranties of merchantability, fitness for a particular purpose and non-infringement."),
                buildParagraph(
                    "We are not liable for damages, direct or consequential, resulting from your use of the Website, and you agree to defend, indemnify and hold us harmless from any claims, losses, liability costs and expenses (including but not limited to attorney's fees) arising from your violation of any third-party's rights. You acknowledge that you have only a limited, non-exclusive, nontransferable license to use the Website. Because the Website is not error or bug free, you agree that you will use it carefully and avoid using it ways which might result in any loss of your or any third party's property or information."),
                buildHeader("Term and termination"),
                buildParagraph(
                    "This Terms and Conditions will become effective in relation to you when you create a Qatar Cyclists account or when you start using the Qatar Cyclists and will remain effective until terminated by you or by us."),
                buildParagraph(
                    "Qatar Cyclists reserves the right to terminate this Terms and Conditions or suspend your account at any time in case of unauthorized, or suspected unauthorized use of the Website whether in contravention of this Terms and Conditions or otherwise. If Qatar Cyclists terminates this Terms and Conditions, or suspends your account for any of the reasons set out in this section, Qatar Cyclists shall have no liability or responsibility to you."),
                buildHeader("Assignment"),
                buildParagraph(
                    "Qatar Cyclists may assign this Terms and Conditions or any part of it without restrictions. You may not assign this Terms and Conditions or any part of it to any third party."),
                buildHeader("Governing Law"),
                buildParagraph(
                    "These Terms and Conditions and any dispute or claim arising out of, or related to them, shall be governed by and construed in accordance with the internal laws of the Qatar without giving effect to any choice or conflict of law provision or rule.Any legal suit, action or proceeding arising out of, or related to, these Terms of Service or the Website shall be instituted exclusively in the federal courts of Qatar.")
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
      title: locale.get('Terms and Conditions') ?? 'Terms and Conditions',
      //titleImage: 'settings.png',
      //titleImageColor: AppColors.accentElement,
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
