import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

//1. Providers
final TipProvider = NotifierProvider<TipNotifier, Bill>(TipNotifier.new);



//2. Consumer
class TipCalculatorScreen extends ConsumerWidget {
  const TipCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(TipProvider);
    final notifier = ref.read(TipProvider.notifier);
    //TextEditingController textEditingController = TextEditingController();
  

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Mon Calculateur de Pourboire', style: Theme.of(context).textTheme.titleLarge),
          Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    //controller: textEditingController,
                    decoration: const InputDecoration(
                     label: Text('Montant de la facture'),
                      prefix: Text('\$ '),
                  ),
                  keyboardType: TextInputType.number,
                  onSubmitted: ((newValue)=> notifier.onAmountChanged(double.parse(newValue))),
                  ),
                  const SizedBox(height: 20),
                  Text("Poucentage du Pourboire: ${provider.tip.toInt()}%"),
                  const SizedBox(height: 20),
                  Slider(
                    value: provider.tip, 
                    min: 0,
                    max: 100,
                    onChanged: ((newValue) => notifier.onTipChanged(newValue)),
                    ),
                    const SizedBox(height: 20),
                    Text("Montant du Pourboire: ${provider.tipAmount.toStringAsFixed(2)} euros"),
                    Text( "Total: ${provider.total.toStringAsFixed(2)} euros"),
                ],
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              notifier.onReset(
              );

            },
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}


//3. Notifier
class TipNotifier extends Notifier<Bill> {

  @override
  Bill build() => Bill();

  onAmountChanged(double newValue) {
    state = Bill(amount: newValue, tip: state.tip);
  }

  onTipChanged(double newValue) {
    state = Bill(amount: state.amount, tip: newValue);
  }

  onReset () {
    state = Bill();
  }
 
}

//4. Modeles
class Bill  {
  double amount;
  double tip;

  double get tipAmount => amount * tip / 100;
  double get total => amount + tipAmount;

  Bill({ this.amount = 0, this.tip = 10});
}
