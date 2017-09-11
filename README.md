# Spree mercado pago

This project is compatible with Spree 3.3.0 and Rails 5
```
gem 'spree_mercado_pago', '~> 3.3.0', git: "https://github.com/lucasruroken/spree_mercado_pago"
```

You should run inside your project
```
bundle exec rails g spree_mercado_pago:install
```
### Usage
* Add a new payment method in the admin panel of type "Spree::MercadoPago::Gateways::CreditCard" and "Spree::MercadoPago::Gateways::Ticket"
* After adding the payment method you will be able to configure your Client ID and Client Secret (provided by Mercado Pago).
