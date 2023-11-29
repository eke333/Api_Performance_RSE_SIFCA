import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuEvaluation extends StatefulWidget {
  const MenuEvaluation({Key? key}) : super(key: key);

  @override
  State<MenuEvaluation> createState() => _MenuEvaluationState();
}

class _MenuEvaluationState extends State<MenuEvaluation> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:20.0,left: 20,right:20,bottom: 20),
      child: SizedBox(
        width: 250,
        child: Card(
          surfaceTintColor:Colors.white,
          shadowColor: Colors.white,
          elevation:10,
          shape: const RoundedRectangleBorder(
            side: BorderSide(
                width:2,
                color:Colors.grey
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 230,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.only(left:11.3),
                      child: Container(
                        width: 200,
                        height: 40,
                        decoration: const BoxDecoration(
                          color:Colors.amber,
                          borderRadius: BorderRadius.all(Radius.circular(20),),
                        ),

                        child: TextButton(
                            onPressed: () {

                            },
                            child: const Text(
                              "Démarer une évaluation",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                            )),
                      ),
                    ),
                    const SizedBox(height: 5,),
                    const Text(
                      "Menu Principal",
                      textAlign:TextAlign.center,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              ),
              Container(
                width:240,
                padding: const EdgeInsets.all(8),
                child: const Divider(
                  color: Colors.black,
                ),
              ),
              const CustomMenuButton(
                pathMenu: '/accueil',
                image: "assets/images/home1.png",
                isFullPath: false,
                // icon: Icons.home,
                label: "Accueil",
              ),
              const SizedBox(height: 5),
              const CustomMenuButton(
                pathMenu: '',
                image: "assets/images/profile-user.png",
                // icon: Icons.person,
                isFullPath: false,
                label: "Profil",
              ),
              const SizedBox(height: 5),
              const CustomMenuButton(
                pathMenu: '/evaluation',
                image: "assets/images/audit.png",
                // icon: Icons.table_chart_rounded,
                isFullPath: false,
                label: "Evaluation",
              ),
              const SizedBox(height: 5),
              const CustomMenuButton(
                pathMenu: '/admin',
                image: "assets/images/homme-daffaire.png",
                // icon: Icons.admin_panel_settings_outlined,
                isFullPath: false,
                label: "Administration",
              ),
              const SizedBox(height: 5),
              const CustomMenuButton(
                pathMenu: '/ressources',
                image: "assets/images/res.png",
                // icon: Icons.admin_panel_settings_outlined,
                isFullPath: false,
                label: "Réssources",
              ),
              const SizedBox(
                height: 5,
              ),
              const CustomMenuButton(
                pathMenu: '/',
                image: "assets/images/soleil (1).png",
                // icon: Icons.admin_panel_settings_outlined,
                isFullPath: false,
                label: "Mode clair",
              ),
              const SizedBox(
                height: 5,
              ),

              Container(
                width:240,
                padding: const EdgeInsets.all(8),
                child: const Divider(
                  color: Colors.black,
                ),
              ),
              const CustomMenuButton(
                pathMenu: '/',
                image: "assets/images/une-langue-etrangere.png",
                // icon: Icons.admin_panel_settings_outlined,
                isFullPath: false,
                label: "Française",
              ),
              const SizedBox(
                height: 5,
              ),
              CustomMenuButton(
                pathMenu: '/',
                image: "assets/images/return.png",
                isFullPath: true,
                onTap: (){
                  context.go("/");
                },
                label: "Accueil Général",
              ),
            ],
          ),
        ),
      ),
    );

  }
}

class CustomMenuButton extends StatefulWidget {
  final String pathMenu;
  final Function()? onTap;
  final String image;
  final bool isFullPath;
  final String label;
  // final IconData icon;
  const CustomMenuButton(
      {Key? key,
        required this.label,
        // required this.icon,
        required this.pathMenu,
        required this.isFullPath,
        required this.image, this.onTap})
      : super(key: key);

  @override
  State<CustomMenuButton> createState() => _CustomMenuButtonState();
}

class _CustomMenuButtonState extends State<CustomMenuButton> {
  bool _isHovering = false;
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: (){},
      onHover: (isHovering) {
        setState(() {
          _isHovering = isHovering;
        });
      },
      child: Container(
        width: 230,
        height: 40,
        decoration: BoxDecoration(
            color: isSelected
                ? _isHovering
                ? const Color(0xFFEEEEEE)
                : const Color(0xFFE8F0FE)
                : Colors.transparent,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        child: OutlinedButton(
          onPressed: widget.onTap,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            side: const BorderSide(
              color: Colors.transparent,
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
          ),
          child: Row(
            children: [
              Image.asset(
                widget.image,
                width:30,
              ),
              const SizedBox(
                width: 18,
              ),
              Text(
                widget.label,
                style: TextStyle(
                    fontSize: 18,
                    overflow:TextOverflow.ellipsis ,
                    color: isSelected ? const Color(0xFF114693) : Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }
}
