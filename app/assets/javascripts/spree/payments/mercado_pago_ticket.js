var mercadoPagoTicket,
    paymentOption,
    docNumberTicket,
    docTypeTicket,
    active_payments;

$(function() {
  mercadoPagoTicket = $(".mercadopago-ticket");
  paymentOption = mercadoPagoTicket.find("#payment_option");
  docNumberTicket = mercadoPagoTicket.find("#doc_number_ticket");
  docTypeTicket = mercadoPagoTicket.find("#doc_type_ticket");

  active_payments = function(){
    var payments = Mercadopago.getPaymentMethods();

    return payments.filter(function(payment) {
      return payment.status === "active" && payment.payment_type_id === "ticket";
    });
  };

  var count = 0;
  var __gateway_loaded_status = function(){
    count = count + 1;
    if( active_payments().length > 0 ){
      $.each(active_payments(), function(key, value) {
        paymentOption.append("<option value='" + value.id + "'>" + value.name + "</option>");
      });
    } else {
      if( count <= 13 ){
        setTimeout(__gateway_loaded_status, 300);
      }
    }
  };
  __gateway_loaded_status();

  var continueButton = checkoutForm.find('input[type="submit"]');

  var hideMercadoPago = function() {
    $('.mercado-pago-ticket').remove();
    // continueButton.show();
  };

  var showMercadoPago = function() {
    $('.mercado-pago-ticket').remove();
    continueButton.after('<span onclick="processTicket()" class="mercado-pago-ticket button ' + continueButton.attr('class') + '">Pagar con ticket</span>');
    continueButton.hide()
  };

  var toggleMercadoPago = function(currentPayment){
    if(parseInt(currentPayment) === mpPaymentIdTicket) {
      showMercadoPago();
    } else {
      hideMercadoPago();
    }
  };

  toggleMercadoPago($('#payment-method-fields').find('input:checked').val());

  $('div[data-hook="checkout_payment_step"] input[type="radio"]').click(function (e) {
    toggleMercadoPago(e.target.value);
  });

});

var processTicket = function() {
  var checkoutForm = $('#checkout_form_payment');
  checkoutForm.append('<input type="hidden" name="payment_source[' + mpPaymentIdTicket + '][doc_type]" value="' + docTypeTicket.val() + '" />');
  checkoutForm.append('<input type="hidden" name="payment_source[' + mpPaymentIdTicket + '][doc_number]" value="' + docNumberTicket.val() + '" />');
  checkoutForm.append('<input type="hidden" name="payment_source[' + mpPaymentIdTicket + '][collected_amount]" value="' + amountTicket + '" />');
  checkoutForm.append('<input type="hidden" name="payment_source[' + mpPaymentIdTicket + '][payment_option]" value="' + paymentOption.val() + '" />');
  checkoutForm.submit();
};