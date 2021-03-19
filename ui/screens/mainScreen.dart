import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mobile_551/core/utils/utils.dart';
import 'package:mobile_551/ui/components/customCard.dart';
import 'package:mobile_551/ui/components/customDivider.dart';
import 'package:mobile_551/ui/screens/infoDetailScreen.dart';
import 'package:mobile_551/ui/screens/memberAreaScreen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatelessWidget {
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: SizedBox(
          height: 50,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/logo-new.png"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/ap2li.png"),
              ),
              Text(
                "PT Sinar Sukses Impian",
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        elevation: 10,
        backgroundColor: Colors.white,
      ),
      body: ListView(children: [
        // Image.asset(
        //   "assets/logo-new.png",
        //   height: 100,
        // ),
        SizedBox(
          height: 200,
          child: Carousel(
            autoplayDuration: Duration(seconds: 10),
            dotBgColor: Colors.transparent,
            dotColor: Colors.transparent,
            dotIncreaseSize: 0,
            onImageChange: (index, page) {
              pageController.animateToPage(page, duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
            },
            images: [
              GestureDetector(
                onTap: () {},
                child: Image(
                  image: AssetImage("assets/home.png"),
                  fit: BoxFit.cover,
                ),
              ),
              GestureDetector(
                onTap: () {
                  startScreen(
                    context,
                    InfoDetailScreen(listAssets: ["assets/propolis/1.jpg", "assets/propolis/2.jpg"], title: "Propolis"),
                  );
                },
                child: Image(
                  image: AssetImage("assets/propolis/1.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              GestureDetector(
                onTap: () {
                  startScreen(
                    context,
                    InfoDetailScreen(listAssets: ["assets/bioprosima/1.jpg", "assets/bioprosima/2.jpg"], title: "Propolis"),
                  );
                },
                child: Image(
                  image: AssetImage("assets/bioprosima/1.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 0,
          child: PageView(
            controller: pageController,
            children: [
              SizedBox(height: 1),
              SizedBox(height: 1),
              SizedBox(height: 1),
            ],
          ),
        ),
        ColumnDivider(),
        Center(
          child: SmoothPageIndicator(
            controller: pageController,
            count: 3,
            effect: ExpandingDotsEffect(
              radius: 10,
              dotHeight: 4,
              dotColor: Colors.grey.shade400,
              activeDotColor: Colors.orange,
              expansionFactor: 1.3,
            ),
          ),
        ),
        ColumnDivider(space: 20),
        Center(
          child: Wrap(
            runSpacing: 20,
            spacing: 10,
            children: [
              CardButton(
                icon: LineIcons.building_o,
                title: "Profil Perusahaan",
                onTap: () {
                  startScreen(
                    context,
                    InfoDetailScreen(
                      title: "Profil Perusahaan",
                      listAssets: List.generate(4, (index) => "assets/profile/${index + 1}.jpg"),
                    ),
                  );
                },
              ),
              CardButton(
                icon: LineIcons.hand_pointer_o,
                title: "Visi dan Misi",
                onTap: () {
                  startScreen(
                    context,
                    InfoDetailScreen(
                      title: "Visi & Misi",
                      listAssets: [
                        "assets/visi_misi/1.png",
                      ],
                    ),
                  );
                },
              ),
              CardButton(
                icon: LineIcons.bar_chart_o,
                title: "Marketing Plan",
                onTap: () {
                  startScreen(
                    context,
                    InfoDetailScreen(
                      title: "Marketing Plan",
                      listAssets: List.generate(7, (index) => "assets/market_plan/${index + 1}.jpg"),
                    ),
                  );
                },
              ),
              CardButton(
                icon: LineIcons.list,
                title: "Kode Etik",
                onTap: () {
                  startScreen(
                    context,
                    InfoDetailScreen(title: "Profil Perusahaan", listAssets: List.generate(14, (index) => "assets/kode_etik/${index + 1}.png")),
                  );
                },
              ),
              CardButton(
                icon: LineIcons.info_circle,
                title: "Informasi",
                onTap: () {
                  startScreen(
                    context,
                    InfoDetailScreen(
                      listAssets: ["assets/information/1.png"],
                      title: "Informasi",
                    ),
                  );
                },
              ),
              CardButton(
                icon: LineIcons.sign_in,
                title: "Member Area",
                onTap: () {
                  startScreen(context, MemberAreaScreen());
                },
              ),
            ]
                .map((e) => SizedBox(
                      width: MediaQuery.of(context).size.width / 3 - 20,
                      child: Center(child: e),
                    ))
                .toList(),
          ),
        ),
        ColumnDivider(space: 20),
        CustomCard(
          borderRadius: 20,
          margin: EdgeInsets.all(10),
          backgroundColor: Color(0xff192437),
          padding: EdgeInsets.all(10),
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    launch("https://www.google.com/maps/search/Cibubur+Point+Square+Blok+A+No.+3A+Jln.+Transyogi+km.01+Cibubur/");
                  },
                  leading: Icon(
                    LineIcons.map_marker,
                    color: Colors.orange,
                  ),
                  title: Text(
                    "Cibubur Point Square Blok A No. 3A Jln. Transyogi km.01 Cibubur",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  onTap: () {
                    launch("mailto:SSI.Pilihanku@gmail.com");
                  },
                  leading: Icon(
                    LineIcons.envelope_o,
                    color: Colors.orange,
                  ),
                  title: Text(
                    "SSI.Pilihanku@gmail.com",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    LineIcons.phone,
                    color: Colors.orange,
                  ),
                  title: SelectableText(
                    "Kantor : 021 83716500\nCS : 0816 805 551",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.credit_card,
                    color: Colors.orange,
                  ),
                  title: SelectableText(
                    "BANK BCA\nPT. SINAR SUKSES IMPIAN\nNO REK 1660719195",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Divider(color: Colors.grey, height: 40),
                Text(
                  "© Copyright 2020 by 551.co.id",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}

class CardButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTap;
  const CardButton({
    Key key,
    this.title,
    this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CustomCard(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Icon(
                icon ?? LineIcons.question,
                size: 30,
              ),
            ),
            showOnOverflow: false,
          ),
          ColumnDivider(),
          Text(
            title ?? "",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
