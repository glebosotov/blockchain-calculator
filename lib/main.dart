import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web3/flutter_web3.dart';

void main() {
  runApp(const MyApp());
}

const abi = '''[
    {
      "inputs": [
        {"internalType": "uint256", "name": "a", "type": "uint256"},
        {"internalType": "uint256", "name": "b", "type": "uint256"}
      ],
      "name": "add",
      "outputs": [
        {"internalType": "uint256", "name": "", "type": "uint256"}
      ],
      "stateMutability": "pure",
      "type": "function"
    },
    {
      "inputs": [
        {"internalType": "uint256", "name": "a", "type": "uint256"},
        {"internalType": "uint256", "name": "b", "type": "uint256"}
      ],
      "name": "div",
      "outputs": [
        {"internalType": "uint256", "name": "", "type": "uint256"}
      ],
      "stateMutability": "pure",
      "type": "function"
    },
    {
      "inputs": [
        {"internalType": "uint256", "name": "a", "type": "uint256"},
        {"internalType": "uint256", "name": "b", "type": "uint256"}
      ],
      "name": "mul",
      "outputs": [
        {"internalType": "uint256", "name": "", "type": "uint256"}
      ],
      "stateMutability": "pure",
      "type": "function"
    },
    {
      "inputs": [
        {"internalType": "uint256", "name": "a", "type": "uint256"},
        {"internalType": "uint256", "name": "b", "type": "uint256"}
      ],
      "name": "sub",
      "outputs": [
        {"internalType": "uint256", "name": "", "type": "uint256"}
      ],
      "stateMutability": "pure",
      "type": "function"
    }
  ]''';
const busdAddress = '0x98EebE6dA1073ABA7f693F89897805bd4214CA7d';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void setupEth() async {
    // From RPC
    final web3provider = Web3Provider(ethereum!);

    // Use `Provider` for Read-only contract, i.e. Can't call state-changing method
    busd = Contract(
      busdAddress,
      abi,
      web3provider,
    );
  }

  late Contract busd;

  @override
  void initState() {
    setupEth();
    super.initState();
  }

  final TextEditingController _aController = TextEditingController();
  final TextEditingController _bController = TextEditingController();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web3 calculator',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo)),
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Row(
                        children: [
                          Flexible(
                            child: TextField(
                              controller: _aController,
                              decoration: const InputDecoration(hintText: 'a'),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          Flexible(
                            child: TextField(
                              controller: _bController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: const InputDecoration(hintText: 'b'),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: ['add', 'sub', 'mul', 'div']
                            .map((e) => ElevatedButton(
                                onPressed: () async {
                                  final scaffoldMessenger =
                                      ScaffoldMessenger.of(context);
                                  final result = await busd.call(e, [
                                    int.parse(_aController.text),
                                    int.parse(_bController.text)
                                  ]);
                                  scaffoldMessenger.showSnackBar(SnackBar(
                                    content: Text(result.toString()),
                                  ));
                                },
                                child: Text(e)))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
