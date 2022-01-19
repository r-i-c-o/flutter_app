import 'package:flutter/material.dart';
import 'package:tarot/helpers/subscription_manager.dart';
import 'package:tarot/theme/app_colors.dart';
import 'package:tarot/widgets/subscription_radio.dart';
import 'package:url_launcher/url_launcher.dart';

import 'gradient_blur.dart';

class SubscriptionRadios extends StatelessWidget {
  final VoidCallback onBuy;
  final List<ProductWrapper> products;
  final Function onChanged;
  final int subscriptionIndex;
  const SubscriptionRadios({
    Key? key,
    required this.onBuy,
    required this.products,
    required this.onChanged,
    required this.subscriptionIndex,
  }) : super(key: key);

  List<Widget> _generateSubscriptions() {
    return List<Widget>.generate(
      products.length,
      (index) {
        final info = products[index].info;
        return SubscriptionRadio(
          label: info.label,
          value: index,
          save: info.plaque,
          groupValue: subscriptionIndex,
          onChanged: onChanged,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSpecial = products.length == 1;
    final premiumText = isSpecial ? 'TRY PREMIUM FOR FREE' : 'TRY PREMIUM';
    final premiumDescriptionText = isSpecial
        ? 'Unlock all Premium features and remove ads only for ${products.first.info.label}'
        : 'NO ADS AND UNLIMITED SPREADS';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GradientBlur(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Column(
            children: [
              Text(
                premiumText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              Text(
                premiumDescriptionText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17.0,
                ),
              ),
              if (!isSpecial)
                Divider(
                  color: Colors.white,
                ),
              if (!isSpecial) ..._generateSubscriptions(),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  'Cancel any moment',
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onBuy,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'START PREMIUM FOR FREE',
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        isSpecial ? '7-DAYS TRIAL' : '3-DAYS TRIAL',
                        style: const TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  launch(
                      'https://sites.google.com/view/truetarotcardreadinghoro13');
                },
                child: Text(
                  'Privacy Policy',
                  style: TextStyle(
                      color: AppColors.semiTransparentWhiteText,
                      decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
