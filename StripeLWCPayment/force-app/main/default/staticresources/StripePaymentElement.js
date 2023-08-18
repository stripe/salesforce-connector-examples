j$ = jQuery.noConflict();
var stripe;
var elements;
var card;
var paymentElement;
const queryString = window.location.search;
const urlParams = new URLSearchParams(queryString);
const client_key = urlParams.get('clientSecret');
const pk_test_key = urlParams.get('pkkey');
j$(document).ready( function () {
	// Set Publishable key of your Stripe Account.
    
stripe = Stripe(pk_test_key);


const appearance = {
    theme: 'flat',
    variables: { colorPrimaryText: '#262626' }
  };
  const options = {
    layout: {
      type: 'tabs',
      defaultCollapsed: false,
    }
  };
  const elementsOptions = {
    appearance: appearance,
    clientSecret: client_key
};
const elements = stripe.elements(elementsOptions);

const paymentElement = elements.create('payment', options);
paymentElement.mount('#payment-element');
    // Handle validation errors from the card Element. 
    paymentElement.addEventListener('change', function(event) { 
        var displayCardError = document.getElementById('payment-element-Errors'); 
        // get cardErrors Div 
        if (event.error) { 
            // Show Validation errors 
            displayCardError.textContent = event.error.message; 
        } 
        else { 
            displayCardError.textContent = ""; 
        } 
    }); 
}); 
function validateCard(){ 
    const queryString = window.location.search;
    const urlParams = new URLSearchParams(queryString);
    const client_key = urlParams.get('clientSecret')
    const {error} = stripe.confirmPayment({
        elements,
        confirmParams: {
          return_url: 'https://www.google.com',
        },
    
        // Uncomment below if you only want redirect for redirect-based payments
        redirect: 'if_required',
    }
      )
        .then(function(result) {
         if(error) { 
             // Display errors in the ‘cardErrors’ Div 
             var errorElement = document.getElementById('payment-element-Errors'); 
             errorElement.textContent = error.message; 
            } 
        else { 
            console.log('====success ==='+JSON.stringify(result.paymentIntent));
             // Generate Card Token and get Token Id 
             generateToken(result.paymentIntent); } 
    }); 
} 
function generateToken(intent){ 
    var tokenId = JSON.stringify(intent.id); 
}