import 'package:flutter/material.dart';
import '../constant.dart';
import '../utils/restart_utils.dart';
import '../utils/server_utils.dart';
import '../widgets/label_text_field.dart';
import '../widgets/snackbar.dart';

// ignore: must_be_immutable
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final TextEditingController serverController = TextEditingController();
  final TextEditingController portController = TextEditingController();
  // final TextEditingController topicController = TextEditingController();

  @override
  void initState() {
    initURL();
    super.initState();
  }

  @override
  void dispose() {
    serverController.dispose();
    portController.dispose();
    // topicController.dispose();

    super.dispose();
  }

  void initURL() async {
    String serverURL = await ServerUtils.getServerURL();
    serverController.text = serverURL;

    int port = await ServerUtils.getPort();
    portController.text = port.toString();

    // String topic = await ServerUtils.getTopic();
    // topicController.text = topic.toString();
  }

  List<Widget> form() {
    return [
      LabelTextField(
        text: "Server URL",
        controller: serverController,
        hintText: "",
        keyboardType: TextInputType.name,
      ),
      const SizedBox(height: 16),
      LabelTextField(
        text: "Port",
        controller: portController,
        hintText: "",
        keyboardType: TextInputType.number,
      ),
      // const SizedBox(height: 16),
      // LabelTextField(
      //   text: "Topic",
      //   controller: topicController,
      //   hintText: "",
      //   keyboardType: TextInputType.name,
      // ),
    ];
  }

  Widget updateButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await ServerUtils.setServerURL(serverController.text);
        await ServerUtils.setPort(int.tryParse(portController.text) ?? 1883);
        // await ServerUtils.setTopic(topicController.text);

        if (context.mounted) {
          // context.read<FarmDataCubit>().setService(
          //       FarmDataService(
          //         serverController.text,
          //         int.tryParse(portController.text) ?? 1883,
          //         topicController.text,
          //       ),
          //     );
          showSnackBar(context, "Pengaturan berhasil diubah");
          RestartUtils.restart(context);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: greenMainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius * 4),
        ),
        padding: const EdgeInsets.all(padding * 2),
      ),
      child: const Text(
        "Ubah Pengaturan",
        style: TextStyle(
          color: whiteMainColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget resetButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await ServerUtils.resetSettings();
        initURL();

        if (context.mounted) {
          // context.read<FarmDataCubit>().setService(
          //       FarmDataService(
          //         serverController.text,
          //         int.tryParse(portController.text) ?? 1883,
          //         topicController.text,
          //       ),
          //     );
          showSnackBar(context, "Pengaturan berhasil direset");
          RestartUtils.restart(context);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: whiteMainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius * 4),
          side: const BorderSide(
            width: 1,
            color: greenMainColor,
          ),
        ),
        padding: const EdgeInsets.all(padding * 2),
      ),
      child: const Text(
        "Reset Pengaturan",
        style: TextStyle(
          color: greenMainColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: greenMainColor,
          title: const Text("Pengaturan"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding * 2),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                ...form(),
                const SizedBox(height: 28),
                Builder(builder: (ctx) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [updateButton(ctx), resetButton(ctx)],
                  );
                }),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
