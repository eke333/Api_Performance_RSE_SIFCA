import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../helper/helper_methods.dart';
import '/widgets/custom_text.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({Key? key}) : super(key: key);

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {

  late final TextEditingController _newPassWord;
  late final TextEditingController _confirmPassWord;
  final _formKey = GlobalKey<FormState>();
  bool isLoadedPage = false;
  final RegExp regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
  final supabase = Supabase.instance.client;

  bool _obscureNewPassWord = true;
  bool _obscureConfirmPassWord = true;

  String? t = "";

  void changePassWord(BuildContext context) async{
    setState(() {
      isLoadedPage = true;
    });

    try {
      String? email = supabase.auth.currentSession?.user.email;
      if (email !=null ) {
        await supabase.auth.updateUser(UserAttributes(
          email: email,
          password: _confirmPassWord.text.trim(),
        ));
        await Future.delayed(const Duration(seconds: 1));
        ScaffoldMessenger.of(context).showSnackBar(showSnackBar("Succès","Votre mot de passe a été modifié avec succès.",Colors.green));
        context.go("/account/login");
        setState(() {
          isLoadedPage = false;
        });
      }else {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          isLoadedPage = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(showSnackBar("Echec","La mise à jour du mot de passe a échoué.",Colors.red));
      }

    } catch (e) {
      final message = e.toString().split("Exception: ").join("");
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        isLoadedPage = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(showSnackBar("Echec",message,Colors.red));
    }

  }

  @override
  void initState() {
    setState(() {
      supabase.auth.onAuthStateChange.listen((data) {
        final AuthChangeEvent event = data.event;
        final Session? session = data.session;
        t = event.name;
      });
    });

    _newPassWord = TextEditingController();
    _confirmPassWord = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: 700,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/logos/perf_rse.png",width: 300,),
          const SizedBox(height: 30,),
          const CustomText(text: "Changement du mot de passe",size: 25,weight: FontWeight.bold,),
          const SizedBox(height: 20,),
          Card(
            elevation: 5,
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 480,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(text: "Veuillez fournir ou confirmer les renseignements suivants :",size: 18,color: Colors.amber,),
                  const SizedBox(height: 10,),
                  const CustomText(text: "Inscrivez votre nouveau mot passe.",size: 13,),
                  Form(
                    autovalidateMode: AutovalidateMode.always,
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(height: 20,),
                        Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                  hintText: "Nouveau mot de passe",
                                  prefixIcon: const Icon(Icons.password),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _obscureNewPassWord =
                                        !_obscureNewPassWord;
                                      });
                                    },
                                    child: Icon(_obscureNewPassWord
                                        ? Icons.visibility
                                        : Icons
                                        .visibility_off),
                                  ),
                                  contentPadding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0),
                                  border: const OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(
                                              context)
                                              .primaryColor,
                                          width: 2))),
                              controller: _newPassWord,
                              obscureText: _obscureNewPassWord,
                              validator: (value) { if (value == null || value.isEmpty || !regex.hasMatch(value) ) {
                                  return 'Le mot de passe doit avoir au moins de 8 caractères.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20,),
                            TextFormField(
                              decoration: InputDecoration(
                                  hintText: "Confirmer le nouveau mot de passe",
                                  prefixIcon: const Icon(Icons.password),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _obscureConfirmPassWord = !_obscureConfirmPassWord;
                                      });
                                    },
                                    child: Icon(_obscureConfirmPassWord
                                        ? Icons.visibility
                                        : Icons
                                        .visibility_off),
                                  ),
                                  contentPadding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0),
                                  border: const OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(
                                              context)
                                              .primaryColor,
                                          width: 2))),
                              controller: _confirmPassWord,
                              obscureText: _obscureConfirmPassWord,
                              validator: (value) {
                                if(value == null || value.isEmpty) {
                                  return "Ce champ est vide.";
                                }
                                if (value!=_newPassWord.text || !regex.hasMatch(value) ){
                                  return "Les mots de passe renseignés ne sont identiques.";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 30,),
                        ElevatedButton(
                            onPressed: isLoadedPage ? null : () async {
                              if (_formKey.currentState!.validate()){
                                changePassWord(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              shape: const StadiumBorder(),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              width: double.maxFinite,
                              height: 40,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: isLoadedPage ? const SpinKitWave(color: Colors.amber, size: 20,) : const CustomText(
                                text: "CONFIRMER",
                                color: Colors.white,
                              ),
                            )),
                        const SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40,),
          TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              onPressed: (){
                context.go("/account/login");
              }, child: const Text(
            "« Retour à la connexion",style: TextStyle(fontSize: 22),
          ))
        ],
      ),
    );
  }
}
